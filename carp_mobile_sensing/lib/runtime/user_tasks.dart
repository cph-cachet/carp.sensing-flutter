/*
 * Copyright 2020-2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of runtime;

/// A factory which can create a [UserTask] based on the `type` of an
/// [AppTask].
abstract class UserTaskFactory {
  /// The list of supported [AppTask] types.
  List<String> types = [];

  /// Create a [UserTask] that wraps [executor].
  UserTask create(AppTaskExecutor executor);

  // /// Create a [UserTask] of type [type].
  // UserTask create(String type);
}

/// A [UserTaskFactory] that can create the non-UI sensing tasks:
///  * [OneTimeBackgroundSensingUserTask]
///  * [BackgroundSensingUserTask]
class SensingUserTaskFactory implements UserTaskFactory {
  @override
  List<String> types = [
    BackgroundSensingUserTask.SENSING_TYPE,
    BackgroundSensingUserTask.ONE_TIME_SENSING_TYPE,
  ];

  @override
  UserTask create(AppTaskExecutor executor) =>
      (executor.task.type == BackgroundSensingUserTask.ONE_TIME_SENSING_TYPE)
          ? OneTimeBackgroundSensingUserTask(executor)
          : BackgroundSensingUserTask(executor);
}

/// A task that the user of the app needs to attend to.
///
/// A [UserTask] is enqueued in the [AppTaskController]'s queue.
abstract class UserTask {
  late AppTaskExecutor _executor;
  UserTaskState _state = UserTaskState.initialized;
  final StreamController<UserTaskState> _stateController =
      StreamController.broadcast();

  /// The [AppTask] from which this user task originates from.
  AppTask get task => _executor.task;

  String id = Uuid().v1();
  String get type => task.type;
  String get title => task.title;
  String get description => task.description;
  String get instructions => task.instructions;
  bool get notification => task.notification;

  /// The time this task should trigger (typically becoming visible to the user).
  late DateTime triggerTime;

  /// The time this task was added to the queue.
  late DateTime enqueued;

  /// Returns a [Duration] until this task expires and is removed from the queue.
  /// The returned [Duration] will be negative if [this] has expired.
  /// Returns `null` if this task never expires.
  Duration? get expiresIn => (task.expire != null)
      ? enqueued.add(task.expire!).difference(DateTime.now())
      : null;

  /// The state of this task.
  UserTaskState get state => _state;
  set state(UserTaskState state) {
    _state = state;
    _stateController.add(state);
  }

  /// Has a notification been created via a [NotificationController] in the
  /// phone's notification system?
  bool hasNotificationBeenCreated = false;

  /// A stream of state changes of this user task.
  ///
  /// This stream is usefull in a [StreamBuilder] to listen on
  /// changes to a [UserTask].
  Stream<UserTaskState> get stateEvents => _stateController.stream;

  /// The [TaskExecutor] that is to be executed once the user
  /// want to start this task.
  TaskExecutor get executor => _executor.backgroundTaskExecutor;

  /// The [AppTaskExecutor] of this user task.
  AppTaskExecutor get appTaskExecutor => _executor;

  /// Create a new [UserTask] based on [executor].
  UserTask(AppTaskExecutor executor) {
    _executor = executor;
  }

  /// Callback from the app when this task is to be started.
  @mustCallSuper
  void onStart(BuildContext context) {
    // initialize the background measure(s) as a background task
    executor.initialize(task.backgroundTask, _executor.deployment);
    state = UserTaskState.started;
  }

  /// Callback from the app if this task is canceled.
  ///
  /// If [dequeue] is `true` the task is removed from the queue.
  /// Othervise, it it kept on the queue for later.
  @mustCallSuper
  void onCancel(BuildContext context, {bool dequeue = false}) {
    state = UserTaskState.canceled;
    (dequeue)
        ? AppTaskController().dequeue(id)
        : state = UserTaskState.enqueued;
  }

  /// Callback from the app if this task is expired.
  ///
  /// If [dequeue] is `true` the task is removed from the queue.
  /// Otherwise, it it kept on the queue for later.
  @mustCallSuper
  void onExpired(BuildContext context) {
    state = UserTaskState.expired;
    AppTaskController().dequeue(id);
  }

  /// Callback from app when this task is done.
  ///
  /// If [dequeue] is `true` the task is removed from the queue.
  @mustCallSuper
  void onDone(BuildContext context, {bool dequeue = false}) {
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

/// A non-UI sensing taks that collects sensor data in the background.
/// For example, a `noise` datum.
///
/// It resumes sensing when the [onStart] methods is called and
/// pauses sensing when the [onDone] methods is called.
class BackgroundSensingUserTask extends UserTask {
  /// A type of sensing user task which can be resumed and paused.
  static const String SENSING_TYPE = 'sensing';

  /// A type of sensing user task which can be resumed once.
  /// See [OneTimeBackgroundSensingUserTask].
  static const String ONE_TIME_SENSING_TYPE = 'one_time_sensing';

  BackgroundSensingUserTask(super.executor);

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
class OneTimeBackgroundSensingUserTask extends BackgroundSensingUserTask {
  OneTimeBackgroundSensingUserTask(super.executor);

  /// Resume sensing for 10 seconds, whereafter it is paused automatically.
  @override
  void onStart(BuildContext context) {
    super.onStart(context);
    Timer(Duration(seconds: 10), () => super.onDone(context));
  }
}
