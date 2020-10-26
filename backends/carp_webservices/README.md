# CARP Web Service Plugin for Flutter

A Flutter plugin to access the [CARP Web Service API](https://cachet.postman.co/collections/7723888-f1dede9d-13db-4561-b0c3-b329c18c408a?version=latest&workspace=fea39375-3597-4b22-851d-6c4a670f7fc3).

[![pub package](https://img.shields.io/pub/v/carp_webservices.svg)](https://pub.dartlang.org/packages/carp_webservices)

For Flutter plugins for other CARP products, see [CARP Mobile Sensing in Flutter](https://github.com/cph-cachet/carp.sensing-flutter/blob/master/README.md).

*Note*: This plugin is still under development, and some APIs might not be available yet. 
[Feedback](https://github.com/cph-cachet/carp.sensing-flutter/issues) and 
[Pull Requests](https://github.com/cph-cachet/carp.sensing-flutter/pulls) are most welcome!

## Setup

1. You need a CARP Web Service host running. See the [CARP Web Service API](https://github.com/cph-cachet/carp.webservices-docker) 
documentation for how to do this. If you're part of the [CACHET](https://www.cachet.dk/) team, you can use the specified 
test, staging, and production servers.

1. Add `carp_services` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

## Usage

```dart
import 'package:carp_webservices/carp_service/carp_service.dart';
```

### Configuration

The [`CarpService`](https://pub.dartlang.org/documentation/carp_webservices/latest/carp_services/CarpService-class.html)
is a singleton and needs to be configured once.
Note that a valid [`Study`](https://pub.dev/documentation/carp_mobile_sensing/latest/domain/Study-class.html) 
with a valid **Study ID** and **Deployment ID** is needed.

````dart
final String uri = "https://staging.carp.cachet.dk:8080";
final String testDeploymentId = "d246170c-515e";
final String testStudyId = "64c1784d-52d1-4c3d";

CarpApp app;
Study study;

study = new Study(testStudyId, "user@dtu.dk", deploymentId: testDeploymentId, name: "Test study");
app = new CarpApp(
      study: study,
      name: "any_display_friendly_name_is_fine",
      uri: Uri.parse(uri),
      oauth: OAuthEndPoint(clientID: "the_client_id", clientSecret: "the_client_secret"));

CarpService.configure(app);

```` 

The singleton can then be accessed via `CarpService.instance`.

### Authentication

Basic authentication is using username and password.

```dart
CarpUser user;
try {
   user = await CarpService.instance.authenticate(username: "a_username", password: "the_password");
} catch (excp) {
   ...;
}
```

Since the [CarpUser](https://pub.dev/documentation/carp_webservices/latest/carp_auth/CarpUser-class.html)
can be serialized to JSON, the OAuth token can be stored on the phone. 
This can then later be used for authentication:

```dart
try {
   user = await CarpService.instance.authenticateWithToken(username: user.username, token: user.token);
} catch (excp) {
   ...;
}
```



### Informed Consent Document

A [ConsentDocument](https://pub.dev/documentation/carp_webservices/latest/carp_services/ConsentDocument-class.html)
can be uploaded and downloaded from CARP.

```dart
try {
  ConsentDocument uploaded = await CarpService.instance.createConsentDocument({"text": "The original terms text.", "signature": "Image Blob"});
  ...
  ConsentDocument downloaded = await CarpService.instance.getConsentDocument(uploaded.id);
} catch (excp) {
   ...;
}
```

### Data Points

A [`DataPointReference`](https://pub.dartlang.org/documentation/carp_webservices/latest/carp_services/DataPointReference-class.html)
is used to manage [data points](https://cachet.postman.co/collections/7723888-f1dede9d-13db-4561-b0c3-b329c18c408a?version=latest&workspace=fea39375-3597-4b22-851d-6c4a670f7fc3#d1e199eb-1e17-43a4-9d5e-6f1f465464b4) 
on a CARP web service and have CRUD methods for:

* post a data point
* batch upload multiple data points
* get a data point
* delete data points

````dart
// Create a test location datum
LocationDatum datum = LocationDatum.fromMap(<String, dynamic>{
  "latitude": 23454.345,
  "longitude": 23.4,
  "altitude": 43.3,
  "accuracy": 12.4,
  "speed": 2.3,
  "speedAccuracy": 12.3
});

// create a CARP data point
final CARPDataPoint data = CARPDataPoint.fromDatum(study.id, study.userId, datum);
// post it to the CARP server, which returns the ID of the data point
data_point_id = await CarpService.instance.getDataPointReference().postDataPoint(data);

// get the data point back from the server
CARPDataPoint data = await CarpService.instance.getDataPointReference().getDataPoint(data_point_id);

// batch upload a list of raw json data points in a file
final File file = File("test/batch.json");
await CarpService.instance.getDataPointReference().batchPostDataPoint(file);

// delete the data point
await CarpService.instance.getDataPointReference().deleteDataPoint(data_point_id);
````


### Application-specific Collections and Documents

A [`CollectionReference`](https://pub.dartlang.org/documentation/carp_webservices/latest/carp_services/CollectionReference-class.html)
is used to manage [collections](https://cachet.postman.co/collections/7723888-f1dede9d-13db-4561-b0c3-b329c18c408a?version=latest&workspace=fea39375-3597-4b22-851d-6c4a670f7fc3#9e896f66-953b-4c11-93fd-4f5e2097a7f2)
and [documents](https://cachet.postman.co/collections/7723888-f1dede9d-13db-4561-b0c3-b329c18c408a?version=latest&workspace=fea39375-3597-4b22-851d-6c4a670f7fc3#aacfb3a6-55ea-454a-9d12-7886ee6c247b) 
on a CARP web service and have methods for:

* creating, updating, and deleting documents
* accessing documents in collections

`````dart
  // access an document
  //  - if the document id is not specified, a new document (with a new id) is created
  //  - if the collection (users) don't exist, it is created
  DocumentSnapshot document =
      await CarpService.instance.collection('users').document().setData({'email': username, 'name': 'Administrator'});

  // update the document
  DocumentSnapshot updated_document = await CarpService.instance
      .collection('/users')
      .document(document.name)
      .updateData({'email': username, 'name': 'Super User'});

  // get the document by its path in collection(s).
  DocumentSnapshot new_document = await CarpService.instance.collection('users').document(document.name).get();

  // get the document by its unique ID
  new_document = await CarpService.instance.documentById(document.id).get();

  // delete the document
  await CarpService.instance.collection('users').document(document.name).delete();

  // get all collections from a document
  List<String> collections = new_document.collections;

  // get all documents in a collection.
  List<DocumentSnapshot> documents = await CarpService.instance.collection("users").documents;
`````


### File Management

A [`FileStorageReference`](https://pub.dartlang.org/documentation/carp_webservices/latest/carp_services/FileStorageReference-class.html)
 is used to manage files on a CARP web service and have methods for:

* uploading a file
* downloading a file
* getting a file object
* getting all file objects
* deleting a file

When uploading a file, you can add metadata as a `Map<String, String>`.

````dart
// first upload a file
final File myFile = File("test/img.jpg");
final FileUploadTask uploadTask = CarpService.instance
   .getFileStorageReference()
   .upload(myFile, {'content-type': 'image/jpg', 'content-language': 'en', 'activity': 'test'});
CarpFileResponse response = await uploadTask.onComplete;
int id = response.id;

// then get its description back from the server
final CarpFileResponse result = await CarpService.instance.getFileStorageReference(id).get();

// then download the file again
// note that a local file to download is needed
final File myFile = File("test/img-$id.jpg");
final FileDownloadTask downloadTask = CarpService.instance.getFileStorageReference(id).download(myFile);
int response = await downloadTask.onComplete;

// now get references to ALL files in this study
final List<CarpFileResponse> results = await CarpService.instance.getFileStorageReference(id).getAll();

// finally, delete the file
final int result = await CarpService.instance.getFileStorageReference(id).delete();

````

### Deployments

A core notion of CARP is the [Deployment subsystem](https://github.com/cph-cachet/carp.core-kotlin/blob/develop/docs/carp-deployment.md).
This subsystem is used for accessing `deployment` configurations, i.e. configurations that describe how 
data sampling in a study should take place. 
The CARP web service have methods for:

 * getting a list of invitation for a specific `accountId`, i.e. a user - default is the user who is authenticated to the CARP Service.
 * getting a deployment reference, which then can be used to query status, register devices, and get the deployment specification.

````dart
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
````

## Features and bugs

Please file feature requests and bug reports at the [issue tracker][tracker].

[tracker]: https://github.com/cph-cachet/carp.sensing/issues

## License

This software is copyright (c) [Copenhagen Center for Health Technology (CACHET)](https://www.cachet.dk/) at the [Technical University of Denmark (DTU)](https://www.dtu.dk).
This software is made available 'as-is' in a MIT [license](/LICENSE).

