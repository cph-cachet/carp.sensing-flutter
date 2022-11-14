/*
 * Copyright 2018-2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of runtime;

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
  bool onInitialize() {
    if (configuration == null) {
      warning(
          'Trying to initialize StudyDeploymentExecutor but the deployment configuration is null. Cannot initialize study deployment.');
      return false;
    }

    group.add(_manualDataPointController.stream);

    for (var triggeredTask in configuration!.triggeredTasks) {
      // get the trigger based on the trigger id
      TriggerConfiguration trigger =
          configuration!.triggers['${triggeredTask.triggerId}']!;
      // get the task based on the task name
      TaskConfiguration task =
          configuration!.getTaskByName(triggeredTask.taskName)!;

      TriggeredTaskExecutor executor = getTriggeredTaskExecutor(
        triggeredTask,
        trigger,
        task,
      );

      executor.initialize(triggeredTask, deployment!);

      // let the device manger know about this executor
      if (triggeredTask.targetDeviceRoleName != null) {
        DeviceConfiguration? targetDevice = configuration
            ?.getDeviceFromRoleName(triggeredTask.targetDeviceRoleName!);
        if (targetDevice != null) {
          DeviceController()
              .getDevice(targetDevice.type)
              ?.executors
              .add(executor);
        }
      }

      group.add(executor.data);
      executors.add(executor);
    }
    return true;
  }

  /// Get the aggregated stream of [DataPoint] data sampled by all executors
  /// and probes in this study deployment.
  ///
  /// Ensures that the `userId` and `studyId` is correctly set in the
  /// [DataPointHeader] based on the [deployment] configuration.
  @override
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
    List<Probe> probes = [];

    for (var executor in executors) {
      if (executor is TriggeredTaskExecutor) {
        probes.addAll(executor.probes);
      }
    }
    return probes;
  }

  /// Lookup all probes of type [type]. Returns an empty list if none are found.
  List<Probe> lookupProbe(String type) {
    List<Probe> retrainedProbes = probes;
    retrainedProbes.retainWhere((probe) => probe.type == type);
    return retrainedProbes;
  }
}

/// Returns the relevant [TriggeredTaskExecutor] based on the type of [trigger]
/// and [task].
TriggeredTaskExecutor getTriggeredTaskExecutor(
  TriggeredTask triggeredTask,
  TriggerConfiguration trigger,
  TaskConfiguration task,
) {
  // a TriggeredAppTaskExecutor need BOTH a Schedulable trigger and an AppTask
  // to schedule
  if (trigger is Schedulable && task is AppTask) {
    return TriggeredAppTaskExecutor(triggeredTask, trigger, task);
  }

  // all other cases we use the normal background triggering relying on the app
  // running in the background
  return TriggeredTaskExecutor(triggeredTask, trigger, task);
}

/// Responsible for handling the execution of a [TriggeredTask].
///
/// This executor runs in real-time and triggers the task using timers. This
/// entails that tasks are only triggered if the app is actively running, either
/// in the foreground or in a background process.
class TriggeredTaskExecutor extends AggregateExecutor<TriggeredTask> {
  late TriggerConfiguration _trigger;
  late TaskConfiguration _task;
  late TriggeredTask _triggeredTask;
  TriggerExecutor? triggerExecutor;
  TaskExecutor? taskExecutor;

  TriggerConfiguration get trigger => _trigger;
  TaskConfiguration get task => _task;
  TriggeredTask get triggeredTask => _triggeredTask;

  TriggeredTaskExecutor(
    TriggeredTask triggeredTask,
    TriggerConfiguration trigger,
    TaskConfiguration task,
  ) : super() {
    _triggeredTask = triggeredTask;
    _trigger = trigger;
    _task = task;
  }

  @override
  bool onInitialize() {
    // get the trigger executor and add it to this stream
    triggerExecutor = getTriggerExecutor(trigger);
    group.add(triggerExecutor!.data);
    executors.add(triggerExecutor!);
    triggerExecutor?.initialize(trigger, deployment!);

    // get the task executor and add it to the trigger executor's stream
    taskExecutor = getTaskExecutor(task);
    triggerExecutor?.group.add(taskExecutor!.data);
    triggerExecutor?.executors.add(taskExecutor!);
    taskExecutor?.initialize(task, deployment!);

    return true;
  }

  /// Get the aggregated stream of [DataPoint] data sampled by all executors
  /// and probes in this triggered task executor.
  ///
  /// Makes sure to set the trigger id and device role name.
  @override
  Stream<DataPoint> get data => group.stream.map((dataPoint) => dataPoint
    ..carpHeader.triggerId = '${triggeredTask.triggerId}'
    ..carpHeader.deviceRoleName = triggeredTask.targetDeviceRoleName);

  /// Returns a list of the running probes in this [TriggeredTaskExecutor].
  List<Probe> get probes => taskExecutor?.probes ?? [];

  // @override
  // String toString() => '$runtimeType - triggeredTask: $triggeredTask';
}

/// Responsible for handling the execution of a [TriggeredTask] which contains
/// an [AppTask].
///
/// In contrast to the [TriggeredTaskExecutor] (which runs in the background),
/// this [TriggeredAppTaskExecutor] will try to schedule the [AppTask] using
/// the [AppTaskController]. This means that triggeres also has to be [Schedulable].
class TriggeredAppTaskExecutor extends TriggeredTaskExecutor {
  TriggeredAppTaskExecutor(
    super.triggeredTask,
    super.trigger,
    super.task,
  );

  @override
  AppTaskExecutor get taskExecutor => super.taskExecutor as AppTaskExecutor;

  @override
  SchedulableTriggerExecutor get triggerExecutor =>
      super.triggerExecutor as SchedulableTriggerExecutor;

  @override
  Future<bool> onResume() async {
    final from = triggeredTask.hasBeenScheduledUntil ?? DateTime.now();
    final to = from.add(Duration(days: 10)); // look 10 days ahead
    final schedule = triggerExecutor.getSchedule(from, to, 10);

    if (schedule.isNotEmpty) {
      // enqueue the first 6 (max) app tasks in the future
      var remainingNotifications =
          NotificationController.PENDING_NOTIFICATION_LIMIT -
              (await SmartPhoneClientManager()
                      .notificationController
                      ?.pendingNotificationRequestsCount ??
                  0);
      remainingNotifications = min(remainingNotifications, 6);
      Iterator<DateTime> it = schedule.iterator;
      var count = 0;
      DateTime current = DateTime.now();
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
      pause();
      var duration = current.millisecondsSinceEpoch -
          DateTime.now().millisecondsSinceEpoch;
      Timer(Duration(milliseconds: duration), () => resume());
    }

    return true;
  }

  @override
  Future<bool> onPause() async =>
      true; // do nothing - this executor is never resumed
}
