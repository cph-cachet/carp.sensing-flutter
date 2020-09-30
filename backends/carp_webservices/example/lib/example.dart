import 'dart:io';

import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:carp_webservices/carp_auth/carp_auth.dart';
import 'package:carp_webservices/carp_domain/carp_domain.dart';
import 'package:carp_webservices/carp_service/carp_service.dart';

void main() async {
  final String username = "researcher";
  final String password = "password";
  final String uri = "http://staging.carp.cachet.dk:8080";
  final String clientID = "carp";
  final String clientSecret = "carp";
  final String testStudyId = "8";

  CarpApp app;
  Study study;

  study = new Study(testStudyId, "user@dtu.dk", name: "Test study #$testStudyId");
  app = new CarpApp(
      study: study,
      name: "any_display_friendly_name_is_fine",
      uri: Uri.parse(uri),
      oauth: OAuthEndPoint(clientID: "the_client_id", clientSecret: "the_client_secret"));

  // Configure the CARP Service with this app.
  CarpService.configure(app);

  // ------------------- AUTHENTICATION --------------------------------

  // Try to authenticate
  CarpUser user;
  try {
    user = await CarpService.instance.authenticate(username: "a_username", password: "the_password");
  } catch (excp) {
    print(excp);
  }

  // ------------------- FILE MANAGEMENT --------------------------------

  // first upload a file
  final File uploadFile = File("test/img.jpg");
  final FileUploadTask uploadTask =
      CarpService.instance.getFileStorageReference().upload(uploadFile, {'content-type': 'image/jpg', 'content-language': 'en', 'activity': 'test'});
  CarpFileResponse response = await uploadTask.onComplete;
  int id = response.id;

  // then get its description back from the server
  final CarpFileResponse result = await CarpService.instance.getFileStorageReference(id).get();

  // then download the file again
  // note that a local file to download is needed
  final File downloadFile = File("test/img-$id.jpg");
  final FileDownloadTask downloadTask = CarpService.instance.getFileStorageReference(id).download(downloadFile);
  int responseCode = await downloadTask.onComplete;

  // now get references to ALL files in this study
  final List<CarpFileResponse> results = await CarpService.instance.getFileStorageReference(id).getAll();

  // finally, delete the file
  responseCode = await CarpService.instance.getFileStorageReference(id).delete();

  // ------------------- DATA POINTS --------------------------------

  // Create a test datum
  LightDatum datum = LightDatum(
    maxLux: 12,
    meanLux: 23,
    minLux: 0.3,
    stdLux: 0.4,
  );

  // create a CARP data point
  final CARPDataPoint data = CARPDataPoint.fromDatum(study.id, study.userId, datum);
  // post it to the CARP server, which returns the ID of the data point
  int data_point_id = await CarpService.instance.getDataPointReference().postDataPoint(data);

  // get the data point back from the server
  CARPDataPoint data_point = await CarpService.instance.getDataPointReference().getDataPoint(data_point_id);

  // batch upload a list of raw json data points in a file
  final File file = File("test/batch.json");
  await CarpService.instance.getDataPointReference().batchPostDataPoint(file);

  // delete the data point
  await CarpService.instance.getDataPointReference().deleteDataPoint(data_point_id);

  // ------------------- COLLECTIONS AND DOCUMENTS --------------------------------

  // access an document
  //  - if the document id is not specified, a new document (with a new id) is created
  //  - if the collection (users) don't exist, it is created
  DocumentSnapshot document = await CarpService.instance.collection('users').document().setData({'email': username, 'name': 'Administrator'});

  // update the document
  DocumentSnapshot updated_document =
      await CarpService.instance.collection('/users').document(document.name).updateData({'email': username, 'name': 'Super User'});

  // get the document
  DocumentSnapshot new_document = await CarpService.instance.collection('users').document(document.name).get();

  // get the document by its unique ID
  new_document = await CarpService.instance.documentById(document.id).get();

  // delete the document
  await CarpService.instance.collection('users').document(document.name).delete();

  // get all collections from a document
  List<String> collections = new_document.collections;

  // get all documents in a collection.
  List<DocumentSnapshot> documents = await CarpService.instance.collection("users").documents;

  // ------------------- DEPLOYMENTS --------------------------------

  // get invitations for this account (user)
  List<ActiveParticipationInvitation> invitations = await CarpService.instance.invitations();

  // get a deployment reference for this master device
  DeploymentReference deploymentReference = CarpService.instance.deployment(masterDeviceRoleName: 'Master');

  // get the status of this deployment
  StudyDeploymentStatus status = await deploymentReference.status();

  // register a device
  status = await deploymentReference.registerDevice(deviceRoleName: 'phone');

  // get the master device deployment
  MasterDeviceDeployment deployment = await deploymentReference.get();

  // mark the deployment as a success
  status = await deploymentReference.success();
}
