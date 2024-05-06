/*
 * Copyright 2018-2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of '../runtime.dart';

/// Responsible for handling the execution of a [TaskControl].
///
/// This executor runs in real-time and triggers the task using timers. This
/// entails that tasks are only triggered if the app is actively running, either
/// in the foreground or in a background process.
class TaskControlExecutor extends AbstractExecutor<TaskControl> {
  final StreamController<Measurement> _controller =
      StreamController<Measurement>.broadcast();
  final StreamGroup<Measurement> _group = StreamGroup.broadcast();

  late SmartphoneDeploymentExecutor _deploymentExecutor;
  late TriggerConfiguration _trigger;
  late TaskConfiguration _task;
  late TaskControl _taskControl;
  TriggerExecutor? triggerExecutor;
  TaskExecutor? taskExecutor;

  SmartphoneDeploymentExecutor get deploymentExecutor => _deploymentExecutor;
  ExecutorFactory get executorFactory => _deploymentExecutor.executorFactory;
  TriggerConfiguration get trigger => _trigger;
  TaskConfiguration get task => _task;
  TaskControl get taskControl => _taskControl;

  TaskControlExecutor(
    SmartphoneDeploymentExecutor deploymentExecutor,
    TaskControl taskControl,
    TriggerConfiguration trigger,
    TaskConfiguration task,
  ) : super() {
    _deploymentExecutor = deploymentExecutor;
    _taskControl = taskControl;
    _trigger = trigger;
    _task = task;
  }

  @override
  bool onInitialize() {
    _group.add(_controller.stream);

    // get the trigger executor and initialize with this task control executor
    if (executorFactory.getTriggerExecutor(taskControl.triggerId) == null) {
      triggerExecutor =
          executorFactory.createTriggerExecutor(taskControl.triggerId, trigger);
      triggerExecutor?.initialize(trigger, deployment);
    }
    triggerExecutor = executorFactory.getTriggerExecutor(taskControl.triggerId);
    triggerExecutor?.triggerEvents.listen((_) => onTrigger());

    // get the task executor and add the measurements it collects to the stream group
    taskExecutor = executorFactory.getTaskExecutor(task);
    taskExecutor?.initialize(task, deployment);
    _group.add(taskExecutor!.measurements);

    return true;
  }

  /// Callback when the [triggerExecutor] triggers.
  void onTrigger() {
    // add the trigger task measurement to the measurements stream
    _controller.add(Measurement.fromData(TriggeredTask(
        triggerId: taskControl.triggerId,
        taskName: taskControl.taskName,
        destinationDeviceRoleName: taskControl.destinationDeviceRoleName!,
        control: taskControl.control)));

    if (taskControl.control == Control.Start) {
      taskExecutor?.start();
    } else if (taskControl.control == Control.Stop) {
      taskExecutor?.stop();
    }
  }

  @override
  Future<bool> onStart() async {
    if (triggerExecutor?.state != ExecutorState.started &&
        !triggerExecutor!.isStarting) {
      triggerExecutor?.start();
    }
    return true;
  }

  @override
  Future<bool> onRestart() async {
    triggerExecutor?.restart();
    return true;
  }

  @override
  Future<bool> onStop() async {
    // stop the trigger executor so it don't trigger any more.
    triggerExecutor?.stop();

    // stop the task executor
    taskExecutor?.stop();

    return true;
  }

  @override
  Future<void> onDispose() async {
    // dispose both trigger and task executors so it don't trigger any more.
    triggerExecutor?.dispose();
    taskExecutor?.dispose();
  }

  @override
  Stream<Measurement> get measurements => _group.stream
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
    super.deploymentExecutor,
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
  bool onInitialize() {
    AppTaskController().userTaskEvents.listen((userTask) {
      if (userTask.state == UserTaskState.done) {
        // add the completed task measurement to the measurements stream
        _controller.add(Measurement.fromData(
            CompletedTask(taskName: userTask.name, taskData: userTask.result)));
      }
    });

    return super.onInitialize();
  }

  @override
  Future<bool> onStart() async {
    final from = taskControl.hasBeenScheduledUntil ?? DateTime.now();
    final to = from.add(const Duration(days: 10)); // look 10 days ahead
    final schedule = triggerExecutor.getSchedule(from, to, 10);

    if (schedule.isEmpty) {
      // Stop since the schedule is empty and there is not more to schedule.
      stop();
    } else {
      // Enqueue the first 6 (max) app tasks in the future
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

      // Save timestamp
      taskControl.hasBeenScheduledUntil = current;

      // Now stop since the schedule has all been enqueued.
      stop();

      // .. but start again when the scheduled time has passed.
      // This in the case where the app keeps running in the background
      var duration = current.millisecondsSinceEpoch -
          DateTime.now().millisecondsSinceEpoch;

      Timer(Duration(milliseconds: duration), () => start());
    }

    return true;
  }

  @override
  Future<bool> onStop() async =>
      true; // do nothing - this executor is never stopped
}
