/*
 * Copyright 2020 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of runtime;

/// The [TaskExecutor] is responsible for executing a [TaskConfiguration].
/// For each measure in the task, it looks up an appropriate [Probe] to
/// collect data.
///
/// Note that a [TaskExecutor] in itself is a [Executor].
/// This - amongst other things - imply that you can listen
/// to [Executor.measurements] from a task executor.
abstract class TaskExecutor<TConfig extends TaskConfiguration>
    extends AggregateExecutor<TConfig> {
  TConfig get task => configuration!;

  /// Returns a list of the running probes in this task executor.
  List<Probe> get probes =>
      executors.map((executor) => executor as Probe).toList();

  @override
  bool onInitialize() {
    if (task.measures != null) {
      for (Measure measure in task.measures!) {
        // create a new probe for each measure - this ensures that we can have
        // multiple measures of the same type, each using its own probe instance
        Probe? probe = SamplingPackageRegistry().create(measure.type);
        if (probe != null) {
          executors.add(probe);
          group.add(probe.measurements);
          probe.initialize(measure, deployment!);
        } else {
          warning(
              "A probe for measure type '${measure.type}' could not be created. "
              'This may be because this probe is not available on the operating system '
              'of this phone (primary device) or on the connected device. '
              'Or it may be because the sampling package containing this probe has not '
              'been registered in the SamplingPackageRegistry.');
        }
      }
    }
    return true;
  }
}

/// Executes a [BackgroundTask].
class BackgroundTaskExecutor extends TaskExecutor<BackgroundTask> {
  @override
  Future<bool> onStart() async {
    // Early out if no probes.
    if (probes.isEmpty) return true;

    // Early out if already running (this is a background task)
    if (state == ExecutorState.started) {
      warning(
          'Trying to start a $runtimeType but it is already started. Ignoring this.');
      return false;
    }

    // Check if the device for this task is connected.
    if (probes.first.deviceManager.isConnected) {
      if (configuration?.duration != null) {
        // If the task has a duration (optional), stop it again after this duration has passed.
        Timer(
            Duration(seconds: configuration!.duration!.toSeconds().truncate()),
            () => stop());
      }
      return await super.onStart();
    } else {
      warning(
          'A $runtimeType could not be started since the device for this task is not connected. '
          'Device type: ${probes.first.deviceManager.typeName}');
      return false;
    }
  }
}

/// Executes a [FunctionTask].
class FunctionTaskExecutor extends TaskExecutor<FunctionTask> {
  @override
  Future<bool> onStart() async {
    if (configuration?.function != null) {
      Function.apply(configuration!.function!, []);
    }
    return true;
  }
}

/// Executes an [AppTask].
///
/// An [AppTaskExecutor] simply wraps a [TaskExecutor], which is executed
/// when the app (user) wants to do this.
///
/// This executor works closely with the singleton [AppTaskController].
/// Whenever an [AppTaskExecutor] is started (e.g. in a [PeriodicTrigger]),
/// this executor is wrapped in a [UserTask] and put on a queue in
/// the [AppTaskController].
///
/// Later, the app (user) can start, cancel, or finalize a [UserTask]
/// by calling the `onStart()`, `onCancel()`, and `onDone()` methods,
/// respectively.
///
/// Special-purpose [UserTask]s can be created by an [UserTaskFactory]
/// and such factories can be registered in the [AppTaskController]
/// using the `registerUserTaskFactory` method.
class AppTaskExecutor<TConfig extends AppTask> extends TaskExecutor<TConfig> {
  /// The task executor which can be used to execute this user task once
  /// activated.
  TaskExecutor backgroundTaskExecutor = BackgroundTaskExecutor();

  /// The user task enqueued when this app task executor is started.
  /// Null if not started, or stopped again.
  UserTask? userTask;

  AppTaskExecutor() : super() {
    // add the events from the embedded executor to the overall stream of events
    group.add(backgroundTaskExecutor.measurements);
  }

  @override
  bool onInitialize() => true;

  @override
  Future<bool> onStart() async {
    // when an app task is started, create a UserTask and put it on the queue
    userTask = await AppTaskController().enqueue(this);
    state; // = ExecutorState.stopped;
    return true;
  }

  @override
  Future<bool> onStop() async {
    backgroundTaskExecutor.stop();
    // if an app task is stopped, remove the user task from the queue again
    if (userTask != null) AppTaskController().dequeue(userTask!.id);
    userTask = null;
    return true;
  }
}
