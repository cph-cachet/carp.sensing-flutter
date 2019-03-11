import 'package:test/test.dart';
import 'package:carp_webservices/carp_auth/carp_auth.dart';
import 'package:carp_webservices/carp_service/carp_service.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'dart:convert';
import 'dart:io';

String _encode(Object object) => const JsonEncoder.withIndent(' ').convert(object);

void main() {
  final String username = "researcher@example.com";
  final String password = "password";
  final String uri = "http://staging.carp.cachet.dk:8080";
  final String clientID = "carp";
  final String clientSecret = "carp";
  final String testStudyId = "2";
  CarpApp app;
  Study study;
  int data_point_id;
  DocumentSnapshot document;

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
  });

  group("Datapoints", () {
    test('- post', () async {
      ScreenDatum screenDatum;
      // Create a test bluetooth datum
      BluetoothDatum datum = BluetoothDatum()
        ..bluetoothDeviceId = "weg"
        ..bluetoothDeviceName = "ksjbdf"
        ..connectable = true
        ..txPowerLevel = 314
        ..rssi = 567
        ..bluetoothDeviceType = "classic";

      final CARPDataPoint data = CARPDataPoint.fromDatum(study.id, study.userId, datum);

      print(_encode(data.toJson()));

      data_point_id = await CarpService.instance.getDataPointReference().postDataPoint(data);
      //var id = await CarpService.instance.getDataPointReference().postDataPoint(data);

      assert(data_point_id > 0);
      print("data_point_id : $data_point_id");
      //print("id : $id");
    });

    test('- batch', () async {
      final File file = File("test/batch.json");
      await CarpService.instance.getDataPointReference().batchPostDataPoint(file);
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

  group("Documents & Collections", () {
    test(' - add document', () async {
      // is not providing an document id, so this should create a new document
      // if the collections (users) don't exist, it is created (according to David).
      document = await CarpService.instance
          .collection('/users')
          .document()
          .setData({'email': username, 'name': 'Administrator'});

      print(document);
      assert(document.id.length > 0);
    });

    test(' - update document', () async {
      assert(document != null);
      // updating the name
      DocumentSnapshot updated_document = await CarpService.instance
          .collection('/users')
          .document(document.id)
          .updateData({'email': username, 'name': 'Super User'});

      print(updated_document.toString());
      print(updated_document.data["name"]);
      assert(updated_document.id.length > 0);
      assert(updated_document.data["name"] == 'Super User');
    });

    test(' - get document', () async {
      assert(document != null);
      DocumentSnapshot new_document = await CarpService.instance.collection('/users').document(document.id).get();

      print((new_document));
      assert(new_document.id == document.id);
    });

    test(' - list collections', () async {
      // List all collections in the root
      List<String> root = await CarpService.instance.collection("").collections;
      root.forEach((ref) => print(ref));
    });

    test(" - list documents in '/users' collection", () async {
      List<DocumentSnapshot> documents = await CarpService.instance.collection("/users").documents;
      documents.forEach((doc) => print(doc));
    });

    test(' - list all documents', () async {
      List<DocumentSnapshot> documents;

      // List all collections in the root
      List<String> root = await CarpService.instance.collection("").collections;
      for (String ref in root) {
        print(ref);
        // List all documents in each collection
        documents = await CarpService.instance.collection("/$ref").documents;
        for (DocumentSnapshot doc in documents) {
          print(doc);
        }
      }

      documents = await CarpService.instance.collection("/users").documents;
      for (DocumentSnapshot doc in documents) {
        print(doc);
      }
    });

    test(' - delete document', () async {
      assert(document != null);
      await CarpService.instance.collection('/users').document(document.id).delete();
    });
  });

  group("Files", () {
    int id = -1;

    test('- upload', () async {
      final File myFile = File("test/img.jpg");

      final FileUploadTask uploadTask = CarpService.instance
          .getFileStorageReference()
          .upload(myFile, {'content-type': 'image/jpg', 'content-language': 'en', 'activity': 'test'});

      assert(uploadTask != null);

      CarpFileResponse response = await uploadTask.onComplete;
      assert(response.id > 0);
      id = response.id;

      print('response.storageName : ${response.storageName}');
      print('response.studyId : ${response.studyId}');
      print('response.createdAt : ${response.createdAt}');
    });

    test('- get', () async {
      final CarpFileResponse result = await CarpService.instance.getFileStorageReference(id).get();

      assert(result.id == id);
      print('result : ${result}');
    });

    test('- download', () async {
      final File myFile = File("test/img-$id.jpg");

      final FileDownloadTask downloadTask = CarpService.instance.getFileStorageReference(id).download(myFile);

      assert(downloadTask != null);

      int response = await downloadTask.onComplete;
      assert(response == 200);
      print('status code : $response');
    });

    test('- get all', () async {
      final List<CarpFileResponse> results = await CarpService.instance.getFileStorageReference(id).getAll();

      //assert(result.id == id);
      print('result : ${results}');
    });

    test('- delete', () async {
      final int result = await CarpService.instance.getFileStorageReference(id).delete();

      assert(result > 0);
      print('result : $result');
    });
  });
}
