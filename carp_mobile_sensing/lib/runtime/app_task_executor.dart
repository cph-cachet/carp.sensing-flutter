/*
 * Copyright 2020 Copenhagen Center for Health Technology (CACHET) at the
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
/// Special-purpose [UserTask] can be created by an [UserTaskFactory]
/// and such factories can be registered in the [AppTaskController]
/// using the `registerUserTaskFactory` method.
class AppTaskExecutor extends TaskExecutor {
  AppTaskExecutor(AppTask task) : super(task) {
    assert(task is AppTask,
        'AppTaskExecutor should be initialized with an AppTask.');
    appTask = task;

    // create an embedded executor that later can be used to execute this task
    _taskExecutor = TaskExecutor(task);

    // add the events from the embedded executor to the overall stream of events
    _group.add(_taskExecutor!.data);
  }

  /// The [AppTask] to be executed.
  AppTask? appTask;
  TaskExecutor? _taskExecutor;

  void onInitialize(Measure measure) {
    _taskExecutor!.initialize(measure);
  }

  Future onResume() async {
    // when an app task is resumed it has to be put on the queue
    AppTaskController().enqueue(this);
  }

  Future onPause() async {
    // TODO - don't know what to do on pause????
  }

  Future onStop() async {
    _taskExecutor!.stop();
    await super.onStop();
  }
}

/// A factory which can create a [UserTask] based on the `type` of an
/// [AppTask].
abstract class UserTaskFactory {
  /// The list of supported [AppTask] types.
  List<String>? types;

  /// Create a [UserTask] that wraps [executor].
  UserTask create(AppTaskExecutor executor);
}

/// A controller of [UserTask]s which accessible in the [userTaskQueue].
class AppTaskController {
  static final AppTaskController _instance = AppTaskController._();
  final StreamController<UserTask> _controller = StreamController.broadcast();

  final Map<String, UserTask> _userTaskMap = {};

  /// The queue of [UserTask]s that the app/user need to attend to.
  List<UserTask> get userTaskQueue => _userTaskMap.values.toList();

  /// A stream of [UserTask]s as they are generated.
  ///
  /// This stream is usefull in a [StreamBuilder] to listen on
  /// changes to the [userTaskQueue].
  Stream<UserTask> get userTaskEvents => _controller.stream;

  /// Constructs a singleton instance of [AppTaskController].
  ///
  /// [AppTaskController] is designed to work as a singleton.
  factory AppTaskController() => _instance;

  AppTaskController._() {
    registerUserTaskFactory(SensingUserTaskFactory());

    // set up a timer which cleans up in the queue once an hour
    Timer.periodic(const Duration(hours: 1), (timer) {
      userTaskQueue.forEach((task) {
        if (task.expiresIn!.isNegative) dequeue(task.id);
      });
    });
  }

  final Map<String, UserTaskFactory> _userTaskFactories = {};

  /// Reguster a [UserTaskFactory] which can create [UserTask]s
  /// for the specified [AppTask] types.
  void registerUserTaskFactory(UserTaskFactory factory) {
    factory.types!.forEach((type) {
      _userTaskFactories[type] = factory;
    });
  }

  /// Put [executor] on the [userTaskQueue] for later access by the app.
  void enqueue(AppTaskExecutor executor) {
    UserTask userTask =
        _userTaskFactories[executor.appTask!.type!]!.create(executor);
    userTask.state = UserTaskState.enqueued;
    userTask.enqueued = DateTime.now();
    _userTaskMap[userTask.id] = userTask;
    _controller.add(userTask);
    info('Enqueued $userTask');
  }

  /// Remove an [UserTask] from the [userTaskQueue].
  void dequeue(String id) {
    UserTask userTask = _userTaskMap[id]!;
    userTask.state = UserTaskState.dequeued;
    _userTaskMap.remove(id);
    _controller.add(userTask);
    info('Dequeued $userTask');
  }
}

/// A task that the user of the app needs to attend to.
///
/// A [UserTask] is enqueued in the [AppTaskController]'s queue.
abstract class UserTask {
  final String _id = Uuid().v4();
  final AppTaskExecutor _executor;
  UserTaskState _state = UserTaskState.initialized;
  String get id => _id;
  String? get type => _executor?.appTask?.type;
  String? get title => _executor?.appTask?.title;
  String? get description => _executor?.appTask?.description;
  String? get instructions => _executor?.appTask?.instructions;

  /// The time this task was added to the queue (enqueued).
  late DateTime enqueued;

  /// Returns a [Duration] until this task expires and is removed from the queue.
  ///
  /// The returned [Duration] will be negative if [this] has expired.
  /// Returns `null` if this task never expires.
  Duration? get expiresIn => (_executor.appTask!.expire == null)
      ? null
      : enqueued.add(_executor.appTask!.expire!).difference(DateTime.now());

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
  AppTask? get task => _executor?.appTask;

  /// The [TaskExecutor] that is to be executed once the user
  /// want to start this task.
  TaskExecutor? get executor => _executor._taskExecutor;

  UserTask(this._executor);

  /// Callback from app when this task is to be started.
  void onStart(BuildContext context) {
    state = UserTaskState.started;
  }

  /// Callback from app if this task is canceled.
  ///
  /// If [dequeue] is `true` the task is removed from the queue.
  /// Othervise, it it kept on the queue ready for later use.
  void onCancel(BuildContext context, {dequeue = false}) {
    state = UserTaskState.canceled;
    (dequeue)
        ? AppTaskController().dequeue(id)
        : state = UserTaskState.enqueued;
  }

  /// Callback from app when this task is done.
  ///
  /// If [dequeue] is `true` the task is removed from the queue.
  void onDone(BuildContext context, {dequeue = false}) {
    state = UserTaskState.done;
    if (dequeue) {
      AppTaskController().dequeue(id);
    }
  }

  String toString() =>
      '$runtimeType - id: $id, type: $type, title: $title, state: $state';
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

  /// An undefined state and cannot be used.
  /// Task Should be ignored.
  undefined,
}

/// A [UserTaskFactory] that can create non-UI sensing tasks:
///  * [OneTimeSensingUserTask]
///  * [SensingUserTask]
class SensingUserTaskFactory implements UserTaskFactory {
  List<String>? types = [
    SensingUserTask.SENSING_TYPE,
    SensingUserTask.ONE_TIME_SENSING_TYPE,
  ];

  UserTask create(AppTaskExecutor executor) =>
      (executor.appTask!.type == SensingUserTask.ONE_TIME_SENSING_TYPE)
          ? OneTimeSensingUserTask(executor)
          : SensingUserTask(executor);
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

  /// Resumes sensing.
  void onStart(BuildContext context) {
    super.onStart(context);
    executor?.resume();
  }

  /// Pauses sensing.
  void onDone(BuildContext context, {dequeue = false}) {
    super.onDone(context, dequeue: dequeue);
    executor?.pause();
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
  void onStart(BuildContext context) {
    super.onStart(context);
    // after 10 seconds, pause the executor automatically
    Timer(Duration(seconds: 10), () => super.onDone(context));
  }
}
