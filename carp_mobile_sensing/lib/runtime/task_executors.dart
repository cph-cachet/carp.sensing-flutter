/*
 * Copyright 2020 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of runtime;

/// Returns the relevant [TaskExecutor] based on the type of [task].
TaskExecutor getTaskExecutor(TaskDescriptor task) {
  switch (task.runtimeType) {
    case TaskDescriptor:
      return TaskExecutor(task);
    case AutomaticTask:
      return AutomaticTaskExecutor(task as AutomaticTask);
    case AppTask:
      return AppTaskExecutor(task as AppTask);
    default:
      return TaskExecutor(task);
  }
}

/// The [TaskExecutor] is responsible for executing a [TaskDescriptor] in the [StudyProtocol].
/// For each task it looks up appropriate [Probe]s to collect data.
///
/// Note that a [TaskExecutor] in itself is a [Probe] and hence work as a 'super probe'.
/// This - amongst other things - imply that you can listen to datum [data] from a task executor.
class TaskExecutor extends Executor {
  TaskDescriptor get task => _task;
  late TaskDescriptor _task;

  /// Returns a list of the running probes in this task executor.
  List<Probe> get probes => executors;

  TaskExecutor(TaskDescriptor task) : super() {
    _task = task;
  }

  void onInitialize(Measure ignored) {
    for (Measure measure in task.measures) {
      // create a new probe for each measure - this ensures that we can have
      // multiple measures of the same type, each using its own probe instance
      Probe? probe = ProbeRegistry().create(measure.type);
      if (probe != null) {
        executors.add(probe);
        _group.add(probe.data);
        probe.initialize(measure);
      } else {
        warning(
            'A probe for measure type ${measure.type} could not be created. '
            'Check that the sampling package containing this probe has been registered in the SamplingPackageRegistry.');
      }
    }
  }
}

/// Executes an [AutomaticTask].
class AutomaticTaskExecutor extends TaskExecutor {
  AutomaticTaskExecutor(AutomaticTask task) : super(task);
}
