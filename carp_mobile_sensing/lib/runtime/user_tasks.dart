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

  String? get studyDeploymentId =>
      appTaskExecutor.deployment?.studyDeploymentId;
  late String id;
  String get type => task.type;
  String get name => task.name;
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

  /// Is this task available to be done by the user?
  bool get availableForUser => (_state == UserTaskState.enqueued ||
      _state == UserTaskState.canceled ||
      _state == UserTaskState.notified);

  /// Has a notification been created via a [NotificationController] in the
  /// phone's notification system?
  bool hasNotificationBeenCreated = false;

  /// A stream of state changes of this user task.
  ///
  /// This stream is useful in a [StreamBuilder] to listen on
  /// changes to a [UserTask].
  Stream<UserTaskState> get stateEvents => _stateController.stream;

  /// The [TaskExecutor] that is to be executed once the user
  /// want to start this task.
  TaskExecutor get executor => _executor.backgroundTaskExecutor;

  /// The [AppTaskExecutor] of this user task.
  AppTaskExecutor get appTaskExecutor => _executor;

  /// The result of this task, once done.
  Data? result;

  /// Create a new [UserTask] based on [executor].
  UserTask(AppTaskExecutor executor) {
    _executor = executor;
    id = const Uuid().v1();
  }

  /// Does this user task has a user interface (`Widget`) to show to the user?
  bool get hasWidget => false;

  /// The widget to be shown to the user as part of this task, if any.
  /// Note that the user interface may not be available before the [onStart]
  /// method has been called.
  Widget? get widget => null;

  /// Callback from the app when this task is to be started.
  @mustCallSuper
  void onStart() {
    // initialize the background task which holds any measures added to the app task
    executor.initialize(task.backgroundTask, _executor.deployment);
    state = UserTaskState.started;
  }

  /// Callback from the app if this task is canceled.
  ///
  /// If [dequeue] is `true` the task is removed from the queue.
  /// Otherwise, it it kept on the queue with state [UserTaskState.canceled].
  @mustCallSuper
  void onCancel({bool dequeue = false}) {
    state = UserTaskState.canceled;
    if (dequeue) AppTaskController().dequeue(id);
  }

  /// Callback from the app if this task expires.
  ///
  /// If [dequeue] is `true` the task is removed from the queue.
  /// Otherwise, it it kept on the queue with state [UserTaskState.expired].
  @mustCallSuper
  void onExpired() {
    state = UserTaskState.expired;
    AppTaskController().dequeue(id);
  }

  /// Callback from the app when this task is done.
  ///
  /// If [dequeue] is `true` the task is removed from the queue.
  /// [result] can specify the result obtained from this task, if available.
  @mustCallSuper
  void onDone({bool dequeue = false, Data? result}) {
    this.result = result;
    state = UserTaskState.done;
    AppTaskController().done(id, result);
    if (dequeue) AppTaskController().dequeue(id);
  }

  /// Callback from the OS when this task is clicked by the user in the
  /// OS notification system.
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

  /// The user has clicked on the notification based on this notification.
  notified,

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

/// A non-UI sensing task that collects sensor data in the background.
/// For example noise.
///
/// It starts when the [onStart] methods is called and stops when the
/// [onDone] methods is called.
class BackgroundSensingUserTask extends UserTask {
  /// A type of sensing user task which can be started and stopped.
  static const String SENSING_TYPE = 'sensing';

  /// A type of sensing user task which can be started once.
  /// See [OneTimeBackgroundSensingUserTask].
  static const String ONE_TIME_SENSING_TYPE = 'one_time_sensing';

  BackgroundSensingUserTask(super.executor);

  @override
  void onStart() {
    super.onStart();
    executor.start();
  }

  @override
  void onDone({dequeue = false, Data? result}) {
    super.onDone(dequeue: dequeue, result: result);
    executor.stop();
  }
}

/// A non-UI sensing task that collects sensor data once.
/// For example collecting location data.
///
/// It starts sensing when the [onStart] methods is called and then
/// automatically stops after 10 seconds.
class OneTimeBackgroundSensingUserTask extends BackgroundSensingUserTask {
  OneTimeBackgroundSensingUserTask(super.executor);

  /// Start sensing for 10 seconds, whereafter it is stops automatically.
  @override
  void onStart() {
    super.onStart();
    Timer(const Duration(seconds: 10), () => super.onDone());
  }
}
