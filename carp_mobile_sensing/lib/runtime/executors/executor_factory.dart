/*
 * Copyright 2018-2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of '../runtime.dart';

/// A factory that can create a:
///
///  * [TriggerExecutor] using the [createTriggerExecutor] method
///  * [TaskExecutor] using the [getTaskExecutor] method
///
/// Note that each deployment has its own [ExecutorFactory].
/// This is because trigger executors needs to be reused across tasks in the same
/// deployment (in the task control), while avoiding them to be reused across
/// deployments (if the task has the same name).
class ExecutorFactory {
  final Map<int, TriggerExecutor> _triggerExecutors = {};
  final Map<String, TaskExecutor> _taskExecutors = {};

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
        case const (ElapsedTimeTrigger):
          executor = ElapsedTimeTriggerExecutor();
          break;
        case const (ScheduledTrigger):
          warning("ScheduledTrigger is not implemented yet. "
              "Using an 'ImmediateTriggerExecutor' instead.");
          executor = ImmediateTriggerExecutor();
          break;
        case const (NoOpTrigger):
          executor = NoOpTriggerExecutor();
          break;
        case const (ImmediateTrigger):
          executor = ImmediateTriggerExecutor();
          break;
        case const (OneTimeTrigger):
          executor = OneTimeTriggerExecutor();
          break;
        case const (DelayedTrigger):
          executor = DelayedTriggerExecutor();
          break;
        case const (PeriodicTrigger):
          executor = PeriodicTriggerExecutor();
          break;
        case const (DateTimeTrigger):
          executor = DateTimeTriggerExecutor();
          break;
        case const (RecurrentScheduledTrigger):
          executor = RecurrentScheduledTriggerExecutor();
          break;
        case const (CronScheduledTrigger):
          executor = CronScheduledTriggerExecutor();
          break;
        case const (SamplingEventTrigger):
          executor = SamplingEventTriggerExecutor();
          break;
        case const (ConditionalSamplingEventTrigger):
          executor = ConditionalSamplingEventTriggerExecutor();
          break;
        case const (ConditionalPeriodicTrigger):
          executor = ConditionalPeriodicTriggerExecutor();
          break;
        case const (RandomRecurrentTrigger):
          executor = RandomRecurrentTriggerExecutor();
          break;
        case const (PassiveTrigger):
          executor = PassiveTriggerExecutor();
          break;
        case const (UserTaskTrigger):
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

  /// Get the [TaskExecutor] for a [task] based on the task name. If the task
  /// executor does not exist, a new one is created based on the type of the task.
  TaskExecutor getTaskExecutor(TaskConfiguration task) {
    if (_taskExecutors[task.name] == null) {
      TaskExecutor executor = BackgroundTaskExecutor();
      if (task is AppTask) executor = AppTaskExecutor();
      if (task is FunctionTask) executor = FunctionTaskExecutor();

      _taskExecutors[task.name] = executor;
    }

    return _taskExecutors[task.name]!;
  }
}
