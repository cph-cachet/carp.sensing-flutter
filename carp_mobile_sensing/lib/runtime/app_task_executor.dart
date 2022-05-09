/*
 * Copyright 2020-2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of runtime;

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
class AppTaskExecutor extends TaskExecutor<AppTask> {
  /// The [AppTask] to be executed.
  // late AppTask appTask;
  late TaskExecutor _taskExecutor;
  AppTask get appTask => task as AppTask;

  AppTaskExecutor() : super() {
    // create an embedded executor that later can be used to execute this task
    _taskExecutor = AutomaticTaskExecutor();

    // add the events from the embedded executor to the overall stream of events
    group.add(_taskExecutor.data);
  }

  @override
  void onInitialize() {
    _taskExecutor.initialize(configuration!, deployment);
  }

  @override
  Future<void> onResume() async {
    // when an app task is resumed it has to be put on the queue
    AppTaskController().enqueue(this);
  }

  @override
  Future<void> onPause() async {
    // TODO - don't know what to do on pause. Remove from queue?
  }

  @override
  Future<void> onStop() async {
    _taskExecutor.stop();
    await super.onStop();
  }
}

/// A factory which can create a [UserTask] based on the `type` of an
/// [AppTask].
abstract class UserTaskFactory {
  /// The list of supported [AppTask] types.
  List<String> types = [];

  /// Create a [UserTask] that wraps [executor].
  UserTask create(AppTaskExecutor executor);
}

/// A task that the user of the app needs to attend to.
///
/// A [UserTask] is enqueued in the [AppTaskController]'s queue.
abstract class UserTask {
  final AppTaskExecutor _executor;
  UserTaskState _state = UserTaskState.initialized;

  String id = Uuid().v1();
  String get type => _executor.appTask.type;
  String get title => _executor.appTask.title;
  String get description => _executor.appTask.description;
  String get instructions => _executor.appTask.instructions;
  bool get notification => _executor.appTask.notification;

  /// The time this task should trigger (typically becoming visible to the user).
  late DateTime triggerTime;

  /// The time this task was added to the queue.
  late DateTime enqueued;

  /// Returns a [Duration] until this task expires and is removed from the queue.
  /// The returned [Duration] will be negative if [this] has expired.
  /// Returns `null` if this task never expires.
  Duration? get expiresIn => (_executor.appTask.expire != null)
      ? enqueued.add(_executor.appTask.expire!).difference(DateTime.now())
      : null;

  /// The state of this task.
  UserTaskState get state => _state;

  set state(UserTaskState state) {
    _state = state;
    _stateController.add(state);
  }

  final StreamController<UserTaskState> _stateController =
      StreamController.broadcast();

  /// A stream of state changes of this user task.
  ///
  /// This stream is usefull in a [StreamBuilder] to listen on
  /// changes to a [UserTask].
  Stream<UserTaskState> get stateEvents => _stateController.stream;

  /// The [AppTask] from which this user task originates from.
  AppTask get task => _executor.appTask;

  /// The [TaskExecutor] that is to be executed once the user
  /// want to start this task.
  TaskExecutor get executor => _executor._taskExecutor;

  /// Create a new [UserTask]. If [triggerTime] is not specified,
  /// it is set to `now`, i.e. to be triggered when created.
  UserTask(this._executor, {DateTime? triggerTime}) {
    this.triggerTime = triggerTime ?? DateTime.now();
  }

  /// Callback from the app when this task is to be started.
  @mustCallSuper
  @protected
  void onStart(BuildContext context) {
    state = UserTaskState.started;
  }

  /// Callback from app if this task is canceled.
  ///
  /// If [dequeue] is `true` the task is removed from the queue.
  /// Othervise, it it kept on the queue for later.
  @mustCallSuper
  @protected
  void onCancel(BuildContext context, {dequeue = false}) {
    state = UserTaskState.canceled;
    (dequeue)
        ? AppTaskController().dequeue(id)
        : state = UserTaskState.enqueued;
  }

  /// Callback from app when this task is done.
  ///
  /// If [dequeue] is `true` the task is removed from the queue.
  @mustCallSuper
  @protected
  void onDone(BuildContext context, {dequeue = false}) {
    state = UserTaskState.done;
    AppTaskController().done(id);
    if (dequeue) AppTaskController().dequeue(id);
  }

  /// Callback from the OS when this task is clicked
  /// by the user in the OS notification system.
  ///
  /// Default implementation is no-op, but can be extended in sub-classes.
  @mustCallSuper
  @protected
  void onNotification() {}

  @override
  String toString() =>
      '$runtimeType - id: $id, type: $type, title: $title, state: $state, triggerTime: $triggerTime';
}

/// The states of a [UserTask].
enum UserTaskState {
  /// Initialized and ready.
  initialized,

  /// Put on the [AppTaskController] queue.
  enqueued,

  /// Removed from the [AppTaskController] queue.
  dequeued,

  /// Started by the user.
  started,

  /// Canceled by the user.
  canceled,

  /// Done by the user.
  done,

  /// Expired.
  expired,

  /// An undefined state and cannot be used.
  /// Task should be ignored.
  undefined,
}

/// A non-UI sensing taks that collects sensor data.
/// For example, a `noise` datum.
///
/// It resumes sensing when the [onStart] methods is called and
/// pauses sensing when the [onDone] methods is called.
class SensingUserTask extends UserTask {
  /// A type of sensing user task which can be resumed and paused.
  static const String SENSING_TYPE = 'sensing';

  /// A type of sensing user task which can be resumed once.
  /// See [OneTimeSensingUserTask].
  static const String ONE_TIME_SENSING_TYPE = 'one_time_sensing';

  SensingUserTask(AppTaskExecutor executor) : super(executor);

  @override
  void onStart(BuildContext context) {
    super.onStart(context);
    executor.resume();
  }

  @override
  void onDone(BuildContext context, {dequeue = false}) {
    super.onDone(context, dequeue: dequeue);
    executor.pause();
  }
}

/// A non-UI sensing taks that collects sensor data once.
/// For example collecting a `location` datum.
///
/// It resumes sensing when the [onStart] methods is called and then
/// automatically pauses after 10 seconds.
class OneTimeSensingUserTask extends SensingUserTask {
  OneTimeSensingUserTask(AppTaskExecutor executor) : super(executor);

  /// Resume sensing for 10 seconds.
  /// After 10 seconds, the executor is paused automatically
  @override
  void onStart(BuildContext context) {
    super.onStart(context);
    Timer(Duration(seconds: 10), () => super.onDone(context));
  }
}
