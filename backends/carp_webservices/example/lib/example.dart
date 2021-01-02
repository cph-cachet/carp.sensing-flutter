import 'dart:io';

import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:carp_webservices/carp_auth/carp_auth.dart';
import 'package:carp_webservices/carp_domain/carp_domain.dart';
import 'package:carp_webservices/carp_service/carp_service.dart';

void main() async {
  final String username = 'researcher';
  final String uri = 'http://staging.carp.cachet.dk:8080';
  final String testStudyId = '8';

  CarpApp app;
  Study study;

  study = Study(
    id: testStudyId,
    userId: 'user@dtu.dk',
    name: 'Test study #$testStudyId',
  );
  app = CarpApp(
    name: 'any_display_friendly_name_is_fine',
    uri: Uri.parse(uri),
    oauth: OAuthEndPoint(
      clientID: 'the_client_id',
      clientSecret: 'the_client_secret',
    ),
    study: study,
  );

  // Configure the CARP Service with this app.
  CarpService().configure(app);

  // ------------------- AUTHENTICATION --------------------------------

  // Try to authenticate
  CarpUser user;
  try {
    user = await CarpService().authenticate(
      username: 'a_username',
      password: 'the_password',
    );
  } catch (excp) {
    print(excp);
  }
  print('$user authenticated.');

// ------------------- INFORMED CONSENT -------------------------------

  try {
    ConsentDocument uploaded = await CarpService().createConsentDocument({
      'text': 'The original terms text.',
      'signature': 'Image Blob',
    });

    ConsentDocument downloaded =
        await CarpService().getConsentDocument(uploaded.id);
  } catch (excp) {
    print(excp);
  }

// ------------------- FILE MANAGEMENT --------------------------------

  // first upload a file
  final File uploadFile = File('test/img.jpg');
  final FileUploadTask uploadTask = CarpService()
      .getFileStorageReference()
      .upload(uploadFile, {
    'content-type': 'image/jpg',
    'content-language': 'en',
    'activity': 'test'
  });
  CarpFileResponse response = await uploadTask.onComplete;
  int id = response.id;

  // then get its description back from the server
  final CarpFileResponse result =
      await CarpService().getFileStorageReference(id).get();

  // then download the file again
  // note that a local file to download is needed
  final File downloadFile = File('test/img-$id.jpg');
  final FileDownloadTask downloadTask =
      CarpService().getFileStorageReference(id).download(downloadFile);
  int responseCode = await downloadTask.onComplete;

  // now get references to ALL files in this study
  final List<CarpFileResponse> results =
      await CarpService().getFileStorageReference(id).getAll();

  // finally, delete the file
  responseCode = await CarpService().getFileStorageReference(id).delete();

  // ------------------- DATA POINTS --------------------------------

  // Create a test datum
  LightDatum datum = LightDatum(
    maxLux: 12,
    meanLux: 23,
    minLux: 0.3,
    stdLux: 0.4,
  );

  // create a CARP data point
  final CARPDataPoint data =
      CARPDataPoint.fromDatum(study.id, study.userId, datum);

  // post it to the CARP server, which returns the ID of the data point
  int dataPointId =
      await CarpService().getDataPointReference().postDataPoint(data);

  // get the data point back from the server
  CARPDataPoint dataPoint =
      await CarpService().getDataPointReference().getDataPoint(dataPointId);

  // batch upload a list of raw json data points in a file
  final File file = File('test/batch.json');
  await CarpService().getDataPointReference().batchPostDataPoint(file);

  // delete the data point
  await CarpService().getDataPointReference().deleteDataPoint(dataPointId);

  // ------------------- COLLECTIONS AND DOCUMENTS --------------------------------

  // access a document
  //  - if the document id is not specified, a new document (with a new id) is created
  //  - if the collection (users) don't exist, it is created
  DocumentSnapshot document = await CarpService()
      .collection('users')
      .document()
      .setData({'email': username, 'name': 'Administrator'});

  // update the document
  DocumentSnapshot updatedDocument = await CarpService()
      .collection('/users')
      .document(document.name)
      .updateData({'email': username, 'name': 'Super User'});

  // get the document
  DocumentSnapshot newDocument =
      await CarpService().collection('users').document(document.name).get();

  // get the document by its unique ID
  newDocument = await CarpService().documentById(document.id).get();

  // delete the document
  await CarpService().collection('users').document(document.name).delete();

  // get all collections from a document
  List<String> collections = newDocument.collections;

  // get all documents in a collection.
  List<DocumentSnapshot> documents =
      await CarpService().collection('users').documents;

  // ------------------- DEPLOYMENTS --------------------------------

  // get invitations for this account (user)
  List<ActiveParticipationInvitation> invitations =
      await CarpService().invitations();

  // get a deployment reference for this master device
  DeploymentReference deploymentReference =
      CarpService().deployment('the_study_deployment_id');

  // get the status of this deployment
  StudyDeploymentStatus status = await deploymentReference.getStatus();

  // register a device
  status = await deploymentReference.registerDevice(deviceRoleName: 'phone');

  // get the master device deployment
  MasterDeviceDeployment deployment = await deploymentReference.get();

  // mark the deployment as a success
  status = await deploymentReference.success();
}
