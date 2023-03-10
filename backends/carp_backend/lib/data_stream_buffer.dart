/*
 * Copyright 2023 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_backend;

/// A local buffer of data streams using the [SQLiteDataManager].
class DataStreamBuffer {
  SQLiteDataManager manager = SQLiteDataManager();
  SmartphoneDeployment? _deployment;
  Transaction? transaction;
  Batch? batch;

  SmartphoneDeployment? get deployment => _deployment;
  Database? get database => manager.database;

  static final DataStreamBuffer _instance = DataStreamBuffer._();
  factory DataStreamBuffer() => _instance;
  DataStreamBuffer._();

  /// Initialize this buffer by specifying which [deployment] it handles
  /// and the stream of [measurements] to buffer.
  Future<void> initialize(
    SmartphoneDeployment deployment,
    Stream<Measurement> measurements,
  ) async {
    info('Initializing $runtimeType...');
    _deployment = deployment;
    manager.initialize(SQLiteDataEndPoint(), deployment, measurements);
  }

  /// Get the list of [DataStreamBatch] which has not yet been uploaded.
  ///
  /// If [delete] is true, the data will be deleted from this buffer.
  /// This happens within a database transaction and needs to be committed
  /// using the [commit] method at some stage.
  ///
  /// Note that the list may be empty, if no data needs to be uploaded.
  Future<List<DataStreamBatch>> getDataStreamBatches([
    bool delete = false,
  ]) async {
    List<DataStreamBatch> batches = [];

    if (deployment != null) {
      await database?.transaction((txn) async {
        transaction = txn;
        batch = transaction?.batch();
        for (var stream in deployment!.expectedDataStreams) {
          var batch = await getDataStreamBatch(
            stream,
            delete,
          );
          if (batch != null) batches.add(batch);
        }
      });
    }
    return batches;
  }

  /// Get a [DataStreamBatch] of all data which has not been uploaded yet
  /// for the [stream].
  /// If [delete] is true, the data will be deleted from this buffer.
  ///
  /// Returns null if no data is found.
  Future<DataStreamBatch?> getDataStreamBatch(
    ExpectedDataStream stream, [
    bool delete = false,
  ]) async {
    DataStreamId dataStream = DataStreamId(
      studyDeploymentId: deployment!.studyDeploymentId,
      deviceRoleName: stream.deviceRoleName,
      dataType: stream.dataType,
    );

    DatabaseExecutor? executor = transaction ?? database;

    int firstSequenceId = 0;
    List<Measurement> measurements = [];
    Set<int> triggerIds = {};
    Set<int> rows = {};

    // get all measurement not uploaded yet for this stream
    final where = '${SQLiteDataManager.UPLOADED_COLUMN} = ? AND '
        '${SQLiteDataManager.ROLE_NAME_COLUMN} = ? AND '
        '${SQLiteDataManager.DATATYPE_COLUMN} = ?';
    final List<Map<String, dynamic>> maps = await executor?.query(
          SQLiteDataManager.MEASUREMENT_TABLE_NAME,
          where: where,
          whereArgs: [0, stream.deviceRoleName, stream.dataType],
        ) ??
        [];

    // fast out if there is no data
    if (maps.isEmpty) return null;

    for (var element in maps) {
      int row =
          int.tryParse(element[SQLiteDataManager.ID_COLUMN].toString()) ?? 0;
      rows.add(row); // save what is uploaded
      int? triggerId =
          int.tryParse(element[SQLiteDataManager.TRIGGER_ID_COLUMN].toString());
      if (triggerId != null) triggerIds.add(triggerId);

      final jsonString =
          element[SQLiteDataManager.MEASUREMENT_COLUMN] as String;
      final measurement =
          Measurement.fromJson(json.decode(jsonString) as Map<String, dynamic>);
      measurements.add(measurement);
    }
    firstSequenceId = rows.reduce(min);

    // batch ??= executor?.batch();
    final args = rows.join(',');
    String sql;
    if (delete) {
      sql = 'DELETE FROM ${SQLiteDataManager.MEASUREMENT_TABLE_NAME} WHERE '
          '${SQLiteDataManager.ID_COLUMN} IN ($args)';
      if (batch != null)
        batch?.rawDelete(sql);
      else
        executor?.rawDelete(sql);
    } else {
      sql = 'UPDATE ${SQLiteDataManager.MEASUREMENT_TABLE_NAME} SET '
          '${SQLiteDataManager.UPLOADED_COLUMN} = 1 WHERE ${SQLiteDataManager.ID_COLUMN} IN ($args)';
      if (batch != null)
        batch?.rawUpdate(sql);
      else
        executor?.rawUpdate(sql);
    }

    return DataStreamBatch(
      dataStream: dataStream,
      firstSequenceId: firstSequenceId,
      measurements: measurements,
      triggerIds: triggerIds,
    );
  }

  /// Commit any changes made to this buffer.
  /// Typically called after buffered data has been fetched via the
  /// [getDataStreamBatches] method and successfully uploaded
  Future<void> commit() async =>
      await batch?.commit(noResult: true, continueOnError: true);

  /// Close this buffer. No more data can be added.
  Future<void> close() async => await database?.close();
}
