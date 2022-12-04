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
  SmartphoneDeployment? _deployment;

  /// The [SmartphoneDeployment] that this controller controls.
  /// Set in the [initialize] method.
  SmartphoneDeployment? get deployment => _deployment;

  /// Should this App Task Controller send notifications to the user.
  bool notificationsEnabled = true;

  final Map<String, UserTask> _userTaskMap = {};

  /// The entire list of all [UserTask]s.
  ///
  /// Note that this list contains all tasks which has already triggered
  /// and which are planned to trigger in the future.
  List<UserTask> get userTasks => _userTaskMap.values.toList();

  /// The queue of [UserTask]s that the user need to attend to.
  List<UserTask> get userTaskQueue => _userTaskMap.values
      .where((task) => task.triggerTime.isBefore(DateTime.now()))
      .toList();

  /// A stream of [UserTask] events generate whenever a user task change state,
  /// like enqueued, dequeued, done, and expire.
  ///
  /// This stream is useful in a [StreamBuilder] to listen on
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

  /// Initialize and set up the app controller for the [deployment].
  ///
  /// If [enableNotifications] is true, a notification will be added to
  /// the phone's notification system when a task is enqueued via the
  /// [enqueue] method.
  Future<void> initialize(
    SmartphoneDeployment deployment, {
    bool enableNotifications = true,
  }) async {
    _deployment = deployment;
    if (Settings().saveAppTaskQueue) {
      // restore the queue from persistent storage
      await restoreQueue();

      // // listen to events and save the queue every time it is modified
      // userTaskEvents.listen((_) async => await saveQueue());
    }

    // set up a timer which cleans up in the queue once an hour
    Timer.periodic(const Duration(hours: 1), (timer) {
      for (var task in userTasks) {
        if (task.expiresIn != null && task.expiresIn!.isNegative) {
          expire(task.id);
        }
      }
    });

    notificationsEnabled = enableNotifications;
    if (notificationsEnabled) {
      await SmartPhoneClientManager().notificationController?.initialize();
    }
  }

  final Map<String, UserTaskFactory> _userTaskFactories = {};

  /// Register a [UserTaskFactory] which can create [UserTask]s
  /// for the specified [AppTask] types.
  void registerUserTaskFactory(UserTaskFactory factory) {
    for (var type in factory.types) {
      _userTaskFactories[type] = factory;
    }
  }

  /// Get an [UserTask] from the [userTasks] based on its [id].
  /// Returns `null` if no task is found.
  UserTask? getUserTask(String id) => _userTaskMap[id];

  /// Put [executor] on the [userTasks] for access by the app.
  ///
  /// [triggerTime] specifies when the task should trigger, i.e., be available.
  /// Notify the user if [sendNotification] and [notificationsEnabled] is true.
  /// If [triggerTime] is null, a notification is send immediately.
  ///
  /// Returns the [UserTask] added to the [userTasks].
  ///
  /// Returns `null` if not successful.
  Future<UserTask?> enqueue(
    AppTaskExecutor executor, {
    DateTime? triggerTime,
    bool sendNotification = true,
  }) async {
    if (_userTaskFactories[executor.task.type] == null) {
      warning(
          'Could not enqueue AppTask. Could not find a factory for creating '
          "a UserTask for type '${executor.task.type}'");
      return null;
    } else {
      UserTask userTask =
          _userTaskFactories[executor.task.type]!.create(executor);
      userTask.state = UserTaskState.enqueued;
      userTask.enqueued = DateTime.now();
      userTask.triggerTime = triggerTime ?? DateTime.now();
      _userTaskMap[userTask.id] = userTask;
      _controller.add(userTask);
      debug('$runtimeType - Enqueued $userTask');

      if (notificationsEnabled && sendNotification) {
        // create notification
        // TODO - iOS has a limit where it will only keep 64 notifications that will fire the soonest...
        // See the flutter_local_notifications plugin.
        (triggerTime == null)
            ? await SmartPhoneClientManager()
                .notificationController
                ?.sendNotification(userTask)
            : await SmartPhoneClientManager()
                .notificationController
                ?.scheduleNotification(userTask);
      }
      return userTask;
    }
  }

  /// De-queue (remove) an [UserTask] from the [userTasks].
  void dequeue(String id) {
    UserTask? userTask = _userTaskMap[id];
    if (userTask == null) {
      warning("Could not dequeue AppTask - id is not valid: '$id'");
    } else {
      userTask.state = UserTaskState.dequeued;
      _userTaskMap.remove(id);
      _controller.add(userTask);
      info('Dequeued $userTask');

      if (notificationsEnabled) {
        SmartPhoneClientManager()
            .notificationController
            ?.cancelNotification(userTask);
      }
    }
  }

  /// Mark the [UserTask] with [id] as done.
  /// [result] may contain the result obtained from the task.
  /// Note that a done task remains on the queue. If you want to remove a
  /// task from the queue, use the [dequeue] method.
  void done(String id, [Data? result]) {
    UserTask? userTask = _userTaskMap[id];
    if (userTask == null) {
      warning("Could not find AppTask - id is not valid: '$id'");
    } else {
      userTask.state = UserTaskState.done;
      userTask.result = result;
      _controller.add(userTask);
      info('Marked $userTask as done');

      SmartPhoneClientManager()
          .notificationController
          ?.cancelNotification(userTask);
    }
  }

  /// Expire an [UserTask].
  /// Note that an expired task remains on the queue. If you want to remove a
  /// task from the queue, use the [dequeue] method.
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
      SmartPhoneClientManager()
          .notificationController
          ?.cancelNotification(userTask);
    }
  }

  // String? _filename;

  // /// Current path and filename of the task queue.
  // Future<String?> get filename async {
  //   if (_filename == null) {
  //     String? path = await Settings().carpBasePath;
  //     _filename = '$path/tasks.json';
  //   }
  //   return _filename;
  // }

  // /// Save the queue persistently to a file.
  // /// Returns `true` if successful.
  // Future<bool> saveQueue() async {
  //   bool success = true;
  //   try {
  //     String name = (await filename)!;
  //     debug("$runtimeType - Saving task queue to file '$name'.");
  //     final json = jsonEncode(UserTaskSnapshotList.fromUserTasks(userTasks));
  //     File(name).writeAsStringSync(json);
  //   } catch (exception) {
  //     success = false;
  //     warning('$runtimeType - Failed to save task queue - $exception');
  //   }
  //   return success;
  // }

  /// Restore the queue from a file. Returns `true` if successful.
  Future<bool> restoreQueue() async {
    if (deployment == null) {
      warning('$runtimeType - No deployment information available');
      return false;
    }

    bool success = true;
    // UserTaskSnapshotList? queue;

    try {
      // String name = (await filename)!;
      // info("$runtimeType - Restoring task queue from file '$name'.");
      // String jsonString = File(name).readAsStringSync();
      // queue = UserTaskSnapshotList.fromJson(
      //     json.decode(jsonString) as Map<String, dynamic>);

      List<UserTaskSnapshot> snapshots =
          await Persistence().getUserTasks(deployment!.studyDeploymentId);

      // now create new AppTaskExecutors, initialize them, and add them to the queue
      for (var snapshot in snapshots) {
        AppTaskExecutor executor = AppTaskExecutor();

        // // find the deployment
        // SmartphoneDeployment? deployment;
        // if (snapshot.studyDeploymentId != null &&
        //     snapshot.deviceRoleName != null) {
        //   deployment = SmartPhoneClientManager()
        //       .lookupStudyRuntime(
        //         snapshot.studyDeploymentId!,
        //         snapshot.deviceRoleName!,
        //       )
        //       ?.deployment;
        // }
        // if (deployment == null) {
        //   warning(
        //       '$runtimeType - Could not find deployment information based on snapshot: $snapshot');
        // }

        executor.initialize(snapshot.task, deployment);

        // now put the restored task back on the queue
        if (_userTaskFactories[executor.task.type] == null) {
          warning(
              'Could not enqueue AppTask. Could not find a factory for creating '
              "a UserTask for type '${executor.task.type}'");
        } else {
          UserTask userTask =
              _userTaskFactories[executor.task.type]!.create(executor);
          userTask.id = snapshot.id;
          userTask.state = snapshot.state;
          userTask.enqueued = snapshot.enqueued;
          userTask.triggerTime = snapshot.triggerTime;

          _userTaskMap[userTask.id] = userTask;
          debug(
              '$runtimeType - Enqueued UserTask from loaded task queue: $userTask');
        }
      }
    } catch (exception) {
      success = false;
      warning('$runtimeType - Failed to load task queue - $exception');
    }
    return success;
  }
}

// @JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
// class UserTaskSnapshotList extends Serializable {
//   List<UserTaskSnapshot> snapshots = [];

//   UserTaskSnapshotList() : super();
//   UserTaskSnapshotList.fromUserTasks(List<UserTask> userTasks) {
//     snapshots = userTasks
//         .map((userTask) => UserTaskSnapshot.fromUserTask(userTask))
//         .toList();
//   }

//   @override
//   Function get fromJsonFunction => _$UserTaskSnapshotListFromJson;

//   factory UserTaskSnapshotList.fromJson(Map<String, dynamic> json) =>
//       FromJsonFactory().fromJson(json) as UserTaskSnapshotList;

//   @override
//   Map<String, dynamic> toJson() => _$UserTaskSnapshotListToJson(this);
// }

/// A snapshot of a [UserTask] at any given time. Used for saving user tasks
/// persistently across app restart.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class UserTaskSnapshot extends Serializable {
  late String id;
  late AppTask task;
  late UserTaskState state;
  late DateTime enqueued;
  late DateTime triggerTime;
  late bool hasNotificationBeenCreated;
  String? studyDeploymentId;
  String? deviceRoleName;

  UserTaskSnapshot(
    this.id,
    this.task,
    this.state,
    this.enqueued,
    this.triggerTime,
    this.hasNotificationBeenCreated,
    this.studyDeploymentId,
    this.deviceRoleName,
  ) : super();

  UserTaskSnapshot.fromUserTask(UserTask userTask) : super() {
    id = userTask.id;
    task = userTask.task;
    state = userTask.state;
    enqueued = userTask.enqueued;
    triggerTime = userTask.triggerTime;
    hasNotificationBeenCreated = userTask.hasNotificationBeenCreated;
    studyDeploymentId = userTask.studyDeploymentId;
    deviceRoleName =
        userTask.appTaskExecutor.deployment?.deviceConfiguration.roleName;
  }

  @override
  Function get fromJsonFunction => _$UserTaskSnapshotFromJson;

  factory UserTaskSnapshot.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as UserTaskSnapshot;

  @override
  Map<String, dynamic> toJson() => _$UserTaskSnapshotToJson(this);

  @override
  String toString() =>
      '$runtimeType - id:$id, task: $task, state: $state, enqueued: $enqueued, triggerTime: $triggerTime, studyDeploymentId: $studyDeploymentId, deviceRoleName: $deviceRoleName';
}
