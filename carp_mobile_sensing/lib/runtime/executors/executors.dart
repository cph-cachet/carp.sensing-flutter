/*
 * Copyright 2018-2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of runtime;

//---------------------------------------------------------------------------------------
//                                        EXECUTORS
//---------------------------------------------------------------------------------------

/// The state of an [Executor].
///
/// The runtime state has the following state machine:
///
/// ```
///    +---------------------------------------------------------------+     +-----------+
///    |  +---------+    +-------------+    +---------+     +--------+ |  -> | undefined |
///    |  | created | -> | initialized | -> | resumed | <-> | paused | |     +-----------+
///    |  +---------+    +-------------+    +---------+     +--------+ |  -> | stopped   |
///    +---------------------------------------------------------------+     +-----------+
/// ```
enum ExecutorState {
  /// Created and ready to be initialized.
  created,

  /// Initialized and ready to be resumed.
  initialized,

  /// Resumed and active in data collection.
  resumed,

  /// Paused and not collecting data.
  paused,

  /// Stopped and can no longer collect data.
  stopped,

  /// Undefined state.
  ///
  /// Typically an executor becomes undefined if it cannot be initialized
  /// or if this executor (probe) is not supported on the specific phone / OS.
  undefined
}

/// A [Executor] is responsible for executing data collection based on a
/// configuration [TConfig].
///
/// The behavior of an executor is controlled by its life-cycle methods: [initialize],
/// [resume], [pause], and [stop]. A [restart] can be used to restart an executor
/// (e.g., if its configuration has changed).
///
/// The [state] property reveals the probe's current runtime state.
/// The [stateEvents] is a stream of state changes which can be listen to as a broadcast
/// stream.
///
/// If an error occurs the state of a probe becomes [undefined]. This is, for example,
/// used when an exception occur.
///
/// The executor returns collected data in the [data] stream. This is the main
/// usage of an executor. For example, to listens to events and print them;
///
///     executor.data.forEach(print);
///
abstract class Executor<TConfig> {
  /// The deployment that this executor is part of executing.
  SmartphoneDeployment? get deployment;

  /// The configuration of this executor as set when [initialize]d.
  TConfig? get configuration;

  /// The runtime state of this executor.
  ExecutorState get state;

  /// The runtime state changes of this executor.
  Stream<ExecutorState> get stateEvents;

  /// The stream of [DataPoint] generated from this executor.
  Stream<DataPoint> get data;

  /// Configure and initialize the executor before starting it.
  void initialize(TConfig configuration, [SmartphoneDeployment? deployment]);

  /// Resume the executor.
  void resume();

  /// Pause the executor. Paused until [resume], [restart] or [stop] is called.
  void pause();

  /// Restart the executor.
  ///
  /// This forces the executor to reload its [configuration] and restart sampling
  /// accordingly. Configuration may be specified via the [initialize] method
  /// before calling restart.
  void restart();

  /// Stop the executor. Once an executor is stopped, it cannot be started again.
  /// If you need to restart an executor, use the [restart] or [pause] and
  /// [resume] methods.
  void stop();
}

/// An abstract implementation of a [Executor] to extend from.
abstract class AbstractExecutor<TConfig> implements Executor<TConfig> {
  final StreamController<ExecutorState> _stateEventController =
      StreamController.broadcast();
  late _ExecutorStateMachine _stateMachine;
  SmartphoneDeployment? _deployment;
  TConfig? _configuration;

  @override
  SmartphoneDeployment? get deployment => _deployment;

  @override
  TConfig? get configuration => _configuration;

  @override
  Stream<ExecutorState> get stateEvents => _stateEventController.stream;

  @override
  ExecutorState get state => _stateMachine.state;

  AbstractExecutor() {
    _stateMachine = _CreatedState(this);
  }

  void _setState(_ExecutorStateMachine state) {
    _stateMachine = state;
    _stateEventController.add(state.state);
  }

  @override
  void initialize(TConfig configuration, [SmartphoneDeployment? deployment]) {
    info('Initializing $runtimeType');
    _deployment = deployment;
    _configuration = configuration;
    _stateMachine.initialize();
  }

  @override
  void resume() {
    info('Resuming $runtimeType');
    _stateMachine.resume();
  }

  @override
  void pause() {
    info('Pausing $runtimeType');
    _stateMachine.pause();
  }

  @override
  void restart() {
    info('Restarting $runtimeType');
    _stateMachine.restart();
    // resume();
  }

  @override
  void stop() {
    info('Stopping $runtimeType');
    _stateMachine.stop();
    _stateEventController.close();
  }

  void error() => _stateMachine.error();

  /// Callback when this executor is initialized.
  /// Returns true if succesfully initialized, false othervise.
  ///
  /// Note that this is a non-async method and should hence be 'light-weight'
  /// and not block execution for a long duration.
  @protected
  bool onInitialize();

  /// Callback when this executor is about to be resumed.
  /// Returns true if ready for being resumed, false othervise.
  @protected
  Future<bool> onResume();

  /// Callback when this executor is about to be paused.
  /// Returns true if ready for being paused, false othervise.
  @protected
  Future<bool> onPause();

  /// Callback when this executor is about to be restarted.
  /// Returns true if ready for being restarted, false othervise.
  @protected
  Future<bool> onRestart();

  /// Callback when this executor is about to be stopped.
  /// Returns true if ready for being stopped, false othervise.
  @protected
  Future<bool> onStop();

  @override
  String toString() =>
      '$runtimeType - state: $state, configuration: $configuration';
}

/// An abstract class used to implement aggregated executors (i.e., executors
/// with a set of underlying executors).
///
/// See [StudyDeploymentExecutor] and [TaskExecutor] for examples.
abstract class AggregateExecutor<TConfig> extends AbstractExecutor<TConfig> {
  static final DeviceInfo deviceInfo = DeviceInfo();
  final StreamGroup<DataPoint> group = StreamGroup.broadcast();
  final List<Executor> executors = [];

  @override
  Stream<DataPoint> get data => group.stream;

  @override
  Future<bool> onResume() async {
    for (var executor in executors) {
      executor.resume();
    }
    return true;
  }

  @override
  Future<bool> onPause() async {
    for (var executor in executors) {
      executor.pause();
    }
    return true;
  }

  @override
  void restart() {
    _stateMachine.restart();
  }

  @override
  Future<bool> onRestart() async {
    for (var executor in executors) {
      executor.restart();
    }
    // // TODO - are we to wait before restart? Wait for true?
    // print('>> $runtimeType - resuming from onRestart()');
    // resume();

    return true;
  }

  @override
  Future<bool> onStop() async {
    for (var executor in executors) {
      executor.stop();
    }
    executors.clear();
    return true;
  }
}

//------------------------------------------------------------------------------
//                           EXECUTOR STATE MACHINE
//
//     created -> initialized -> resumed <-> paused *-> stopped/undefined
//
//------------------------------------------------------------------------------
//
// All of the below executor state machine classes are private and only used
// internally, and are therefore not documented.

abstract class _ExecutorStateMachine {
  ExecutorState get state;

  void initialize();
  void pause();
  void resume();
  void restart();
  void stop();
  void error();
}

abstract class _AbstractExecutorState implements _ExecutorStateMachine {
  @override
  ExecutorState state;

  AbstractExecutor executor;
  _AbstractExecutorState(this.executor, this.state);

  // Default behavior is to print a warning.
  // If a state supports this method, this behavior is overwritten in
  // the state implementation classes below.

  @override
  void initialize() => _printWarning('initialize');
  @override
  void restart() => _printWarning('restart');
  @override
  void resume() => _printWarning('resume');
  @override
  void pause() => _printWarning('pause');

  // Default stop behavior. A Executor can be stopped in all states.
  @override
  void stop() {
    executor.onStop();
    executor._setState(_StoppedState(executor));
  }

  // Default error behavior. A Executor can experience an error and become
  // undefined in all states.
  @override
  void error() {
    warning('Error in ${executor.runtimeType}.');
    executor._setState(_UndefinedState(executor));
  }

  void _printWarning(String operation) => warning(
      'Trying to $operation a ${executor.runtimeType} in a state where this cannot be done - state: $state');
}

class _CreatedState extends _AbstractExecutorState
    implements _ExecutorStateMachine {
  _CreatedState(Executor executor)
      : super(executor as AbstractExecutor, ExecutorState.created);

  @override
  void initialize() {
    try {
      if (executor.onInitialize()) {
        executor._setState(_InitializedState(executor));
      }
    } catch (error) {
      warning('Error initializing ${executor.runtimeType}: $error');
      executor._setState(_UndefinedState(executor));
    }
  }

  @override
  String toString() => 'created';
}

class _InitializedState extends _AbstractExecutorState
    implements _ExecutorStateMachine {
  _InitializedState(Executor executor)
      : super(executor as AbstractExecutor, ExecutorState.initialized);

  @override
  void resume() {
    executor.onResume().then((resumed) {
      if (resumed) executor._setState(_ResumedState(executor));
    });
  }

  // @override
  // void restart() {
  //   info('Restarting ${executor.runtimeType}');
  //   executor.onRestart().then((restarted) {
  //     if (restarted) resume(); // only resume if succesfully restarted
  //   });
  // }

  @override
  void restart() {
    executor.onRestart();
  }

  @override
  String toString() => 'initialized';
}

class _ResumedState extends _AbstractExecutorState
    implements _ExecutorStateMachine {
  _ResumedState(Executor executor)
      : super(executor as AbstractExecutor, ExecutorState.resumed);

  @override
  void resume() {
    executor.onResume().then((resumed) {
      if (resumed) executor._setState(_ResumedState(executor));
    });
  }

  // @override
  // void restart() {
  //   info('Restarting ${executor.runtimeType}');
  //   executor.onRestart().then((restarted) {
  //     if (restarted) resume(); // only resume if ready to be restarted
  //   });
  // }

  @override
  void restart() {
    executor.onRestart();
  }

  @override
  void pause() {
    executor.onPause().then((paused) {
      if (paused) executor._setState(_PausedState(executor));
    });
  }

  @override
  String toString() => 'resumed';
}

class _PausedState extends _AbstractExecutorState
    implements _ExecutorStateMachine {
  _PausedState(Executor executor)
      : super(executor as AbstractExecutor, ExecutorState.paused);

  @override
  void resume() {
    executor.onResume().then((resumed) {
      if (resumed) executor._setState(_ResumedState(executor));
    });
  }

  // The following is removed - cannot restart in a paused state - use resume instead.
  // @override
  // void restart() {
  //   info('Restarting ${executor.runtimeType}');
  //   executor.onRestart().then((restarted) {
  //     if (restarted) executor.resume(); // only resume if succesfully restarted
  //   });
  // }

  @override
  String toString() => 'paused';
}

class _StoppedState extends _AbstractExecutorState
    implements _ExecutorStateMachine {
  _StoppedState(Executor executor)
      : super(executor as AbstractExecutor, ExecutorState.stopped);
  @override
  String toString() => 'stopped';
}

class _UndefinedState extends _AbstractExecutorState
    implements _ExecutorStateMachine {
  _UndefinedState(Executor executor)
      : super(executor as AbstractExecutor, ExecutorState.undefined);
  @override
  String toString() => 'undefined';
}
