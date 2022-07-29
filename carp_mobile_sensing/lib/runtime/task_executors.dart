/*
 * Copyright 2020 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of runtime;

/// Returns the relevant [TaskExecutor] based on the type of [task].
TaskExecutor getTaskExecutor(TaskDescriptor task) {
  if (task is AppTask) return AppTaskExecutor();
  return BackgroundTaskExecutor();
}

/// The [TaskExecutor] is responsible for executing a [TaskDescriptor].
/// For each task it looks up appropriate [Probe]s to collect data.
///
/// Note that a [TaskExecutor] in itself is a [Executor] and hence work as a
/// 'super probe'. This - amongst other things - imply that you can listen
/// to [Executor.data] from a task executor.
abstract class TaskExecutor<TConfig extends TaskDescriptor>
    extends AggregateExecutor<TConfig> {
  TConfig get task => configuration!;

  /// Returns a list of the running probes in this task executor.
  List<Probe> get probes =>
      executors.map((executor) => executor as Probe).toList();

  @override
  void onInitialize() {
    for (Measure measure in task.measures) {
      // create a new probe for each measure - this ensures that we can have
      // multiple measures of the same type, each using its own probe instance
      Probe? probe = SamplingPackageRegistry().create(measure.type);
      if (probe != null) {
        executors.add(probe);
        group.add(probe.data);
        probe.initialize(measure, deployment!);
      } else {
        warning(
            'A probe for measure type ${measure.type} could not be created. '
            'Check that the sampling package containing this probe has been registered in the SamplingPackageRegistry.');
      }
    }
  }
}

/// Executes a [BackgroundTask].
class BackgroundTaskExecutor extends TaskExecutor<BackgroundTask> {
  @override
  Future<void> onResume() async {
    await super.onResume();
    if (configuration?.duration != null) {
      Timer(configuration!.duration!, () => super.pause());
    }
  }
}
