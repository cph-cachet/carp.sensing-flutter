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
/// For each measure in the task, it looks up appropriate [Probe]s to collect data.
///
/// Note that a [TaskExecutor] in itself is a [Executor].
/// This - amongst other things - imply that you can listen
/// to [Executor.data] from a task executor.
abstract class TaskExecutor<TConfig extends TaskDescriptor>
    extends AggregateExecutor<TConfig> {
  TConfig get task => configuration!;

  /// Returns a list of the running probes in this task executor.
  List<Probe> get probes =>
      executors.map((executor) => executor as Probe).toList();

  @override
  bool onInitialize() {
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
        return false;
      }
    }
    return true;
  }
}

/// Executes a [BackgroundTask].
class BackgroundTaskExecutor extends TaskExecutor<BackgroundTask> {
  @override
  Future<bool> onResume() async {
    if (configuration?.duration != null) {
      Timer(configuration!.duration!, () => pause());
    }
    return await super.onResume();
  }
}

/// Executes an [AppTask].
///
/// An [AppTaskExecutor] simply wraps a [TaskExecutor], which is executed
/// when the app (user) wants to do this.
///
/// This executor works closely with the singleton [AppTaskController].
/// Whenever an [AppTaskExecutor] is resumed (e.g. in a [PeriodicTrigger]),
/// this executor is wrapped in a [UserTask] and put on a queue in
/// the [AppTaskController].
///
/// Later, the app (user) can start, pause, or finalize a [UserTask]
/// by calling the `onStart()`, `onHold()`, and `onDone()` methods,
/// respectively.
///
/// Special-purpose [UserTask]s can be created by an [UserTaskFactory]
/// and such factories can be registered in the [AppTaskController]
/// using the `registerUserTaskFactory` method.
class AppTaskExecutor<TConfig extends AppTask> extends TaskExecutor<TConfig> {
  /// The task executor which can be used to execute this user task once
  /// activated.
  BackgroundTaskExecutor backgroundTaskExecutor = BackgroundTaskExecutor();

  AppTaskExecutor() : super() {
    // add the events from the embedded executor to the overall stream of events
    group.add(backgroundTaskExecutor.data);
  }

  @override
  bool onInitialize() => true;
  // backgroundTaskExecutor.initialize(configuration!, deployment);

  @override
  Future<bool> onResume() async {
    // when an app task is resumed simply put it on the queue
    await AppTaskController().enqueue(this);
    return true;
  }

  @override
  // TODO - don't know what to do on pause. Remove from queue?
  Future<bool> onPause() async => true;

  @override
  Future<bool> onStop() async {
    backgroundTaskExecutor.stop();
    await super.onStop();
    return true;
  }
}
