import 'dart:io';

import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:carp_webservices/carp_auth/carp_auth.dart';
import 'package:carp_webservices/carp_services/carp_services.dart';

void main() async {
  final String username = 'researcher';
  final String uri = "https://cans.cachet.dk";

  CarpApp app;
  StudyProtocol protocol;
  Smartphone phone;

  // Create a study protocol
  protocol = StudyProtocol(
    ownerId: 'owner@dtu.dk',
    name: 'Context Sensing Example',
  );

  // Define which devices are used for data collection.
  phone = Smartphone();

  protocol..addPrimaryDevice(phone);

  app = CarpApp(
    name: 'any_display_friendly_name_is_fine',
    studyId: 'the_study_id',
    studyDeploymentId: 'the_study_deployment_id',
    uri: Uri.parse(uri),
    oauth: OAuthEndPoint(
      clientID: 'the_client_id',
      clientSecret: 'the_client_secret',
    ),
  );

  // Configure the CARP Service with this app.
  CarpService().configure(app);

  // ------------------- AUTHENTICATION --------------------------------

  // Try to authenticate
  CarpUser? user;
  try {
    user = await CarpService().authenticate(
      username: 'a_username',
      password: 'the_password',
    );
  } catch (error) {
    print(error);
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
    print(downloaded);
  } catch (error) {
    print(error);
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
  print(result);

  // then download the file again
  // note that a local file to download is needed
  final File downloadFile = File('test/img-$id.jpg');
  final FileDownloadTask downloadTask =
      CarpService().getFileStorageReference(id).download(downloadFile);
  await downloadTask.onComplete;

  // now get references to ALL files
  final List<CarpFileResponse> results = await CarpService().getAllFiles();
  print(results);

  // finally, delete the file
  await CarpService().getFileStorageReference(id).delete();

  // ------------------- DATA POINTS --------------------------------

  // Create a piece of data
  final lightData = AmbientLight(
    maxLux: 12,
    meanLux: 23,
    minLux: 0.3,
    stdLux: 0.4,
  );

  // create a CARP data point
  final data = DataPoint.fromData(lightData);

  // post it to the CARP server, which returns the ID of the data point
  int dataPointId = await CarpService().getDataPointReference().post(data);

  // get the data point back from the server
  DataPoint dataPoint =
      await CarpService().getDataPointReference().get(dataPointId);
  print(dataPoint);

  // batch upload a list of raw json data points in a file
  final file = File('test/batch.json');
  await CarpService().getDataPointReference().upload(file);

  // delete the data point
  await CarpService().getDataPointReference().delete(dataPointId);

  // ------------------- COLLECTIONS AND DOCUMENTS --------------------------------

  // access a document
  //  - if the document id is not specified, a new document (with a new id)
  //    is created
  //  - if the collection ('users') don't exist, it is created
  DocumentSnapshot document = await CarpService()
      .collection('users')
      .document()
      .setData({'email': username, 'name': 'Administrator'});

  // update the document
  DocumentSnapshot updatedDocument = await CarpService()
      .collection('/users')
      .document(document.name)
      .updateData({'email': username, 'name': 'Super User'});

  print(updatedDocument);

  // get the document
  DocumentSnapshot? newDocument =
      await CarpService().collection('users').document(document.name).get();

  // get the document by its unique ID
  newDocument = await CarpService().documentById(document.id).get();

  // delete the document
  await CarpService().collection('users').document(document.name).delete();

  // get all collections from a document
  List<String?>? collections = newDocument?.collections;
  collections?.forEach(print);

  // get all documents in a collection.
  List<DocumentSnapshot> documents =
      await CarpService().collection('users').documents;
  documents.forEach(print);

  // ------------------- DEPLOYMENTS --------------------------------

  // This example uses the
  //  * [CarpDeploymentService]
  //  * [CarpParticipationService]
  //
  // To use these, we first must configure them and authenticate.
  // However, the [configureFrom] method is a convenient way to do this based
  // on an existing service, which has been configured.

  CarpParticipationService().configureFrom(CarpService());
  CarpDeploymentService().configureFrom(CarpService());

  // get invitations for this account (user)
  List<ActiveParticipationInvitation> invitations =
      await CarpParticipationService().getActiveParticipationInvitations();
  invitations.forEach(print);

  // get a deployment reference for this master device
  DeploymentReference deploymentReference =
      CarpDeploymentService().deployment('the_study_deployment_id');

  // get the status of this deployment
  StudyDeploymentStatus status = await deploymentReference.getStatus();
  print(status);

  // register this primary device
  status = await deploymentReference.registerPrimaryDevice();

  // get the master device deployment
  PrimaryDeviceDeployment deployment = await deploymentReference.get();
  print(deployment);

  // mark the deployment as a success
  status = await deploymentReference.deployed();

// ------------------- DATA STREAMING --------------------------------

  // Configure a [CarpDataStreamService] from an existing CAWS service.
  CarpDataStreamService().configureFrom(CarpService());

  // Create a (very simple) data batch to upload
  var measurement = Measurement(
      sensorStartTime: 1642505144000000,
      data: Geolocation(
          latitude: 55.680802203873114, longitude: 12.581802212861367));
  var batch = [
    DataStreamBatch(
        dataStream: DataStreamId(
            studyDeploymentId:
                CarpDataStreamService().app?.studyDeploymentId ?? '',
            deviceRoleName: 'smartphone',
            dataType: Geolocation.dataType),
        firstSequenceId: 0,
        measurements: [measurement],
        triggerIds: {0}),
  ];

  // Get a data stream and append the batch
  CarpDataStreamService().stream().append(batch);
}
