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
  OAuthToken token;
  Study study;
  int dataPointId;
  BluetoothDatum datum;
  DocumentSnapshot document;
  int documentId;

  group("CARP Base Services", () {
    // Runs before all tests.
    setUpAll(() {
      study = new Study(testStudyId, "user@dtu.dk", name: "Test study #$testStudyId");

      // Create a test bluetooth datum
      datum = BluetoothDatum()
        ..bluetoothDeviceId = "weg"
        ..bluetoothDeviceName = "ksjbdf"
        ..connectable = true
        ..txPowerLevel = 314
        ..rssi = 567
        ..bluetoothDeviceType = "classic";

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

    test('- authentication', () async {
      CarpUser user;
      try {
        user = await CarpService.instance.authenticate(username: username, password: password);
        // saving the token for later use
        token = user.token.clone();
      } catch (excp) {
        print(excp.toString());
      }
      assert(token != null);
      assert(user != null);
      assert(user.isAuthenticated);

      print("signed in : $user");
      print("   token  : ${user.token}");
    });

    test('- refresh token', () async {
      print('expiring token...');
      CarpService.instance.currentUser.token.expire();

      print('trying to upload a document...');
      DocumentSnapshot d = await CarpService.instance
          .collection('users')
          .document()
          .setData({'email': username, 'name': 'Administrator'});

      assert(d.id > 0);
      print(d);
    });

    test('- authentication with saved token', () async {
      CarpUser user;
      try {
        user = await CarpService.instance.authenticateWithToken(username: username, token: token);
      } catch (excp) {
        print(excp.toString());
      }
      assert(user != null);
      assert(user.isAuthenticated);

      print("signed in : $user");
      print("   token  : ${user.token}");
    });
  });

  group("Datapoints", () {
    test('- post', () async {
      final CARPDataPoint data = CARPDataPoint.fromDatum(study.id, study.userId, datum);

      print(_encode(data.toJson()));

      dataPointId = await CarpService.instance.getDataPointReference().postDataPoint(data);

      assert(dataPointId > 0);
      print("data_point_id : $dataPointId");
    });

    test('- batch', () async {
      final File file = File("test/batch.json");
      await CarpService.instance.getDataPointReference().batchPostDataPoint(file);
    });

    test('- get by id', () async {
      print("GET data_point_id : $dataPointId");
      CARPDataPoint data = await CarpService.instance.getDataPointReference().getDataPoint(dataPointId);

      print(_encode(data.toJson()));
      assert(data.id == dataPointId);
      assert(data.carpBody['rssi'] == datum.rssi);
    });

    test('- get all', () async {
      List<CARPDataPoint> data = await CarpService.instance.getDataPointReference().getAllDataPoint();

      data.forEach((datapoint) => print(_encode((datapoint.toJson()))));
      assert(data.length > 0);
    });

    test('- query', () async {
      String query = 'carp_header.user_id==$username';
      print("query : $query");
      List<CARPDataPoint> data = await CarpService.instance.getDataPointReference().queryDataPoint(query);

      data.forEach((datapoint) => print(_encode((datapoint.toJson()))));
      assert(data.length > 0);
    });

    test('- delete', () async {
      print("DELETE data_point_id : $dataPointId");
      await CarpService.instance.getDataPointReference().deleteDataPoint(dataPointId);
    });
  });

  group("Documents & Collections", () {
    test(' - add document', () async {
      // is not providing an document id, so this should create a new document
      // if the collections (users) don't exist, it is created (according to David).
      document = await CarpService.instance
          .collection('users')
          .document(username)
          .setData({'email': username, 'role': 'Administrator'});

      print(document);
      assert(document.id > 0);
      documentId = document.id;
    });

    test(' - update document', () async {
      assert(document != null);

      DocumentSnapshot original = await CarpService.instance.collection('users').document(document.name).get();

      print(_encode(original.data));

      // updating the name
      DocumentSnapshot updated = await CarpService.instance
          .collection('users')
          .document(document.name)
          .updateData({'email': username, 'role': 'Super User'});

      print(_encode(updated.data));

      print(updated.toString());
      print(updated.data["role"]);
      assert(updated.id > 0);
      assert(updated.data["role"] == 'Super User');
    });

    test(' - rename document', () async {
      assert(document != null);

      document = await CarpService.instance.collection('users').document(document.name).rename('new name');

      print(_encode(document.data));

      print(document.toString());
      assert(document.id > 0);
      assert(document.name == 'new name');
    });

    test(' - get document by path', () async {
      assert(document != null);
      DocumentSnapshot newDocument = await CarpService.instance.collection('users').document(document.name).get();

      print((newDocument));
      assert(newDocument.id == document.id);
    });

    test(' - get document by id', () async {
      assert(document != null);
      DocumentSnapshot newDocument = await CarpService.instance.documentById(documentId).get();

      print((newDocument));
      assert(newDocument.id == document.id);
      assert(newDocument.id == documentId);
    });

    test(' - get nested document', () async {
      assert(document != null);
      DocumentSnapshot newDocument = await CarpService.instance.collection('activities').document("test").get();

      print(newDocument);
      print(newDocument.createdAt);
      print(newDocument.snapshot);
      print(newDocument.data);
      print(newDocument['my_field']);
      assert(newDocument.id == 4);
    });

    test(' - list collections', () async {
      DocumentSnapshot newDocument = await CarpService.instance.collection('activities').document("test").get();
      newDocument.collections.forEach((ref) => print(ref));
    });

    test(" - list documents in 'users' collection", () async {
      List<DocumentSnapshot> documents = await CarpService.instance.collection("users").documents;
      documents.forEach((doc) => print(doc));
    });

    test(" - list all nested documents in 'activities' collection", () async {
      List<DocumentSnapshot> documents = await CarpService.instance.collection("activities").documents;
      documents.forEach((doc) {
        print(doc);
        doc.collections.forEach((col) => print(col));
        // doc.c
      });

      //     List<DocumentSnapshot> documents;

//      // List all collections in the root
//      List<String> root = await CarpService.instance.collection("").collections;
//      for (String ref in root) {
//        print(ref);
//        // List all documents in each collection
//        documents = await CarpService.instance.collection("/$ref").documents;
//        for (DocumentSnapshot doc in documents) {
//          print(doc);
//        }
//      }
//
//      documents = await CarpService.instance.collection("users").documents;
//      for (DocumentSnapshot doc in documents) {
//        print(doc);
//      }
    });

    test(' - get collection from path', () async {
      assert(document != null);
      CollectionReference collection = await CarpService.instance.collection('users').get();
      assert(collection.id > 0);
      print(collection);
    });

    test(' - delete document', () async {
      assert(document != null);
      await CarpService.instance.collection('users').document(document.name).delete();
    });

    test(' - rename collection', () async {
      CollectionReference collection = await CarpService.instance.collection('users').get();
      await collection.rename('new_users');
      expect(collection.name, 'new_users');
    });

    test(' - delete collection', () async {
      CollectionReference collection = await CarpService.instance.collection('users').get();
      await collection.delete();
      expect(collection.name, 'new_users');
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
      print('result : $result');
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
      print('result : $results');
    });

    test('- delete', () async {
      final int result = await CarpService.instance.getFileStorageReference(id).delete();

      assert(result > 0);
      print('result : $result');
    });
  });
}
