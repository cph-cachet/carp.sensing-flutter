import 'package:test/test.dart';
import 'package:carp_webservices/carp_auth/carp_auth.dart';
import 'package:carp_webservices/carp_service/carp_service.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'dart:io';

void main() {
  final String email = "admin";
  final String pw = "password";
  final String uri = "http://staging.carp.cachet.dk:8080";
  final String clientID = "carp";
  final String clientSecret = "carp";
  CarpApp app;
  Study study;

  group("CARP Base Services", () {
    // Runs before all tests.
    setUpAll(() {
      study = new Study("983476-1", "user@dtu.dk", name: "Test study #1");
      app = new CarpApp(
          study: study,
          name: "any_name_is_fine_for_now",
          uri: Uri.parse(uri),
          oauth: OAuthEndPoint(clientID: clientID, clientSecret: clientSecret, path: "/oauth/token"));

      CarpService.configure(app);
      print(app.name);
    });

    // Runs before each test.
    setUp(() {});

    test('Authentication', () async {
      CarpUser user;
      try {
        user = await CarpService.instance.signInWithEmailAndPassword(email: email, password: pw);
      } catch (excp) {
        print(excp.toString());
      }
      assert(user != null);
      assert(user.isAuthenticated);

      print("signed in " + user.email + " : " + user.uid);
    });

    test('File upload', () async {
      final File myFile = new File("abc.txt");

      final FileUploadTask uploadTask = CarpService.instance.getFileStorageReference("abc.txt").putFile(
            myFile,
            new FileMetadata(
              contentLanguage: 'en',
              customMetadata: <String, String>{'activity': 'test'},
            ),
          );

      assert(uploadTask != null);

      await uploadTask.onComplete;
    });

    test('Data point upload', () async {
      // Create a dummy location datum
      LocationDatum datum = LocationDatum.fromMap(<String, dynamic>{
        "latitude": 23454.345,
        "longitude": 23.4,
        "altitude": 43.3,
        "accuracy": 12.4,
        "speed": 2.3,
        "speedAccuracy": 12.3
      });

      final CARPDataPoint data = CARPDataPoint.fromDatum(study.id, study.userId, datum);

      CarpService.instance.getDataPointReference().postDataPoint(data);
    });

    test('Collections', () async {
      // List all collections in the root
      List<String> root = await CarpService.instance.collection("").collections;
      for (String ref in root) {
        print(ref);
        // List all object in each collection
        List<ObjectSnapshot> objects = await CarpService.instance.collection("/$ref").objects;
        for (ObjectSnapshot object in objects) {
          print(object);
        }
      }

      List<ObjectSnapshot> objects = await CarpService.instance.collection("users").objects;
      for (ObjectSnapshot object in objects) {
        print(object);
      }

      // is not providing an object id, so this should create a new object
      ObjectSnapshot object =
          await CarpService.instance.collection('users').object().setData({'email': email, 'name': 'Administrator'});

      // updating the name
      await CarpService.instance
          .collection('users')
          .object(object.id)
          .updateData({'email': email, 'name': 'Super User'});

      // deleting the object
      await CarpService.instance.collection('users').object(object.id).delete();
    });
  });
}
