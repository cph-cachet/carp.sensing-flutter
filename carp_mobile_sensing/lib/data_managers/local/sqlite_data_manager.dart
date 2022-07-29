/*
 * Copyright 2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of managers;

/// Stores [DataPoint] json objects in an SQLite database on the device's
/// local storage media.
///
/// The path and filename format is
///
///   `~/carp-data-yyyy-mm-dd-hh-mm-ss-ms.db`
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
  static const String TABLENAME = 'data_points';

  String? _databasePath;
  Database? database;

  @override
  String get type => DataEndPointTypes.SQLITE;

  @override
  Future<void> initialize(
    MasterDeviceDeployment deployment,
    DataEndPoint dataEndPoint,
    Stream<DataPoint> data,
  ) async {
    assert(dataEndPoint is SQLiteDataEndPoint);
    info('Initializing $runtimeType...');
    await super.initialize(deployment, dataEndPoint, data);

    // note that a new db (with timestamp in its name) is created on each app (re)start.
    String path = await databasePath;
    // open the database
    database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // when creating the db, create the table
      await db.execute(
          'CREATE TABLE $TABLENAME (id INTEGER PRIMARY KEY, created_at INTEGER, created_by TEXT, deployment_id TEXT, carp_header TEXT, carp_body TEXT)');
      debug('$runtimeType - SQLite DB created');
    });

    info('SQLite DB file path : $path');
  }

  /// Full path and name of the DB according to this format:
  ///
  ///   `~/carp-data-yyyy-mm-dd-hh-mm-ss-ms.db`
  ///
  /// where the date is in UTC format / zulu time.
  Future<String> get databasePath async {
    if (_databasePath == null) {
      // get the location of the SQLite DB
      String path = await getDatabasesPath();
      final created = DateTime.now()
          .toUtc()
          .toString()
          .replaceAll(RegExp(r':'), '-')
          .replaceAll(RegExp(r' '), '-')
          .replaceAll(RegExp(r'\.'), '-');

      _databasePath = '$path/carp-data-$created.db';
    }

    return _databasePath!;
  }

  @override
  Future<void> onDataPoint(DataPoint dataPoint) async {
    int createdAt = DateTime.now().millisecondsSinceEpoch;
    String createdBy = dataPoint.carpHeader.userId.toString();
    String carpHeader = jsonEncode(dataPoint.carpHeader);
    String carpBody = jsonEncode(dataPoint.carpBody);
    String deploymentId = deployment.studyDeploymentId;
    String sql =
        "INSERT INTO $TABLENAME(created_at, created_by, deployment_id, carp_header, carp_body) VALUES('$createdAt', '$createdBy', '$deploymentId', '$carpHeader', '$carpBody')";

    int? id = await database?.rawInsert(sql);
    debug(
        '$runtimeType - writing data point to SQLite - id: $id, type: ${dataPoint.carpHeader.dataFormat}');
  }

  @override
  Future<void> onDone() async {
    await database?.close();
    await super.close();
  }

  @override
  Future<void> onError(Object? error) async =>
      await onDataPoint(DataPoint.fromData(ErrorDatum(error.toString()))
        ..carpHeader.dataFormat = DataFormat.fromString(CAMSDataType.ERROR)
        ..carpHeader.studyId = deployment.studyDeploymentId
        ..carpHeader.userId = deployment.userId);
}