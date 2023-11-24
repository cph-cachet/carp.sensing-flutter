import 'dart:convert';
import 'dart:io';

import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:carp_webservices/carp_auth/carp_auth.dart';
import 'package:carp_webservices/carp_services/carp_services.dart';
import 'package:test/test.dart';

import 'mock_authentication_service.dart';
import 'credentials.dart';

String _encode(Object? object) =>
    const JsonEncoder.withIndent(' ').convert(object);

void main() {
  const String userId = "jakob@bardram.net";
  const String studyId = "test_1234";
  const String collectionName = 'test_patients';
  const String newCollectionName = 'new_patients';

  StudyProtocol protocol;
  Smartphone phone;
  CarpApp app;

  final lightData = AmbientLight(12, 23, 0.3, 0.4);

  final deviceData = DeviceInformation(
    platform: 'Android',
    deviceId: '12345jE',
  );

  /// Setup CARP and authenticate.
  /// Runs once before all tests.
  setUpAll(() async {
    Settings().debugLevel = DebugLevel.debug;

    // Create a new study protocol.
    protocol = StudyProtocol(
      ownerId: 'owner@dtu.dk',
      name: 'CARP Web Services Test',
    );

    // Define which devices are used for data collection.
    phone = Smartphone();

    protocol.addPrimaryDevice(phone);
    app = MockAuthenticationService().app;

    CarpService().configure(app);

    CarpUser mockUser = await MockAuthenticationService().authenticate(
      username: username,
      password: password,
    );

    CarpService().currentUser = mockUser;
  });

  /// Close connection to CARP.
  /// Runs once after all tests.
  tearDownAll(() {});

  group(
    "CARP Base Services",
    () {
      // test('- service', () async {
      //   print('CarpService : ${MockAuthenticationService().app}');
      // });
      group('authentication', () {
        test('- authentication w. username and password', () async {
          CarpUser user = await MockAuthenticationService().authenticate(
            username: username,
            password: password,
          );

          expect(user.token, isNotNull);
          expect(user.isAuthenticated, true);

          print("signed in : $user");
          print("token  : ${user.token}");
        });

        setUp(() async {
          await MockAuthenticationService().authenticate(
            username: username,
            password: password,
          );

          expect(MockAuthenticationService().authenticated, true);
        });

        test('- get user profile', () async {
          assert(MockAuthenticationService().authenticated);

          CarpUser newUser = MockAuthenticationService().currentUser;

          print("signed in : $newUser");
          print("   name   : ${newUser.firstName} ${newUser.lastName}");

          expect(newUser.firstName, isNotEmpty);
          expect(newUser.lastName, isNotEmpty);
          expect(newUser.isAuthenticated, true);
        });

        test('- oauth token refreshes', () async {
          print('expiring token...');
          MockAuthenticationService().currentUser.token!.expire();

          MockAuthenticationService().currentUser;
        });

        test('- refreshing token', () async {
          CarpUser user = await MockAuthenticationService().authenticate(
            username: username,
            password: password,
          );

          CarpUser newUser = await MockAuthenticationService().refresh();

          assert(newUser.isAuthenticated);
          assert(newUser.username == user.username);

          print("signed in : $newUser");
          print("   token  : ${newUser.token}");
        });
      });

      group('Informed Consent', () {
        test('- create', () async {
          ConsentDocument uploaded = await CarpService().createConsentDocument(
              {"text": "The original terms text.", "signature": "Image Blob"});

          print(uploaded);
          print('id        : ${uploaded.id}');
          print('createdAt : ${uploaded.createdAt}');
          print('createdBy : ${uploaded.createdBy}');
          print('document  : ${uploaded.document}');
        });

        test('- get', () async {
          ConsentDocument uploaded = await CarpService().createConsentDocument(
              {"text": "The original terms text.", "signature": "Image Blob"});

          expect(uploaded.id, isNotNull);

          ConsentDocument downloaded =
              await CarpService().getConsentDocument(uploaded.id);

          print(downloaded);
          print('id        : ${downloaded.id}');
          print('createdAt : ${downloaded.createdAt}');
          print('createdBy : ${downloaded.createdBy}');
          print('document  : ${downloaded.document}');
        });
      });

      group(
        "Data points",
        () {
          test('- post', () async {
            final DataPoint data = DataPoint.fromData(lightData);
            // studyId & userId is required for upload
            data.carpHeader.studyId = testStudyId;
            data.carpHeader.userId = userId;

            print(_encode(data.toJson()));

            int dataPointId =
                await CarpService().getDataPointReference().post(data);

            assert(dataPointId > 0);
            print("data_point_id : $dataPointId");
          });

          test('- post w/o trigger id & device role name', () async {
            final DataPoint data = DataPoint.fromData(lightData);
            // studyId & userId is required for upload
            data.carpHeader.studyId = testStudyId;
            data.carpHeader.userId = userId;

            // triggerId, deviceRoleName, startTime & endTime are not required
            data.carpHeader.triggerId = null;
            data.carpHeader.deviceRoleName = null;
            data.carpHeader.startTime = null;
            data.carpHeader.endTime = null;

            print(_encode(data.toJson()));

            int dataPointId =
                await CarpService().getDataPointReference().post(data);

            assert(dataPointId > 0);
            print("data_point_id : $dataPointId");
          });

          test('- batch', () async {
            List<DataPoint> batch = [];
            batch.addAll([
              DataPoint.fromData(lightData),
              DataPoint.fromData(lightData),
              DataPoint.fromData(deviceData),
              DataPoint.fromData(deviceData),
              DataPoint.fromData(deviceData),
            ]);

            var reference = CarpService().getDataPointReference();

            // test two consecutive batch uploads
            await reference.batch(batch);
            await reference.batch(batch);

            // wait for the batch requests to finish
            await Future.delayed(const Duration(seconds: 2), () {});

            List<DataPoint> data =
                await CarpService().getDataPointReference().getAll();
            print('N=${data.length}');
            // data.forEach((datapoint) => print(_encode((datapoint.toJson()))));

            assert(data.length >= 5);
          });

          test('- upload', () async {
            final File file = File("test/json/batch-correct-test.json");
            await CarpService().getDataPointReference().upload(file);

            // wait for the batch requests to finish
            await Future.delayed(const Duration(seconds: 2), () {});

            String query = 'carp_header.data_format.namespace==test';
            print("query : $query");

            List<DataPoint> data =
                await CarpService().getDataPointReference().query(query);

            print('N=${data.length}');
            // data.forEach((datapoint) => print(_encode((datapoint.toJson()))));

            assert(data.length >= 140);
          });

          test('- query for test data points', () async {
            String query = 'carp_header.data_format.namespace==test';
            print("query : $query");
            List<DataPoint> data =
                await CarpService().getDataPointReference().query(query);

            print('N=${data.length}');
            // data.forEach((datapoint) => print(_encode((datapoint.toJson()))));

            expect(data, isNotNull);
          });

          test('- count data points based on query', () async {
            String query = 'carp_header.data_format.namespace==test';
            print("query : $query");
            int count =
                await CarpService().getDataPointReference().count(query);

            print('N=$count');
            expect(count, greaterThanOrEqualTo(0));
          });

          test('- delete test data points', () async {
            String query = 'carp_header.data_format.namespace==test';
            print("query : $query");
            List<DataPoint> data =
                await CarpService().getDataPointReference().query(query);

            print('N=${data.length}');
            print('deleting...');
            for (var datapoint in data) {
              print(' ${datapoint.id}');
              await CarpService().getDataPointReference().delete(datapoint.id!);
            }
          });

          test('- get by id', () async {
            final DataPoint dataPost = DataPoint.fromData(lightData);
            // studyId & userId is required for upload
            dataPost.carpHeader.studyId = studyId;
            dataPost.carpHeader.userId = userId;

            print(_encode(dataPost.toJson()));

            int dataPointId =
                await CarpService().getDataPointReference().post(dataPost);

            assert(dataPointId > 0);

            DataPoint dataGet =
                await CarpService().getDataPointReference().get(dataPointId);

            print(_encode(dataGet.toJson()));
            assert(dataGet.id == dataPointId);
          });

          test(
            '- get all',
            () async {
              List<DataPoint> data =
                  await CarpService().getDataPointReference().getAll();

              //data.forEach((datapoint) => print(_encode((datapoint.toJson()))));
              expect(data, isNotNull);
              print('N=${data.length}');
            },
            skip: false,
          );

          test('- query', () async {
            await CarpService()
                .getDataPointReference()
                .post(DataPoint.fromData(lightData)
                  ..carpHeader.studyId = studyId
                  ..carpHeader.userId = userId);
            await CarpService()
                .getDataPointReference()
                .post(DataPoint.fromData(deviceData)
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
                await CarpService().getDataPointReference().query(query);

            expect(data, isNotNull);
            print('N=${data.length}');
            String str = '[';
            for (var datapoint in data) {
              str += '${datapoint.id},';
            }
            // data.forEach((datapoint) => print(_encode((datapoint.toJson()))));
            str += ']';
            print(str);
          });

          test('- delete', () async {
            int dataPointId = await CarpService()
                .getDataPointReference()
                .post(DataPoint.fromData(lightData)
                  ..carpHeader.studyId = studyId
                  ..carpHeader.userId = userId);
            print("DELETE data_point_id : $dataPointId");
            await CarpService().getDataPointReference().delete(dataPointId);
          });

          test(
            '- delete all',
            () async {
              List<DataPoint> data =
                  await CarpService().getDataPointReference().getAll();

              print('N=${data.length}');
              print('deleting...');
              for (var datapoint in data) {
                print(' ${datapoint.id}');
                await CarpService()
                    .getDataPointReference()
                    .delete(datapoint.id!);
              }

              // wait for the delete requests to finish
              await Future.delayed(const Duration(seconds: 2), () {});

              List<DataPoint> empty =
                  await CarpService().getDataPointReference().getAll();

              print('N=${empty.length}');
              assert(empty.isEmpty);
            },
            skip: true,
          );
        },
        skip: false,
      );

      group("Documents & Collections", () {
        test(' - delete document by path', () async {
          await CarpService()
              .collection(collectionName)
              .document(userId)
              .delete();
        });

        test(' - CRUD document', () async {
          // first create a document
          var document = await CarpService()
              .collection(collectionName)
              .document(userId)
              .setData({'email': userId, 'role': 'Administrator'});

          expect(document, isNotNull);

          // create a document reference
          final reference =
              CarpService().collection(collectionName).document(userId);

          // get it back from the server
          final original = await reference.get();
          print(_encode(original?.data));

          // updating the role to super user
          final updated = await reference
              .updateData({'email': userId, 'role': 'Super User'});

          print('----------- updated -------------');
          print(updated);
          print(_encode(updated.data));
          print(updated.data["role"]);
          expect(updated.id, greaterThan(0));
          expect(updated.data["role"], 'Super User');

          // delete document again
          await CarpService()
              .collection(collectionName)
              .document(userId)
              .delete();
        });

        test(' - get document by id', () async {
          // first create a document
          var document = await CarpService()
              .collection(collectionName)
              .document(userId)
              .setData({'email': userId, 'role': 'Administrator'});

          print(document);
          expect(document, isNotNull);

          // then get it back by the id
          var newDocument = await CarpService().documentById(document.id).get();

          print((newDocument));
          expect(newDocument, isNotNull);
          expect(newDocument?.id, document.id);

          // delete document again
          await CarpService()
              .collection(collectionName)
              .document(userId)
              .delete();
        });

        test(' - get document by path', () async {
          var document = await CarpService()
              .collection(collectionName)
              .document(userId)
              .setData({'email': userId, 'role': 'Administrator'});

          expect(document, isNotNull);

          DocumentSnapshot? newDocument = await CarpService()
              .collection(collectionName)
              .document(document.name)
              .get();

          print((newDocument));
          expect(newDocument?.id, document.id);

          // delete document again
          await CarpService()
              .collection(collectionName)
              .document(userId)
              .delete();
        });

        test(' - get non-existing document', () async {
          DocumentSnapshot? newDocument = await CarpService()
              .collection(collectionName)
              .document('not_available')
              .get();

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

        // NOTE :: In order to run the following two tests (query) you need to be
        // authenticated as a researcher (and not as a participant).
        test(' - get documents by query', () async {
          var document = await CarpService()
              .collection(collectionName)
              .document(userId)
              .setData({'email': userId, 'role': 'Administrator'});

          expect(document, isNotNull);

          String query = 'name==$userId';
          List<DocumentSnapshot> documents =
              await CarpService().documentsByQuery(query);

          print("Found ${documents.length} document(s) for user '$userId'");
          for (var document in documents) {
            print(' - $document');
          }

          expect(documents.length, greaterThan(0));
        });

        test(' - get all documents', () async {
          List<DocumentSnapshot> documents = await CarpService().documents();

          print('Found ${documents.length} document(s)');
          for (var document in documents) {
            print(' - $document');
          }
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

          // delete document again
          await CarpService()
              .collection(collectionName)
              .document(userId)
              .delete();
        });

        test(' - get nested document', () async {
          var document = await CarpService()
              .collection(collectionName)
              .document(userId)
              .setData({'email': userId, 'role': 'Administrator'});

          expect(document, isNotNull);

          DocumentSnapshot? newDocument = await CarpService()
              .collection(collectionName)
              .document(userId)
              .collection('activities')
              .document('cooking')
              .get();

          // expect(newDocument?.id, greaterThan(0));

          print(newDocument);
          print(newDocument?.snapshot);
          print(newDocument?.createdAt);
          print(newDocument?.data);
          // print(newDocument['what']);

          // delete document again
          await CarpService()
              .collection(collectionName)
              .document(userId)
              .delete();
        });

        test('- expire token and the upload document', () async {
          print('expiring token...');
          CarpService().currentUser.token!.expire();

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
          for (var doc in documents) {
            print(doc);
          }
          expect(documents.length, greaterThan(0));
        });

        test(" - list collections in a document", () async {
          DocumentSnapshot? newDocument = await CarpService()
              .collection(collectionName)
              .document(userId)
              .get();
          newDocument?.collections.forEach((element) => print(element));
        });

        test(" - list all nested documents in a collection", () async {
          List<DocumentSnapshot> documents =
              await CarpService().collection(collectionName).documents;
          for (var doc in documents) {
            print(doc);
            for (var col in doc.collections) {
              print(col);
            }
          }
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
          var document = await CarpService()
              .collection(collectionName)
              .document(userId)
              .setData({'email': userId, 'role': 'Administrator'});

          expect(document, isNotNull);

          await CarpService()
              .collection(collectionName)
              .document(document.name)
              .delete();
        });

        // NOTE :: In order to run the following two tests (rename & delete)
        // you need to be authenticated as a researcher.
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
            collection =
                await CarpService().collection(newCollectionName).get();
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
          for (var doc in documents) {
            print(doc);
            for (var col in doc.collections) {
              print(col);
            }
          }
        });
        test(
            " - list all nested documents in 'patients/s174238@student.dtu.dk/chapters' collection",
            () async {
          List<DocumentSnapshot> documents = await CarpService()
              .collection('patients/s174238@student.dtu.dk/chapters')
              .documents;
          for (var doc in documents) {
            print(doc);
            for (var col in doc.collections) {
              print(col);
            }
          }
        });
      }, skip: true);

      group("Files", () {
        // int id = -1;

        test('- upload', () async {
          final File myFile = File("test/img.jpg");

          final uploadTask = CarpService().getFileStorageReference().upload(
            myFile,
            {
              'content-type': 'image/jpg',
              'content-language': 'en',
              'activity': 'test'
            },
          );

          final response = await uploadTask.onComplete;
          expect(response.id, greaterThan(0));

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
          var id = response.id;

          final CarpFileResponse result =
              await CarpService().getFileStorageReference(id).get();
          print(result);
          expect(result.id, id);
          print('result : $result');
        });

        test('- download', () async {
          final File upFile = File("test/img.jpg");

          final FileUploadTask uploadTask = CarpService()
              .getFileStorageReference()
              .upload(upFile, {
            'content-type': 'image/jpg',
            'content-language': 'en',
            'activity': 'test'
          });

          CarpFileResponse upResponse = await uploadTask.onComplete;
          expect(upResponse.id, greaterThan(0));
          var id = upResponse.id;

          File downFile = File("test/img-$id.jpg");

          final FileDownloadTask downloadTask =
              CarpService().getFileStorageReference(id).download(downFile);

          int downResponse = await downloadTask.onComplete;
          expect(downResponse, 200);
          print('status code : $downResponse');
        });

        // NOTE that the following "get non-existing, "get all", "query",
        // "get by name", and "delete" unit tests ONLY works if you're
        // authenticated as a RESEARCHER.
        // See https://github.com/cph-cachet/carp.webservices-docker/issues/56

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
        test('- get all', () async {
          final List<CarpFileResponse> results =
              await CarpService().getAllFiles();
          print('result : $results');
        });

        test('- query', () async {
          final List<CarpFileResponse> results =
              await CarpService().queryFiles('original_name==img.jpg');

          if (results.isNotEmpty) {
            expect(results[0].originalName, 'img.jpg');
          }
          print('result : $results');
        });

        test('- get by name', () async {
          final FileStorageReference? reference =
              await CarpService().getFileStorageReferenceByName('img.jpg');

          if (reference != null) {
            final CarpFileResponse result = await reference.get();
            expect(result.originalName, 'img.jpg');
            print('result : $result');
          } else {
            print('File not found.');
          }
        });

        test('- delete', () async {
          final FileStorageReference? reference =
              await CarpService().getFileStorageReferenceByName('img.jpg');

          if (reference != null) {
            expect(reference.id, isNotNull);

            final int result = await CarpService()
                .getFileStorageReference(reference.id)
                .delete();
            expect(result, greaterThan(0));
            print('result : $result');
          } else {
            print('File not found.');
          }
        });
      }, skip: false);
    },
  );
}
