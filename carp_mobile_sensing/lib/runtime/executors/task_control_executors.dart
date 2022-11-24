/*
 * Copyright 2018-2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of runtime;

abstract class Triggerable {
  void onTrigger();
}

/// Responsible for handling the execution of a [TaskControl].
///
/// This executor runs in real-time and triggers the task using timers. This
/// entails that tasks are only triggered if the app is actively running, either
/// in the foreground or in a background process.
class TaskControlExecutor extends AbstractExecutor<TaskControl> {
  final StreamController<Measurement> _controller =
      StreamController<Measurement>.broadcast();
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
    // get the trigger executor and initialize with this task control executor
    if (ExecutorFactory().getTriggerExecutor(taskControl.triggerId) == null) {
      triggerExecutor = ExecutorFactory()
          .createTriggerExecutor(taskControl.triggerId, trigger);
      debug('$runtimeType - creating new TriggerExecutor: $triggerExecutor');
      triggerExecutor?.initialize(trigger, deployment);
    }
    triggerExecutor =
        ExecutorFactory().getTriggerExecutor(taskControl.triggerId);
    triggerExecutor?.addTaskControlExecutor(this);

    // if not already created, get the task executor and add the
    // measurements it collects to the [group]
    if (ExecutorFactory().getTaskExecutor(task) == null) {
      taskExecutor = ExecutorFactory().createTaskExecutor(task);
      debug('$runtimeType - creating new TaskExecutor: $taskExecutor');
      taskExecutor?.initialize(task, deployment);
      _controller.addStream(taskExecutor!.measurements);
    } else {
      taskExecutor = ExecutorFactory().getTaskExecutor(task);
    }

    return true;
  }

  @override
  Future<bool> onStart() async {
    debug('$runtimeType - triggerExecutor.state: ${triggerExecutor?.state}');
    if (triggerExecutor?.state != ExecutorState.started) {
      debug('$runtimeType - starting triggerExecutor: $triggerExecutor');
      triggerExecutor?.start();
      // TODO - why the #&"#€ is the state not set to STARTED????
      debug('$runtimeType - triggerExecutor: $triggerExecutor');
    }
    return true;
  }

  /// Callback when the [triggerExecutor] triggers.
  void onTrigger() {
    debug(
        '$runtimeType - onTrigger(), control: ${taskControl.control}, taskExecutor: $taskExecutor');
    if (taskControl.control == Control.Start) {
      taskExecutor?.start();
    } else if (taskControl.control == Control.Stop) {
      taskExecutor?.stop();
    }
  }

  @override
  Future<bool> onRestart() async {
    taskExecutor?.restart();
    return true;
  }

  @override
  Future<bool> onStop() async {
    // stop the triggers so they don't trigger any more.
    triggerExecutor?.stop();
    // await super.onStop();

    // stop the task executor
    taskExecutor?.stop();

    return true;
  }

  @override
  Stream<Measurement> get measurements => _controller.stream
      .map((measurement) => measurement..taskControl = taskControl);

  /// Returns a list of the running probes in this task control executor.
  List<Probe> get probes => taskExecutor?.probes ?? [];
}

/// Responsible for handling the execution of a [TaskControl] which contains
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
  Future<bool> onStart() async {
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
      stop();
      var duration = current.millisecondsSinceEpoch -
          DateTime.now().millisecondsSinceEpoch;
      Timer(Duration(milliseconds: duration), () => start());
    }

    return true;
  }

  @override
  Future<bool> onPause() async =>
      true; // do nothing - this executor is never resumed
}
