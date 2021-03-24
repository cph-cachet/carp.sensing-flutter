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
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:carp_webservices/carp_auth/carp_auth.dart';
import 'package:carp_webservices/carp_services/carp_services.dart';
import 'package:carp_core/carp_core.dart';
```

### Configuration

The [`CarpService`](https://pub.dartlang.org/documentation/carp_webservices/latest/carp_services/CarpService-class.html)
is a singleton and needs to be configured once.
Note that a valid [`Study`](https://pub.dev/documentation/carp_mobile_sensing/latest/domain/Study-class.html) 
with a valid **Study ID** and **Deployment ID** is needed before any study-specifc resources in CARP can be accessed.

````dart
final String uri = "https://staging.carp.cachet.dk:8080";
final String testDeploymentId = "d246170c-515e";
final String testStudyId = "64c1784d-52d1-4c3d";

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
        clientID: 'the_client_id', clientSecret: 'the_client_secret'),
    study: study,
  );

  // Configure the CARP Service with this app.
  CarpService().configure(app);

```` 

The singleton can then be accessed via `CarpService()`.

### Authentication

Basic authentication is using username and password.

```dart
CarpUser user;
try {
   user = await CarpService().authenticate(
      username: "a_username", 
      password: "the_password",
   );
} catch (excp) {
   ...;
}
```

Since the [CarpUser](https://pub.dev/documentation/carp_webservices/latest/carp_auth/CarpUser-class.html)
can be serialized to JSON, the OAuth token can be stored on the phone. 
This can then later be used for authentication:

```dart
try {
   user = await CarpService().authenticateWithToken(
      username: user.username, 
      token: user.token,
   );
} catch (excp) {
   ...;
}
```

The user's password can be changed using the `changePassword()` method:

```dart
try {
   user = await CarpService().changePassword(
        currentPassword: 'the_password',
        newPassword: 'a_new_password',
      );
} catch (excp) {
   ...;
}
```

The plugin also comes with a user interface for authenticating at a CARP server using the `authenticateWithDialog()` method.
For example, the login can be implemeted as part of a TextButton like this:

```dart
    child: TextButton.icon(
      onPressed: () => CarpService().authenticateWithDialog(
        context,
        username: 'user@cachet.dk',
      ),
      icon: Icon(Icons.login),
      label: Text(
        'LOGIN',
        style: TextStyle(fontSize: 35),
      ),
   ),
```


### Informed Consent Document

A [ConsentDocument](https://pub.dev/documentation/carp_webservices/latest/carp_services/ConsentDocument-class.html)
can be uploaded and downloaded from CARP.

```dart
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

````


### Application-specific Collections and Documents

A [`CollectionReference`](https://pub.dartlang.org/documentation/carp_webservices/latest/carp_services/CollectionReference-class.html)
is used to manage [collections](https://cachet.postman.co/collections/7723888-f1dede9d-13db-4561-b0c3-b329c18c408a?version=latest&workspace=fea39375-3597-4b22-851d-6c4a670f7fc3#9e896f66-953b-4c11-93fd-4f5e2097a7f2)
and [documents](https://cachet.postman.co/collections/7723888-f1dede9d-13db-4561-b0c3-b329c18c408a?version=latest&workspace=fea39375-3597-4b22-851d-6c4a670f7fc3#aacfb3a6-55ea-454a-9d12-7886ee6c247b) 
on a CARP web service and have methods for:

* creating, updating, and deleting documents
* accessing documents in collections

`````dart
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
````

### Deployments

A core notion of CARP is the [Deployment subsystem](https://github.com/cph-cachet/carp.core-kotlin/blob/develop/docs/carp-deployment.md).
This subsystem is used for accessing `deployment` configurations, i.e. configurations that describe how 
data sampling in a study should take place. 
The CARP web service have methods for:

 * getting invitations for a specific `accountId`, i.e. a user - default is the user who is authenticated to the CARP Service.
 * getting a deployment reference, which then can be used to query status, register devices, and get the deployment specification.

````dart
  // get invitations for this account (user)
  List<ActiveParticipationInvitation> invitations =
      await CarpService().invitations();

  // get a deployment reference for this master device
  DeploymentReference deploymentReference = CarpService().deployment();

  // get the status of this deployment
  StudyDeploymentStatus status = await deploymentReference.getStatus();

  // register a device
  status = await deploymentReference.registerDevice(deviceRoleName: 'phone');

  // get the master device deployment
  MasterDeviceDeployment deployment = await deploymentReference.get();

  // mark the deployment as a success
  status = await deploymentReference.success();
````

There is also support for shwing a modal dialog for the user to select amongst several invitations. 
This is done using the `getStudyInvitation` method, like this:

```dart
    ActiveParticipationInvitation invitation = await CarpService().getStudyInvitation(context);
    print('CARP Study Invitation: $invitation');
```


## Features and bugs

Please file feature requests and bug reports at the [issue tracker][tracker].

[tracker]: https://github.com/cph-cachet/carp.sensing/issues

## License

This software is copyright (c) [Copenhagen Center for Health Technology (CACHET)](https://www.cachet.dk/) at the [Technical University of Denmark (DTU)](https://www.dtu.dk).
This software is made available 'as-is' in a MIT [license](/LICENSE).

