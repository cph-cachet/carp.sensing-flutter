/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_firebase_backend;

final GoogleSignIn _googleSignIn = GoogleSignIn();
final FirebaseAuth _auth = FirebaseAuth.instance;

/// Stores files with [Datum] json objects in the Firebase Storage file store.
/// Works closely with the [FileDataManager] which is responsible for writing and zipping
/// files to the local device.
///
/// Files are transferred when the device is online and buffered when offline.
/// Once the file has been transferred to Firebase, it is deleted on the local device.
class FirebaseStorageDataManager extends AbstractDataManager implements FileDataManagerListener {
  FileDataManager _fileDataManager;
  FirebaseStorageDataEndPoint _firebaseStorageDataEndPoint;

  FirebaseApp _firebaseApp;
  FirebaseStorage _firebaseStorage;

  FirebaseUser _user;

  FirebaseStorageDataManager() {
    // Create a [FileDataManager] and wrap it.
    _fileDataManager = new FileDataManager();
    _fileDataManager.addFileDataManagerListener(this);
  }

  @override
  Future initialize(Study study) async {
    super.initialize(study);
    assert(study.dataEndPoint is FirebaseStorageDataEndPoint);
    _firebaseStorageDataEndPoint = study.dataEndPoint as FirebaseStorageDataEndPoint;

    _fileDataManager.initialize(study);

    final FirebaseStorage storage = await firebaseStorage;
    final FirebaseUser authenticatedUser = await user;

    print('Initializig FirebaseStorageDataManager...');
    print(' Firebase URI  : ${_firebaseStorageDataEndPoint.uri}');
    print(' Folder path   : ${_firebaseStorageDataEndPoint.path}');
    print(' Storage       : ${storage.app.name}');
    print(' Auth. user    : ${authenticatedUser.displayName} <${authenticatedUser.email}>');
  }

  Future<FirebaseApp> get firebaseApp async {
    if (_firebaseApp == null) {
      _firebaseApp = await FirebaseApp.configure(
        name: _firebaseStorageDataEndPoint.name,
        options: new FirebaseOptions(
          googleAppID: Platform.isIOS
              ? _firebaseStorageDataEndPoint.iOSGoogleAppID
              : _firebaseStorageDataEndPoint.androidGoogleAppID,
          gcmSenderID: _firebaseStorageDataEndPoint.gcmSenderID,
          apiKey: _firebaseStorageDataEndPoint.webAPIKey,
          projectID: _firebaseStorageDataEndPoint.projectID,
        ),
      );
    }
    return _firebaseApp;
  }

  Future<FirebaseStorage> get firebaseStorage async {
    if (_firebaseStorage == null) {
      final FirebaseApp app = await firebaseApp;
      _firebaseStorage = new FirebaseStorage(app: app, storageBucket: _firebaseStorageDataEndPoint.uri);
    }
    return _firebaseStorage;
  }

  Future<FirebaseUser> get user async {
    if (_user == null) {
      switch (_firebaseStorageDataEndPoint.firebaseAuthenticationMethod) {
        case FireBaseAuthenticationMethods.GOOGLE:
          {
            GoogleSignInAccount googleUser = await _googleSignIn.signIn();
            GoogleSignInAuthentication googleAuth = await googleUser.authentication;
            await _auth.signInWithGoogle(
              accessToken: googleAuth.accessToken,
              idToken: googleAuth.idToken,
            );

            break;
          }
        case FireBaseAuthenticationMethods.PASSWORD:
          {
            assert(_firebaseStorageDataEndPoint.email != null);
            assert(_firebaseStorageDataEndPoint.password != null);
            _user = await _auth.signInWithEmailAndPassword(
                email: _firebaseStorageDataEndPoint.email, password: _firebaseStorageDataEndPoint.password);
            break;
          }
        default:
          {
            //TODO : should probably throw a NotImplementedException
          }
      }

      print("signed in " + _user.email + " : " + _user.uid);
    }
    return _user;
  }

  Future close() async {
    return;
  }

  Future<bool> uploadData(Datum data) {
    // Forward to [FileDataManager]
    return _fileDataManager.uploadData(data);
  }

  String get firebasePath => "${_firebaseStorageDataEndPoint.path}/${study.id}/${Device.deviceID.toString()}";

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
}
