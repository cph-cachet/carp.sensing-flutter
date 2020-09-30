import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:carp_webservices/carp_auth/carp_auth.dart';
import 'package:carp_webservices/carp_domain/carp_domain.dart';
import 'package:carp_webservices/carp_service/carp_service.dart';
import 'package:test/test.dart';

import 'credentials.dart';

String _encode(Object object) => const JsonEncoder.withIndent(' ').convert(object);

void main() {
  // CANS DEV
  final String uri = "http://cans.cachet.dk:8087";

  // CANS PROD
  //final String uri = "https://cans.cachet.dk:443";

  // from Barnabas / iPDM-GO test 2020-07-14
  //final String testDeploymentId = "d1f01720-1714-46ee-a16d-da2a566b979e";
  //final String testStudyId = "bc1d3178-c541-46f3-8af2-f313cc9d72fb";

  // from Richard / iPDM-GO test 2020-07-16
  //final String testDeploymentId = "d246170c-515e-40c3-8424-ec1f054f6ba4";
  //final String testStudyId = "64c1784d-52d1-4c3d-99de-24c97fe06939";

  // from Alban - production testing 2020-08-13
  //  final String testDeploymentId = "ab00aeda-9cd0-44d8-902c-9736fec24ab5";
  //  final String testStudyId = "c695ab41-e635-42d7-9b89-57530d0ae3da";

  // from Lori - production testing 2020-08-21
  //final String testDeploymentId = "bb9c2550-f6b7-4948-967f-2e62bdddd840";
  //final String testStudyId = "42ca52da-c768-44f3-9dc5-7f094c192892";

  // from Richard - new JSON model at DEV 2020-09-18
  //final String testStudyId = '682e11d1-ffb8-41fc-81c5-78d2e82fbe94';
  //final String testDeploymentId = 'e286e04b-31c5-4fb2-b4b0-db37c4510ae0';

  // from Richard - new study/deployment at DEV 2020-09-25
  final String testStudyId = '19d79948-c4f3-4d0b-91c5-7f55a390e338';
  final String testDeploymentId = '5b4a3a4d-87df-4c09-adf1-fd47e6a78cc7';

  final String userId = "user@dtu.dk";
  final String collectionName = 'test_patients';
  final String newCollectionName = 'new_patients_3';

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
      study = new Study(testStudyId, userId, deploymentId: testDeploymentId, name: "Test study");

      // Create a test datum
      datum = LightDatum(
        maxLux: 12,
        meanLux: 23,
        minLux: 0.3,
        stdLux: 0.4,
      );

      app = new CarpApp(study: study, name: "Test", uri: Uri.parse(uri), oauth: OAuthEndPoint(clientID: clientID, clientSecret: clientSecret));

      CarpService.configure(app);
    });

    test('- service', () async {
      print('CarpService : ${CarpService.instance.app}');
    });
  });

  group("CARP Base Services", () {
    // Runs before each test.
    setUp(() {});

    test('- authentication w. username and password', () async {
      user = await CarpService.instance.authenticate(
        username: username,
        password: password,
      );

      assert(user != null);
      assert(user.token != null);
      assert(user.isAuthenticated);

      print("signed in : $user");
      print("   token  : ${user.token}");
      print(_encode(user.toJson()));
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
      CarpUser new_user = await CarpService.instance.createUser(username: 'user_$id@dtu.dk', password: 'underbar', firstName: 'CACHET User #$id');

      // we expect this call to fail, since we're not authenticated as admin
      assert(new_user == null);

      print("create  : $new_user");
      print("   name : ${new_user.firstName} ${new_user.lastName}");
    }, skip: true);

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
      CarpUser new_user = await CarpService.instance.authenticateWithToken(username: user.username, token: user.token);

      assert(new_user != null);
      assert(new_user.isAuthenticated);

      print("signed in : $new_user");
      print("   token  : ${new_user.token}");
    });

    test('- authentication with saved JSON token', () async {
      CarpUser new_user = await CarpService.instance.authenticateWithToken(username: username, token: OAuthToken.fromJson(tokenAsJson));

      assert(new_user != null);
      assert(new_user.isAuthenticated);

      print("signed in : $new_user");
      print("   token  : ${new_user.token}");
    });
  });

  group('Informed Consent', () {
    test('- create', () async {
      ConsentDocument uploaded = await CarpService.instance.createConsentDocument({"text": "The original terms text.", "signature": "Image Blob"});

      assert(uploaded != null);
      print(uploaded);
      print(uploaded.createdAt);

      consentDocumentId = uploaded.id;
    });

    test('- get', () async {
      ConsentDocument downloaded = await CarpService.instance.getConsentDocument(consentDocumentId);

      assert(downloaded != null);
      assert(downloaded.id == consentDocumentId);
      print(downloaded);
      print(downloaded.createdAt);
    });
  }, skip: true);

  group("Data points", () {
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
  }, skip: false);

  group("Documents & Collections", () {
    test(' - add document', () async {
      // is providing userId as the document name
      // if the collection don't exist, it is created (according to David).
      document = await CarpService.instance.collection(collectionName).document(userId).setData({'email': userId, 'role': 'Administrator'});

      print(document);
      print(_encode(document.data));

      assert(document.id > 0);
      documentId = document.id;

      // create another document
      await CarpService.instance.collection(collectionName).document(username).setData({'email': username, 'role': 'Participant'});
    });

    test(' - update document', () async {
      assert(document != null);
      print(document);

      DocumentSnapshot original = await CarpService.instance.collection(collectionName).document(document.name).get();
      print(_encode(original.data));

      // updating the role to super user
      DocumentSnapshot updated =
          await CarpService.instance.collection(collectionName).document(document.name).updateData({'email': userId, 'role': 'Super User'});

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
      DocumentSnapshot newDocument = await CarpService.instance.collection(collectionName).document(document.name).get();
      print((newDocument));
      assert(newDocument.id == document.id);
    });

    test(' - rename document', () async {
      assert(document != null);

      print('----------- local document -------------');
      print(document);
      print(_encode(document.data));

      print('----------- renamed document -------------');
      DocumentSnapshot renamed_document = await CarpService.instance.collection(collectionName).document(document.name).rename('new_name');
      print(renamed_document);
      print(_encode(renamed_document.data));

      // get the document back from the server
//      DocumentSnapshot server_document =
//          await CarpService.instance.collection(collectionName).document(renamed_document.name).get();

      print('----------- server document by ID -------------');
      DocumentSnapshot server_document = await CarpService.instance.documentById(documentId).get();
      print(server_document);
      print(_encode(server_document.data));

      print('----------- server document by NAME -------------');
      server_document = await CarpService.instance.collection(collectionName).document(renamed_document.name).get();
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
      // if the collection don't exist, it is created (according to David).
      DocumentSnapshot newDocument = await CarpService.instance
          .collection(collectionName)
          .document(userId)
          .collection('activities')
          .document('cooking')
          .setData({'what': 'breakfast', 'time': 'morning'});

      print(newDocument);
      assert(newDocument.id > 0);
      assert(newDocument.path == '$collectionName/$userId/activities/cooking');
    });

    test(' - get nested document', () async {
      assert(document != null);
      DocumentSnapshot newDocument = await CarpService.instance.collection(collectionName).document(userId).collection('activities').document('cooking').get();

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
      DocumentSnapshot d = await CarpService.instance.collection(collectionName).document().setData({'email': username, 'name': 'Administrator'});

      assert(d.id > 0);
      print(d);
    });

    test(" - get the '$collectionName' collection", () async {
      CollectionReference collection = await CarpService.instance.collection(collectionName).get();
      print(collection);
    });

    test(" - list documents in '$collectionName' collection", () async {
      List<DocumentSnapshot> documents = await CarpService.instance.collection(collectionName).documents;
      documents.forEach((doc) => print(doc));
    });

    test(" - list collections in the 'user@dtu.dk' document", () async {
      DocumentSnapshot newDocument = await CarpService.instance.collection(collectionName).document(userId).get();
      newDocument.collections.forEach((ref) => print(ref));
    });

    test(" - list all nested documents in '$collectionName' collection", () async {
      List<DocumentSnapshot> documents = await CarpService.instance.collection(collectionName).documents;
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
//      documents = await CarpService.instance.collection(collectionName).documents;
//      for (DocumentSnapshot doc in documents) {
//        print(doc);
//      }
//    });

    test(' - get collection from path', () async {
      CollectionReference collection = await CarpService.instance.collection(collectionName).get();
      assert(collection.id > 0);
      print(collection);
    });

    test(' - delete document', () async {
      assert(document != null);
      await CarpService.instance.collection(collectionName).document(document.name).delete();
    });

    test(' - rename collection', () async {
      CollectionReference collection = await CarpService.instance.collection(collectionName).get();
      print('Collection before rename: $collection');
      await collection.rename(newCollectionName);
      expect(collection.name, newCollectionName);
      print('Collection after rename: $collection');
      collection = await CarpService.instance.collection(newCollectionName).get();
      expect(collection.name, newCollectionName);
      print('Collection after get: $collection');
    });

    test(' - delete collection', () async {
      CollectionReference collection = await CarpService.instance.collection(newCollectionName).get();
      await collection.delete();
      expect(collection.id, -1);
      print(collection);
      try {
        collection = await CarpService.instance.collection(newCollectionName).get();
      } catch (error) {
        print(error);
        expect((error as CarpServiceException).httpStatus.httpResponseCode, HttpStatus.notFound);
      }
    });
  }, skip: true);

  group("iPDM-GO", () {
    test(" - get 'patients' collection from path", () async {
      CollectionReference collection = await CarpService.instance.collection('patients').get();
      assert(collection.id > 0);
      print(collection);
    });

    test(" - list all nested documents in 'patients' collection", () async {
      List<DocumentSnapshot> documents = await CarpService.instance.collection('patients').documents;
      documents.forEach((doc) {
        print(doc);
        doc.collections.forEach((col) => print(col));
      });
    });
    test(" - list all nested documents in 'patients/s174238@student.dtu.dk/chapters' collection", () async {
      List<DocumentSnapshot> documents = await CarpService.instance.collection('patients/s174238@student.dtu.dk/chapters').documents;
      documents.forEach((doc) {
        print(doc);
        doc.collections.forEach((col) => print(col));
      });
    });
  }, skip: true);

  group("Files", () {
    int id = -1;

    test('- upload', () async {
      final File myFile = File("test/img.jpg");

      final FileUploadTask uploadTask =
          CarpService.instance.getFileStorageReference().upload(myFile, {'content-type': 'image/jpg', 'content-language': 'en', 'activity': 'test'});

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

    test('- get non-existing', () async {
      try {
        final CarpFileResponse result = await CarpService.instance.getFileStorageReference(876872).get();
      } catch (error) {
        print(error);
        assert(error is CarpServiceException);
        expect((error as CarpServiceException).httpStatus.httpResponseCode, HttpStatus.notFound);
      }
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
  }, skip: true);

  group("Deployment", () {
    DeploymentReference deploymentReference;

    setUpAll(() async {
      deploymentReference = CarpService.instance.deployment();
    });

    test('- get invitations for this account (user)', () async {
      List<ActiveParticipationInvitation> invitations = await CarpService.instance.invitations();
      invitations.forEach((invitation) => print(invitation));
      //assert(invitations.length > 0);
    }, skip: false);

    test('- get deployment status', () async {
      StudyDeploymentStatus status = await deploymentReference.status();
      print(_encode(status.toJson()));
      print(status);
      expect(status.studyDeploymentId, study.deploymentId);
    }, skip: false);

    test('- register device', () async {
      StudyDeploymentStatus status = await deploymentReference.registerDevice(deviceRoleName: 'phone');
      print(status);
      expect(status.studyDeploymentId, study.deploymentId);
    }, skip: false);

    test('- get master device deployment', () async {
      MasterDeviceDeployment deployment = await deploymentReference.get();
      //expect(deployment.studyDeploymentId, study.deploymentId);
    }, skip: true);

    test('- deployment success', () async {
      StudyDeploymentStatus status = await deploymentReference.success();
      print(status);
      expect(status.studyDeploymentId, study.deploymentId);
    }, skip: true);

    test('- unregister device', () async {
      StudyDeploymentStatus status = await deploymentReference.unRegisterDevice('phone');
      print(status);
      expect(status.studyDeploymentId, study.deploymentId);
    }, skip: true);
  }, skip: false);
}
