/*
 * Copyright 2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_backend;

/// A local buffer of data streams based on a SQLite DB.
class DataStreamBuffer {
  static const String DATABASE_NAME = 'carp-data-stream-buffer';

  static const String ID_COLUMN = 'id';
  // static const String MEASUREMENT_TABLE_NAME = 'measurements';
  // SQLite does not have a separate Boolean storage class. Instead,
  // Boolean values are stored as integers 0 (false) and 1 (true).
  static const String UPLOADED_COLUMN = 'uploaded';
  static const String DEPLOYMENT_ID_COLUMN = 'deployment_id';
  static const String TRIGGER_ID_COLUMN = 'trigger_id';
  static const String ROLE_NAME_COLUMN = 'device_rolename';
  static const String DATATYPE_COLUMN = 'data_type';
  static const String MEASUREMENT_COLUMN = 'measurement';

  String? _databasePath;
  late SmartphoneDeployment _deployment;

  String get databaseName => '$_databasePath/$DATABASE_NAME.db';
  SmartphoneDeployment get deployment => _deployment;
  Database? database;

  static final DataStreamBuffer _instance = DataStreamBuffer._();
  factory DataStreamBuffer() => _instance;
  DataStreamBuffer._();

  Future<void> initialize(
    SmartphoneDeployment deployment,
    Stream<Measurement> measurements,
  ) async {
    info('Initializing $runtimeType...');
    _deployment = deployment;
    _databasePath ??= await getDatabasesPath();

    // open the database - make sure to use the same database across app (re)start
    database = await openDatabase(
      databaseName,
      version: 1,
      singleInstance: true,
      onCreate: (Database db, int version) async {
        // when creating the database, create the measurements tables
        for (var stream in deployment.expectedDataStreams) {
          // final tableName = '${stream.deviceRoleName}_${stream.dataType}';
          final tableName = getTableName(stream);
          debug("$runtimeType - Creating '$tableName' table");
          await db.execute(
              'CREATE TABLE $tableName ($ID_COLUMN INTEGER PRIMARY KEY, $UPLOADED_COLUMN INTEGER, $TRIGGER_ID_COLUMN INTEGER, $ROLE_NAME_COLUMN TEXT, $DATATYPE_COLUMN TEXT, $MEASUREMENT_COLUMN TEXT)');
        }

        debug("$runtimeType - '$databaseName' DB created");
      },
    );
  }

  String getTableName(ExpectedDataStream stream) =>
      '${stream.deviceRoleName}_${stream.dataType}';

  Future<void> onMeasurement(Measurement measurement) async {
    String? roleName = measurement.taskControl?.targetDevice?.roleName;
    String dataType = measurement.dataType.toString();
    if (roleName != null) {
      ExpectedDataStream stream =
          ExpectedDataStream(deviceRoleName: roleName, dataType: dataType);
      int? id = await database?.insert(
        getTableName(stream),
        {
          UPLOADED_COLUMN: 0,
          TRIGGER_ID_COLUMN: measurement.taskControl?.triggerId ?? 0,
          ROLE_NAME_COLUMN: roleName,
          DATATYPE_COLUMN: dataType,
          MEASUREMENT_COLUMN: jsonEncode(measurement),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      debug(
          '$runtimeType - wrote measurement to SQLite - id: $id, type: ${measurement.data.format}');
    } else {}
  }

  Future<void> onError(Object? error) async => await onMeasurement(
      Measurement.fromData(Error(message: error.toString())));

  Future<List<DataStreamBatch>> getDataStreamBatches([
    bool delete = false,
  ]) async {
    List<DataStreamBatch> batches = [];
    for (var stream in deployment.expectedDataStreams) {
      batches.add(await getDataStreamBatch(stream, delete));
    }
    return batches;
  }

  Future<DataStreamBatch> getDataStreamBatch(
    ExpectedDataStream stream, [
    bool delete = false,
  ]) async {
    DataStreamId dataStream = DataStreamId(
      studyDeploymentId: deployment.studyDeploymentId,
      deviceRoleName: stream.deviceRoleName,
      dataType: stream.dataType,
    );

    int firstSequenceId = 0;
    List<Measurement> measurements = [];
    Set<int> triggerIds = {};
    Set<int> rows = {};

    // get all measurement not uploaded yet
    final List<Map<String, dynamic>> maps = await database?.query(
          getTableName(stream),
          where: '$UPLOADED_COLUMN = ?',
          whereArgs: [0],
        ) ??
        [];

    for (var element in maps) {
      int row = int.tryParse(element[ID_COLUMN].toString()) ?? 0;
      rows.add(row); // save the list of what is uploaded
      int? triggerId = int.tryParse(element[TRIGGER_ID_COLUMN].toString());
      if (triggerId != null) triggerIds.add(triggerId);

      String jsonString = element[MEASUREMENT_COLUMN] as String;
      var measurement =
          Measurement.fromJson(json.decode(jsonString) as Map<String, dynamic>);
      measurements.add(measurement);
    }
    firstSequenceId = rows.reduce(min);

    // for (var row in rows) {
    //   if (delete) {
    //     database?.delete(
    //       getTableName(stream),
    //       where: '$ID_COLUMN = ?',
    //       whereArgs: [row],
    //     );
    //   } else {
    //     database?.update(
    //       getTableName(stream),
    //       {
    //         UPLOADED_COLUMN: 1,
    //       },
    //       where: '$ID_COLUMN = ?',
    //       whereArgs: [row],
    //     );
    //   }
    // }

    if (delete) {
      database?.delete(
        getTableName(stream),
        where: '$ID_COLUMN = ?',
        whereArgs: rows.toList(),
      );
    } else {
      database?.update(
        getTableName(stream),
        {
          UPLOADED_COLUMN: 1,
        },
        where: '$ID_COLUMN = ?',
        whereArgs: rows.toList(),
      );
    }

    return DataStreamBatch(
      dataStream: dataStream,
      firstSequenceId: firstSequenceId,
      measurements: measurements,
      triggerIds: triggerIds,
    );
  }

  Future<void> close() async {
    await database?.close();
  }
}
