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
abstract class AggregateExecutor<TConfig> extends AbstractExecutor<TConfig> {
  static final DeviceInfo deviceInfo = DeviceInfo();
  final StreamGroup<DataPoint> group = StreamGroup.broadcast();
  final List<Executor> executors = [];
  Stream<DataPoint> get data => group.stream;

  Future<void> onResume() async =>
      executors.forEach((executor) => executor.resume());

  Future<void> onPause() async =>
      executors.forEach((executor) => executor.pause());

  Future<void> onRestart() async =>
      executors.forEach((executor) => executor.restart());

  Future<void> onStop() async {
    executors.forEach((executor) => executor.stop());
    executors.clear();
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

  @override
  void onInitialize() {
    group.add(_manualDataPointController.stream);

    configuration?.triggeredTasks.forEach((triggeredTask) {
      debug('$runtimeType - has a trigger task $triggeredTask');

      // get the trigger based on the trigger id
      Trigger trigger = configuration!.triggers['${triggeredTask.triggerId}']!;
      // get the task based on the task name
      TaskDescriptor task =
          configuration!.getTaskByName(triggeredTask.taskName)!;

      TriggeredTaskExecutor executor = getTriggeredTaskExecutor(
        triggeredTask,
        trigger,
        task,
      );

      debug('$runtimeType - created $executor');

      executor.initialize(triggeredTask, deployment!);

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
    ..carpHeader.studyId = deployment?.studyDeploymentId
    ..carpHeader.userId = deployment?.userId);

  /// Add a [DataPoint] object to the stream of events.
  void addDataPoint(DataPoint dataPoint) =>
      _manualDataPointController.add(dataPoint);

  /// Add a error to the stream of events.
  void addError(Object error, [StackTrace? stacktrace]) =>
      _manualDataPointController.addError(error, stacktrace);

  /// A list of the running probes in this study deployment executor.
  List<Probe> get probes {
    List<Probe> _probes = [];

    executors.forEach((executor) {
      if (executor is TriggeredTaskExecutor) {
        _probes.addAll(executor.probes);
      }
    });
    return _probes;
  }

  /// Lookup all probes of type [type]. Returns an empty list if none are found.
  List<Probe> lookupProbe(String type) {
    List<Probe> _probes = probes;
    _probes.retainWhere((probe) => probe.type == type);
    return _probes;
  }
}

/// Responsible for handling the execution of a [TriggeredTask].
///
/// This executor runs in real-time and triggers the task using timers. This
/// entails that tasks are only triggered if the app is actively running, either
/// in the foreground or in a background process.
class TriggeredTaskExecutor extends AggregateExecutor<TriggeredTask> {
  late Trigger _trigger;
  late TaskDescriptor _task;
  late TriggeredTask _triggeredTask;
  TriggerExecutor? triggerExecutor;
  TaskExecutor? taskExecutor;

  Trigger get trigger => _trigger;
  TaskDescriptor get task => _task;
  TriggeredTask get triggeredTask => _triggeredTask;

  TriggeredTaskExecutor(
    TriggeredTask triggeredTask,
    Trigger trigger,
    TaskDescriptor task,
  ) : super() {
    _triggeredTask = triggeredTask;
    _trigger = trigger;
    _task = task;
  }

  @override
  void onInitialize() {
    // get the trigger executor and add it to this stream
    triggerExecutor = getTriggerExecutor(trigger);
    group.add(triggerExecutor!.data);
    executors.add(triggerExecutor!);
    triggerExecutor?.initialize(trigger, deployment!);

    // get the task executor and add it to the trigger executor's stream
    taskExecutor = getTaskExecutor(task);
    debug('$runtimeType - taskExecutor: $taskExecutor');
    triggerExecutor?.group.add(taskExecutor!.data);
    triggerExecutor?.executors.add(taskExecutor!);
    taskExecutor?.initialize(task, deployment!);
  }

  /// Get the aggregated stream of [DataPoint] data sampled by all executors
  /// and probes in this triggered task executor.
  ///
  /// Makes sure to set the trigger id and device role name.
  Stream<DataPoint> get data => group.stream.map((dataPoint) => dataPoint
    ..carpHeader.triggerId = '${triggeredTask.triggerId}'
    ..carpHeader.deviceRoleName = triggeredTask.targetDeviceRoleName);

  /// Returns a list of the running probes in this [TriggeredTaskExecutor].
  List<Probe> get probes => taskExecutor?.probes ?? [];
}

/// Responsible for handling the execution of a [TriggeredTask] which contains
/// an [AppTask].
///
/// In contrast to the [TriggeredTaskExecutor] (which runs in the background),
/// this [TriggeredAppTaskExecutor] will try to schedule the [AppTask] using
/// the [AppTaskController]. This means that triggeres also has to be [Scheduleable].
class TriggeredAppTaskExecutor extends TriggeredTaskExecutor {
  TriggeredAppTaskExecutor(
    TriggeredTask triggeredTask,
    Trigger trigger,
    AppTask task,
  ) : super(triggeredTask, trigger, task);

  @override
  AppTaskExecutor get taskExecutor => super.taskExecutor as AppTaskExecutor;

  @override
  ScheduleableTriggerExecutor get triggerExecutor =>
      super.triggerExecutor as ScheduleableTriggerExecutor;

  @override
  Future<void> onResume() async {
    debug('hasBeenScheduledUntil : ${triggeredTask.hasBeenScheduledUntil}');
    final from = triggeredTask.hasBeenScheduledUntil ?? DateTime.now();
    final to = from.add(Duration(days: 10)); // look 10 days ahead
    final schedule = triggerExecutor.getSchedule(from, to);
    debug('$runtimeType - schedule: $schedule');

    if (schedule.isNotEmpty) {
      // enqueue the first 6 (max) app tasks in the future
      var remainingNotifications =
          NotificationController.PENDING_NOTIFICATION_LIMIT -
              (await SmartPhoneClientManager()
                      .notificationController
                      ?.pendingNotificationRequestsCount ??
                  0);
      remainingNotifications = min(remainingNotifications, 6);
      Iterator it = schedule.iterator;
      var count = 0;
      var current;
      while (it.moveNext() && count++ < remainingNotifications) {
        current = it.current;
        await AppTaskController().enqueue(
          taskExecutor,
          triggerTime: current,
        );
      }

      // save timestamp
      triggeredTask.hasBeenScheduledUntil = current;

      // now pause and resume again when the time has passed
      // this in the case where the app keeps running in the background
      this.pause();
      var duration = current.millisecondsSinceEpoch -
          DateTime.now().millisecondsSinceEpoch;
      Timer(Duration(milliseconds: duration), () => this.resume());
    }
  }

  @override
  Future<void> onPause() async {} // do nothing - this executor is never resumed
}

/// Returns the relevant [TriggeredTaskExecutor] based on the type of [trigger]
/// and [task].
TriggeredTaskExecutor getTriggeredTaskExecutor(
  TriggeredTask triggeredTask,
  Trigger trigger,
  TaskDescriptor task,
) {
  // a TriggeredAppTaskExecutor need BOTH a Scheduleable trigger and an AppTask
  // to schedule
  if (trigger is Scheduleable && task is AppTask)
    return TriggeredAppTaskExecutor(triggeredTask, trigger, task);

  // all other cases we use the normal background triggering relying on the app
  // running in the background
  return TriggeredTaskExecutor(triggeredTask, trigger, task);
}
