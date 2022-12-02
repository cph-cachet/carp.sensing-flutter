/*
 * Copyright 2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of runtime;

class Persistence {
  static const String DATABASE_NAME = 'carp-data';
  static const String DEPLOYMENT_TABLENAME = 'deployment';
  static const String TASK_QUEUE_TABLENAME = 'task-queue';

  static final Persistence _instance = Persistence._();
  Persistence._();
  factory Persistence() => _instance;

  String? _databaseName;
  Database? database;

  /// Full path and name of the database.
  String get databaseName => _databaseName ?? 'unknown';

  Future<void> _initDatabasePath() async {
    if (_databaseName == null) {
      String path = await getDatabasesPath();
      _databaseName = '$path/$DATABASE_NAME.db';
    }
  }

  Future<void> init([SmartphoneDeployment? deployment]) async {
    info('Initializing $runtimeType...');
    await _initDatabasePath();

    // open the database - make sure to use the same database across app (re)start
    database = await openDatabase(
      databaseName,
      version: 1,
      singleInstance: true,
      onCreate: (Database db, int version) async {
        // when creating the database, create the tables
        await db.execute(
            'CREATE TABLE $DEPLOYMENT_TABLENAME (updated_at TEXT, deployment_id TEXT PRIMARY KEY, deployed_at TEXT, user_id TEXT, deployment TEXT)');
        await db.execute(
            'CREATE TABLE $TASK_QUEUE_TABLENAME (task_id TEXT PRIMARY KEY, user_task TEXT)');

        debug('$runtimeType - SQLite DB created');
      },
    );

    // save the deployment if specified
    if (deployment != null) (deployment);

    AppTaskController()
        .userTaskEvents
        .listen((task) => _userTaskHasChanged(task));

    info(
        '$runtimeType - SQLite DB opened and initialized - name: $databaseName');
  }

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
        'updated_at': DateTime.now().toUtc().toIso8601String(),
        'deployment_id': deployment.studyDeploymentId,
        'deployed_at': deployment.deployed?.toUtc().toIso8601String(),
        'user_id': deployment.userId,
        'deployment': jsonEncode(deployment),
      };
      await database?.insert(
        DEPLOYMENT_TABLENAME,
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
        DEPLOYMENT_TABLENAME,
        columns: ['deployment'],
        where: 'deployment_id = ?',
        whereArgs: [deploymentId],
      );
      debug('$runtimeType - maps: $maps');
      String jsonString = maps?[0]['deployment'] as String;
      deployment = SmartphoneDeployment.fromJson(
          json.decode(jsonString) as Map<String, dynamic>);
    } catch (exception) {
      warning('$runtimeType - Failed to load deployment - $exception');
    }

    return deployment;
  }

  void _userTaskHasChanged(UserTask task) {
    var snapshot = UserTaskSnapshot.fromUserTask(task);
  }
}
