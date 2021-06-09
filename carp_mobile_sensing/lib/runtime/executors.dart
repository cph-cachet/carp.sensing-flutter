/*
 * Copyright 2018-2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of runtime;

/// An abstract class used to implement executors.
/// See [StudyDeploymentExecutor] and [TaskExecutor] for examples.
abstract class Executor extends AbstractProbe {
  static final DeviceInfo deviceInfo = DeviceInfo();
  final StreamGroup<DataPoint> _group = StreamGroup.broadcast();
  List<Probe> executors = [];
  Stream<DataPoint> get data => _group.stream;

  Executor() : super();

  void onInitialize(Measure measure) {
    executors.forEach((executor) => executor.initialize(measure));
  }

  Future onPause() async {
    executors.forEach((executor) => executor.pause());
  }

  Future onResume() async {
    executors.forEach((executor) => executor.resume());
  }

  Future onRestart({Measure? measure}) async {
    executors.forEach((executor) => executor.restart());
  }

  Future onStop() async {
    executors.forEach((executor) => executor.stop());
    executors = [];
  }
}

// ---------------------------------------------------------------------------------------------------------
// STUDY DEPLOYMENT EXECUTOR
// ---------------------------------------------------------------------------------------------------------

/// The [StudyDeploymentExecutor] is responsible for executing a [MasterDeviceDeployment].
/// For each triggered task in this deployment, it starts a [TriggeredTaskExecutor].
///
/// Note that the [StudyDeploymentExecutor] in itself is a [Probe] and hence work
/// as a 'super probe'. This - amongst other things - imply that you can listen
/// to data point from the [data] stream.
class StudyDeploymentExecutor extends Executor {
  final StreamController<DataPoint> _manualDataPointController =
      StreamController.broadcast();
  CAMSMasterDeviceDeployment? get deployment => _deployment;
  CAMSMasterDeviceDeployment? _deployment;

  StudyDeploymentExecutor(CAMSMasterDeviceDeployment deployment) : super() {
    assert(deployment != null,
        'Cannot initiate a StudyDeploymentExecutor without a MasterDeviceDeployment.');
    _deployment = deployment;
    _group.add(_manualDataPointController.stream);

    _deployment!.triggeredTasks.forEach((triggeredTask) {
      // get the trigger based on the trigger id
      Trigger trigger = _deployment!.triggers['${triggeredTask.triggerId}']!;
      // get the task based on the task name
      // and the set the study deployment id (some probes need this)
      TaskDescriptor task = _deployment!.getTaskByName(triggeredTask.taskName)!;
      for (var measure in task?.measures) {
        if (measure is CAMSMeasure) {
          measure.studyDeploymentId = _deployment!.studyDeploymentId;
        }
      }

      TriggeredTaskExecutor executor = TriggeredTaskExecutor(
        triggeredTask,
        trigger as CAMSTrigger,
        task,
      );

      _group.add(executor.data);
      executors.add(executor);
    });
  }

  /// Get the aggregated stream of [DataPoint] data sampled by all executors
  /// and probes in this study deployment.
  ///
  /// Makes sure to set the user and study id from the deployment configuration.
  Stream<DataPoint> get data => _group.stream.map((dataPoint) => dataPoint
    ..carpHeader!.studyId = deployment!.studyId
    ..carpHeader!.userId = deployment!.userId);

  Future onResume() async {
    // check the start time for this study on this phone
    // this will save it, the first time the study is executed
    DateTime studyStartTimestamp =
        await (Settings().studyStartTimestamp as FutureOr<DateTime>);
    info(
        'Study deployment was started on this phone on ${studyStartTimestamp.toUtc()}');

    await super.onResume();
  }

  /// Add a [DataPoint] object to the stream of events.
  void addDataPoint(DataPoint dataPoint) =>
      _manualDataPointController.add(dataPoint);

  /// Add a error to the stream of events.
  void addError(Object error, [StackTrace? stacktrace]) =>
      _manualDataPointController.addError(error, stacktrace);

  /// Returns a list of the running probes in this study executor.
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
///
/// This is an abstract class. For each specific type of [Trigger],
/// a corresponding implementation of a [TriggeredTaskExecutor] exists.
class TriggeredTaskExecutor extends Executor {
  CAMSTrigger? _trigger;
  TaskDescriptor? _task;
  TriggeredTask? _triggeredTask;

  CAMSTrigger? get trigger => _trigger;
  TaskDescriptor? get task => _task;
  TriggeredTask? get triggeredTask => _triggeredTask;

  TriggeredTaskExecutor(
    TriggeredTask triggeredTask,
    CAMSTrigger trigger,
    TaskDescriptor task,
  ) : super() {
    assert(triggeredTask != null,
        'Cannot initiate a TriggeredTaskExecutor without a Triggered Task.');
    _triggeredTask = triggeredTask;
    assert(trigger != null,
        'Cannot initiate a TriggeredTaskExecutor without a Trigger.');
    _trigger = trigger;
    assert(task != null,
        'Cannot initiate a TriggeredTaskExecutor without a Task.');
    _task = task;

    // get the trigger executor and add it to this stream
    TriggerExecutor triggerExecutor = getTriggerExecutor(trigger);
    _group.add(triggerExecutor.data);
    executors.add(triggerExecutor);

    // get the task executor and add it to the trigger executor stream
    TaskExecutor taskExecutor = getTaskExecutor(task);
    triggerExecutor._group.add(taskExecutor.data);
    triggerExecutor.executors.add(taskExecutor);
  }

  /// Get the aggregated stream of [DataPoint] data sampled by all executors
  /// and probes in this triggered task executor.
  ///
  /// Makes sure to set the trigger id and device role name.
  Stream<DataPoint> get data => _group.stream.map((dataPoint) => dataPoint
    ..carpHeader!.triggerId = '${triggeredTask!.triggerId}'
    ..carpHeader!.deviceRoleName = triggeredTask!.targetDeviceRoleName);

  /// Returns a list of the running probes in this [TriggeredTaskExecutor].
  /// This is a combination of the running probes in all task executors.
  List<Probe> get probes {
    List<Probe> _probes = [];
    executors.forEach((executor) {
      if (executor is TriggerExecutor) {
        executor.probes!.forEach((probe) {
          _probes.add(probe);
        });
      }
    });
    return _probes;
  }
}
