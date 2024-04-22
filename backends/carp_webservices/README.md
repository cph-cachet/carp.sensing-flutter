# CARP Web Service Plugin for Flutter

[![pub package](https://img.shields.io/pub/v/carp_webservices.svg)](https://pub.dartlang.org/packages/carp_webservices)
[![pub points](https://img.shields.io/pub/points/carp_webservices?color=2E8B57&label=pub%20points)](https://pub.dev/packages/carp_webservices/score)
[![github stars](https://img.shields.io/github/stars/cph-cachet/carp.sensing-flutter.svg?style=flat&logo=github&colorB=deeppink&label=stars)](https://github.com/cph-cachet/carp.sensing-flutter)
[![MIT License](https://img.shields.io/badge/license-MIT-purple.svg)](https://opensource.org/licenses/MIT)
[![arXiv](https://img.shields.io/badge/arXiv-2006.11904-green.svg)](https://arxiv.org/abs/2006.11904)

A Flutter library to access the [CARP Web Service (CAWS)](https://carp.cachet.dk/caws/) web API.
This library is intended to be used with the [`carp_mobile_sensing`](https://pub.dartlang.org/packages/carp_mobile_sensing) framework, but also works on its own, if a app is to connect directly to CAWS.

For an overview of CARP and other Flutter CARP libraries, see [CARP Mobile Sensing in Flutter](https://github.com/cph-cachet/carp.sensing-flutter/blob/master/README.md).

## Setup

1. You need a CARP Web Service (CAWS) host running. See the [CARP Web Service GitHub](https://github.com/cph-cachet/carp.webservices-docker) repro and documentation for how to do this. If you're part of the [CARP](https://carp.cachet.dk/) team, you can use the specified test, staging, and production servers.

1. Add `carp_services` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

This package uses the [oidc](https://pub.dev/packages/oidc) plugin for authentication. Please follow their [getting started](https://bdaya-dev.github.io/oidc/oidc-getting-started/) guide and take a look at their [example app](https://github.com/Bdaya-Dev/oidc/tree/main/packages/oidc/example).

### Android

On Android you need to edit both the `build.gradle` file and the `AndroidManifest.xml` file plus disable some backup settings.
You also need to add an activity to the `AndroidManifest.xml` to allow for redirection to/from the web view for authentication (if you are using the `authenticate()` method in the package). You manifest file would look something like this:

```xml
  ...

  <application
    android:name="${applicationName}"
    android:label="CAWS Example"
    android:fullBackupContent="@xml/backup_rules"
    android:dataExtractionRules="@xml/data_extraction_rules" 
    android:icon="@mipmap/ic_launcher">

  <!-- Used by authentication redirect to/from web view -->
  <activity
    android:name="net.openid.appauth.RedirectUriReceiverActivity"
    android:exported="true"
    tools:node="replace">
    <intent-filter>
      <action android:name="android.intent.action.VIEW" />
      <category android:name="android.intent.category.DEFAULT" />
      <category android:name="android.intent.category.BROWSABLE" />
      <data android:scheme="carp-studies-auth" android:pathPrefix="/auth" />
    </intent-filter>
    <intent-filter>
      <action android:name="android.intent.action.VIEW" />
      <category android:name="android.intent.category.DEFAULT" />
      <category android:name="android.intent.category.BROWSABLE" />
      <data android:scheme="http" />
      <data android:host="carp.computerome.dk" />
      <data android:pathPrefix="/auth" />
    </intent-filter>
  </activity>
```

### iOS

Add the following `CFBundleURLTypes` entry in your `Info.plist` file:

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>com.my.app</string>
        </array>
    </dict>
</array>
```

Replace `com.my.app` with your application id.

## Usage

Import the needed CARP libraries.

```dart
import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:carp_webservices/carp_auth/carp_auth.dart';
import 'package:carp_webservices/carp_services/carp_services.dart';
```

### Configuration

The [`CarpService`](https://pub.dartlang.org/documentation/carp_webservices/latest/carp_services/CarpService-class.html) is a singleton and needs to be configured once via the `CarpApp` configuration.

````dart
// The URI of the CAWS server to connect to.
final Uri uri = Uri(
  scheme: 'https',
  host: 'dev.carp.dk',
);

final CarpApp _app = CarpApp(
  name: "CAWS @ DTU [DEV]",
  uri: uri,
);

// Configure the CARP Service with this app.
CarpService().configure(app);
````

The `CarpApp` can also hold information about the `studyId` and `studyDeploymentId` for a specific study and deployment hosted at a CAWS server. This information is used in the methods below for handling e.g., informed consent, data points, documents and folders, etc.

The singleton can now be accessed via `CarpService()`. However, in order to access the CARP Web Service endpoint, authentication is needed first.

### Authentication

Authentication is done using the `CarpAuthService` singleton, which is configured using the `CarpAuthProperties` properties:

```dart
// The authentication configuration
late CarpAuthProperties authProperties = CarpAuthProperties(
  authURL: uri,
  clientId: 'studies-app',
  redirectURI: Uri.parse('carp-studies-auth://auth'),
  // For authentication at CAWS the path is '/auth/realms/Carp'
  discoveryURL: uri.replace(pathSegments: [
    'auth',
    'realms',
    'Carp',
  ]),
);

await CarpAuthService().configure(authProperties);
```

Basic authentication is using the CAWS Keycloak login page, which the system opens when running:

```dart
CarpUser user = await CarpAuthService().authenticate();
```

This `CarpUser` object contains the OAuth token in the `.token` (of type `OAuthToken`) parameter.
Since the [CarpUser](https://pub.dev/documentation/carp_webservices/latest/carp_auth/CarpUser-class.html) can be serialized to JSON, the OAuth token can be stored on the phone.

To refresh the OAuth token the client (Flutter) simply calls

```dart
await CarpAuthService().refresh()
```

This method returns a `CarpUser`, with the new access token.

To authenticate using username and password without opening the web view, use the `authenticateWithUsernamePassword` method:

```dart
CarpUser user = await CarpAuthService().authenticateWithUsernamePassword('username', 'password');
```

To log out, just call the `logout` or `logoutNoContext` methods:

```dart
await CarpAuthService().logout()
```

### Informed Consent Document

A [`ConsentDocument`](https://pub.dev/documentation/carp_webservices/latest/carp_services/ConsentDocument-class.html) can be uploaded and downloaded to and from CAWS.

```dart
try {
  ConsentDocument uploaded = await CarpService().createConsentDocument({
    'text': 'The original terms text.',
    'signature': 'Image Blob',
  });

  ConsentDocument downloaded =
      await CarpService().getConsentDocument(uploaded.id);
} catch (error) {
  ...;
}
```

### Data Points

A [`DataPointReference`](https://pub.dartlang.org/documentation/carp_webservices/latest/carp_services/DataPointReference-class.html) is used to manage [`DataPoint`](https://pub.dartlang.org/documentation/carp_webservices/latest/carp_services/DataPoint-class.html) objects on a CARP Web Service, and have CRUD methods for:

* post a data point
* batch upload multiple data points
* get a data point
* delete data points

````dart
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

CARP Web Service supports storing JSON documents in nested collections.

A [`CollectionReference`](https://pub.dartlang.org/documentation/carp_webservices/latest/carp_services/CollectionReference-class.html) is used to access collections and a [`DocumentReference`](https://pub.dev/documentation/carp_webservices/latest/carp_services/DocumentReference-class.html) is used to access documents. Both of these can be used to:

* creating, updating, and deleting documents
* accessing documents in collections

`````dart
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

CARP Web Service supports storing raw binary file.

A [`FileStorageReference`](https://pub.dartlang.org/documentation/carp_webservices/latest/carp_services/FileStorageReference-class.html) is used to manage files and have methods for:

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

A core notion of CARP is the [Deployment](https://github.com/cph-cachet/carp.core-kotlin/blob/develop/docs/carp-deployments.md) subsystem.
This subsystem is used for accessing `deployment` configurations, i.e. configurations that describe how data sampling in a study should take place.
The CARP Web Service have methods for:

* getting invitations for a specific `accountId`, i.e. a user. Default is the user who is authenticated to the CARP Service.
* getting a deployment reference, which then can be used to query status, register devices, and get the deployment specification.

Deployments are accessed via a [`DeploymentReference`](https://pub.dev/documentation/carp_webservices/latest/carp_services/DeploymentReference-class.html).

````dart
// This example uses the
//  * CarpDeploymentService
//  * CarpParticipationService
//
// To use these, we first must configure them and authenticate.
// However, the [configureFrom] method is a convenient way to do this
// based on an existing service, which has been configured.

CarpParticipationService().configureFrom(CarpService());
CarpDeploymentService().configureFrom(CarpService());

// get invitations for this account (user)
List<ActiveParticipationInvitation> invitations =
    await CarpParticipationService().getActiveParticipationInvitations();

// get a deployment reference for this master device
DeploymentReference deploymentReference =
    CarpDeploymentService().deployment('the_study_deployment_id');

// get the status of this deployment
StudyDeploymentStatus status = await deploymentReference.getStatus();

// register a device
status = await deploymentReference.registerDevice(deviceRoleName: 'phone');

// get the master device deployment
MasterDeviceDeployment deployment = await deploymentReference.get();

// mark the deployment as a success
status = await deploymentReference.success();
````

There is also support for showing a modal dialog for the user to select amongst several invitations. This is done using the `getStudyInvitation` method, like this:

```dart
var invitation =
    await CarpParticipationService().getStudyInvitation(context);
print('Selected CARP Study Invitation: $invitation');
```

### Streaming Data

Collected data can be streamed back to a CARP Web Service using the [`Data`](https://github.com/cph-cachet/carp.core-kotlin/blob/develop/docs/carp-data.md) subsystem. Note that this is a separate subsystem from the `DataPoint` endpoint described above. CAWS supports **both** types of data upload (for legacy reasons).

```dart
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
```

## Features and bugs

Please file feature requests and bug reports at the [issue tracker][tracker].

[tracker]: https://github.com/cph-cachet/carp.sensing/issues

## License

This software is copyright (c) [Copenhagen Center for Health Technology (CACHET)](https://www.cachet.dk/) at the [Technical University of Denmark (DTU)](https://www.dtu.dk).
This software is made available 'as-is' in a MIT [license](/LICENSE).
