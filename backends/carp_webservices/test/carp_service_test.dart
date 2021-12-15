import 'dart:convert';
import 'dart:io';

import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:carp_webservices/carp_auth/carp_auth.dart';
import 'package:carp_webservices/carp_services/carp_services.dart';
import 'package:test/test.dart';

import 'credentials.dart';

String _encode(Object? object) =>
    const JsonEncoder.withIndent(' ').convert(object);

void main() {
  final String userId = "jakob@bardram.net";
  final String studyId = "test_1234";
  final String collectionName = 'test_patients';
  final String newCollectionName = 'new_patients';

  CarpApp app;
  StudyProtocol protocol;
  Smartphone phone;

  LightDatum datum1 = LightDatum(
    maxLux: 12,
    meanLux: 23,
    minLux: 0.3,
    stdLux: 0.4,
  );

  DeviceDatum datum2 = DeviceDatum(
    'Android',
    '12345jE',
  );

  DocumentSnapshot? document;
  int? documentId;

  /// Setup CARP and authenticate.
  /// Runs once before all tests.
  setUpAll(() async {
    // Create a new study protocol.
    protocol = StudyProtocol(
      ownerId: 'owner@dtu.dk',
      name: 'CARP Webb Services Test',
    );

    // Define which devices are used for data collection.
    phone = Smartphone();

    protocol..addMasterDevice(phone);

    app = new CarpApp(
      name: "Test",
      studyId: testStudyId,
      studyDeploymentId: testDeploymentId,
      uri: Uri.parse(uri),
      oauth: OAuthEndPoint(clientID: clientID, clientSecret: clientSecret),
    );

    CarpService().configure(app);

    await CarpService().authenticate(
      username: username,
      password: password,
    );
  });

  /// Close connection to CARP.
  /// Runs once after all tests.
  tearDownAll(() {});

  group("CARP Base Services", () {
    test('- service', () async {
      print('CarpService : ${CarpService().app}');
    });

    test('- authentication w. username and password', () async {
      CarpUser user = await CarpService().authenticate(
        username: username,
        password: password,
      );

      assert(user.token != null);
      assert(user.isAuthenticated);

      print("signed in : $user");
      print("   token  : ${user.token}");
      print(_encode(user.toJson()));
    });

    test('- get user profile', () async {
      CarpUser newUser = await CarpService().getCurrentUserProfile();

      print("signed in : $newUser");
      print("   name   : ${newUser.firstName} ${newUser.lastName}");
    });

    test('- refresh token', () async {
      print('expiring token...');
      CarpService().currentUser!.token!.expire();

      await CarpService().currentUser!.getOAuthToken(refresh: true);
      CarpUser user = CarpService().currentUser!;

      assert(user.token != null);
      print("signed in : $user");
      print("   token  : ${user.token}\n");
    });

    test('- authentication with saved token', () async {
      CarpUser user = await CarpService().authenticate(
        username: username,
        password: password,
      );

      CarpUser newUser = await CarpService()
          .authenticateWithToken(username: user.username, token: user.token!);

      assert(newUser.isAuthenticated);
      assert(newUser.username == user.username);

      print("signed in : $newUser");
      print("   token  : ${newUser.token}");
    });

    test('- authentication with saved JSON token', () async {
      CarpUser user = await CarpService().authenticate(
        username: username,
        password: password,
      );

      //saving token as json
      Map<String, dynamic> tokenAsJson = user.token!.toJson();
      print(_encode(tokenAsJson));

      CarpUser newUser = await CarpService().authenticateWithToken(
          username: username, token: OAuthToken.fromJson(tokenAsJson));

      assert(newUser.isAuthenticated);
      assert(newUser.username == user.username);

      print("signed in : $newUser");
      print("   token  : ${newUser.token}");
    });

    test('- change password', () async {
      CarpUser user1 = await CarpService().authenticate(
        username: username,
        password: password,
      );

      // saving password
      String oldPassword = password;
      String newPassword = 'new_$password';

      // changing password to the new one
      CarpUser user2 = await CarpService().changePassword(
        currentPassword: password,
        newPassword: newPassword,
      );

      assert(user2.isAuthenticated);
      assert(user2.username == user1.username);
      print("Password has been changed to '$newPassword'\n - user : $user2");

      // check if we can authenticate with the new password
      CarpUser user3 = await CarpService().authenticate(
        username: username,
        password: newPassword,
      );

      assert(user3.isAuthenticated);
      assert(user3.username == user1.username);
      print("signed in using the '$newPassword' password\n - user: $user3");

      // changing the password back to the old one
      CarpUser? user4 = await CarpService().changePassword(
        currentPassword: newPassword,
        newPassword: oldPassword,
      );
      print(
          "Password has been changed back to '$oldPassword'\n - user : $user4");
    });
  });

  int? consentDocumentId;

  group('Informed Consent', () {
    test('- create', () async {
      ConsentDocument uploaded = await CarpService().createConsentDocument(
          {"text": "The original terms text.", "signature": "Image Blob"});

      print(uploaded);
      print('document id : ${uploaded.id}');
      print('createdAt   : ${uploaded.createdAt}');
      print('createdByUserId : ${uploaded.createdByUserId}');
      print('document    : ${uploaded.document}');

      consentDocumentId = uploaded.id;
    });

    test('- get', () async {
      ConsentDocument downloaded =
          await CarpService().getConsentDocument(consentDocumentId!);

      assert(downloaded.id == consentDocumentId);

      print(downloaded);
      print('document id : ${downloaded.id}');
      print('createdAt : ${downloaded.createdAt}');
      print('createdByUserId : ${downloaded.createdByUserId}');
      print('document : ${downloaded.document}');
    });
  }, skip: false);

  group(
    "Data points",
    () {
      test('- post', () async {
        final DataPoint data = DataPoint.fromData(datum1);
        // studyId & userId is required for upload
        data.carpHeader.studyId = studyId;
        data.carpHeader.userId = userId;

        print(_encode(data.toJson()));

        int dataPointId =
            await CarpService().getDataPointReference().postDataPoint(data);

        assert(dataPointId > 0);
        print("data_point_id : $dataPointId");
      });

      test('- post w/o trigger id & device role name', () async {
        final DataPoint data = DataPoint.fromData(datum1);
        // studyId & userId is required for upload
        data.carpHeader.studyId = studyId;
        data.carpHeader.userId = userId;

        // triggerId, deviceRoleName, startTime & endTime are not required
        data.carpHeader.triggerId = null;
        data.carpHeader.deviceRoleName = null;
        data.carpHeader.startTime = null;
        data.carpHeader.endTime = null;

        print(_encode(data.toJson()));

        int dataPointId =
            await CarpService().getDataPointReference().postDataPoint(data);

        assert(dataPointId > 0);
        print("data_point_id : $dataPointId");
      });

      test('- batch', () async {
        final File file = File("test/batch-correct-test.json");
        await CarpService().getDataPointReference().batchPostDataPoint(file);

        // wait for the batch requests to finish
        await Future.delayed(const Duration(seconds: 2), () {});

        String query = 'carp_header.data_format.namespace==test';
        print("query : $query");

        List<DataPoint> data =
            await CarpService().getDataPointReference().queryDataPoint(query);

        print('N=${data.length}');
        // data.forEach((datapoint) => print(_encode((datapoint.toJson()))));

        assert(data.length >= 140);
      });

      test('- query for test data points', () async {
        String query = 'carp_header.data_format.namespace==test';
        print("query : $query");
        List<DataPoint> data =
            await CarpService().getDataPointReference().queryDataPoint(query);

        print('N=${data.length}');
        // data.forEach((datapoint) => print(_encode((datapoint.toJson()))));

        assert(data.length >= 0);
      });

      test('- delete test data points', () async {
        String query = 'carp_header.data_format.namespace==test';
        print("query : $query");
        List<DataPoint> data =
            await CarpService().getDataPointReference().queryDataPoint(query);

        print('N=${data.length}');
        print('deleting...');
        data.forEach((datapoint) async {
          print(' ${datapoint.id}');
          await CarpService()
              .getDataPointReference()
              .deleteDataPoint(datapoint.id!);
        });
      });

      test('- get by id', () async {
        final DataPoint dataPost = DataPoint.fromData(datum1);
        // studyId & userId is required for upload
        dataPost.carpHeader.studyId = studyId;
        dataPost.carpHeader.userId = userId;

        print(_encode(dataPost.toJson()));

        int dataPointId =
            await CarpService().getDataPointReference().postDataPoint(dataPost);

        assert(dataPointId > 0);

        DataPoint dataGet = await CarpService()
            .getDataPointReference()
            .getDataPoint(dataPointId);

        print(_encode(dataGet.toJson()));
        assert(dataGet.id == dataPointId);
      });

      test(
        '- get all',
        () async {
          List<DataPoint> data =
              await CarpService().getDataPointReference().getAllDataPoint();

          //data.forEach((datapoint) => print(_encode((datapoint.toJson()))));
          assert(data.length >= 0);
          print('N=${data.length}');
        },
        skip: true,
      );

      test('- query', () async {
        await CarpService()
            .getDataPointReference()
            .postDataPoint(DataPoint.fromData(datum1)
              ..carpHeader.studyId = studyId
              ..carpHeader.userId = userId);
        await CarpService()
            .getDataPointReference()
            .postDataPoint(DataPoint.fromData(datum2)
              ..carpHeader.studyId = studyId
              ..carpHeader.userId = userId);

        // String query =
        //     'carp_header.user_id==$userId;carp_body.timestamp>2019-11-02T12:53:40.219598Z';
        //String query = 'carp_header.data_format.namespace==test';
        String query = 'carp_header.data_format.name==light';
        // String query = 'carp_header.user_id==$userId';
        //String query = 'carp_body.timestamp>2019-11-02T12:53:40.219598Z';
        //String query = 'carp_header.data_format.namespace=in=(carp,omh)';
        print("query : $query");
        List<DataPoint> data =
            await CarpService().getDataPointReference().queryDataPoint(query);

        assert(data.length >= 0);
        print('N=${data.length}');
        String str = '[';
        data.forEach((datapoint) => str += '${datapoint.id},');
        // data.forEach((datapoint) => print(_encode((datapoint.toJson()))));
        str += ']';
        print(str);
      });

      test('- delete', () async {
        int dataPointId = await CarpService()
            .getDataPointReference()
            .postDataPoint(DataPoint.fromData(datum1)
              ..carpHeader.studyId = studyId
              ..carpHeader.userId = userId);
        print("DELETE data_point_id : $dataPointId");
        await CarpService()
            .getDataPointReference()
            .deleteDataPoint(dataPointId);
      });

      test(
        '- delete all',
        () async {
          List<DataPoint> data =
              await CarpService().getDataPointReference().getAllDataPoint();

          print('N=${data.length}');
          print('deleting...');
          data.forEach((datapoint) async {
            print(' ${datapoint.id}');
            await CarpService()
                .getDataPointReference()
                .deleteDataPoint(datapoint.id!);
          });

          // wait for the delete requests to finish
          await Future.delayed(const Duration(seconds: 2), () {});

          List<DataPoint> empty =
              await CarpService().getDataPointReference().getAllDataPoint();

          print('N=${empty.length}');
          assert(empty.length == 0);
        },
        skip: true,
      );
    },
    skip: false,
  );

  group("Documents & Collections", () {
    setUp(() async {
      // first create a document - providing userId as the document name
      // if the collection don't exist, it is created (according to David).
      document = await CarpService()
          .collection(collectionName)
          .document(userId)
          .setData({'email': userId, 'role': 'Administrator'});

      expect(document, isNotNull);

      // save the id for later use
      documentId = document!.id;
    });

    test(' - add document', () async {
      print(document);
      print(_encode(document!.data));

      expect(document!.id, greaterThan(0));

      // create another document
      await CarpService()
          .collection(collectionName)
          .document(username)
          .setData({'email': username, 'role': 'Participant'});
    });

    test(' - update document', () async {
      assert(document != null);
      print(document);

      // now get it back from the server
      DocumentSnapshot? original = await CarpService()
          .collection(collectionName)
          .document(document!.name)
          .get();
      print(_encode(original?.data));

      // updating the role to super user
      DocumentSnapshot updated = await CarpService()
          .collection(collectionName)
          .document(document!.name)
          .updateData({'email': userId, 'role': 'Super User'});

      print('----------- updated -------------');
      print(updated);
      print(_encode(updated.data));
      print(updated.data["role"]);
      expect(updated.id, greaterThan(0));
      expect(updated.data["role"], 'Super User');
    });

    test(' - get document by id', () async {
      assert(document != null);
      DocumentSnapshot? newDocument =
          await CarpService().documentById(documentId!).get();

      print((newDocument));
      expect(newDocument?.id, document!.id);
      expect(newDocument?.id, documentId);
    });

    test(' - get document by path', () async {
      DocumentSnapshot? newDocument = await CarpService()
          .collection(collectionName)
          .document(document!.name)
          .get();

      print((newDocument));
      expect(newDocument?.id, document!.id);
    });

    test(' - get non-existing document', () async {
      DocumentSnapshot? newDocument = await CarpService()
          .collection(collectionName)
          .document('not_available')
          .get();

      print((newDocument));
      expect(newDocument, isNull);
    });

//     test(' - rename document', () async {
//       assert(document != null);

//       print('----------- local document -------------');
//       print(document);
//       print(_encode(document.data));

//       print('----------- renamed document -------------');
//       DocumentSnapshot renamedDocument = await CarpService()
//           .collection(collectionName)
//           .document(document.name)
//           .rename('new_name');
//       print(renamedDocument);
//       print(_encode(renamedDocument.data));

//       // get the document back from the server
// //      DocumentSnapshot server_document =
// //          await CarpService().collection(collectionName).document(renamed_document.name).get();

//       print('----------- server document by ID -------------');
//       DocumentSnapshot serverDocument =
//           await CarpService().documentById(documentId).get();
//       print(serverDocument);
//       print(_encode(serverDocument.data));

//       print('----------- server document by NAME -------------');
//       serverDocument = await CarpService()
//           .collection(collectionName)
//           .document(renamedDocument.name)
//           .get();
//       print(serverDocument);
//       print(_encode(serverDocument.data));

//       assert(serverDocument.id > 0);
//       assert(serverDocument.name == renamedDocument.name);
//       assert(serverDocument.data.length == document.data.length);
//     }, skip: true);

    test(' - get documents by query', () async {
      assert(document != null);
      String query = 'name==$userId';
      List<DocumentSnapshot> documents =
          await CarpService().documentsByQuery(query);

      print("Found ${documents.length} document(s) for user '$userId'");
      documents.forEach((document) => print(' - $document'));

      expect(documents.length, greaterThan(0));
    });

    test(' - get all documents', () async {
      List<DocumentSnapshot> documents = await CarpService().documents();

      print('Found ${documents.length} document(s)');
      documents.forEach((document) => print(' - $document'));
      expect(documents.length, greaterThan(0));
    });

    test(' - add document in nested collections', () async {
      // is not providing an document id, so this should create a new document
      // if the collection don't exist, it is created (according to David).
      DocumentSnapshot newDocument = await CarpService()
          .collection(collectionName)
          .document(userId)
          .collection('activities')
          .document('cooking')
          .setData({'what': 'breakfast', 'time': 'morning'});

      print(newDocument);
      expect(newDocument.id, greaterThan(0));
      expect(newDocument.path,
          equals('$collectionName/$userId/activities/cooking'));
    });

    test(' - get nested document', () async {
      assert(document != null);
      DocumentSnapshot? newDocument = await CarpService()
          .collection(collectionName)
          .document(userId)
          .collection('activities')
          .document('cooking')
          .get();

      expect(newDocument!.id, greaterThan(0));

      print(newDocument);
      print(newDocument.snapshot);
      print(newDocument.createdAt);
      print(newDocument.data);
      print(newDocument['what']);
    });

    test('- expire token and the upload document', () async {
      print('expiring token...');
      CarpService().currentUser!.token!.expire();

      print('trying to upload a document w/o a name...');
      DocumentSnapshot d = await CarpService()
          .collection(collectionName)
          .document()
          .setData({'email': username, 'name': 'Administrator'});

      expect(d.id, greaterThan(0));
      print(d);
    });

    test(" - get a collection from path name", () async {
      CollectionReference collection =
          await CarpService().collection(collectionName).get();
      print(collection);
    });

    test(" - list documents in a collection", () async {
      List<DocumentSnapshot> documents =
          await CarpService().collection(collectionName).documents;
      documents.forEach((doc) => print(doc));
      expect(documents.length, greaterThan(0));
    });

    test(" - list collections in a document", () async {
      DocumentSnapshot? newDocument =
          await CarpService().collection(collectionName).document(userId).get();
      newDocument?.collections.forEach((ref) => print(ref));
    });

    test(" - list all nested documents in a collection", () async {
      List<DocumentSnapshot> documents =
          await CarpService().collection(collectionName).documents;
      documents.forEach((doc) {
        print(doc);
        doc.collections.forEach((col) => print(col));
      });
    });

//    test(" - list all collections in the root", () async {
//      List<String> root = await CarpService().collection("").collections;
//      for (String ref in root) {
//        print(ref);
//        // List all documents in each collection
//        List<DocumentSnapshot> documents =
//            await CarpService().collection("/$ref").documents;
//        for (DocumentSnapshot doc in documents) {
//          print(doc);
//        }
//      }
//
//      documents = await CarpService().collection(collectionName).documents;
//      for (DocumentSnapshot doc in documents) {
//        print(doc);
//      }
//    });

    test(' - get collection from path', () async {
      CollectionReference collection =
          await CarpService().collection(collectionName).get();
      expect(collection.id!, greaterThan(0));
      print(collection);
    });

    test(' - delete document', () async {
      assert(document != null);
      await CarpService()
          .collection(collectionName)
          .document(document!.name)
          .delete();
    });

    test(' - rename collection', () async {
      CollectionReference collection =
          await CarpService().collection(collectionName).get();
      print('Collection before rename: $collection');
      await collection.rename(newCollectionName);
      expect(collection.name, newCollectionName);
      print('Collection after rename: $collection');
      collection = await CarpService().collection(newCollectionName).get();
      expect(collection.name, newCollectionName);
      print('Collection after get: $collection');
    });

    test(' - delete collection', () async {
      CollectionReference collection =
          await CarpService().collection(newCollectionName).get();
      await collection.delete();
      expect(collection.id, -1);
      print(collection);
      try {
        collection = await CarpService().collection(newCollectionName).get();
      } catch (error) {
        print(error);
        expect((error as CarpServiceException).httpStatus!.httpResponseCode,
            HttpStatus.notFound);
      }
    });
  }, skip: false);

  group("iPDM-GO", () {
    test(" - get 'patients' collection from path", () async {
      CollectionReference collection =
          await CarpService().collection('patients').get();
      expect(collection.id!, greaterThan(0));
      print(collection);
    });

    test(" - list all nested documents in 'patients' collection", () async {
      List<DocumentSnapshot> documents =
          await CarpService().collection('patients').documents;
      documents.forEach((doc) {
        print(doc);
        doc.collections.forEach((col) => print(col));
      });
    });
    test(
        " - list all nested documents in 'patients/s174238@student.dtu.dk/chapters' collection",
        () async {
      List<DocumentSnapshot> documents = await CarpService()
          .collection('patients/s174238@student.dtu.dk/chapters')
          .documents;
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

      final FileUploadTask uploadTask = CarpService()
          .getFileStorageReference()
          .upload(myFile, {
        'content-type': 'image/jpg',
        'content-language': 'en',
        'activity': 'test'
      });

      CarpFileResponse response = await uploadTask.onComplete;
      expect(response.id, greaterThan(0));
      id = response.id;

      print('response.storageName : ${response.storageName}');
      print('response.studyId : ${response.studyId}');
      print('response.createdAt : ${response.createdAt}');
    });

    test('- get', () async {
      final File myFile = File("test/img.jpg");

      final FileUploadTask uploadTask = CarpService()
          .getFileStorageReference()
          .upload(myFile, {
        'content-type': 'image/jpg',
        'content-language': 'en',
        'activity': 'test'
      });

      CarpFileResponse response = await uploadTask.onComplete;
      expect(response.id, greaterThan(0));
      id = response.id;

      final CarpFileResponse result =
          await CarpService().getFileStorageReference(id).get();
      print(result);
      expect(result.id, id);
      print('result : $result');
    });

    test('- get non-existing', () async {
      try {
        await CarpService().getFileStorageReference(876872).get();
      } catch (error) {
        print(error);
        expect(error, isA<CarpServiceException>());
        expect((error as CarpServiceException).httpStatus!.httpResponseCode,
            HttpStatus.notFound);
      }
    });

    test('- download', () async {
      final File myFile = File("test/img-$id.jpg");

      final FileDownloadTask downloadTask =
          CarpService().getFileStorageReference(id).download(myFile);

      int response = await downloadTask.onComplete;
      expect(response, 200);
      print('status code : $response');
    });

    test('- get all', () async {
      final List<CarpFileResponse> results = await CarpService().getAllFiles();
      print('result : $results');
    });

    test('- query', () async {
      final List<CarpFileResponse> results =
          await CarpService().queryFiles('original_name==img.jpg');

      expect(results[0].originalName, 'img.jpg');
      print('result : $results');
    });

    test('- get by name', () async {
      final FileStorageReference? reference =
          await CarpService().getFileStorageReferenceByName('img.jpg');

      assert(reference != null);
      final CarpFileResponse result = await reference!.get();

      expect(result.originalName, 'img.jpg');
      print('result : $result');
    });

    test('- delete', () async {
      final int result =
          await CarpService().getFileStorageReference(id).delete();

      expect(result, greaterThan(0));
      print('result : $result');
    });
  }, skip: false);
}
