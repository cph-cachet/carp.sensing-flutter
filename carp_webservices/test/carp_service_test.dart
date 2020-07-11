import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:carp_webservices/carp_auth/carp_auth.dart';
import 'package:carp_webservices/carp_service/carp_service.dart';
import 'package:test/test.dart';

String _encode(Object object) => const JsonEncoder.withIndent(' ').convert(object);

void main() {
  //final String username = "researcher@example.com";
  //final String password = "password";
  final String username = "admin@cachet.dk";
  final String password = "admin";
  final String userId = "user@dtu.dk";
  //final String uri = "http://staging.carp.cachet.dk:8080";
  //final String uri = "https://test.carp.cachet.dk:443";
  final String uri = "https://cans.cachet.dk:443";
  final String clientID = "carp";
  final String clientSecret = "carp";
  //final String testStudyId = "2";
  final String testStudyId = "ea7d63f7-3c42-43e8-ba4f-2c02ae63a272";

  Map<String, dynamic> tokenAsJson;
  CarpApp app;
  CarpUser user;
  Study study;
  int dataPointId;
  LightDatum datum;
  DocumentSnapshot document;
  int documentId;
  int consentDocumentId;
  Random random = Random();

  group("Setup Carp Service", () {
    // Runs before all tests.
    setUpAll(() {
      study = new Study(testStudyId, userId, name: "Test study #$testStudyId");

      // Create a test datum
      datum = LightDatum(
        maxLux: 12,
        meanLux: 23,
        minLux: 0.3,
        stdLux: 0.4,
      );

      app = new CarpApp(
          study: study,
          name: "Test",
          uri: Uri.parse(uri),
          oauth: OAuthEndPoint(clientID: clientID, clientSecret: clientSecret));

      CarpService.configure(app);
    });

    test('- service', () async {
      print('CarpService : ${CarpService.instance.app}');
    });
  });

  group("CARP Base Services", () {
    // Runs before each test.
    setUp(() {});

    test('- authentication', () async {
      user = await CarpService.instance.authenticate(username: username, password: password);

      assert(user != null);
      assert(user.token != null);
      assert(user.isAuthenticated);

      print("signed in : $user");
      print("   token  : ${user.token}");
    });

    test('- get user profile', () async {
      CarpUser new_user = await CarpService.instance.getCurrentUserProfile();

      assert(new_user != null);

      print("signed in : $new_user");
      print("   name   : ${new_user.firstName} ${new_user.lastName}");
    });

    // This test fails -- we do not have access to create users with the authenticated user.
    test('- create user', () async {
      int id = random.nextInt(1000);
      CarpUser new_user = await CarpService.instance
          .createUser(username: 'user_$id@dtu.dk', password: 'underbar', firstName: 'CACHET User #$id');

      // we expect this call to fail, since we're not authenticated as admin
      assert(new_user == null);

      print("create  : $new_user");
      print("   name : ${new_user.firstName} ${new_user.lastName}");
    });

//    test('- create participant by invite', () async {
//      int id = random.nextInt(1000);
//      CarpUser new_user = await CarpService.instance.createParticipantByInvite(
//          username: 'participant_$id@dtu.dk', password: 'underbar', firstName: 'CACHET Participant #$id');
//
//      assert(new_user != null);
//
//      print("create  : $new_user");
//      print("   name : ${new_user.firstName} ${new_user.lastName}");
//    });
//
//    test('- create researcher by invite', () async {
//      int id = random.nextInt(1000);
//      CarpUser new_user = await CarpService.instance.createResearcherByInvite(
//          username: 'researcher_$id@dtu.dk', password: 'underbar', firstName: 'CACHET Researcher #$id');
//
//      assert(new_user != null);
//
//      print("create  : $new_user");
//      print("   name : ${new_user.firstName} ${new_user.lastName}");
//    });

    test('- refresh token', () async {
      print('expiring token...');
      CarpService.instance.currentUser.token.expire();

      await CarpService.instance.currentUser.getOAuthToken(refresh: true);

      assert(user.token != null);
      print("signed in : $user");
      print("   token  : ${user.token}\n");

      //saving token as json for later
      tokenAsJson = user.token.toJson();
      print(_encode(tokenAsJson));
    });

    test('- authentication with saved token', () async {
      CarpUser new_user = await CarpService.instance.authenticateWithToken(username: username, token: user.token);

      assert(new_user != null);
      assert(new_user.isAuthenticated);

      print("signed in : $new_user");
      print("   token  : ${new_user.token}");
    });

    test('- authentication with saved JSON token', () async {
      CarpUser new_user =
          await CarpService.instance.authenticateWithToken(username: username, token: OAuthToken.fromJson(tokenAsJson));

      assert(new_user != null);
      assert(new_user.isAuthenticated);

      print("signed in : $new_user");
      print("   token  : ${new_user.token}");
    });
  });

  group(
    'Informed Consent',
    () {
      test('- create', () async {
        ConsentDocument uploaded = await CarpService.instance
            .createConsentDocument({"text": "The original terms text.", "signature": "Image Blob"});

        assert(uploaded != null);
        print(uploaded);
        print(uploaded.createdAt);

        consentDocumentId = uploaded.id;
      });

      test('- get', () async {
        ConsentDocument uploaded = await CarpService.instance.getConsentDocument(consentDocumentId);

        assert(uploaded != null);
        print(uploaded);
        print(uploaded.createdAt);
      });
    },
    skip: false,
  );

  group(
    "Data points",
    () {
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
        assert(data.carpBody['id'] == datum.id);
      });

      test('- get all', () async {
        List<CARPDataPoint> data = await CarpService.instance.getDataPointReference().getAllDataPoint();

        data.forEach((datapoint) => print(_encode((datapoint.toJson()))));
        assert(data.length > 0);
      });

      test('- query', () async {
        String query = 'carp_header.user_id==$userId;carp_body.timestamp>2019-11-02T12:53:40.219598Z';
        //String query = 'carp_header.user_id==$userId';
        print("query : $query");
        List<CARPDataPoint> data = await CarpService.instance.getDataPointReference().queryDataPoint(query);

        data.forEach((datapoint) => print(_encode((datapoint.toJson()))));
        assert(data.length > 0);
      });

      test('- delete', () async {
        print("DELETE data_point_id : $dataPointId");
        await CarpService.instance.getDataPointReference().deleteDataPoint(dataPointId);
      });
    },
    skip: false,
  );

  group("Documents & Collections", () {
    test(' - add document', () async {
      // is providing userId as the document name
      // if the collections (patients) don't exist, it is created (according to David).
      document = await CarpService.instance
          .collection('patients')
          .document(userId)
          .setData({'email': userId, 'role': 'Administrator'});

      print(document);
      print(_encode(document.data));

      assert(document.id > 0);
      documentId = document.id;

      // create another document
      await CarpService.instance
          .collection('patients')
          .document(username)
          .setData({'email': username, 'role': 'Participant'});
    });

    test(' - update document', () async {
      assert(document != null);
      print(document);

      DocumentSnapshot original = await CarpService.instance.collection('patients').document(document.name).get();
      print(_encode(original.data));

      // updating the role to super user
      DocumentSnapshot updated = await CarpService.instance
          .collection('patients')
          .document(document.name)
          .updateData({'email': userId, 'role': 'Super User'});

      print('----------- updated -------------');
      print(updated);
      print(_encode(updated.data));
      print(updated.data["role"]);
      assert(updated.id > 0);
      assert(updated.data["role"] == 'Super User');
    });

    test(' - get document by id', () async {
      assert(document != null);
      DocumentSnapshot newDocument = await CarpService.instance.documentById(documentId).get();

      print((newDocument));
      assert(newDocument.id == document.id);
      assert(newDocument.id == documentId);
    });

    test(' - get document by path', () async {
      DocumentSnapshot newDocument = await CarpService.instance.collection('patients').document(document.name).get();
      print((newDocument));
      assert(newDocument.id == document.id);
    });

    test(' - rename document', () async {
      assert(document != null);

      print('----------- local document -------------');
      print(document);
      print(_encode(document.data));

      print('----------- renamed document -------------');
      DocumentSnapshot renamed_document =
          await CarpService.instance.collection('patients').document(document.name).rename('new_name');
      print(renamed_document);
      print(_encode(renamed_document.data));

      // get the document back from the server
//      DocumentSnapshot server_document =
//          await CarpService.instance.collection('patients').document(renamed_document.name).get();

      print('----------- server document by ID -------------');
      DocumentSnapshot server_document = await CarpService.instance.documentById(documentId).get();
      print(server_document);
      print(_encode(server_document.data));

      print('----------- server document by NAME -------------');
      server_document = await CarpService.instance.collection('patients').document(renamed_document.name).get();
      print(server_document);
      print(_encode(server_document.data));

      assert(server_document.id > 0);
      assert(server_document.name == renamed_document.name);
      assert(server_document.data.length == document.data.length);
    }, skip: true);

    test(' - get document by query', () async {
      assert(document != null);
      String query = 'name==$userId';
      List<DocumentSnapshot> documents = await CarpService.instance.documentsByQuery(query);

      print('Found ${documents.length} document(s)');
      documents.forEach((document) => print(' - $document'));

      assert(documents.length != 0);
    });

    test(' - add document in nested collections', () async {
      // is not providing an document id, so this should create a new document
      // if the collections (patients) don't exist, it is created (according to David).
      DocumentSnapshot newDocument = await CarpService.instance
          .collection('patients')
          .document(userId)
          .collection('activities')
          .document('cooking')
          .setData({'what': 'breakfast', 'time': 'morning'});

      print(newDocument);
      assert(newDocument.id > 0);
      assert(newDocument.path == 'patients/$userId/activities/cooking');
    });

    test(' - get nested document', () async {
      assert(document != null);
      DocumentSnapshot newDocument = await CarpService.instance
          .collection('patients')
          .document(userId)
          .collection('activities')
          .document('cooking')
          .get();

      print(newDocument);
      print(newDocument.snapshot);
      print(newDocument.createdAt);
      print(newDocument.data);
      print(newDocument['what']);
      assert(newDocument.id > 0);
    });

    test('- expire token and the upload document', () async {
      print('expiring token...');
      CarpService.instance.currentUser.token.expire();

      print('trying to upload a document w/o a name...');
      DocumentSnapshot d = await CarpService.instance
          .collection('patients')
          .document()
          .setData({'email': username, 'name': 'Administrator'});

      assert(d.id > 0);
      print(d);
    });

    test(" - list documents in 'patients' collection", () async {
      List<DocumentSnapshot> documents = await CarpService.instance.collection("patients").documents;
      documents.forEach((doc) => print(doc));
    });

    test(" - list collections in the 'user@dtu.dk' document", () async {
      DocumentSnapshot newDocument = await CarpService.instance.collection('patients').document(userId).get();
      newDocument.collections.forEach((ref) => print(ref));
    });

    test(" - list all nested documents in 'patients' collection", () async {
      List<DocumentSnapshot> documents = await CarpService.instance.collection("patients").documents;
      documents.forEach((doc) {
        print(doc);
        doc.collections.forEach((col) => print(col));
      });
    });

//    test(" - list all collections in the root", () async {
//      List<String> root = await CarpService.instance.collection("").collections;
//      for (String ref in root) {
//        print(ref);
//        // List all documents in each collection
//        List<DocumentSnapshot> documents =
//            await CarpService.instance.collection("/$ref").documents;
//        for (DocumentSnapshot doc in documents) {
//          print(doc);
//        }
//      }
//
//      documents = await CarpService.instance.collection("patients").documents;
//      for (DocumentSnapshot doc in documents) {
//        print(doc);
//      }
//    });

    test(' - get collection from path', () async {
      CollectionReference collection = await CarpService.instance.collection('patients').get();
      assert(collection.id > 0);
      print(collection);
    });

    test(' - delete document', () async {
      assert(document != null);
      await CarpService.instance.collection('patients').document(document.name).delete();
    });

    test(' - rename collection', () async {
      CollectionReference collection = await CarpService.instance.collection('patients').get();
      await collection.rename('new_patients');
      expect(collection.name, 'new_patients');
      print(collection);
    });

    test(' - delete collection', () async {
      CollectionReference collection = await CarpService.instance.collection('new_patients').get();
      await collection.delete();
      print(collection);
    });
  });

  group(
    "Files",
    () {
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
    },
    skip: false,
  );
}
