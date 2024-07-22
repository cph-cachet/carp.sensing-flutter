/*
 * Copyright 2020 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of '../../runtime.dart';

/// The [TaskExecutor] is responsible for executing a [TaskConfiguration].
/// For each measure in the task, it looks up an appropriate [Probe] to
/// collect data.
///
/// Note that a [TaskExecutor] in itself is a [Executor].
/// This - amongst other things - imply that you can listen
/// to [Executor.measurements] from a task executor.
abstract class TaskExecutor<TConfig extends TaskConfiguration>
    extends AggregateExecutor<TConfig> {
  final StreamGroup<ExecutorState> _statesGroup = StreamGroup.broadcast();

  /// The [TaskConfiguration] for this task executor.
  TConfig get task => configuration!;

  /// Returns a list of the probes in this task executor.
  List<Probe> get probes =>
      executors.map((executor) => executor as Probe).toList();

  /// The combines state event from all [probes] in this task executor.
  Stream<ExecutorState> get states => _statesGroup.stream;

  @override
  bool onInitialize() {
    if (task.measures != null) {
      for (Measure measure in task.measures!) {
        // create a new probe for each measure - this ensures that we can have
        // multiple measures of the same type, each using its own probe instance
        Probe? probe = SamplingPackageRegistry().create(measure.type);
        if (probe != null) {
          addExecutor(probe);
          _statesGroup.add(probe.stateEvents);

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
  StreamSubscription<ExecutorState>? _subscription;

  /// Are all [probes] in a stopped state?
  bool get haveAllProbesStopped =>
      !probes.any((probe) => probe.state != ExecutorState.stopped);

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

    // Listen to stop this background executor when all of its underlying
    // probes have stopped - Issue #384
    _subscription =
        states.where((event) => event == ExecutorState.stopped).listen((_) {
      if (haveAllProbesStopped) {
        debug(
            '$runtimeType - all probes have stopped - stopping this $runtimeType too.');
        stop();
      }
    });

    // Check if the device for this task is connected.
    if (probes.first.deviceManager.isConnected) {
      if (configuration?.duration != null) {
        // If the task has a duration (optional), stop it again after this duration has passed.
        Timer(Duration(seconds: configuration!.duration!.inSeconds.truncate()),
            () => stop());
      }

      // Now - finally - we can start the probes.
      return await super.onStart();
    } else {
      warning(
          'A $runtimeType could not be started since the device for this task is not connected. '
          'Device type: ${probes.first.deviceManager.typeName}');
      return false;
    }
  }

  @override
  Future<bool> onRestart() async {
    _subscription?.cancel();
    return super.onRestart();
  }

  @override
  Future<bool> onStop() async {
    _subscription?.cancel();
    return super.onStop();
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
/// An [AppTaskExecutor] wraps a [BackgroundTaskExecutor], which is started
/// by the app (user) and starts collecting the measures defined in this task.
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
    addExecutor(backgroundTaskExecutor);
  }

  @override
  bool onInitialize() => true;

  @override
  Future<bool> onStart() async {
    // when an app task is started, create a UserTask and put it on the queue
    userTask = await AppTaskController().enqueue(this);
    return userTask != null;
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
