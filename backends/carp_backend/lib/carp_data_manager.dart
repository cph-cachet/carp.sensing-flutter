/*
 * Copyright 2018-2023 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_backend;

class CarpDataManagerFactory implements DataManagerFactory {
  @override
  String get type => DataEndPointTypes.CAWS;

  @override
  DataManager create() => CarpDataManager();

  CarpDataManagerFactory() : super() {
    CarpDataManager();
  }
}

/// Stores CAMS data points in the CARP Web Services (CAWS) backend.
///
/// Upload of data to CAWS can happen in three ways, as specified in
/// [CarpUploadMethod]:
///
///   * [CarpUploadMethod.stream] - Upload data as data streams (the default method).
///   * [CarpUploadMethod.datapoint] - Upload each data point separately using
///       the old DataPoint batch endpoint in CAWS.
///   * [CarpUploadMethod.file] - Collect measurements in a SQLite DB file and
///       upload as a `db` file
class CarpDataManager extends AbstractDataManager {
  late CarpDataEndPoint carpEndPoint;
  DataStreamBuffer buffer = DataStreamBuffer();
  Timer? uploadTimer;
  ConnectivityResult _connectivity = ConnectivityResult.none;

  /// Make sure to create and initialize the [CarpDataManager].
  static void ensureInitialized() =>
      FromJsonFactory().register(CarpDataEndPoint());

  CarpDataManager() : super() {
    CarpMobileSensing.ensureInitialized();
    FromJsonFactory().register(CarpDataEndPoint());
  }

  @override
  String get type => DataEndPointTypes.CAWS;

  /// The connectivity status of this data manager.
  ConnectivityResult get connectivity => _connectivity;
  set connectivity(ConnectivityResult status) {
    _connectivity = status;
    info("$runtimeType - Network connectivity status set to '${status.name}'");
  }

  @override
  Future<void> initialize(
    DataEndPoint dataEndPoint,
    SmartphoneDeployment deployment,
    Stream<Measurement> measurements,
  ) async {
    info("$runtimeType - Initializing, endpoint: $dataEndPoint");
    assert(dataEndPoint is CarpDataEndPoint);
    await super.initialize(dataEndPoint, deployment, measurements);
    carpEndPoint = dataEndPoint as CarpDataEndPoint;

    assert(CarpService().isConfigured,
        'CarpService is not configured -- cannot upload data to this end point.');

    buffer.initialize(deployment, measurements);

    // set up a timer that uploads data on a regular basis
    uploadTimer = Timer.periodic(Duration(minutes: carpEndPoint.uploadInterval),
        (_) => uploadBufferedMeasurements());

    // listen to connectivity events
    Connectivity()
        .onConnectivityChanged
        .listen((status) => connectivity = status);

    if (!CarpDataStreamService().isConfigured) {
      CarpDataStreamService().configureFrom(CarpService());
    }
  }

  @override
  Future<void> onMeasurement(Measurement measurement) async {}

  /// Upload buffered measurements to CAWS.
  Future<void> uploadBufferedMeasurements() async {
    info("$runtimeType - Starting upload of data batches...");

    // fast exit if not connected
    if (connectivity == ConnectivityResult.none) {
      warning('$runtimeType - Offline - cannot upload buffered data.');
      return;
    }

    // fast exit if only upload on wifi and we're not on wifi
    if (carpEndPoint.onlyUploadOnWiFi &&
        connectivity != ConnectivityResult.wifi) {
      warning(
          '$runtimeType - WiFi required by the data endpoint, but no wifi connectivity - '
          'cannot upload buffered data.');
      return;
    }

    // now start trying to upload data...
    try {
      // check if authenticated to CAWS and fast exit if not
      if (!CarpService().authenticated) {
        warning('No user authenticated to CAWS - cannot upload data.');
        return;
      }

      // check if token has expired, and try to refresh token, if so
      if (CarpService().currentUser.token!.hasExpired) {
        try {
          await CarpService().refresh();
        } catch (error) {
          warning('$runtimeType - Failed to refresh access token - $error. '
              'Cannot upload data.');
          return;
        }
      }

      final batches = await buffer.getDataStreamBatches(
        carpEndPoint.deleteWhenUploaded,
      );

      switch (carpEndPoint.uploadMethod) {
        case CarpUploadMethod.stream:
          await CarpDataStreamService().appendToDataStreams(
            studyDeploymentId,
            batches,
          );
          addEvent(
              DataManagerEvent(CarpDataManagerEventTypes.dataStreamAppended));
          break;
        case CarpUploadMethod.datapoint:
          await uploadDataStreamBatchesAsDataPoint(
            batches,
          );
          addEvent(DataManagerEvent(
              CarpDataManagerEventTypes.dataPointsBatchUploaded));
          break;
        case CarpUploadMethod.file:
          // TODO - implement file method.
          warning('$runtimeType - CarpUploadMethod.file not supported (yet).');
          break;
        default:
      }

      // check if any measurement has a separate file to be uploaded
      for (var batch in batches) {
        for (var measurement in batch.measurements) {
          if (measurement.data is FileData) {
            var fileData = measurement.data as FileData;
            if (fileData.upload) uploadFile(fileData);
          }
        }
      }

      // if everything is uploaded successfully, then commit the transaction
      await buffer.commit();

      info(
          "$runtimeType - Upload of data batches done - ${batches.length} batches uploaded.");
    } catch (error) {
      warning('$runtimeType - Data upload failed - $error');
    }
  }

  DataPointReference? _dataPointReference;
  DataPointReference get dataPointReference {
    _dataPointReference ??= CarpService().getDataPointReference();
    return _dataPointReference!;
  }

  /// Transform all measurements in all [batches] to [DataPoint]s and upload
  /// them to CAWS using the DataPoint batch upload endpoint.
  Future<void> uploadDataStreamBatchesAsDataPoint(
    List<DataStreamBatch> batches,
  ) async {
    final List<DataPoint> dataPoints = [];
    for (var batch in batches) {
      for (var measurement in batch.measurements) {
        var dataPoint = DataPoint(
          DataPointHeader(
            studyId: deployment.studyDeploymentId,
            userId: deployment.userId,
            dataFormat: measurement.dataType,
            deviceRoleName: measurement.taskControl?.targetDevice?.roleName ??
                deployment.deviceConfiguration.roleName,
            triggerId: measurement.taskControl?.triggerId.toString() ?? '0',
            startTime:
                DateTime.fromMicrosecondsSinceEpoch(measurement.sensorStartTime)
                    .toUtc(),
            endTime: measurement.sensorEndTime == null
                ? null
                : DateTime.fromMicrosecondsSinceEpoch(
                        measurement.sensorEndTime!)
                    .toUtc(),
          ),
          measurement.data,
        );
        dataPoints.add(dataPoint);
      }
    }

    info(
        '$runtimeType - Batch uploading data points to CAWS, N=${dataPoints.length}');
    dataPointReference.batch(dataPoints);
  }

  /// Upload a file attachment to CAWS, i.e. one that is referenced
  /// in a [FileData] data object.
  Future<void> uploadFile(FileData data) async {
    if (data.path == null) {
      warning(
          '$runtimeType - No path to local FileData specified when trying to upload file - data: $data.');
      return;
    }

    info(
        "$runtimeType - File attachment upload to CAWS started - path : '${data.path}'");
    final File file = File(data.path!);

    if (!file.existsSync()) {
      warning(
          '$runtimeType - The file attachment is not found - skipping upload.');
    } else {
      final String deviceID = DeviceInfo().deviceID.toString();
      data.metadata!['device_id'] = deviceID;
      data.metadata!['study_deployment_id'] = studyDeploymentId;

      // start upload
      final FileUploadTask uploadTask =
          CarpService().getFileStorageReference().upload(file, data.metadata);

      // await the upload is successful
      CarpFileResponse response = await uploadTask.onComplete;
      int id = response.id;

      addEvent(DataManagerEvent(
        CarpDataManagerEventTypes.fileUploaded,
        file.path,
      ));
      info("$runtimeType - File upload to CAWS finished - server id : $id ");

      // delete the local file once uploaded?
      if (carpEndPoint.deleteWhenUploaded) {
        file.delete();
        addEvent(FileDataManagerEvent(
            FileDataManagerEventTypes.fileDeleted, file.path));
      }
    }
  }

  @override
  Future<void> close() async {
    uploadTimer?.cancel();
    super.close();
  }
}

/// An enumeration of file data manager event types
class CarpDataManagerEventTypes extends DataManagerEventTypes {
  static const String dataPointsBatchUploaded = 'data_points_batch_uploaded';
  static const String dataStreamAppended = 'data_stream_appended';
  static const String fileUploaded = 'file_uploaded';
}
