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
///        the old DataPoint endpoint in CAWS. Note that every time a CARP json measurement
///        object is created, it is uploaded to CARP. Hence, this method only works
///        when the device is online.
///   * [CarpUploadMethod.file] - Collect measurements in a SQLite DB file and
///        upload as a `db` file
class CarpDataManager extends AbstractDataManager {
  late CarpDataEndPoint carpEndPoint;
  DataStreamBuffer buffer = DataStreamBuffer();
  Timer? uploadTimer;
  ConnectivityResult _connectivity = ConnectivityResult.none;

  CarpDataManager() : super() {
    CarpMobileSensing.ensureInitialized();
    FromJsonFactory().register(CarpDataEndPoint());
  }

  String get type => DataEndPointTypes.CAWS;

  /// The connectivity status of this data manager.
  ConnectivityResult get connectivity => _connectivity;
  set connectivity(ConnectivityResult status) {
    _connectivity = status;
    info("$runtimeType - network connectivity status set to '${status.name}'");
  }

  @override
  Future<void> initialize(
    DataEndPoint dataEndPoint,
    SmartphoneDeployment deployment,
    Stream<Measurement> measurements,
  ) async {
    assert(dataEndPoint is CarpDataEndPoint);
    await super.initialize(dataEndPoint, deployment, measurements);
    carpEndPoint = dataEndPoint as CarpDataEndPoint;

    buffer.initialize(deployment, measurements);

    // set up a timer that uploads data on a regular basis
    uploadTimer = Timer.periodic(Duration(minutes: carpEndPoint.uploadInterval),
        (_) => uploadBufferedMeasurements());

    // listen to connectivity events
    Connectivity()
        .onConnectivityChanged
        .listen((status) => connectivity = status);

    if (!CarpDataStreamService().isConfigured)
      CarpDataStreamService().configureFrom(CarpService());
  }

  /// The currently signed in user.
  ///
  /// If a user is already authenticated to the [CarpService], then this account
  /// is used for uploading the data to CARP.
  ///
  /// If the user is not authenticated, this method will try to authenticate
  /// the user based on the configuration (uri, client_id, client_secret) and
  /// credentials (username and password) specified in [carpEndPoint].
  Future<CarpUser?> get user async {
    // check if the CARP web service has already been configured and the user is logged in.
    if (!CarpService().authenticated) {
      info('$runtimeType - No user is authenticated. '
          'Trying to authenticate based on configuration and credentials specified in the endpoint configuration.');

      try {
        if (!CarpService().isConfigured) {
          CarpService().configure(CarpApp(
            studyDeploymentId: studyDeploymentId,
            name: carpEndPoint.name,
            uri: Uri.parse(carpEndPoint.uri.toString()),
            oauth: OAuthEndPoint(
                clientID: carpEndPoint.clientId.toString(),
                clientSecret: carpEndPoint.clientSecret.toString()),
          ));
        }
        await CarpService().authenticate(
          username: carpEndPoint.email.toString(),
          password: carpEndPoint.password.toString(),
        );
        info("$runtimeType - signed in user: ${CarpService().currentUser}");
      } catch (error) {
        warning('$runtimeType - cannot authenticate user');
      }
    }

    return CarpService().currentUser;
  }

  @override
  Future<void> onMeasurement(Measurement measurement) async {}

  /// Upload buffered measurements to CAWS.
  Future<void> uploadBufferedMeasurements() async {
    // fast exit if not connected
    if (connectivity == ConnectivityResult.none) {
      warning('$runtimeType - offline - cannot upload buffered data.');
      return;
    }

    // fast exit if only upload on wifi and we're not on wifi
    if (carpEndPoint.onlyUploadOnWiFi &&
        connectivity != ConnectivityResult.wifi) {
      warning('$runtimeType - no wifi connectivity - '
          'cannot upload buffered data.');
      return;
    }

    // now start trying to upload data...
    // try {
    // authenticated to CAWS and fast exit if not successful
    if (await user == null) {
      warning('User cannot be authenticated - username: ${carpEndPoint.email}');
      return;
    }

    final batches = await buffer.getDataStreamBatches(
      carpEndPoint.deleteWhenUploaded,
    );

    if (carpEndPoint.uploadMethod == CarpUploadMethod.stream) {
      CarpDataStreamService().appendToDataStreams(
        studyDeploymentId,
        batches,
      );
      addEvent(DataManagerEvent(CarpDataManagerEventTypes.dataStreamAppended));
    } else if (carpEndPoint.uploadMethod == CarpUploadMethod.datapoint) {
      uploadDataStreamBatchesAsDataPoint(
        batches,
      );
      addEvent(
          DataManagerEvent(CarpDataManagerEventTypes.dataPointsBatchUploaded));
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

    // } catch (error) {
    //   warning('$runtimeType - data upload failed - $error');
    // }
  }

  DataPointReference? _datePointReference;
  DataPointReference get datePointReference {
    if (_datePointReference == null)
      _datePointReference = CarpService().getDataPointReference();
    return _datePointReference!;
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

    info('Batch uploading data points to CAWS - N=${dataPoints.length}');
    datePointReference.batch(dataPoints);
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

  Future close() async {
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
