/*
 * Copyright 2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of data_managers;

/// Stores meta data about the running [SmartphoneDeployment] and all
/// collected [Measurement] json objects in an SQLite database on the device's
/// local storage media.
///
/// Meta data is stored in the `deployment` table and measurements are stored
/// in the `measurements` table.
///
/// The path and filename format is
///
///   `~/carp-data.db`
///
/// where `~` is the folder where SQLite places it database files.
///
/// On iOS, this is the `NSDocumentsDirectory` and the files can be accessed via
/// the MacOS Finder.
///
/// On Android, Flutter files are stored in the `databases` directory, which is
/// located in the `data/data/<package_name>/databases/` folder.
/// Files can be accessed via AndroidStudio.
///
/// A new DB file is created each time the app is (re)started. Hence, several
/// `.db` files may exist for a study. This is done to ensure that the DB is
/// not corrupted when an app is forced to close and to keep the size of db files
/// down.
class SQLiteDataManager extends AbstractDataManager {
  static const String MEASUREMENT_TABLENAME = 'measurements';
  static const String DEPLOYMENT_ID_COLUMN = 'deployment_id';
  static const String TRIGGER_ID_COLUMN = 'trigger_id';
  static const String ROLENAME_COLUMN = 'device_rolename';
  static const String DTATYPE_COLUMN = 'data_type';
  static const String MEASUREMENT_COLUMN = 'measurement';

  String get databaseName => Persistence().databaseName;
  Database? get database => Persistence().database;

  @override
  String get type => DataEndPointTypes.SQLITE;

  @override
  Future<void> initialize(
    SmartphoneDeployment deployment,
    DataEndPoint dataEndPoint,
    Stream<Measurement> measurements,
  ) async {
    assert(dataEndPoint is SQLiteDataEndPoint);
    info('Initializing $runtimeType...');
    await super.initialize(deployment, dataEndPoint, measurements);

    // check to see if the measurements table is already created
    List<Map<String, Object?>>? tables = await database?.query('sqlite_master',
        where: 'name = ?', whereArgs: [MEASUREMENT_TABLENAME]);

    if (tables == null || tables.isEmpty) {
      debug("$runtimeType - Creating '$MEASUREMENT_TABLENAME' table");
      await database?.execute(
          'CREATE TABLE $MEASUREMENT_TABLENAME (id INTEGER PRIMARY KEY, $DEPLOYMENT_ID_COLUMN TEXT, $TRIGGER_ID_COLUMN INTEGER, $ROLENAME_COLUMN TEXT, $DTATYPE_COLUMN TEXT, $MEASUREMENT_COLUMN TEXT)');
    }
  }

  @override
  Future<void> onMeasurement(Measurement measurement) async {
    final Map<String, dynamic> map = {
      DEPLOYMENT_ID_COLUMN: deployment.studyDeploymentId,
      TRIGGER_ID_COLUMN: measurement.taskControl?.triggerId ?? 0,
      ROLENAME_COLUMN: measurement.taskControl?.targetDevice?.roleName ??
          deployment.deviceConfiguration.roleName,
      DTATYPE_COLUMN: measurement.dataType.toString(),
      MEASUREMENT_COLUMN: jsonEncode(measurement),
    };
    int? id = await database?.insert(
      MEASUREMENT_TABLENAME,
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // String deploymentId = deployment.studyDeploymentId;
    // int triggerId = measurement.taskControl?.triggerId ?? 0;
    // String rolename = measurement.taskControl?.targetDevice?.roleName ??
    //     deployment.deviceConfiguration.roleName;
    // String datatype = measurement.dataType.toString();
    // String measurementJson = jsonEncode(measurement);
    // String sql =
    //     "INSERT INTO $MEASUREMENT_TABLENAME(deployment_id, trigger_id, device_rolename, data_type, measurement) VALUES('$deploymentId', '$triggerId', '$rolename', '$datatype', '$measurementJson')";

    // int? id = await database?.rawInsert(sql);
    debug(
        '$runtimeType - writing data point to SQLite - id: $id, type: ${measurement.data.format}');
  }

  @override
  Future<void> onDone() async {
    await database?.close();
    await super.close();
  }

  @override
  Future<void> onError(Object? error) async => await onMeasurement(
      Measurement.fromData(Error(message: error.toString())));
}
