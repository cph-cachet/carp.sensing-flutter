/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_backend;

String _encode(Object object) => const JsonEncoder.withIndent(' ').convert(object);

/// Stores CARP json objects in the CARP backend.
///
///
/// Every time a CARP json data object is created, it is uploaded to Firebase.
/// Hence, this interface only works when the device is online.
/// If offline data storage and forward is needed, use the [FirebaseStorageDataManager] instead.
class CarpDataManager extends AbstractDataManager implements FileDataManagerListener {
  bool _initialized = false;
  CarpDataEndPoint carpEndPoint;
  CarpApp _app;
  CarpUser _user;

  FileDataManager fileDataManager;

  CarpDataManager() {}

  @override
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
      fileDataManager.addFileDataManagerListener(this);
      fileDataManager.initialize(study, events);
    }
    await user; // This will trigger authentication to the CARP server
  }

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

  Future<CarpUser> get user async {
    if (_user == null) {
      CarpService.configure(await app);
      _user = await CarpService.instance.authenticate(username: carpEndPoint.email, password: carpEndPoint.password);
      print("signed in - username: ${_user.username} uid: ${_user.uid}");
      _initialized = true;
    }
    return _user;
  }

  /// Handle upload of data depending on the specified [CarpUploadMethod].
  Future<bool> uploadData(Datum data) async {
    print(">> $data");
    assert(data is CARPDatum);

    // Check if CARP authentication is ready before writing...
    if (!_initialized) {
      print("waiting for CARP authentication -- delaying for 10 sec...");
      return Future.delayed(const Duration(seconds: 10), () => uploadData(data));
    }

    await user;
    if (user != null) {
      switch (carpEndPoint.uploadMethod) {
        case CarpUploadMethod.DATA_POINT:
          return (await CarpService.instance
                  .getDataPointReference()
                  .postDataPoint(CARPDataPoint.fromDatum(study.id, study.userId, data)) !=
              null);
        case CarpUploadMethod.BATCH_DATA_POINT:
        case CarpUploadMethod.FILE:
          // Forward to [FileDataManager]
          return fileDataManager.uploadData(data);
        case CarpUploadMethod.OBJECT:
          return (await CarpService.instance
                  .collection('/${carpEndPoint.collection}')
                  .object()
                  .setData(json.decode(json.encode(data))) !=
              null);
      }
    }

    return false;
  }

  /// Called by the [FileDataManager]
  Future notify(FileDataManagerEvent event) async {
    switch (event.event) {
      case FileEvent.created:
        break;
      case FileEvent.closed:
        _uploadFileToCarp(event.path);
        break;
    }
  }

  Future<void> _uploadFileToCarp(String path) async {
    print("File upload to CARP started - path : '$path'");
    final File file = File(path);

    final String deviceID = Device.deviceID.toString();
    final String studyID = study.id;
    final String userID = (await user).email;

    switch (carpEndPoint.uploadMethod) {
      case CarpUploadMethod.BATCH_DATA_POINT:
        await CarpService.instance.getDataPointReference().batchPostDataPoint(file);
        print("Batch upload to CARP finished");
        break;
      case CarpUploadMethod.FILE:
        final FileUploadTask uploadTask = CarpService.instance
            .getFileStorageReference()
            .upload(file, {'device_id': '$deviceID', 'study_id': '$studyID', 'user_id': '$userID'});

        // await the upload is successful
        CarpFileResponse response = await uploadTask.onComplete;
        int id = response.id;

        print("File upload to CARP finished - remote id : $id ");
        break;
    }

    // then delete the local file.
    file.delete();
    print("Local file deleted : ${file.path}");
  }

  Future close() async {
    return;
  }

  void onData(Datum datum) => uploadData(datum);

  void onDone() {
    close();
  }

  void onError(error) {}
}
