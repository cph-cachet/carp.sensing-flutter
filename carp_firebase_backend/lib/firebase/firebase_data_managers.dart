/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_firebase_backend;

/// An abstract class handling initialization and authentication to Firebase.
abstract class FirebaseDataManager extends AbstractDataManager {
  FirebaseEndPoint firebaseEndPoint;

  FirebaseApp _firebaseApp;
  FirebaseUser _user;

  FirebaseDataManager();

  @override
  Future initialize(Study study, Stream<Datum> events) async {
    super.initialize(study, events);
    assert(study.dataEndPoint is FirebaseDataEndPoint);
    firebaseEndPoint = (study.dataEndPoint as FirebaseDataEndPoint).firebaseEndPoint;
  }

  Future<FirebaseApp> get firebaseApp async {
    if (_firebaseApp == null) {
      _firebaseApp = await FirebaseApp.configure(
        name: firebaseEndPoint.name,
        options: new FirebaseOptions(
          googleAppID: Platform.isIOS ? firebaseEndPoint.iOSGoogleAppID : firebaseEndPoint.androidGoogleAppID,
          gcmSenderID: firebaseEndPoint.gcmSenderID,
          apiKey: firebaseEndPoint.webAPIKey,
          projectID: firebaseEndPoint.projectID,
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
  Future<FirebaseUser> get user async {
    if (_user == null) {
      switch (firebaseEndPoint.firebaseAuthenticationMethod) {
        case FireBaseAuthenticationMethods.GOOGLE:
          {
            GoogleSignInAccount googleUser = await _googleSignIn.signIn();
            GoogleSignInAuthentication googleAuth = await googleUser.authentication;
            final AuthCredential credential = GoogleAuthProvider.getCredential(
              accessToken: googleAuth.accessToken,
              idToken: googleAuth.idToken,
            );
            _user = await _auth.signInWithCredential(credential);
            break;
          }
        case FireBaseAuthenticationMethods.PASSWORD:
          {
            assert(firebaseEndPoint.email != null);
            assert(firebaseEndPoint.password != null);
            _user = await _auth.signInWithEmailAndPassword(
                email: firebaseEndPoint.email, password: firebaseEndPoint.password);
            break;
          }
        default:
          {
            //TODO : should probably throw a NotImplementedException
          }
      }

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
/// Works closely with the [FileDataManager] which is responsible for writing and zipping
/// files to the local device.
///
/// Files are transferred when the device is online and buffered when offline.
/// Once the file has been transferred to Firebase, it is deleted on the local device.
class FirebaseStorageDataManager extends FirebaseDataManager implements FileDataManagerListener {
  FileDataManager fileDataManager;
  FirebaseStorageDataEndPoint dataEndPoint;

  FirebaseStorage _firebaseStorage;

  FirebaseStorageDataManager() : super() {
    // Create a [FileDataManager] and wrap it.
    fileDataManager = new FileDataManager();
    fileDataManager.addFileDataManagerListener(this);
  }

  @override
  Future initialize(Study study, Stream<Datum> events) async {
    super.initialize(study, events);
    assert(study.dataEndPoint is FirebaseStorageDataEndPoint);
    dataEndPoint = study.dataEndPoint as FirebaseStorageDataEndPoint;

    fileDataManager.initialize(study, events);

    final FirebaseStorage storage = await firebaseStorage;
    final FirebaseUser authenticatedUser = await user;

    print('Initializig FirebaseStorageDataManager...');
    print(' Firebase URI  : ${firebaseEndPoint.uri}');
    print(' Folder path   : ${dataEndPoint.path}');
    print(' Storage       : ${storage.app.name}');
    print(' Auth. user    : ${authenticatedUser.displayName} <${authenticatedUser.email}>\n');
  }

  Future<FirebaseStorage> get firebaseStorage async {
    if (_firebaseStorage == null) {
      final FirebaseApp app = await firebaseApp;
      _firebaseStorage = new FirebaseStorage(app: app, storageBucket: dataEndPoint.firebaseEndPoint.uri);
    }
    return _firebaseStorage;
  }

  Future<bool> uploadData(Datum data) {
    // Forward to [FileDataManager]
    return fileDataManager.uploadData(data);
  }

  String get firebasePath => "${dataEndPoint.path}/${study.id}/${Device.deviceID.toString()}";

  Future<Uri> _uploadFileToFirestore(String localFilePath) async {
    final String filename = localFilePath.substring(localFilePath.lastIndexOf('/') + 1);

    print("Upload to Firestore started - path : '$firebasePath', filename : '$filename'");

    final StorageReference ref = FirebaseStorage.instance.ref().child(firebasePath).child(filename);
    final File file = new File(localFilePath);
    final String deviceID = Device.deviceID.toString();
    final String studyID = study.id;
    final String userID = (await user).email;

    final StorageUploadTask uploadTask = ref.putFile(
      file,
      new StorageMetadata(
        contentEncoding: 'application/json',
        contentType: 'application/zip',
        customMetadata: <String, String>{'device_id': '$deviceID', 'study_id': '$studyID', 'user_id': '$userID'},
        // TODO add location as metadata
      ),
    );

    // await the upload is successful
    final Uri downloadUrl = (await uploadTask.onComplete).uploadSessionUri;
    print("Upload to Firestore finished - remote file uri  : ${downloadUrl.path}'");
    // then delete the local file.
    file.delete();
    print("File deleted : ${file.path}");

    return downloadUrl;
  }

  Future notify(FileDataManagerEvent event) async {
    print("FirebaseStorageDataManager : {event: ${event.event}, path : ${event.path}");
    switch (event.event) {
      case FileEvent.created:
        {
          // do nothing
          break;
        }
      case FileEvent.closed:
        {
          // Queue file for transfer to Firebase
          _uploadFileToFirestore(event.path);
          break;
        }
    }
  }

  void onData(Datum datum) => uploadData(datum);
}

/// Stores CARP json objects in the Firebase Database.
///
/// Every time a CARP json data object is created, it is uploaded to Firebase.
/// Hence, this interface only works when the device is online.
/// If offline data storage and forward is needed, use the [FirebaseStorageDataManager] instead.
class FirebaseDatabaseDataManager extends FirebaseDataManager {
  FirebaseDatabaseDataEndPoint dataEndPoint;

  Firestore _firebaseDatabase;

  FirebaseDatabaseDataManager();

  @override
  Future initialize(Study study, Stream<Datum> events) async {
    super.initialize(study, events);
    assert(study.dataEndPoint is FirebaseDatabaseDataEndPoint);
    dataEndPoint = study.dataEndPoint as FirebaseDatabaseDataEndPoint;

    final Firestore database = await firebaseDatabase;
    final FirebaseUser authenticatedUser = await user;

    print('Initializig FirebaseStorageDataManager...');
    print(' Firebase URI    : ${firebaseEndPoint.uri}');
    print(' Collection path : ${dataEndPoint.collection}');
    print(' Database        : ${database.app.name}');
    print(' Auth. user      : ${authenticatedUser.displayName} <${authenticatedUser.email}>\n');
  }

  Future<Firestore> get firebaseDatabase async {
    if (_firebaseDatabase == null) {
      final FirebaseApp app = await firebaseApp;
      _firebaseDatabase = new Firestore(app: app);
    }
    return _firebaseDatabase;
  }

  /// Called every time a JSON CARP [data] object is to be uploaded.
  Future<bool> uploadData(Datum data) async {
    assert(data is CARPDatum);
    final carp_data = data as CARPDatum;
    await user;

    if (user != null) {
      final String device_id = Device.deviceID.toString();
      final String data_type = data.format.name;

      final json_data_string = json.encode(data);
      Map<String, dynamic> json_data = json.decode(json_data_string) as Map<String, dynamic>;

      // add json data
      Firestore.instance
          .collection(dataEndPoint.collection)
          .document(study.id) // study id
          .collection(device_id) // device id
          .document('upload') // the default upload document is called 'upload'
          .collection(data_type) // data/measure type
          .document(carp_data.id) // data id
          .setData(json_data);

      return true;
    }

    return false;
  }

  void onData(Datum datum) => uploadData(datum);
}
