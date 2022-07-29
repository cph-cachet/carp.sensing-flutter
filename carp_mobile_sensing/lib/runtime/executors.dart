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
///    +----------------------------------------------------------------+     +-----------+
///    |   +---------+    +-------------+    +---------+     +--------+ |  -> | undefined |
///    |   | created | -> | initialized | -> | resumed | <-> | paused | |     +-----------+
///    |   +---------+    +-------------+    +---------+     +--------+ |  -> | stopped   |
///    +----------------------------------------------------------------+     +-----------+
///
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
  /// or if this executor is not supported on the specific phone / OS.
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

  /// Is [nextState] a valid next state for this executor?
  ///
  /// For example:
  ///   * if the current state of this Executor is `initialized` then a valid next state is `resumed`.
  ///   * if the current state of this Executor is `resumed` then a valid next state is `paused`.
  ///   * if the current state of this Executor is `resumed` then `initialized` is **not** a valid next state.
  bool validNextState(ExecutorState nextState);

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

  @override
  bool validNextState(ExecutorState nextState) =>
      _stateMachine.validNextState(nextState);

  void _setState(_ExecutorStateMachine state) {
    _stateMachine = state;
    _stateEventController.add(state.state);
  }

  @override
  void initialize(TConfig configuration, [SmartphoneDeployment? deployment]) {
    _deployment = deployment;
    _configuration = configuration;
    _stateMachine.initialize();
  }

  @override
  void restart() => _stateMachine.restart();

  @override
  void pause() => _stateMachine.pause();

  @override
  void resume() => _stateMachine.resume();

  @override
  void stop() {
    _stateMachine.stop();
    _stateEventController.close();
  }

  void error() => _stateMachine.error();

  /// Callback when this executor is initialized.
  ///
  /// Note that this is a non-async method and should hence be 'light-weight'
  /// and not block execution for a long duration.
  @protected
  void onInitialize();

  /// Callback when this executor is resumed.
  @protected
  Future<void> onResume();

  /// Callback when this executor is paused.
  @protected
  Future<void> onPause();

  /// Callback when this executor is restarted.
  @protected
  Future<void> onRestart();

  /// Callback when this executor is stopped.
  @protected
  Future<void> onStop();

  @override
  String toString() => '$runtimeType - configuration: $configuration';
}

//---------------------------------------------------------------------------------------
//                                 EXECUTOR STATE MACHINE
//
//         created -> initialized -> resumed <-> paused *-> stopped/undefined
//
//---------------------------------------------------------------------------------------
//
// all of the below executor state machine classes are private and only used internally
// hence, they are not documented

abstract class _ExecutorStateMachine {
  ExecutorState get state;
  bool validNextState(ExecutorState nextState);

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
    info('Stopping ${executor.runtimeType}');
    executor._setState(_StoppedState(executor));
    executor.onStop();
  }

  // Default error behavior. A Executor can become undefined in all states.
  @override
  void error() {
    warning('Error in ${executor.runtimeType}.');
    executor._setState(_UndefinedState(executor));
  }

  // Default implementation of next state. Can always be stopped.
  @override
  bool validNextState(ExecutorState nextState) =>
      (nextState == ExecutorState.stopped);

  void _printWarning(String operation) => warning(
      'Trying to $operation a ${executor.runtimeType} in a state where this cannot be done - state: $state');
}

class _CreatedState extends _AbstractExecutorState
    implements _ExecutorStateMachine {
  _CreatedState(Executor executor)
      : super(executor as AbstractExecutor, ExecutorState.created);

  @override
  void initialize() {
    info('Initializing ${executor.runtimeType}');
    try {
      executor.onInitialize();
      executor._setState(_InitializedState(executor));
    } catch (error) {
      warning('Error initializing ${executor.runtimeType}: $error');
      executor._setState(_UndefinedState(executor));
    }
  }

  @override
  bool validNextState(ExecutorState nextState) =>
      (nextState == ExecutorState.initialized);

  @override
  String toString() => 'created';
}

class _InitializedState extends _AbstractExecutorState
    implements _ExecutorStateMachine {
  _InitializedState(Executor executor)
      : super(executor as AbstractExecutor, ExecutorState.initialized);

  @override
  void resume() {
    info('Resuming ${executor.runtimeType}');
    executor.onResume();
    executor._setState(_ResumedState(executor));
  }

  @override
  bool validNextState(ExecutorState nextState) =>
      (nextState == ExecutorState.resumed);

  @override
  String toString() => 'initialized';
}

class _ResumedState extends _AbstractExecutorState
    implements _ExecutorStateMachine {
  _ResumedState(Executor executor)
      : super(executor as AbstractExecutor, ExecutorState.resumed);

  @override
  void restart() {
    info('Restarting ${executor.runtimeType}');
    executor.pause(); // first pause executor, setting it in a paused state
    executor.onRestart();
    executor.resume();
  }

  @override
  void pause() {
    info('Pausing ${executor.runtimeType}');
    executor.onPause();
    executor._setState(_PausedState(executor));
  }

  @override
  bool validNextState(ExecutorState nextState) =>
      (nextState == ExecutorState.paused);

  @override
  String toString() => 'resumed';
}

class _PausedState extends _AbstractExecutorState
    implements _ExecutorStateMachine {
  _PausedState(Executor executor)
      : super(executor as AbstractExecutor, ExecutorState.paused);

  @override
  void restart() {
    info('Restarting ${executor.runtimeType}');
    executor.onRestart();
    executor.resume();
  }

  @override
  void resume() {
    info('Resuming ${executor.runtimeType}');
    executor.onResume();
    executor._setState(_ResumedState(executor));
  }

  @override
  bool validNextState(ExecutorState nextState) =>
      (nextState == ExecutorState.resumed);

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
