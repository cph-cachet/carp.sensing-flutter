/*
 * Copyright 2018-2020 Copenhagen Center for Health Technology (CACHET) at the
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

  Future initialize(Study study, Stream<Datum> events) async {
    super.initialize(study, events);
    assert(study.dataEndPoint is FirebaseDataEndPoint);
    firebaseEndPoint =
        (study.dataEndPoint as FirebaseDataEndPoint).firebaseEndPoint;
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
  FileDataManager fileDataManager;
  FirebaseStorageDataEndPoint dataEndPoint;

  FirebaseStorage _firebaseStorage;

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

  Future initialize(Study study, Stream<Datum> events) async {
    super.initialize(study, events);
    assert(study.dataEndPoint is FirebaseStorageDataEndPoint);
    dataEndPoint = study.dataEndPoint as FirebaseStorageDataEndPoint;

    fileDataManager.initialize(study, events);

    final FirebaseStorage storage = await firebaseStorage;
    final User authenticatedUser = await user;

    info('Initializig FirebaseStorageDataManager...');
    info(' Firebase URI  : ${firebaseEndPoint.uri}');
    info(' Folder path   : ${dataEndPoint.path}');
    info(' Storage       : ${storage.app.name}');
    info(
        ' Auth. user    : ${authenticatedUser.displayName} <${authenticatedUser.email}>\n');
  }

  Future<FirebaseStorage> get firebaseStorage async {
    if (_firebaseStorage == null) {
      final FirebaseApp app = await firebaseApp;
      _firebaseStorage = FirebaseStorage.instanceFor(
          app: app, bucket: dataEndPoint.firebaseEndPoint.uri);
    }
    return _firebaseStorage;
  }

  String get firebasePath =>
      "${dataEndPoint.path}/${study.id}/${Device().deviceID.toString()}";

  Future<String> _uploadFileToFirestore(String localFilePath) async {
    final String filename =
        localFilePath.substring(localFilePath.lastIndexOf('/') + 1);

    info(
        "Upload to Firestore started - path : '$firebasePath', filename : '$filename'");

    final Reference ref =
        FirebaseStorage.instance.ref().child(firebasePath).child(filename);
    final File file = new File(localFilePath);
    final String deviceID = Device().deviceID.toString();
    final String studyID = study.id;
    final String userID = (await user).email;

    final UploadTask uploadTask = ref.putFile(
      file,
      SettableMetadata(
        contentEncoding: 'application/json',
        contentType: 'application/zip',
        customMetadata: <String, String>{
          'device_id': '$deviceID',
          'study_id': '$studyID',
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
  void onDatum(Datum datum) => fileDataManager.write(datum);
}

/// Stores CARP json objects in the Firebase Database.
///
/// Every time a CARP json data object is created, it is uploaded to Firebase.
/// Hence, this interface only works when the device is online.
/// If offline data storage and forward is needed, use the [FirebaseStorageDataManager]
/// instead.
class FirebaseDatabaseDataManager extends FirebaseDataManager {
  FirebaseDatabaseDataEndPoint dataEndPoint;

  FirebaseFirestore _firebaseDatabase;

  FirebaseDatabaseDataManager();

  String get type => DataEndPointTypes.FIREBASE_DATABSE;

  Future initialize(Study study, Stream<Datum> events) async {
    super.initialize(study, events);
    assert(study.dataEndPoint is FirebaseDatabaseDataEndPoint);
    dataEndPoint = study.dataEndPoint as FirebaseDatabaseDataEndPoint;

    final FirebaseFirestore database = await firebaseDatabase;
    final User authenticatedUser = await user;

    print('Initializig FirebaseStorageDataManager...');
    print(' Firebase URI    : ${firebaseEndPoint.uri}');
    print(' Collection path : ${dataEndPoint.collection}');
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
  Future<bool> uploadData(Datum data) async {
    assert(data is CARPDatum);
    final carpData = data as CARPDatum;
    await user;

    if (user != null) {
      final String deviceId = Device().deviceID.toString();
      final String dataType = data.format.name;

      final jsonDataString = json.encode(data);
      Map<String, dynamic> jsonData =
          json.decode(jsonDataString) as Map<String, dynamic>;

      // add json data
      FirebaseFirestore.instance
          .collection(dataEndPoint.collection)
          .doc(study.id) // study id
          .collection(deviceId) // device id
          .doc('upload') // the default upload document is called 'upload'
          .collection(dataType) // data/measure type
          .doc(carpData.id) // data id
          .set(jsonData);

      return true;
    }

    return false;
  }

  void onDatum(Datum datum) => uploadData(datum);
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
