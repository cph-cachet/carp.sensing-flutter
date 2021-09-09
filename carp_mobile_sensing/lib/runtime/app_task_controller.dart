/*
 * Copyright 2020 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of runtime;

/// A controller of [UserTask]s which is accessible in the [userTaskQueue].
class AppTaskController {
  static final AppTaskController _instance = AppTaskController._();
  final StreamController<UserTask> _controller = StreamController.broadcast();

  /// The study deployment id for the running study.
  String? get studyDeploymentId => Settings().studyDeploymentId;

  final Map<String, UserTask> _userTaskMap = {};

  /// The queue of [UserTask]s that the user need to attend to.
  List<UserTask> get userTaskQueue => _userTaskMap.values.toList();

  /// A stream of [UserTask]s as they are generated.
  ///
  /// This stream is usefull in a [StreamBuilder] to listen on
  /// changes to the [userTaskQueue].
  Stream<UserTask> get userTaskEvents => _controller.stream;

  /// The total number of tasks.
  int get taskTotal => userTaskQueue.length;

  /// The number of tasks completed so far.
  int get taskCompleted =>
      userTaskQueue.where((task) => task.state == UserTaskState.done).length;

  /// The number of tasks expired so far.
  int get taskExpired =>
      userTaskQueue.where((task) => task.state == UserTaskState.expired).length;

  /// The number of tasks pending so far.
  int get taskPending => userTaskQueue
      .where((task) => task.state == UserTaskState.enqueued)
      .length;

  /// Get the singleton instance of [AppTaskController].
  ///
  /// The [AppTaskController] is designed to work as a singleton.
  factory AppTaskController() => _instance;

  AppTaskController._() {
    registerUserTaskFactory(SensingUserTaskFactory());
  }

  /// Initialize and set up the app controller.
  ///
  /// Caches app tasks based on the [studyDeploymentId], if
  /// [Settings().saveAppTaskQueue] is `true`.
  ///
  /// An optional [SelectedUserTaskNotificationCallback] callback can be specified
  /// to be called when the notification is selected by the user.
  Future<void> initialize({
    SelectedUserTaskNotificationCallback? selectedUserTaskNotificationCallback,
  }) async {
    if (studyDeploymentId != null && Settings().saveAppTaskQueue) {
      // retore the queue from persistent storage
      await restoreQueue();

      // listen to events and save the queue every time it is modified
      userTaskEvents.listen((_) async => await saveQueue());
    }

    // set up a timer which cleans up in the queue once an hour
    Timer.periodic(const Duration(hours: 1), (timer) {
      userTaskQueue.forEach((task) {
        if (task.expiresIn != null && task.expiresIn!.isNegative) {
          expire(task.id);
        }
      });
    });

    await NotificationController().initialize(
        selectedUserTaskNotificationCallback:
            selectedUserTaskNotificationCallback);
  }

  final Map<String, UserTaskFactory> _userTaskFactories = {};

  /// Register a [UserTaskFactory] which can create [UserTask]s
  /// for the specified [AppTask] types.
  void registerUserTaskFactory(UserTaskFactory factory) {
    factory.types.forEach((type) {
      _userTaskFactories[type] = factory;
    });
  }

  /// Get an [UserTask] from the [userTaskQueue] based on its [id].
  /// Returns `null` if no task is found on the queue.
  UserTask? getUserTask(String id) => _userTaskMap[id];

  /// Put [executor] on the [userTaskQueue] for later access by the app.
  ///
  /// Returns the [UserTask] added to the [userTaskQueue].
  /// Returns `null` if not successful.
  UserTask? enqueue(AppTaskExecutor executor) {
    if (_userTaskFactories[executor.appTask.type] == null) {
      warning(
          'Could not enqueue AppTask. Could not find a factory for creating '
          "a UserTask for type '${executor.appTask.type}'");
      return null;
    } else {
      UserTask userTask =
          _userTaskFactories[executor.appTask.type]!.create(executor);
      userTask.state = UserTaskState.enqueued;
      userTask.enqueued = DateTime.now();
      _userTaskMap[userTask.id] = userTask;
      _controller.add(userTask);
      info('Enqueued $userTask');

      NotificationController().sendNotification(userTask);

      return userTask;
    }
  }

  /// De-queue (remove) an [UserTask] from the [userTaskQueue].
  void dequeue(String id) {
    UserTask? userTask = _userTaskMap[id];
    if (userTask == null) {
      warning("Could not dequeue AppTask - id is not valid: '$id'");
    } else {
      userTask.state = UserTaskState.dequeued;
      _userTaskMap.remove(id);
      _controller.add(userTask);
      info('Dequeued $userTask');

      NotificationController().cancelNotification(userTask);
    }
  }

  /// Mark an [UserTask] on the [userTaskQueue] as done.
  /// Note that a done task remains on the queue.
  /// If you want to remove a taks from the queue, use the [dequeue] method.
  void done(String id) {
    UserTask? userTask = _userTaskMap[id];
    if (userTask == null) {
      warning("Could not find AppTask - id is not valid: '$id'");
    } else {
      // only expire tasks which are not already done
      userTask.state = UserTaskState.done;
      _controller.add(userTask);
      info('Marked $userTask as done');

      NotificationController().cancelNotification(userTask);
    }
  }

  /// Expire an [UserTask] on the [userTaskQueue].
  /// Note that an expired task remains on the queue.
  /// If you want to remove a taks from the queue, use the [dequeue] method.
  void expire(String id) {
    UserTask? userTask = _userTaskMap[id];
    if (userTask == null) {
      warning("Could not expire AppTask - id is not valid: '$id'");
    } else {
      // only expire tasks which are not already done or expired
      if (userTask.state != UserTaskState.done) {
        userTask.state = UserTaskState.expired;
        _controller.add(userTask);
        info('Expired $userTask');
      }
      NotificationController().cancelNotification(userTask);
    }
  }

  /// Current path and filename of the task queue according to this format:
  ///
  ///   `carp/study/tasks-<study_deployment_id>.json`
  ///
  String get filename =>
      '${Settings().queuePath}/tasks_$studyDeploymentId.json';

  /// Save the queue persistenly to a file.
  Future<bool> saveQueue() async {
    bool success = true;
    info("Saving task queue to file '$filename'.");
    try {
      final json =
          jsonEncode(UserTaskSnapshotList.fromUserTasks(userTaskQueue));
      File(filename).writeAsStringSync(json);
    } catch (exception) {
      success = false;
      warning('Failed to save task queue - $exception');
    }
    return success;
  }

  /// Restore the queue from a file.
  Future<void> restoreQueue() async {
    info("Restoring task queue from file '$filename'.");
    UserTaskSnapshotList? queue;

    try {
      String jsonString = File(filename).readAsStringSync();
      queue = UserTaskSnapshotList.fromJson(
          json.decode(jsonString) as Map<String, dynamic>);

      // now create new AppTaskExecutors, initialize them, and add them to the queue
      queue.snapshot.forEach((snapshot) {
        AppTaskExecutor executor = AppTaskExecutor(snapshot.task);
        executor.initialize(Measure(type: CAMSDataType.EXECUTOR));
        UserTask? userTask = enqueue(executor);
        if (userTask != null) {
          userTask.enqueued = snapshot.enqueued;
          userTask.state = snapshot.state;
        }
      });
    } catch (exception) {
      warning('Failed to load task queue - $exception');
    }
  }
}

@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class UserTaskSnapshotList extends Serializable {
  List<UserTaskSnapshot> snapshot = [];

  UserTaskSnapshotList() : super();
  UserTaskSnapshotList.fromUserTasks(List<UserTask> userTaskQueue) {
    snapshot = userTaskQueue
        .map((userTask) => UserTaskSnapshot.fromUserTask(userTask))
        .toList();
  }

  Function get fromJsonFunction => _$UserTaskSnapshotListFromJson;
  factory UserTaskSnapshotList.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as UserTaskSnapshotList;
  Map<String, dynamic> toJson() => _$UserTaskSnapshotListToJson(this);
}

/// A snapshot of a [UserTask] at any given time. Used for saving user tasks
/// persistently across app restart.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class UserTaskSnapshot extends Serializable {
  late AppTask task;
  late UserTaskState state;
  late DateTime enqueued;

  UserTaskSnapshot(this.task, this.state, this.enqueued) : super();
  UserTaskSnapshot.fromUserTask(UserTask userTask) {
    task = userTask.task;
    state = userTask.state;
    enqueued = userTask.enqueued;
  }
  Function get fromJsonFunction => _$UserTaskSnapshotFromJson;
  factory UserTaskSnapshot.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as UserTaskSnapshot;
  Map<String, dynamic> toJson() => _$UserTaskSnapshotToJson(this);
}

/// A [UserTaskFactory] that can create non-UI sensing tasks:
///  * [OneTimeSensingUserTask]
///  * [SensingUserTask]
class SensingUserTaskFactory implements UserTaskFactory {
  @override
  List<String> types = [
    SensingUserTask.SENSING_TYPE,
    SensingUserTask.ONE_TIME_SENSING_TYPE,
  ];

  @override
  UserTask create(AppTaskExecutor executor) =>
      (executor.appTask.type == SensingUserTask.ONE_TIME_SENSING_TYPE)
          ? OneTimeSensingUserTask(executor)
          : SensingUserTask(executor);
}
