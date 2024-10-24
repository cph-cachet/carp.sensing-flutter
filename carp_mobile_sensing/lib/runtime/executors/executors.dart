/*
 * Copyright 2018-2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of '../../runtime.dart';

//---------------------------------------------------------------------------------------
//                                        EXECUTORS
//---------------------------------------------------------------------------------------

/// The state of an [Executor].
///
/// The runtime state has the following state machine:
///
/// ```
///    +----------------------------------------------------------------+      +-----------+
///    |  +---------+    +-------------+    +---------+     +---------+ |   -> | undefined |
///    |  | created | -> | initialized | -> | started | <-> | stopped | |      +-----------+
///    |  +---------+    +-------------+    +---------+     +---------+ |
///    |                                         |                      |      +-----------+
///    |                                      restart                   |   -> | disposed  |
///    +----------------------------------------------------------------+      +-----------+
/// ```
enum ExecutorState {
  /// Created and ready to be initialized.
  created,

  /// Initialized and ready to be started.
  initialized,

  /// Started and active in data collection. Can be restarted in this state.
  started,

  /// Stopped and not collecting data. Can be started again in this state.
  stopped,

  /// Permanently disposed. Cannot be used anymore.
  disposed,

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
  /// accordingly. Any changes to the configuration must be specified via the
  /// [initialize] method before calling restart.
  ///
  /// Only executors that has been started (i.e. in state [ExecutorState.started])
  /// can be restarted.
  ///
  /// Calling restart automatically starts the executor if it can be restarted.
  void restart();

  /// Stop the executor. Stopped until [start] or [restart] is called.
  void stop();

  /// Dispose of this executor.
  ///
  /// Is not stopped, [stop] will be called first.
  ///
  /// Once disposed, the executor cannot be used anymore and nothing will happen
  /// if any of the life cycle methods are called.
  void dispose();
}

/// An abstract implementation of a [Executor] to extend from.
abstract class AbstractExecutor<TConfig> implements Executor<TConfig> {
  final StreamController<Measurement> _measurementsController =
      StreamController.broadcast();
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
  Stream<Measurement> get measurements => _measurementsController.stream;

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

  /// Add [measurement] to the [measurements] stream.
  void addMeasurement(Measurement measurement) =>
      _measurementsController.add(measurement);

  /// Add [error] to the [measurements] stream.
  void addError(Object error, [StackTrace? stacktrace]) =>
      _measurementsController.addError(error, stacktrace);

  @override
  @nonVirtual
  void initialize(TConfig configuration, [SmartphoneDeployment? deployment]) {
    info('Initializing $this');
    _deployment = deployment;
    _configuration = configuration;
    _stateMachine.initialize();
  }

  @override
  @nonVirtual
  void start() {
    _isStarting = true;
    info('Starting $this');
    _stateMachine.start();
  }

  @override
  @nonVirtual
  void restart() {
    info('Restarting $this');
    _stateMachine.restart();
  }

  @override
  @nonVirtual
  void stop() {
    info('Stopping $this');
    _stateMachine.stop();
  }

  @override
  @nonVirtual
  void dispose() {
    info('Disposing $this');
    _stateMachine.dispose();
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

  /// Callback when this executor is to be restarted.
  /// Returns true if the executor is ready to restart (default), false otherwise.
  ///
  /// Subclasses should override this, to implement any configuration to be
  /// done before restarting.
  @protected
  Future<bool> onRestart() async => true;

  /// Callback when this executor is stopped.
  /// Returns true if successfully stopped, false otherwise.
  @protected
  Future<bool> onStop();

  /// Callback when this executor is disposed.
  ///
  /// Subclasses should override this, to implement any cleanup to be
  /// done before disposing.
  @protected
  Future<void> onDispose() async {}

  @override
  String toString() => '$runtimeType [$hashCode] (${state.name})';
}

/// An abstract class used to implement aggregated executors (i.e., executors
/// with a set of underlying executors).
///
/// See [SmartphoneDeploymentExecutor] and [TaskExecutor] for examples.
abstract class AggregateExecutor<TConfig> extends AbstractExecutor<TConfig> {
  static final DeviceInfo deviceInfo = DeviceInfo();
  final StreamGroup<Measurement> _group = StreamGroup.broadcast();
  final List<Executor<dynamic>> _executors = [];

  List<Executor<dynamic>> get executors => _executors;

  AggregateExecutor() : super() {
    _group.add(super.measurements);
  }

  @override
  Stream<Measurement> get measurements => _group.stream;

  /// Add the [executor] to the list of [executors] and forwards its measurements
  /// to this aggregate executor's stream of [measurements].
  void addExecutor(Executor<dynamic> executor) {
    _executors.add(executor);
    _group.add(executor.measurements);
  }

  /// Remove the [executor] to the list of [executors].
  void removeExecutor(Executor<dynamic> executor) {
    _group.remove(executor.measurements);
    _executors.remove(executor);
  }

  @override
  Future<bool> onStart() async {
    for (var executor in _executors) {
      executor.start();
    }
    return true;
  }

  @override
  Future<bool> onRestart() async {
    for (var executor in _executors) {
      executor.restart();
    }
    return true;
  }

  @override
  Future<bool> onStop() async {
    for (var executor in _executors) {
      executor.stop();
    }
    return true;
  }

  @override
  Future<void> onDispose() async {
    for (var executor in _executors) {
      executor.dispose();
    }
    _group.close();
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
  void dispose();
  void error();
}

abstract class _AbstractExecutorState implements _ExecutorStateMachine {
  AbstractExecutor<dynamic> executor;
  _AbstractExecutorState(this.executor);

  // Default behavior is to print a warning.
  // If a state supports this method, this behavior is overwritten in
  // the state implementation classes below.

  @override
  void initialize() => _printWarning('initialize');
  @override
  void start() => _printWarning('start');
  @override
  void restart() => _printWarning('restart');
  @override
  void stop() => _printWarning('stop');

  // Default dispose behavior. A Executor can be disposed in all states.
  @override
  void dispose() {
    if (state == ExecutorState.started) {
      warning(
          "Trying to dispose a ${executor.runtimeType} in a 'started' state."
          "Consider stopping it first.");
    }
    executor.onDispose().then((_) {
      executor._setState(_DisposedState(executor));
    });
  }

  // Default error behavior. A Executor can experience an error and become
  // undefined in all states.
  @override
  void error() {
    warning('Error in ${executor.runtimeType}.');
    executor._setState(_UndefinedState(executor));
  }

  void _printWarning(String operation) => warning(
      "Trying to $operation a ${executor.runtimeType} in a state where this cannot be done - state: '${state.name}'. "
      'Ignoring this.');

  @override
  String toString() => state.name;
}

class _CreatedState extends _AbstractExecutorState
    implements _ExecutorStateMachine {
  _CreatedState(Executor<dynamic> executor)
      : super(executor as AbstractExecutor);

  @override
  ExecutorState get state => ExecutorState.created;

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
}

class _InitializedState extends _AbstractExecutorState
    implements _ExecutorStateMachine {
  _InitializedState(Executor<dynamic> executor)
      : super(executor as AbstractExecutor);

  @override
  ExecutorState get state => ExecutorState.initialized;

  @override
  void start() {
    executor.onStart().then((started) {
      if (started) executor._setState(_StartedState(executor));
      executor._isStarting = false;
    });
  }
}

class _StartedState extends _AbstractExecutorState {
  _StartedState(Executor<dynamic> executor)
      : super(executor as AbstractExecutor);

  @override
  ExecutorState get state => ExecutorState.started;

  @override
  void restart() {
    executor.onRestart().then((restarted) {
      if (restarted) {
        // explicitly start the executor - issue #408
        executor.onStart().then((started) {
          if (started) executor._setState(_StartedState(executor));
          executor._isStarting = false;
        });
      }
    });
  }

  @override
  void stop() {
    executor.onStop().then((stopped) {
      if (stopped) executor._setState(_StoppedState(executor));
      debug('$executor - stopped');
    });
  }
}

class _StoppedState extends _AbstractExecutorState {
  _StoppedState(Executor<dynamic> executor)
      : super(executor as AbstractExecutor);

  @override
  ExecutorState get state => ExecutorState.stopped;

  @override
  void start() {
    executor.onStart().then((started) {
      if (started) executor._setState(_StartedState(executor));
      executor._isStarting = false;
    });
  }
}

class _DisposedState extends _AbstractExecutorState
    implements _ExecutorStateMachine {
  _DisposedState(Executor<dynamic> executor)
      : super(executor as AbstractExecutor);
  @override
  ExecutorState get state => ExecutorState.disposed;
}

class _UndefinedState extends _AbstractExecutorState
    implements _ExecutorStateMachine {
  _UndefinedState(Executor<dynamic> executor)
      : super(executor as AbstractExecutor);
  @override
  ExecutorState get state => ExecutorState.undefined;
}
