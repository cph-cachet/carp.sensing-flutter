/*
 * Copyright 2018-2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of runtime;

class ExecutorFactory {
  static final ExecutorFactory _instance = ExecutorFactory._();
  ExecutorFactory._();
  factory ExecutorFactory() => _instance;

  final Map<int, TriggerExecutor> _triggerExecutors = {};
  final Map<String, TaskExecutor> _taskExecutors = {};

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

  /// Get the [TriggerExecutor] for a [triggerId], if available.
  TriggerExecutor? getTriggerExecutor(int triggerId) =>
      _triggerExecutors[triggerId];

  /// Create a [TriggerExecutor] based on the [trigger] type.
  TriggerExecutor createTriggerExecutor(
    int triggerId,
    TriggerConfiguration trigger,
  ) {
    if (_triggerExecutors[triggerId] == null) {
      TriggerExecutor executor = ImmediateTriggerExecutor();

      switch (trigger.runtimeType) {
        case ElapsedTimeTrigger:
          executor = ElapsedTimeTriggerExecutor();
          break;
        case ScheduledTrigger:
          warning("ScheduledTrigger is not implemented yet. "
              "Using an 'ImmediateTriggerExecutor' instead.");
          executor = ImmediateTriggerExecutor();
          break;
        case ImmediateTrigger:
          executor = ImmediateTriggerExecutor();
          break;
        case OneTimeTrigger:
          executor = OneTimeTriggerExecutor();
          break;
        case DelayedTrigger:
          executor = DelayedTriggerExecutor();
          break;
        case PeriodicTrigger:
          executor = PeriodicTriggerExecutor();
          break;
        // case PeriodicTrigger:
        //   executor = PeriodicTriggerExecutor();
        //   break;
        case DateTimeTrigger:
          executor = DateTimeTriggerExecutor();
          break;
        case RecurrentScheduledTrigger:
          executor = RecurrentScheduledTriggerExecutor();
          break;
        case CronScheduledTrigger:
          executor = CronScheduledTriggerExecutor();
          break;
        case SamplingEventTrigger:
          executor = SamplingEventTriggerExecutor();
          break;
        case ConditionalSamplingEventTrigger:
          executor = ConditionalSamplingEventTriggerExecutor();
          break;
        case ConditionalPeriodicTrigger:
          executor = ConditionalPeriodicTriggerExecutor();
          break;
        case RandomRecurrentTrigger:
          executor = RandomRecurrentTriggerExecutor();
          break;
        case PassiveTrigger:
          executor = PassiveTriggerExecutor();
          break;
        case UserTaskTrigger:
          executor = UserTaskTriggerExecutor();
          break;
        default:
          warning(
              "Unknown trigger used - cannot find a TriggerExecutor for the trigger of type '${trigger.runtimeType}'. "
              "Using an 'ImmediateTriggerExecutor' instead.");
          executor = ImmediateTriggerExecutor();
      }
      _triggerExecutors[triggerId] = executor;
    }
    return _triggerExecutors[triggerId]!;
  }

  /// Get the [TaskExecutor] for a [task].
  TaskExecutor? getTaskExecutor(TaskConfiguration task) =>
      _taskExecutors[task.name];

  /// Create a [TaskExecutor] for a [task] based on the task type.
  /// If already created, returns this.
  TaskExecutor createTaskExecutor(TaskConfiguration task) {
    if (_taskExecutors[task.name] == null) {
      TaskExecutor executor = BackgroundTaskExecutor();
      if (task is AppTask) executor = AppTaskExecutor();
      _taskExecutors[task.name] = executor;
    }
    return _taskExecutors[task.name]!;
  }
}
