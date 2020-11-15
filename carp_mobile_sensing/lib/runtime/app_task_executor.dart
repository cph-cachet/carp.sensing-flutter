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
  AppTaskExecutor(AppTask task)
      : assert(task is AppTask,
            '$runtimeType should be initialized with an AppTask.'),
        super(task) {
    appTask = task;

    // create an embedded executor that later can be used to execute this task
    _taskExecutor = TaskExecutor(task);

    // add the events from the embedded executor to the overall stream of events
    _group.add(_taskExecutor.events);
  }

  /// The [AppTask] to be executed.
  AppTask appTask;
  TaskExecutor _taskExecutor;

  void onInitialize(Measure measure) {
    _taskExecutor.initialize(measure);
  }

  Future<void> onResume() async {
    // when an app task is resumed it has to be put on the queue
    AppTaskController().enqueue(this);
  }

  Future<void> onPause() async {
    // TODO - don't know what to do on pause????
  }

  Future<void> onStop() async {
    _taskExecutor.stop();
    await super.onStop();
  }
}

/// A factory which can create a [UserTask] based on the `type` of an
/// [AppTask].
abstract class UserTaskFactory {
  /// The list of supported [AppTask] types.
  List<String> types;

  /// Create a [UserTask] that wraps [executor].
  UserTask create(AppTaskExecutor executor);
}

/// A singleton controller of active (resumed / paused) [AppTaskExecutor]s.
class AppTaskController {
  static final AppTaskController _instance = AppTaskController._();
  final StreamController<UserTask> _controller =
      StreamController<UserTask>.broadcast();

  final Map<String, UserTask> _userTaskMap = {};

  /// The queue of [UserTask]s that the app/user need to attend to.
  List<UserTask> get userTaskQueue => _userTaskMap.values.toList();

  /// A stream of [UserTask]s as they are generated.
  ///
  /// This stream is usefull in a [StreamBuilder] to listen on
  /// changes to the [userTaskQueue].
  Stream<UserTask> get userTaskEvents => _controller.stream;

  factory AppTaskController() => _instance;
  AppTaskController._() {
    registerUserTaskFactory(SensingUserTaskFactory());
  }

  final Map<String, UserTaskFactory> _userTaskFactories = {};

  /// Reguster a [UserTaskFactory] which can create [UserTask]s
  /// for the specified [AppTask] types.
  void registerUserTaskFactory(UserTaskFactory factory) {
    factory.types.forEach((type) {
      _userTaskFactories[type] = factory;
    });
  }

  /// Put [executor] on the [userTaskQueue] for later access by the app.
  void enqueue(AppTaskExecutor executor) {
    UserTask userTask =
        _userTaskFactories[executor.appTask.type].create(executor);
    userTask.state = UserTaskState.enqueued;
    userTask.enqueued = DateTime.now();
    _userTaskMap[userTask.id] = userTask;
    _controller.add(userTask);
    info('Enqueued $userTask');
  }

  /// Remove an [UserTask] from the [userTaskQueue].
  void dequeue(String id) {
    UserTask userTask = _userTaskMap[id];
    userTask.state = UserTaskState.dequeued;
    _userTaskMap.remove(id);
    _controller.add(userTask);
    info('Dequeued $userTask');
  }
}

/// A task that the user of the app needs to attend to.
///
///
abstract class UserTask {
  final String _id = Uuid().v4();
  final AppTaskExecutor _executor;
  UserTaskState _state = UserTaskState.initialized;
  String get id => _id;
  String get type => _executor?.appTask?.type;
  String get title => _executor?.appTask?.title;
  String get description => _executor?.appTask?.description;
  String get instructions => _executor?.appTask?.instructions;

  /// The time this task was added to the list (enqueued).
  DateTime enqueued;

  /// The state of this task.
  UserTaskState get state => _state;

  set state(UserTaskState state) {
    _state = state;
    _stateController.add(state);
  }

  final StreamController<UserTaskState> _stateController =
      StreamController<UserTaskState>.broadcast();

  /// A stream of state changes of this user task.
  ///
  /// This stream is usefull in a [StreamBuilder] to listen on
  /// changes to a [UserTask].
  Stream<UserTaskState> get stateEvents => _stateController.stream;

  /// The [AppTask] from which this user task originates from.
  AppTask get task => _executor?.appTask;

  /// The [TaskExecutor] that is to be executed once the user
  /// want to start this task.
  TaskExecutor get executor => _executor._taskExecutor;

  UserTask(this._executor);

  /// Callback from app when this task is to be started.
  void onStart(BuildContext context) {
    state = UserTaskState.started;
  }

  /// Callback from app when this task is to be set on hold.
  void onHold(BuildContext context) {
    state = UserTaskState.onhold;
  }

  /// Callback from app when this task is done.
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
  initialized,

  /// Put on the [AppTaskController] queue.
  enqueued,

  /// Removed from the [AppTaskController] queue.
  dequeued,

  /// Started by the user.
  started,

  /// Put on hold by the user.
  onhold,

  /// Done by the user.
  done,
  undefined,
}

/// A [UserTaskFactory] that can create non-UI sensing tasks:
///  * [OneTimeSensingUserTask]
///  * [SensingUserTask]
class SensingUserTaskFactory implements UserTaskFactory {
  List<String> types = [
    SensingUserTask.SENSING_TYPE,
    OneTimeSensingUserTask.ONE_TIME_SENSING_TYPE,
  ];

  UserTask create(AppTaskExecutor executor) =>
      (executor.appTask.type == OneTimeSensingUserTask.ONE_TIME_SENSING_TYPE)
          ? OneTimeSensingUserTask(executor)
          : SensingUserTask(executor);
}

/// A non-UI sensing taks that collects sensor data.
/// For example, a `noise` datum.
///
/// It resumes sensing when the [onStart] methods is called and
/// pauses sensing when the [onDone] methods is called.
class SensingUserTask extends UserTask {
  static const String SENSING_TYPE = 'sensing';

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
  static const String ONE_TIME_SENSING_TYPE = 'one_time_sensing';

  OneTimeSensingUserTask(AppTaskExecutor executor) : super(executor);

  /// Resume sensing for 10 seconds.
  void onStart(BuildContext context) {
    super.onStart(context);
    // after 10 seconds, pause the executor automatically
    Timer(Duration(seconds: 10), () => super.onDone(context));
  }
}
