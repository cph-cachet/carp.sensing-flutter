/*
 * Copyright 2018-2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_backend;

/// Stores CAMS data points in the CARP backend.
///
/// Every time a CARP json data object is created, it is uploaded to CARP.
/// Hence, this interface only works when the device is online.
/// If offline data storage and forward is needed, use the [CarpUploadMethod.FILE]
/// or [CarpUploadMethod.BATCH_DATA_POINT] instead. These methods will buffer files for upload, if offline.
class CarpDataManager extends AbstractDataManager {
  bool _initialized = false;
  late CarpDataEndPoint carpEndPoint;
  // late FileDataManager fileDataManager;
  // late SQLiteDataManager sqliteDataManager;
  late DataStreamBuffer buffer;
  Timer? uploadTimer;

  CarpDataManager() : super() {
    // Initialization of serialization
    CarpMobileSensing();

    // register for de-serialization
    FromJsonFactory().register(CarpDataEndPoint(
      uploadMethod: CarpUploadMethod.FILE,
      name: '',
      uri: '',
    ));
  }

  String get type => DataEndPointTypes.CAWS;

  @override
  Future initialize(
    SmartphoneDeployment deployment,
    DataEndPoint dataEndPoint,
    Stream<Measurement> data,
  ) async {
    super.initialize(deployment, dataEndPoint, data);
    assert(dataEndPoint is CarpDataEndPoint);
    carpEndPoint = dataEndPoint as CarpDataEndPoint;

    if ((carpEndPoint.uploadMethod == CarpUploadMethod.DATA_STREAM) ||
        (carpEndPoint.uploadMethod == CarpUploadMethod.FILE)) {
      // Create data managers for buffering.
      // fileDataManager = FileDataManager();
      // sqliteDataManager = SQLiteDataManager();
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

      // initialize the data managers
      // fileDataManager.initialize(deployment, dataEndPoint, data);
      buffer.initialize(deployment, data);

      // set up a timer that uploads data on a regular basis
      uploadTimer =
          Timer.periodic(Duration(minutes: 1), (_) => _uploadMeasurements());
    }
    _initialized = true;
    await user; // This will trigger authentication to the CARP server
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
      info("CarpDataManager - signed in user: ${CarpService().currentUser}");
    }

    CarpDataStreamService().configureFrom(CarpService());

    return CarpService().currentUser;
  }

  @override
  Future<void> onMeasurement(Measurement measurement) =>
      uploadMeasurement(measurement);

  @override
  Future<void> onError(Object? error) =>
      uploadMeasurement(Measurement.fromData(Error(message: error.toString())));

  @override
  Future<void> onDone() => close();

  /// Handle upload of a measurement depending on the specified [CarpUploadMethod].
  Future<bool> uploadMeasurement(Measurement measurement) async {
    // Check if CARP authentication is ready before writing...
    if (!_initialized) {
      warning("Waiting for CARP to be initialized -- delaying for 10 sec...");
      return Future.delayed(
          const Duration(seconds: 10), () => uploadMeasurement(measurement));
    }

    CarpUser? _user = await user;
    if (_user == null) {
      warning('User is not authenticated - username: ${carpEndPoint.email}');
      return false;
    } else {
      // first check if this is a measurement that has a separate file to be uploaded
      if (measurement.data is FileData) {
        var fileData = measurement.data as FileData;
        if (fileData.upload) _uploadFile(fileData);
      }

      // then upload the measurement as specified in the upload method.
      switch (carpEndPoint.uploadMethod) {
        case CarpUploadMethod.DATA_STREAM:
        case CarpUploadMethod.FILE:
          // Forward to the [SQLiteDataManager] for buffering data
          await buffer.onMeasurement(measurement);
          return true;
        case CarpUploadMethod.DATA_POINT:
          return await _uploadMeasurementAsDataPoint(measurement);
        // case CarpUploadMethod.BATCH_DATA_POINT:
        //   // Forward to [FileDataManager] for buffering data
        //   return await fileDataManager.write(measurement);
      }
    }
  }

  /// Upload buffered measurements to CAWS.
  Future<void> _uploadMeasurements() async =>
      CarpDataStreamService().appendToDataStreams(
        studyDeploymentId,
        await buffer.getDataStreamBatches(),
      );

  /// Transform [measurement] to a [DataPoint] and upload it to CAWS using the
  /// old data_point endpoint.
  Future<bool> _uploadMeasurementAsDataPoint(Measurement measurement) async {
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
    return (await CarpService()
            .getDataPointReference()
            .postDataPoint(dataPoint) >
        0);
  }

  // // This method upload a file of [Datum] data to CAPP.
  // // TODO - implement support for offline store-and-wait for later upload when online.
  // Future _uploadDatumFileToCarp(String path) async {
  //   info("Datum json file upload to CARP started - path : '$path'");
  //   final File file = File(path);

  //   final String deviceID = DeviceInfo().deviceID.toString();
  //   final String? userID = (await user)!.email;

  //   switch (carpEndPoint.uploadMethod) {
  //     case CarpUploadMethod.BATCH_DATA_POINT:
  //       await CarpService().getDataPointReference().batchPostDataPoint(file);

  //       addEvent(CarpDataManagerEvent(
  //           CarpDataManagerEventTypes.file_uploaded,
  //           file.path,
  //           null,
  //           CarpService().getDataPointReference().dataEndpointUri));
  //       info("Batch upload to CARP finished");
  //       break;
  //     case CarpUploadMethod.FILE:
  //       final FileUploadTask uploadTask = CarpService()
  //           .getFileStorageReference()
  //           .upload(file, {'device_id': '$deviceID', 'user_id': '$userID'});

  //       // await the upload is successful
  //       CarpFileResponse response = await uploadTask.onComplete;
  //       int id = response.id;

  //       addEvent(CarpDataManagerEvent(CarpDataManagerEventTypes.file_uploaded,
  //           file.path, id, uploadTask.reference.fileEndpointUri));
  //       info("Datum json file upload to CARP finished - remote id: '$id' ");
  //       break;
  //     case CarpUploadMethod.DATA_POINT:
  //       // do nothing -- no file to upload since data point has already been
  //       // uploaded (see uploadData method)
  //       break;
  //     case CarpUploadMethod.DATA_STREAM:
  //       // TODO: Handle this case.
  //       break;
  //   }

  //   if (carpEndPoint.deleteWhenUploaded) {
  //     // delete the local file once uploaded
  //     file.delete();
  //     info("Locale json file deleted - path: '${file.path}'.");
  //     addEvent(FileDataManagerEvent(
  //         FileDataManagerEventTypes.FILE_DELETED, file.path));
  //   }
  // }

  /// Upload a file attachment to CAWS, i.e. one that is referenced
  /// in a [FileData] data object.
  Future _uploadFile(FileData data) async {
    if (data.path == null) {
      warning(
          '$runtimeType - No path to local FileData specified when trying to upload file - data: $data.');
    } else {
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
