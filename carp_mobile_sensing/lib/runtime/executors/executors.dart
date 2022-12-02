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
///    +----------------------------------------------------------------+
///    |  +---------+    +-------------+    +---------+     +---------+ |     +-----------+
///    |  | created | -> | initialized | -> | started | <-> | stopped | |  -> | undefined |
///    |  +---------+    +-------------+    +---------+     +---------+ |     +-----------+
///    +----------------------------------------------------------------+
/// ```
enum ExecutorState {
  /// Created and ready to be initialized.
  created,

  /// Initialized and ready to be started.
  initialized,

  /// Started and active in data collection.
  started,

  /// Stopped and not collecting data.
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
/// [start], [stop], and [stop]. A [restart] can be used to restart an executor
/// (e.g., if its configuration has changed).
///
/// The [state] property reveals the probe's current runtime state.
/// The [stateEvents] is a stream of state changes which can be listen to as a broadcast
/// stream.
///
/// If an error occurs the state of a probe becomes [undefined]. This is, for example,
/// used when an exception occur.
///
/// The executor returns collected data in the [measurements] stream. This is the main
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

  /// Is this executor in the process of being started?
  ///
  /// This is true while the [start] method is executing.
  bool get isStarting;

  /// The runtime state changes of this executor.
  Stream<ExecutorState> get stateEvents;

  /// The stream of [Measurement] collected by this executor.
  Stream<Measurement> get measurements;

  /// Configure and initialize the executor before starting it.
  void initialize(TConfig configuration, [SmartphoneDeployment? deployment]);

  /// Start the executor.
  void start();

  /// Restart the executor.
  ///
  /// This forces the executor to reload its [configuration] and initialize sampling
  /// accordingly. Configuration must be specified via the [initialize] method
  /// before calling restart.
  ///
  /// Calling restart automatically starts the executor.
  void restart();

  /// Stop the executor. Stopped until [start] or [restart] is called.
  void stop();
}

/// An abstract implementation of a [Executor] to extend from.
abstract class AbstractExecutor<TConfig> implements Executor<TConfig> {
  final StreamController<ExecutorState> _stateEventController =
      StreamController.broadcast();
  late _ExecutorStateMachine _stateMachine;
  SmartphoneDeployment? _deployment;
  TConfig? _configuration;
  bool _isStarting = false;

  @override
  SmartphoneDeployment? get deployment => _deployment;

  @override
  TConfig? get configuration => _configuration;

  @override
  Stream<ExecutorState> get stateEvents => _stateEventController.stream;

  @override
  ExecutorState get state => _stateMachine.state;

  @override
  bool get isStarting => _isStarting;

  AbstractExecutor() {
    _stateMachine = _CreatedState(this);
  }

  void _setState(_ExecutorStateMachine state) {
    _stateMachine = state;
    _stateEventController.add(state.state);
  }

  @override
  void initialize(TConfig configuration, [SmartphoneDeployment? deployment]) {
    info('Initializing $runtimeType - configuration: $configuration');
    _deployment = deployment;
    _configuration = configuration;
    _stateMachine.initialize();
  }

  @override
  void start() {
    _isStarting = true;
    info('Starting $runtimeType');
    _stateMachine.start();
  }

  @override
  void restart() {
    info('Restarting $runtimeType');
    _stateMachine.restart();
  }

  @override
  void stop() {
    info('Stopping $runtimeType');
    _stateMachine.stop();
  }

  void error() => _stateMachine.error();

  /// Callback when this executor is initialized.
  /// Returns true if successfully initialized, false otherwise.
  ///
  /// Note that this is a non-async method and should hence be 'light-weight'
  /// and not block execution for a long duration.
  @protected
  bool onInitialize();

  /// Callback when this executor is started.
  /// Returns true if successfully started, false otherwise.
  @protected
  Future<bool> onStart();

  /// Callback when this executor is restarted.
  /// Returns true if successfully restarted, false otherwise.
  @protected
  Future<bool> onRestart();

  /// Callback when this executor is stopped.
  /// Returns true if successfully stopped, false otherwise.
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
  final StreamGroup<Measurement> group = StreamGroup.broadcast();
  final List<Executor> executors = [];

  @override
  Stream<Measurement> get measurements => group.stream;

  @override
  Future<bool> onStart() async {
    for (var executor in executors) {
      executor.start();
    }
    return true;
  }

  @override
  Future<bool> onRestart() async {
    for (var executor in executors) {
      executor.restart();
    }
    return true;
  }

  @override
  Future<bool> onStop() async {
    for (var executor in executors) {
      executor.stop();
    }
    return true;
  }
}

// All of the below executor state machine classes are private and only used
// internally, and are therefore not documented.

abstract class _ExecutorStateMachine {
  ExecutorState get state;

  void initialize();
  void start();
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
  void start() => _printWarning('start');
  @override
  void restart() => _printWarning('restart');

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
  void start() {
    executor.onStart().then((started) {
      if (started) executor._setState(_StartedState(executor));
      executor._isStarting = false;
    });
  }

  @override
  void restart() {
    executor.onRestart().then((restarted) {
      if (restarted) executor._setState(_StartedState(executor));
    });
  }

  @override
  String toString() => 'initialized';
}

class _StartedState extends _AbstractExecutorState
    implements _ExecutorStateMachine {
  _StartedState(Executor executor)
      : super(executor as AbstractExecutor, ExecutorState.started);

  @override
  void start() {
    executor.onStart().then((started) {
      if (started) executor._setState(_StartedState(executor));
      executor._isStarting = false;
    });
  }

  @override
  void restart() {
    executor.onRestart().then((restarted) {
      if (restarted) executor._setState(_InitializedState(executor));
    });
  }

  @override
  void stop() {
    executor.onStop().then((stopped) {
      if (stopped) executor._setState(_StoppedState(executor));
    });
  }

  @override
  String toString() => 'started';
}

class _StoppedState extends _AbstractExecutorState
    implements _ExecutorStateMachine {
  _StoppedState(Executor executor)
      : super(executor as AbstractExecutor, ExecutorState.stopped);

  @override
  void start() {
    executor.onStart().then((started) {
      if (started) executor._setState(_StartedState(executor));
      executor._isStarting = false;
    });
  }

  @override
  void restart() {
    executor.onRestart().then((restarted) {
      if (restarted) executor._setState(_InitializedState(executor));
    });
  }

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
