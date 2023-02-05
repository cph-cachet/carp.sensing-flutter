/*
 * Copyright 2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of runtime;

/// A persistence layer that knows how to persistently store deployment and app
/// task information across app restart.
class Persistence {
  static const String DATABASE_NAME = 'carp';
  static const String DEPLOYMENT_TABLE_NAME = 'deployment';
  static const String TASK_QUEUE_TABLE_NAME = 'task_queue';

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
            'CREATE TABLE $DEPLOYMENT_TABLE_NAME (deployment_id TEXT PRIMARY KEY, updated_at TEXT, deployed_at TEXT, user_id TEXT, deployment TEXT)');
        await db.execute(
            'CREATE TABLE $TASK_QUEUE_TABLE_NAME (id INTEGER PRIMARY KEY, deployment_id TEXT, task_id TEXT, task TEXT)');

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

  /// Save the [deployment] persistently to a local cache.
  /// Returns `true` if successful.
  Future<bool> saveDeployment(SmartphoneDeployment deployment) async {
    info("$runtimeType - Saving deployment to database.");
    bool success = true;
    try {
      final Map<String, dynamic> map = {
        'deployment_id': deployment.studyDeploymentId,
        'updated_at': DateTime.now().toUtc().toIso8601String(),
        'deployed_at': deployment.deployed?.toUtc().toIso8601String(),
        'user_id': deployment.userId,
        'deployment': jsonEncode(deployment),
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
      final List<Map<String, Object?>>? maps = await database?.query(
        DEPLOYMENT_TABLE_NAME,
        columns: ['deployment'],
        where: 'deployment_id = ?',
        whereArgs: [deploymentId],
      );
      // debug('$runtimeType - maps: $maps');
      String jsonString = maps?[0]['deployment'] as String;
      deployment = SmartphoneDeployment.fromJson(
          json.decode(jsonString) as Map<String, dynamic>);
    } catch (exception) {
      warning('$runtimeType - Failed to load deployment - $exception');
    }

    return deployment;
  }

  /// Erase the [SmartphoneDeployment] with the [deploymentId] from local cache.
  Future<void> eraseDeployment(String deploymentId) async {
    info("$runtimeType - Restoring deployment, deploymentId: $deploymentId");
    try {
      await database?.delete(
        DEPLOYMENT_TABLE_NAME,
        where: 'deployment_id = ?',
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
      case UserTaskState.started:
      case UserTaskState.canceled:
      case UserTaskState.done:
      case UserTaskState.expired:
      case UserTaskState.undefined:
        // all these cases we need to create or update the record
        var snapshot = UserTaskSnapshot.fromUserTask(task);
        final Map<String, dynamic> map = {
          'deployment_id': task.studyDeploymentId,
          'task_id': task.id,
          'task': jsonEncode(snapshot),
        };
        await database?.insert(
          TASK_QUEUE_TABLE_NAME,
          map,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        break;

      case UserTaskState.dequeued:
        await database?.delete(
          TASK_QUEUE_TABLE_NAME,
          where: 'task_id = ?',
          whereArgs: [task.id],
        );
        break;
    }
  }

  /// Get the entire list of [UserTaskSnapshot].
  Future<List<UserTaskSnapshot>> getUserTasks() async {
    List<UserTaskSnapshot> result = [];
    try {
      final List<Map<String, Object?>>? list = await database?.query(
        TASK_QUEUE_TABLE_NAME,
        columns: ['user_task'],
      );
      debug('$runtimeType - list: $list');
      if (list != null && list.isNotEmpty) {
        for (var element in list) {
          result.add(UserTaskSnapshot.fromJson(element));
        }
      }
    } catch (exception) {
      warning('$runtimeType - Failed to load task queue - $exception');
    }

    return result;
  }
}
