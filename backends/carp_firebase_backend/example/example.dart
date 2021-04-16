import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:carp_firebase_backend/carp_firebase_backend.dart';

void main() {
  // Using email/password as authentication
  final FirebaseEndPoint firebaseEndPoint_1 = new FirebaseEndPoint(
      name: "Flutter Sensing Sandbox",
      uri: 'gs://flutter-sensing-sandbox.appspot.com',
      projectID: 'flutter-sensing-sandbox',
      webAPIKey: 'AIzaSyCGy6MeHkiv5XkBtMcMbtgGYOpf6ntNVE4',
      gcmSenderID: '201621881872',
      androidGoogleAppID: '1:201621881872:android:8e84e7ccfc85e121',
      iOSGoogleAppID: '1:159623150305:ios:4a213ef3dbd8997b',
      firebaseAuthenticationMethod: FireBaseAuthenticationMethods.PASSWORD,
      email: "some_email@dtu.dk",
      password: "some_password");

  final FirebaseStorageDataEndPoint storageEndPoint =
      new FirebaseStorageDataEndPoint(firebaseEndPoint_1,
          path: 'sensing/data',
          bufferSize: 500 * 1000,
          zip: true,
          encrypt: false);

  CAMSStudyProtocol study_1 = CAMSStudyProtocol()
    ..dataEndPoint = storageEndPoint;

  print(study_1);

  // Using Google Sign-In as authentication
  final FirebaseEndPoint firebaseEndPoint_2 = new FirebaseEndPoint(
      name: "Flutter Sensing Sandbox",
      uri: 'gs://flutter-sensing-sandbox.appspot.com',
      projectID: 'flutter-sensing-sandbox',
      webAPIKey: 'AIzaSyCGy6MeHkiv5XkBtMcMbtgGYOpf6ntNVE4',
      gcmSenderID: '201621881872',
      androidGoogleAppID: '1:201621881872:android:8e84e7ccfc85e121',
      iOSGoogleAppID: '1:159623150305:ios:4a213ef3dbd8997b',
      firebaseAuthenticationMethod: FireBaseAuthenticationMethods.GOOGLE);

  final FirebaseDatabaseDataEndPoint databaseEndPoint =
      new FirebaseDatabaseDataEndPoint(firebaseEndPoint_2,
          collection: 'carp_data');

  CAMSStudyProtocol study_2 = CAMSStudyProtocol()
    ..dataEndPoint = databaseEndPoint;

  print(study_2);
}
