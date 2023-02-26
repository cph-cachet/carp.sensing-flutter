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
}

/// Stores CAMS data points in the CARP Web Services (CAWS) backend.
///
/// Upload of data to CAWS can happen in three ways, as specified in
/// [CarpUploadMethod]:
///
///   * [CarpUploadMethod.DATA_STREAM] - Upload data as data streams (the default method).
///   * [CarpUploadMethod.DATA_POINT] - Upload each data point separately using
///        the old DataPoint endpoint in CAWS. Note that every time a CARP json measurement
///        object is created, it is uploaded to CARP. Hence, this method only works
///        when the device is online.
///   * [CarpUploadMethod.FILE] - Collect measurements in a SQLite DB file and
///        upload as a `db` file
class CarpDataManager extends AbstractDataManager {
  bool _initialized = false;
  late CarpDataEndPoint carpEndPoint;
  late DataStreamBuffer buffer;
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
    Stream<Measurement> data,
  ) async {
    assert(dataEndPoint is CarpDataEndPoint);
    await super.initialize(dataEndPoint, deployment, data);
    carpEndPoint = dataEndPoint as CarpDataEndPoint;

    if ((carpEndPoint.uploadMethod == CarpUploadMethod.DATA_STREAM) ||
        (carpEndPoint.uploadMethod == CarpUploadMethod.FILE)) {
      buffer = DataStreamBuffer();

      // merge the file data manager's events into this CARP data manager's event stream
      // fileDataManager.events.listen((event) => addEvent(event));

      // listen to data manager events, but only those from the file manager and only closing events
      // on a close event, upload the file to CARP
      // fileDataManager.events
      //     .where((event) => event.runtimeType == FileDataManagerEvent)
      //     .where((event) => event.type == FileDataManagerEventTypes.FILE_CLOSED)
      //     .listen((event) =>
      //         _uploadDatumFileToCarp((event as FileDataManagerEvent).path));

      buffer.initialize(deployment, data);

      // set up a timer that uploads data on a regular basis
      uploadTimer = Timer.periodic(
          Duration(minutes: carpEndPoint.uploadInterval),
          (_) => uploadBufferedMeasurements());
    }

    // listen to connectivity events
    Connectivity()
        .onConnectivityChanged
        .listen((status) => connectivity = status);

    _initialized = true;
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
          'Trying to authenticate based on configuration and credentials specified in the carpEndPoint.');
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
    }

    if (!CarpDataStreamService().isConfigured)
      CarpDataStreamService().configureFrom(CarpService());

    return CarpService().currentUser;
  }

  @override
  Future<void> onMeasurement(Measurement measurement) =>
      buffer.onMeasurement(measurement);

  @override
  Future<void> onError(Object? error) => buffer
      .onMeasurement(Measurement.fromData(Error(message: error.toString())));

  @override
  Future<void> onDone() => close();

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

    // fast exit if not authenticated to CAWS
    if (await user == null) {
      warning('User is not authenticated - username: ${carpEndPoint.email}');
      return;
    }

    // TODO - if the upload fails, we should not delete now
    // TODO - need to make a try-catch clause
    // TODO - make a transaction mechanism

    final batches = await buffer.getDataStreamBatches(
      carpEndPoint.deleteWhenUploaded,
    );

    if (carpEndPoint.uploadMethod == CarpUploadMethod.DATA_STREAM) {
      CarpDataStreamService().appendToDataStreams(
        studyDeploymentId,
        batches,
      );
    }

    for (var batch in batches) {
      for (var measurement in batch.measurements) {
        if (carpEndPoint.uploadMethod == CarpUploadMethod.DATA_POINT) {
          uploadMeasurementAsDataPoint(measurement);
        }

        // check if this measurement that has a separate file to be uploaded
        if (measurement.data is FileData) {
          var fileData = measurement.data as FileData;
          if (fileData.upload) uploadFile(fileData);
        }
      }
    }
  }

  /// Transform [measurement] to a [DataPoint] and upload it to CAWS using the
  /// DataPoint endpoint.
  Future<void> uploadMeasurementAsDataPoint(Measurement measurement) async {
    final dataPoint = DataPoint(
      DataPointHeader(
        studyId: deployment.studyDeploymentId,
        userId: deployment.userId,
        dataFormat: measurement.dataType,
        deviceRoleName: measurement.taskControl?.targetDevice?.roleName ??
            deployment.deviceConfiguration.roleName,
        triggerId: measurement.taskControl?.triggerId.toString() ?? '0',
        startTime:
            DateTime.fromMicrosecondsSinceEpoch(measurement.sensorStartTime),
        endTime: measurement.sensorEndTime == null
            ? null
            : DateTime.fromMicrosecondsSinceEpoch(measurement.sensorEndTime!),
      ),
      measurement.data,
    );

    info('Uploading data point to CAWS - ${dataPoint.carpHeader.dataFormat}');
    CarpService().getDataPointReference().post(dataPoint);
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

      addEvent(CarpDataManagerEvent(CarpDataManagerEventTypes.file_uploaded,
          file.path, id, uploadTask.reference.fileEndpointUri));
      info("$runtimeType - File upload to CAWS finished - server id : $id ");

      // delete the local file once uploaded?
      if (carpEndPoint.deleteWhenUploaded) {
        file.delete();
        addEvent(FileDataManagerEvent(
            FileDataManagerEventTypes.FILE_DELETED, file.path));
      }
    }
  }

  Future close() async {
    uploadTimer?.cancel();
    super.close();
  }
}

/// A status event for this CARP data manager.
/// See [CarpDataManagerEventTypes] for a list of possible event types.
class CarpDataManagerEvent extends DataManagerEvent {
  /// The full path and filename for the file on the device.
  String path;

  /// The ID of the file on the CARP server, if provided.
  /// `null` if not available from the server.
  int? id;

  /// The URI of the file on the CARP server.
  String fileEndpointUri;

  CarpDataManagerEvent(super.type, this.path, this.id, this.fileEndpointUri);

  String toString() =>
      'CarpDataManagerEvent - type: $type, path: $path, id: $id, fileEndpointUri: $fileEndpointUri';
}

/// An enumeration of file data manager event types
class CarpDataManagerEventTypes extends FileDataManagerEventTypes {
  static const String file_uploaded = 'file_uploaded';
}
