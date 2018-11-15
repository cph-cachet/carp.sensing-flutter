import 'package:test/test.dart';
import 'package:carp_webservices/carp_auth/carp_auth.dart';
import 'package:carp_webservices/carp_service/carp_service.dart';
import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'dart:convert';
import 'dart:io';

String _encode(Object object) => const JsonEncoder.withIndent(' ').convert(object);

void main() {
  final String username = "researcher";
  final String password = "password";
  final String uri = "http://staging.carp.cachet.dk:8080";
  final String clientID = "carp";
  final String clientSecret = "carp";
  final String testStudyId = "1";
  CarpApp app;
  Study study;
  String data_point_id;
  ObjectSnapshot object;

  group("CARP Base Services", () {
    // Runs before all tests.
    setUpAll(() {
      study = new Study(testStudyId, "user@dtu.dk", name: "Test study #$testStudyId");
      app = new CarpApp(
          study: study,
          name: "any_display_friendly_name_is_fine",
          uri: Uri.parse(uri),
          oauth: OAuthEndPoint(clientID: clientID, clientSecret: clientSecret));

      CarpService.configure(app);
      print(app.name);
    });

    // Runs before each test.
    setUp(() {});

    test('Authentication', () async {
      CarpUser user;
      try {
        user = await CarpService.instance.authenticate(username: username, password: password);
      } catch (excp) {
        print(excp.toString());
      }
      assert(user != null);
      assert(user.isAuthenticated);

      print("signed in : $user");
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

      //await uploadTask.onComplete;
    });
  });

  group("Data point", () {
    test('- upload', () async {
      // Create a test location datum
      LocationDatum datum = LocationDatum.fromMap(<String, dynamic>{
        "latitude": 23454.345,
        "longitude": 23.4,
        "altitude": 43.3,
        "accuracy": 12.4,
        "speed": 2.3,
        "speedAccuracy": 12.3
      });

      final CARPDataPoint data = CARPDataPoint.fromDatum(study.id, study.userId, datum);

      //print(_encode(data.toJson()));

      data_point_id = await CarpService.instance.getDataPointReference().postDataPoint(data);

      assert(data_point_id.length > 0);
      print("data_point_id : $data_point_id");
    });

    test('- get', () async {
      CARPDataPoint data = await CarpService.instance.getDataPointReference().getDataPoint(data_point_id);

      print(_encode(data.toJson()));
      assert(data.id == data_point_id);
    });

    test('- delete', () async {
      await CarpService.instance.getDataPointReference().deleteDataPoint(data_point_id);
    });
  });

  group("Collections", () {
    test(' - add object', () async {
      // is not providing an object id, so this should create a new object
      // if the collections (users) don't exist, it is created (according to David).
      object = await CarpService.instance
          .collection('/users')
          .object()
          .setData({'email': username, 'name': 'Administrator'});

      print(object);
      assert(object.id.length > 0);
    });

    test(' - update object', () async {
      assert(object != null);
      // updating the name
      ObjectSnapshot updated_object = await CarpService.instance
          .collection('/users')
          .object(object.id)
          .updateData({'email': username, 'name': 'Super User'});

      print(updated_object.toString());
      print(updated_object.data["name"]);
      assert(updated_object.id.length > 0);
      assert(updated_object.data["name"] == 'Super User');
    });

    test(' - get object', () async {
      assert(object != null);
      // get the object
      ObjectSnapshot new_object = await CarpService.instance.collection('/users').object(object.id).get();

      print((new_object));
      assert(new_object.id == object.id);
    });

    test(' - delete object', () async {
      assert(object != null);
      // deleting the object
      await CarpService.instance.collection('/users').object(object.id).delete();
    });

    test(' - list collections', () async {
      // List all collections in the root
      List<String> root = await CarpService.instance.collection("").collections;
      root.forEach((ref) => print(ref));
    });

    test(" - list objects in '/users' collection", () async {
      List<ObjectSnapshot> objects = await CarpService.instance.collection("/users").objects;
      objects.forEach((object) => print(object));
    });

    test(' - list all objects', () async {
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

      List<ObjectSnapshot> objects = await CarpService.instance.collection("/users").objects;
      for (ObjectSnapshot object in objects) {
        print(object);
      }
    });
  });
}
