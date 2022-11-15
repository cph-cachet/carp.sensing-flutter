/*
 * Copyright 2018-2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of runtime;

/// Returns the relevant [TaskControlExecutor] based on the type of [trigger]
/// and [task].
TaskControlExecutor getTriggeredTaskExecutor(
  TaskControl taskControl,
  TriggerConfiguration trigger,
  TaskConfiguration task,
) {
  // a TriggeredAppTaskExecutor need BOTH a [Schedulable] trigger and an [AppTask]
  // to schedule
  if (trigger is Schedulable && task is AppTask) {
    return AppTaskControlExecutor(taskControl, trigger, task);
  }

  // all other cases we use the normal background triggering relying on the app
  // running in the background
  return TaskControlExecutor(taskControl, trigger, task);
}

/// Responsible for handling the execution of a [TriggeredTask].
///
/// This executor runs in real-time and triggers the task using timers. This
/// entails that tasks are only triggered if the app is actively running, either
/// in the foreground or in a background process.
class TaskControlExecutor extends AggregateExecutor<TaskControl> {
  late TriggerConfiguration _trigger;
  late TaskConfiguration _task;
  late TaskControl _taskControl;
  TriggerExecutor? triggerExecutor;
  TaskExecutor? taskExecutor;

  TriggerConfiguration get trigger => _trigger;
  TaskConfiguration get task => _task;
  TaskControl get taskControl => _taskControl;

  TaskControlExecutor(
    TaskControl taskControl,
    TriggerConfiguration trigger,
    TaskConfiguration task,
  ) : super() {
    _taskControl = taskControl;
    _trigger = trigger;
    _task = task;
  }

  @override
  bool onInitialize() {
    // get the trigger executor and add it to this stream
    triggerExecutor = getTriggerExecutor(trigger);
    group.add(triggerExecutor!.measurements);
    executors.add(triggerExecutor!);
    triggerExecutor?.initialize(trigger, deployment);

    // get the task executor and add it to the trigger executor's stream
    taskExecutor = getTaskExecutor(task);
    triggerExecutor?.group.add(taskExecutor!.measurements);
    triggerExecutor?.executors.add(taskExecutor!);
    taskExecutor?.initialize(task, deployment);

    return true;
  }

  /// Returns a list of the running probes in this [TaskControlExecutor].
  List<Probe> get probes => taskExecutor?.probes ?? [];
}

/// Responsible for handling the execution of a [TriggeredTask] which contains
/// an [AppTask].
///
/// In contrast to the [TaskControlExecutor] (which runs in the background),
/// this [AppTaskControlExecutor] will try to schedule the [AppTask] using
/// the [AppTaskController]. This means that triggers also has to be [Schedulable].
class AppTaskControlExecutor extends TaskControlExecutor {
  AppTaskControlExecutor(
    super.taskControl,
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
    final from = taskControl.hasBeenScheduledUntil ?? DateTime.now();
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
      taskControl.hasBeenScheduledUntil = current;

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
