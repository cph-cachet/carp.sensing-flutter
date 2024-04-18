/*
 * Copyright 2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of 'runtime.dart';

/// A persistence layer that knows how to persistently store deployment and
/// app task information across app restart.
class Persistence {
  static const String DATABASE_NAME = 'carp';
  static const String DEPLOYMENT_TABLE_NAME = 'deployment';
  static const String TASK_QUEUE_TABLE_NAME = 'task_queue';

  static const String DEPLOYMENT_ID_COLUMN = 'deployment_id';
  static const String ROLENAME_COLUMN = 'device_rolename';
  static const String DEPLOYMENT_STATUS_COLUMN = 'deployment_status';
  static const String UPDATED_AT_COLUMN = 'updated_at';
  static const String DEPLOYED_AT_COLUMN = 'deployed_at';
  static const String USER_ID_COLUMN = 'user_id';
  static const String DEPLOYMENT_COLUMN = 'deployment';

  static const String ID_COLUMN = 'id';
  static const String TASK_ID_COLUMN = 'task_id';
  static const String TASK_COLUMN = 'task';

  static final Persistence _instance = Persistence._();
  Persistence._();
  factory Persistence() => _instance;

  String? _databasePath;
  Database? database;

  /// Path of the database.
  String get databasePath => '$_databasePath';

  /// Full path and name of the database.
  String get databaseName => '$_databasePath/$DATABASE_NAME.db';

  /// Initialize the persistence layer and the database.
  Future<void> init([SmartphoneDeployment? deployment]) async {
    info('Initializing $runtimeType...');
    _databasePath ??= await getDatabasesPath();

    // open the database - make sure to use the same database across app (re)start
    database = await openDatabase(
      databaseName,
      version: 1,
      singleInstance: true,
      onCreate: (Database db, int version) async {
        // when creating the database, create the tables
        await db.execute(
            'CREATE TABLE $DEPLOYMENT_TABLE_NAME ($DEPLOYMENT_ID_COLUMN TEXT PRIMARY KEY, $ROLENAME_COLUMN TEXT, $DEPLOYMENT_STATUS_COLUMN INTEGER, $UPDATED_AT_COLUMN TEXT, $DEPLOYED_AT_COLUMN TEXT, $USER_ID_COLUMN TEXT, $DEPLOYMENT_COLUMN TEXT)');
        await db.execute(
            'CREATE TABLE $TASK_QUEUE_TABLE_NAME ($ID_COLUMN INTEGER PRIMARY KEY, $DEPLOYMENT_ID_COLUMN TEXT, $TASK_ID_COLUMN TEXT, $TASK_COLUMN TEXT)');

        debug('$runtimeType - $databaseName DB created');
      },
    );

    // save the deployment if specified
    if (deployment != null) saveDeployment(deployment);

    // listen to changes to the app task queue so we can save them
    AppTaskController().userTaskEvents.listen((task) => saveUserTask(task));

    info('$runtimeType - SQLite DB initialized - name: $databaseName');
  }

  /// Called when the app is closing.
  Future<void> close() async {
    await database?.close();
  }

  /// Get the list of all study deployments previously stored on this phone.
  ///
  /// Returns an empty list, if not study deployments are stored.
  Future<List<Study>> getAllStudyDeployments() async {
    info("$runtimeType - Getting all study deployments stored on this device.");
    List<Study> list = [];
    try {
      final List<Map<String, Object?>> maps = await database?.query(
            DEPLOYMENT_TABLE_NAME,
            columns: [
              DEPLOYMENT_ID_COLUMN,
              ROLENAME_COLUMN,
              DEPLOYMENT_STATUS_COLUMN,
            ],
          ) ??
          [];
      debug('$runtimeType - maps: $maps');
      if (maps.isNotEmpty) {
        for (var map in maps) {
          final study = Study(
            map[DEPLOYMENT_ID_COLUMN] as String,
            map[ROLENAME_COLUMN] as String,
          );
          final status = map[DEPLOYMENT_STATUS_COLUMN] as int;
          study.status = StudyStatus.values[status];
          list.add(study);
        }
      }
    } catch (exception) {
      warning('$runtimeType - Failed to load deployments - $exception');
    }

    return list;
  }

  /// Save the [deployment] persistently to a local cache.
  /// Returns `true` if successful.
  Future<bool> saveDeployment(SmartphoneDeployment deployment) async {
    info("$runtimeType - Saving deployment to database.");
    bool success = true;
    try {
      final Map<String, dynamic> map = {
        DEPLOYMENT_ID_COLUMN: deployment.studyDeploymentId,
        ROLENAME_COLUMN: deployment.deviceConfiguration.roleName,
        DEPLOYMENT_STATUS_COLUMN: deployment.status.index,
        UPDATED_AT_COLUMN: DateTime.now().toUtc().toIso8601String(),
        DEPLOYED_AT_COLUMN: deployment.deployed?.toUtc().toIso8601String(),
        USER_ID_COLUMN: deployment.userId,
        DEPLOYMENT_COLUMN: jsonEncode(deployment),
      };
      await database?.insert(
        DEPLOYMENT_TABLE_NAME,
        map,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (exception) {
      success = false;
      warning('$runtimeType - Failed to save deployment - $exception');
    }
    return success;
  }

  /// Restore the [SmartphoneDeployment] with the [deploymentId] from local cache.
  /// Returns a [SmartphoneDeployment] if successful, null otherwise.
  Future<SmartphoneDeployment?> restoreDeployment(String deploymentId) async {
    info("$runtimeType - Restoring deployment, deploymentId: $deploymentId");
    SmartphoneDeployment? deployment;
    try {
      final List<Map<String, Object?>> maps = await database?.query(
            DEPLOYMENT_TABLE_NAME,
            columns: [DEPLOYMENT_COLUMN],
            where: '$DEPLOYMENT_ID_COLUMN = ?',
            whereArgs: [deploymentId],
          ) ??
          [];
      // debug('$runtimeType - maps: $maps');
      if (maps.isNotEmpty) {
        final jsonString = maps[0][DEPLOYMENT_COLUMN] as String;
        deployment = SmartphoneDeployment.fromJson(
            json.decode(jsonString) as Map<String, dynamic>);
      }
    } catch (exception) {
      warning('$runtimeType - Failed to load deployment - $exception');
    }

    return deployment;
  }

  /// Erase the [SmartphoneDeployment] with the [deploymentId] from local cache.
  Future<void> eraseDeployment(String deploymentId) async {
    info("$runtimeType - Erasing deployment, deploymentId: $deploymentId");
    try {
      await database?.delete(
        DEPLOYMENT_TABLE_NAME,
        where: '$DEPLOYMENT_ID_COLUMN = ?',
        whereArgs: [deploymentId],
      );
    } catch (exception) {
      warning('$runtimeType - Failed to erase deployment - $exception');
    }
  }

  /// Update or delete a task queue entry.
  Future<void> saveUserTask(UserTask task) async {
    debug("$runtimeType - Saving task to database '$task'.");
    switch (task.state) {
      case UserTaskState.initialized:
      case UserTaskState.enqueued:
      case UserTaskState.notified:
      case UserTaskState.started:
      case UserTaskState.canceled:
      case UserTaskState.done:
      case UserTaskState.expired:
      case UserTaskState.undefined:
        // all these cases we need to create or update the record
        var snapshot = UserTaskSnapshot.fromUserTask(task);
        final Map<String, dynamic> map = {
          DEPLOYMENT_ID_COLUMN: task.studyDeploymentId,
          TASK_ID_COLUMN: task.id,
          TASK_COLUMN: jsonEncode(snapshot),
        };
        int count = await database?.update(
              TASK_QUEUE_TABLE_NAME,
              map,
              where: '$TASK_ID_COLUMN = ?',
              whereArgs: [task.id],
              conflictAlgorithm: ConflictAlgorithm.replace,
            ) ??
            0;

        if (count == 0) {
          await database?.insert(
            TASK_QUEUE_TABLE_NAME,
            map,
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
        break;
      case UserTaskState.dequeued:
        await database?.delete(
          TASK_QUEUE_TABLE_NAME,
          where: '$TASK_ID_COLUMN = ?',
          whereArgs: [task.id],
        );
        break;
    }
  }

  /// Get the entire list of [UserTaskSnapshot].
  Future<List<UserTaskSnapshot>> getUserTasks() async {
    List<UserTaskSnapshot> result = [];
    try {
      final List<Map<String, Object?>> list = await database?.query(
            TASK_QUEUE_TABLE_NAME,
            columns: [TASK_COLUMN],
          ) ??
          [];

      if (list.isNotEmpty) {
        for (var element in list) {
          final jsonString = element[TASK_COLUMN] as String;
          result.add(UserTaskSnapshot.fromJson(
              json.decode(jsonString) as Map<String, dynamic>));
        }
      }
    } catch (exception) {
      warning('$runtimeType - Failed to load task queue - $exception');
    }

    return result;
  }
}
