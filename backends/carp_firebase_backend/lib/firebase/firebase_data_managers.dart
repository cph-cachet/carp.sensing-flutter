/*
 * Copyright 2018-2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_firebase_backend;

/// An abstract class handling initialization and authentication to Firebase.
abstract class FirebaseDataManager extends AbstractDataManager {
  FirebaseEndPoint firebaseEndPoint;

  FirebaseApp _firebaseApp;
  User _user;

  FirebaseDataManager();

  Future initialize(
    String studyDeploymentId,
    DataEndPoint dataEndPoint,
    Stream<DataPoint> data,
  ) async {
    super.initialize(studyDeploymentId, dataEndPoint, data);
    assert(dataEndPoint is FirebaseDataEndPoint);
    firebaseEndPoint = (dataEndPoint as FirebaseDataEndPoint).firebaseEndPoint;
  }

  Future<FirebaseApp> get firebaseApp async {
    if (_firebaseApp == null) {
      _firebaseApp = await Firebase.initializeApp(
        name: firebaseEndPoint.name,
        options: new FirebaseOptions(
          appId: Platform.isIOS
              ? firebaseEndPoint.iOSGoogleAppID
              : firebaseEndPoint.androidGoogleAppID,
          messagingSenderId: firebaseEndPoint.gcmSenderID,
          apiKey: firebaseEndPoint.webAPIKey,
          projectId: firebaseEndPoint.projectID,
        ),
      );
    }
    return _firebaseApp;
  }

  /// Returns the current authenticated user.
  ///
  /// If the user is not authenticated, authentication to Firebase is done
  /// according to the specified [FireBaseAuthenticationMethods]:
  ///
  ///   * `GOOGLE` -- authenticate using Google credentials
  ///   * `PASSWORD` - authenticate using username and password
  ///
  Future<User> get user async {
    if (_user == null) {
      switch (firebaseEndPoint.firebaseAuthenticationMethod) {
        case FireBaseAuthenticationMethods.GOOGLE:
          {
            GoogleSignInAccount googleUser = await _googleSignIn.signIn();
            GoogleSignInAuthentication googleAuth =
                await googleUser.authentication;
            final AuthCredential credential = GoogleAuthProvider.credential(
              accessToken: googleAuth.accessToken,
              idToken: googleAuth.idToken,
            );
            UserCredential result =
                await _auth.signInWithCredential(credential);
            _user = result.user;
            break;
          }
        case FireBaseAuthenticationMethods.PASSWORD:
          {
            assert(firebaseEndPoint.email != null);
            assert(firebaseEndPoint.password != null);
            UserCredential result = await _auth.signInWithEmailAndPassword(
                email: firebaseEndPoint.email,
                password: firebaseEndPoint.password);
            _user = result.user;
            break;
          }
        default:
          {
            //TODO : should probably throw a NotImplementedException
          }
      }
      addEvent(FirebaseDataManagerEvent(
          FirebaseDataManagerEventTypes.authenticated));
      print("signed in as " + _user.email + " - uid: " + _user.uid);
    }
    return _user;
  }

  Future close() async {
    return;
  }

  void onDone() {
    close();
  }

  void onError(error) {}
}

/// Stores files with [Datum] json objects in the Firebase Storage file store.
/// Works closely with the [FileDataManager] which is responsible for writing
/// and zipping files to the local device.
///
/// Files are transferred when the device is online and buffered when offline.
/// Once the file has been transferred to Firebase, it is deleted on the local
/// device.
class FirebaseStorageDataManager extends FirebaseDataManager {
  FirebaseStorage _firebaseStorage;

  FileDataManager fileDataManager;
  FirebaseStorageDataEndPoint firebaseStorageDataEndPoint;

  String get type => DataEndPointTypes.FIREBASE_STORAGE;

  FirebaseStorageDataManager() : super() {
    // Create a [FileDataManager] and wrap it.
    fileDataManager = new FileDataManager();

    // merge the file data manager's events into this CARP data manager's event stream
    fileDataManager.events.forEach((event) => controller.add(event));

    // listen to data manager events, but only those from the file manager and
    // only closing events on a close event, upload the file to CARP
    fileDataManager.events
        .where((event) => event.runtimeType == FileDataManagerEvent)
        .where((event) => event.type == FileDataManagerEventTypes.FILE_CLOSED)
        .listen((event) =>
            _uploadFileToFirestore((event as FileDataManagerEvent).path));
  }

  Future initialize(
    String studyDeploymentId,
    DataEndPoint dataEdPoint,
    Stream<DataPoint> data,
  ) async {
    super.initialize(studyDeploymentId, dataEndPoint, data);
    assert(dataEndPoint is FirebaseStorageDataEndPoint);
    this.firebaseStorageDataEndPoint =
        dataEndPoint as FirebaseStorageDataEndPoint;

    fileDataManager.initialize(studyDeploymentId, dataEndPoint, data);

    final FirebaseStorage storage = await firebaseStorage;
    final User authenticatedUser = await user;

    info('Initializig FirebaseStorageDataManager...');
    info(
        ' Firebase URI  : ${firebaseStorageDataEndPoint.firebaseEndPoint.uri}');
    info(' Folder path   : ${firebaseStorageDataEndPoint.path}');
    info(' Storage       : ${storage.app.name}');
    info(
        ' Auth. user    : ${authenticatedUser.displayName} <${authenticatedUser.email}>\n');
  }

  Future<FirebaseStorage> get firebaseStorage async {
    if (_firebaseStorage == null) {
      final FirebaseApp app = await firebaseApp;
      _firebaseStorage = FirebaseStorage.instanceFor(
          app: app, bucket: firebaseStorageDataEndPoint.firebaseEndPoint.uri);
    }
    return _firebaseStorage;
  }

  String get firebasePath =>
      "${firebaseStorageDataEndPoint.path}/$studyDeploymentId/${DeviceInfo().deviceID.toString()}";

  Future<String> _uploadFileToFirestore(String localFilePath) async {
    final String filename =
        localFilePath.substring(localFilePath.lastIndexOf('/') + 1);

    info(
        "Upload to Firestore started - path : '$firebasePath', filename : '$filename'");

    final Reference ref =
        FirebaseStorage.instance.ref().child(firebasePath).child(filename);
    final File file = new File(localFilePath);
    final String deviceID = DeviceInfo().deviceID.toString();
    final String userID = (await user).email;

    final UploadTask uploadTask = ref.putFile(
      file,
      SettableMetadata(
        contentEncoding: 'application/json',
        contentType: 'application/zip',
        customMetadata: <String, String>{
          'device_id': '$deviceID',
          'study_deployment_id': '$studyDeploymentId',
          'user_id': '$userID'
        },
        // TODO - add location as metadata
      ),
    );

    ref.fullPath;

    // await the upload is successful
    String downloadUrl = await ref.getDownloadURL();

    await uploadTask.whenComplete(() {
      addEvent(FirebaseDataManagerEvent(
        FirebaseDataManagerEventTypes.file_uploaded,
        file.path,
        downloadUrl,
      ));
      info('Upload to Firestore finished - remote file url  : $downloadUrl');
      // then delete the local file.
      file.delete();
      addEvent(FileDataManagerEvent(
          FileDataManagerEventTypes.FILE_DELETED, file.path));
    });

    return downloadUrl;
  }

  // forward to file data manager
  void onDataPoint(DataPoint dataPoint) => fileDataManager.write(dataPoint);
}

/// Stores CARP json objects in the Firebase Database.
///
/// Every time a CARP json data object is created, it is uploaded to Firebase.
/// Hence, this interface only works when the device is online.
/// If offline data storage and forward is needed, use the [FirebaseStorageDataManager]
/// instead.
class FirebaseDatabaseDataManager extends FirebaseDataManager {
  FirebaseFirestore _firebaseDatabase;
  FirebaseDatabaseDataEndPoint firebaseDatabaseDataEndPoint;

  FirebaseDatabaseDataManager();

  String get type => DataEndPointTypes.FIREBASE_DATABSE;

  Future initialize(
    String studyDeploymentId,
    DataEndPoint dataEdPoint,
    Stream<DataPoint> data,
  ) async {
    super.initialize(studyDeploymentId, dataEndPoint, data);
    assert(dataEndPoint is FirebaseDatabaseDataEndPoint);
    firebaseDatabaseDataEndPoint = dataEndPoint as FirebaseDatabaseDataEndPoint;

    final FirebaseFirestore database = await firebaseDatabase;
    final User authenticatedUser = await user;

    print('Initializig FirebaseStorageDataManager...');
    print(
        ' Firebase URI    : ${firebaseDatabaseDataEndPoint.firebaseEndPoint.uri}');
    print(' Collection path : ${firebaseDatabaseDataEndPoint.collection}');
    print(' Database        : ${database.app.name}');
    print(
        ' Auth. user      : ${authenticatedUser.displayName} <${authenticatedUser.email}>\n');
  }

  Future<FirebaseFirestore> get firebaseDatabase async {
    if (_firebaseDatabase == null) {
      final FirebaseApp app = await firebaseApp;
      _firebaseDatabase = FirebaseFirestore.instanceFor(app: app);
    }
    return _firebaseDatabase;
  }

  /// Called every time a JSON CARP [data] object is to be uploaded.
  Future<bool> uploadData(DataPoint dataPoint) async {
    assert(dataPoint.data is Datum);
    final datum = dataPoint.data as Datum;

    await user;

    if (user != null) {
      final String deviceId = DeviceInfo().deviceID.toString();
      final String dataType = dataPoint.carpHeader.dataFormat.toString();

      final jsonDataString = json.encode(dataPoint);
      Map<String, dynamic> jsonData =
          json.decode(jsonDataString) as Map<String, dynamic>;

      // add json data
      FirebaseFirestore.instance
          .collection(firebaseDatabaseDataEndPoint.collection)
          .doc(studyDeploymentId) // study deployment id
          .collection(deviceId) // device id
          .doc('upload') // the default upload document is called 'upload'
          .collection(dataType) // data/measure type
          .doc(datum.id) // data id
          .set(jsonData);

      return true;
    }

    return false;
  }

  void onDataPoint(DataPoint dataPoint) => uploadData(dataPoint);
}

/// A status event for this Firebase data manager.
/// See [FirebaseDataManagerEventTypes] for a list of possible event types.
class FirebaseDataManagerEvent extends DataManagerEvent {
  /// The full path and filename for the file on the device.
  String path;

  /// The URI of the file on the Firebase server.
  String firebaseUri;

  FirebaseDataManagerEvent(String type, [this.path, this.firebaseUri])
      : super(type);

  String toString() =>
      'FirebaseDataManagerEvent - type: $type, path: $path, firebaseUri: $firebaseUri';
}

/// An enumeration of file data manager event types
class FirebaseDataManagerEventTypes extends FileDataManagerEventTypes {
  static const String authenticated = 'authenticated';
  static const String file_uploaded = 'file_uploaded';
}
