/*
 * Copyright 2018-2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of runtime;

/// An abstract class used to implement aggregated executors (i.e., executors
/// with a set of underlying executors).
///
/// See [StudyDeploymentExecutor] and [TaskExecutor] for examples.
abstract class AggregateExecutor<Config> extends AbstractExecutor<Config> {
  static final DeviceInfo deviceInfo = DeviceInfo();
  final StreamGroup<DataPoint> group = StreamGroup.broadcast();
  List<Executor> executors = [];
  Stream<DataPoint> get data => group.stream;

  AggregateExecutor(SmartphoneDeployment deployment) : super(deployment);

  // void onInitialize() {
  //   executors.forEach((executor) => executor.initialize());
  // }

  Future<void> onPause() async {
    executors.forEach((executor) => executor.pause());
  }

  Future<void> onResume() async {
    executors.forEach((executor) => executor.resume());
  }

  Future<void> onRestart({Measure? measure}) async {
    executors.forEach((executor) => executor.restart());
  }

  Future<void> onStop() async {
    executors.forEach((executor) => executor.stop());
    executors = [];
  }
}

// ---------------------------------------------------------------------------------------------------------
// STUDY DEPLOYMENT EXECUTOR
// ---------------------------------------------------------------------------------------------------------

/// The [StudyDeploymentExecutor] is responsible for executing a [SmartphoneDeployment].
/// For each triggered task in this deployment, it starts a [TriggeredTaskExecutor].
///
/// Note that the [StudyDeploymentExecutor] in itself is an [Executor] and hence work
/// as a 'super executor'. This - amongst other things - imply that you can listen
/// to data point from the [data] stream.
class StudyDeploymentExecutor extends AggregateExecutor<SmartphoneDeployment> {
  final StreamController<DataPoint> _manualDataPointController =
      StreamController.broadcast();

  StudyDeploymentExecutor(SmartphoneDeployment deployment) : super(deployment);

  @override
  void onInitialize() {
    group.add(_manualDataPointController.stream);

    configuration?.triggeredTasks.forEach((triggeredTask) {
      // get the trigger based on the trigger id
      Trigger trigger = configuration!.triggers['${triggeredTask.triggerId}']!;
      // get the task based on the task name
      TaskDescriptor task =
          configuration!.getTaskByName(triggeredTask.taskName)!;

      TriggeredTaskExecutor executor = TriggeredTaskExecutor(
        deployment,
        triggeredTask,
        trigger,
        task,
      );

      executor.initialize(triggeredTask);

      group.add(executor.data);
      executors.add(executor);
    });
  }

  /// Get the aggregated stream of [DataPoint] data sampled by all executors
  /// and probes in this study deployment.
  ///
  /// Ensures that the `userId` and `studyId` is correctly set in the
  /// [DataPointHeader] based on the [deployment] configuration.
  Stream<DataPoint> get data => group.stream.map((dataPoint) => dataPoint
    ..carpHeader.studyId = deployment.studyDeploymentId
    ..carpHeader.userId = deployment.userId);

  /// Add a [DataPoint] object to the stream of events.
  void addDataPoint(DataPoint dataPoint) =>
      _manualDataPointController.add(dataPoint);

  /// Add a error to the stream of events.
  void addError(Object error, [StackTrace? stacktrace]) =>
      _manualDataPointController.addError(error, stacktrace);

  /// Returns a list of the running probes in this study deployment executor.
  /// This is a combination of the running probes in all trigger executors.
  List<Probe> get probes {
    List<Probe> _probes = [];
    executors.forEach((executor) {
      if (executor is TriggeredTaskExecutor) {
        executor.probes.forEach((probe) {
          _probes.add(probe);
        });
      }
    });
    return _probes;
  }
}

/// Responsible for handling the execution of a [TriggeredTask].
class TriggeredTaskExecutor extends AggregateExecutor<TriggeredTask> {
  late Trigger _trigger;
  late TaskDescriptor _task;
  late TriggeredTask _triggeredTask;

  Trigger get trigger => _trigger;
  TaskDescriptor get task => _task;
  TriggeredTask get triggeredTask => _triggeredTask;

  TriggeredTaskExecutor(
    SmartphoneDeployment deployment,
    TriggeredTask triggeredTask,
    Trigger trigger,
    TaskDescriptor task,
  ) : super(deployment) {
    _triggeredTask = triggeredTask;
    _trigger = trigger;
    _task = task;
  }

  @override
  void onInitialize() {
    // get the trigger executor and add it to this stream
    TriggerExecutor triggerExecutor = getTriggerExecutor(trigger);
    group.add(triggerExecutor.data);
    executors.add(triggerExecutor);
    triggerExecutor.initialize(trigger);

    // get the task executor and add it to the trigger executor stream
    TaskExecutor taskExecutor = getTaskExecutor(task);
    triggerExecutor.group.add(taskExecutor.data);
    triggerExecutor.executors.add(taskExecutor);
    taskExecutor.initialize(task);
  }

  /// Get the aggregated stream of [DataPoint] data sampled by all executors
  /// and probes in this triggered task executor.
  ///
  /// Makes sure to set the trigger id and device role name.
  Stream<DataPoint> get data => group.stream.map((dataPoint) => dataPoint
    ..carpHeader.triggerId = '${triggeredTask.triggerId}'
    ..carpHeader.deviceRoleName = triggeredTask.targetDeviceRoleName);

  /// Returns a list of the running probes in this [TriggeredTaskExecutor].
  /// This is a combination of the running probes in all task executors.
  List<Probe> get probes {
    List<Probe> _probes = [];
    executors.forEach((executor) {
      if (executor is TriggerExecutor) {
        executor.probes.forEach((probe) {
          _probes.add(probe);
        });
      }
    });
    return _probes;
  }
}
