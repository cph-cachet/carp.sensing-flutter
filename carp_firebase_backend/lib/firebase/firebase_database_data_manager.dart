/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_firebase_backend;

/// Stores CARP json objects in the Firebase Database.
///
/// Every time a CARP json data object is created, it is uploaded to Firebase.
/// Hence, this interface only works when the device is online.
/// If offline data storage and forward is needed, use the [FirebaseStorageDataManager] instead.
class FirebaseDatabaseDataManager extends AbstractDataManager {
  FirebaseDatabaseDataEndPoint dataEndPoint;

  FirebaseApp _firebaseApp;
  Firestore _firebaseDatabase;

  FirebaseUser _user;

  FirebaseDatabaseDataManager() {}

  @override
  Future initialize(Study study) async {
    super.initialize(study);
    assert(study.dataEndPoint is FirebaseDatabaseDataEndPoint);
    dataEndPoint = study.dataEndPoint as FirebaseDatabaseDataEndPoint;

    final Firestore database = await firebaseDatabase;
    final FirebaseUser authenticatedUser = await user;

    print('Initializig FirebaseStorageDataManager...');
    print(' Firebase URI    : ${dataEndPoint.uri}');
    print(' Collection path : ${dataEndPoint.collection}');
    print(' Storage         : ${database.app.name}');
    print(' Auth. user      : ${authenticatedUser.displayName} <${authenticatedUser.email}>');
  }

  Future<FirebaseApp> get firebaseApp async {
    if (_firebaseApp == null) {
      _firebaseApp = await FirebaseApp.configure(
        name: dataEndPoint.name,
        options: new FirebaseOptions(
          googleAppID: Platform.isIOS ? dataEndPoint.iOSGoogleAppID : dataEndPoint.androidGoogleAppID,
          gcmSenderID: dataEndPoint.gcmSenderID,
          apiKey: dataEndPoint.webAPIKey,
          projectID: dataEndPoint.projectID,
        ),
      );
    }
    return _firebaseApp;
  }

  Future<Firestore> get firebaseDatabase async {
    if (_firebaseDatabase == null) {
      final FirebaseApp app = await firebaseApp;
      _firebaseDatabase = new Firestore(app: app);
    }
    return _firebaseDatabase;
  }

  Future<FirebaseUser> get user async {
    if (_user == null) {
      switch (dataEndPoint.firebaseAuthenticationMethod) {
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
            assert(dataEndPoint.email != null);
            assert(dataEndPoint.password != null);
            _user = await _auth.signInWithEmailAndPassword(email: dataEndPoint.email, password: dataEndPoint.password);
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

  /// Called every time a JSON CARP [data] object is to be uploaded.
  Future<bool> uploadData(Datum data) async {
    assert(data is CARPDatum);
    final carp_data = data as CARPDatum;
    await user;

    if (user != null) {
      final String device_id = Device.deviceID.toString();

      // add json data
      Firestore.instance
          .collection(dataEndPoint.collection)
          .document(study.id) // study id
          .collection(device_id) // device id
          .document(carp_data.id) // data id
          .setData(carp_data.toJson());

      return true;
    }

    return false;
  }
}
