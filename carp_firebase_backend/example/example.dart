import 'package:carp_core/carp_core.dart';
import 'package:carp_firebase_backend/carp_firebase_backend.dart';

void main() {
  // Using email/password as authentication
  final FirebaseDataEndPoint firebaseEndPoint_1 = new FirebaseDataEndPoint(DataEndPointType.FIREBASE,
      name: "Flutter Sensing Sandbox",
      uri: 'gs://flutter-sensing-sandbox.appspot.com',
      path: 'sensing/data',
      projectID: 'flutter-sensing-sandbox',
      webAPIKey: 'AIzaSyCGy6MeHkiv5XkBtMcMbtgGYOpf6ntNVE4',
      gcmSenderID: '201621881872',
      androidGoogleAppID: '1:201621881872:android:8e84e7ccfc85e121',
      iOSGoogleAppID: '1:159623150305:ios:4a213ef3dbd8997b',
      firebaseAuthenticationMethod: FireBaseAuthenticationMethods.PASSWORD,
      email: "some_email@dtu.dk",
      password: "some_password");

  firebaseEndPoint_1.bufferSize = 1000 * 1000;
  firebaseEndPoint_1.zip = true;

  Study study_1 = new Study("1234", "user_1@dtu.dk", name: "Test study #1");
  study_1.dataEndPoint = firebaseEndPoint_1;

  // Using Google Sign-In as authentication
  final FirebaseDataEndPoint firebaseEndPoint_2 = new FirebaseDataEndPoint(DataEndPointType.FIREBASE,
      name: "Flutter Sensing Sandbox",
      uri: 'gs://flutter-sensing-sandbox.appspot.com',
      path: 'sensing/data',
      projectID: 'flutter-sensing-sandbox',
      webAPIKey: 'AIzaSyCGy6MeHkiv5XkBtMcMbtgGYOpf6ntNVE4',
      gcmSenderID: '201621881872',
      androidGoogleAppID: '1:201621881872:android:8e84e7ccfc85e121',
      iOSGoogleAppID: '1:159623150305:ios:4a213ef3dbd8997b',
      firebaseAuthenticationMethod: FireBaseAuthenticationMethods.GOOGLE);

  Study study_2 = new Study("5678", "user_2@dtu.dk", name: "Test study #2");
  study_2.dataEndPoint = firebaseEndPoint_2;
}
