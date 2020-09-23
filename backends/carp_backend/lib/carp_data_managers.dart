/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_backend;

/// Stores CARP json data points in the CARP backend.
///
/// Every time a CARP json data object is created, it is uploaded to CARP.
/// Hence, this interface only works when the device is online.
/// If offline data storage and forward is needed, use the [CarpUploadMethod.FILE]
/// or [CarpUploadMethod.BATCH_DATA_POINT] instead. These methods will buffer files for upload, if offline.
class CarpDataManager extends AbstractDataManager {
  bool _initialized = false;
  CarpDataEndPoint carpEndPoint;
  CarpApp _app;
  //CarpUser _user;

  FileDataManager fileDataManager;

  CarpDataManager() : super();

  String get type => DataEndPointTypes.CARP;

  Future initialize(Study study, Stream<Datum> events) async {
    super.initialize(study, events);
    assert(study.dataEndPoint is CarpDataEndPoint);
    carpEndPoint = study.dataEndPoint as CarpDataEndPoint;

    if ((carpEndPoint.uploadMethod == CarpUploadMethod.FILE) ||
        (carpEndPoint.uploadMethod == CarpUploadMethod.BATCH_DATA_POINT)) {
      // make sure that files are not zipped if using batch upload
      assert(carpEndPoint.uploadMethod == CarpUploadMethod.BATCH_DATA_POINT ? carpEndPoint.zip == false : true);

      // Create a [FileDataManager] and wrap it.
      fileDataManager = new FileDataManager();

      // merge the file data manager's events into this CARP data manager's event stream
      fileDataManager.events.forEach((event) => controller.add(event));

      // listen to data manager events, but only those from the file manager and only closing events
      // on a close event, upload the file to CARP
      fileDataManager.events
          .where((event) => event.runtimeType == FileDataManagerEvent)
          .where((event) => event.type == FileDataManagerEventTypes.file_closed)
          .listen((event) => _uploadDatumFileToCarp((event as FileDataManagerEvent).path));

      // initialize the file data manager
      fileDataManager.initialize(study, events);
    }

    await user; // This will trigger authentication to the CARP server
  }

  /// The current [CarpApp] as configured in a [CarpDataEndPoint].
  Future<CarpApp> get app async {
    if (_app == null) {
      _app = new CarpApp(
          study: study,
          name: carpEndPoint.name,
          uri: Uri.parse(carpEndPoint.uri),
          oauth: OAuthEndPoint(clientID: carpEndPoint.clientId, clientSecret: carpEndPoint.clientSecret));
    }
    return _app;
  }

  /// The current signed in user. If the user is not already signed in,
  /// this method will authenticate the user and sign him/her in.
  Future<CarpUser> get user async {
    // check if the CARP webservice has already been configured and the user is logged in.
    if (!CarpService.isConfigured) await CarpService.configure(await app);
    if (CarpService.instance.currentUser == null) {
      await CarpService.instance.authenticate(username: carpEndPoint.email, password: carpEndPoint.password);
      print("CarpDataManager - signed in user: ${CarpService.instance.currentUser}");
    }
    _initialized = true;
    return CarpService.instance.currentUser;
  }

  /// Handle upload of data depending on the specified [CarpUploadMethod].
  Future<bool> uploadData(Datum data) async {
    assert(data is CARPDatum);

    // Check if CARP authentication is ready before writing...
    if (!_initialized) {
      print("waiting for CARP authentication -- delaying for 10 sec...");
      return Future.delayed(const Duration(seconds: 10), () => uploadData(data));
    }

    await user;
    if (user != null) {
      // first check if this is a [FileDatum] that has a separate file to be uploaded
      if (data is FileDatum) {
        FileDatum fileDatum = data;
        if (fileDatum.upload) _uploadFileToCarp(fileDatum);
      }

      // then upload the datum as specified in the upload method.
      switch (carpEndPoint.uploadMethod) {
        case CarpUploadMethod.DATA_POINT:
          return (await CarpService.instance
                  .getDataPointReference()
                  .postDataPoint(CARPDataPoint.fromDatum(study.id, study.userId, data)) !=
              null);
        case CarpUploadMethod.BATCH_DATA_POINT:
        case CarpUploadMethod.FILE:
          // In both cases, forward to [FileDataManager], which collects data in a file before upload.
          return fileDataManager.write(data);
        case CarpUploadMethod.DOCUMENT:
          return (await CarpService.instance
                  .collection('/${carpEndPoint.collection}')
                  .document()
                  .setData(json.decode(json.encode(data))) !=
              null);
      }
    }

    return false;
  }

  // This method upload a file of [Datum] data to CAPP.
  //TODO - implement support for offline store-and-wait for later upload when online.
  Future<void> _uploadDatumFileToCarp(String path) async {
    print("File upload to CARP started - path : '$path'");
    final File file = File(path);

    final String deviceID = Device.deviceID.toString();
    final String studyID = study.id;
    final String userID = (await user).email;

    switch (carpEndPoint.uploadMethod) {
      case CarpUploadMethod.BATCH_DATA_POINT:
        await CarpService.instance.getDataPointReference().batchPostDataPoint(file);

        addEvent(CarpDataManagerEvent(CarpDataManagerEventTypes.file_uploaded, file.path, null,
            CarpService.instance.getDataPointReference().dataEndpointUri));
        print("Batch upload to CARP finished");
        break;
      case CarpUploadMethod.FILE:
        final FileUploadTask uploadTask = CarpService.instance
            .getFileStorageReference()
            .upload(file, {'device_id': '$deviceID', 'study_id': '$studyID', 'user_id': '$userID'});

        // await the upload is successful
        CarpFileResponse response = await uploadTask.onComplete;
        int id = response.id;

        addEvent(CarpDataManagerEvent(
            CarpDataManagerEventTypes.file_uploaded, file.path, id, uploadTask.reference.fileEndpointUri));
        print("File upload to CARP finished - remote id : $id ");
        break;
      case CarpUploadMethod.DATA_POINT:
      case CarpUploadMethod.DOCUMENT:
        // do nothing -- no file to upload since data point has already been uploaded (see uploadData method)
        break;
    }

    if (carpEndPoint.deleteWhenUploaded) {
      // delete the local file once uploaded
      file.delete();
      addEvent(FileDataManagerEvent(FileDataManagerEventTypes.file_deleted, file.path));
    }
  }

  // This method upload a file attachment to CARP, i.e. one that is referenced in a [FileDatum].
  Future<void> _uploadFileToCarp(FileDatum datum) async {
    print("File attachment upload to CARP started - path : '${datum.filename}'");
    final File file = File(datum.filename);

    final String deviceID = Device.deviceID.toString();
    final String studyID = study.id;
    final String userID = (await user).email;

    datum.metadata['device_id'] = deviceID;
    datum.metadata['study_id'] = studyID;
    datum.metadata['user_id'] = userID;

    // start upload
    final FileUploadTask uploadTask = CarpService.instance.getFileStorageReference().upload(file, datum.metadata);

    // await the upload is successful
    CarpFileResponse response = await uploadTask.onComplete;
    int id = response.id;

    addEvent(CarpDataManagerEvent(
        CarpDataManagerEventTypes.file_uploaded, file.path, id, uploadTask.reference.fileEndpointUri));
    print("File upload to CARP finished - remote id : $id ");

    // delete the local file once uploaded?
    if (carpEndPoint.deleteWhenUploaded) {
      file.delete();
      addEvent(FileDataManagerEvent(FileDataManagerEventTypes.file_deleted, file.path));
    }
  }

  Future close() async => super.close();

  void onDatum(Datum datum) => uploadData(datum);

  void onDone() => close();

  void onError(error) {}
}

/// A status event for this CARP data manager.
/// See [CarpDataManagerEventTypes] for a list of possible event types.
class CarpDataManagerEvent extends DataManagerEvent {
  /// The full path and filename for the file on the device.
  String path;

  /// The ID of the file on the CARP server, if provided.
  /// `null` if not available from the server.
  int id;

  /// The URI of the file on the CARP server.
  String fileEndpointUri;

  CarpDataManagerEvent(String type, this.path, this.id, this.fileEndpointUri) : super(type);

  String toString() => 'CarpDataManagerEvent - type: $type, path: $path, id: $id, fileEndpointUri: $fileEndpointUri';
}

/// An enumeration of file data manager event types
class CarpDataManagerEventTypes extends FileDataManagerEventTypes {
  static const String file_uploaded = 'file_uploaded';
}
