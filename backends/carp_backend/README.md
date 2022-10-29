# CARP Data Backend

[![pub package](https://img.shields.io/pub/v/carp_backend.svg)](https://pub.dartlang.org/packages/carp_backend)
[![style: effective dart](https://img.shields.io/badge/style-pedandic_dart-40c4ff.svg)](https://pub.dev/packages/pedandic_dart)
[![github stars](https://img.shields.io/github/stars/cph-cachet/carp.sensing-flutter.svg?style=flat&logo=github&colorB=deeppink&label=stars)](https://github.com/cph-cachet/carp.sensing-flutter)
[![MIT License](https://img.shields.io/badge/license-MIT-purple.svg)](https://opensource.org/licenses/MIT)

This package integrates the [CARP Mobile Sensing](https://github.com/cph-cachet/carp.sensing)
Framework with the [CARP web service backend](https://carp.cachet.dk).
It support downloading a study configuration and uploading collected data.

For Flutter plugins for other CARP products, see [CARP Mobile Sensing in Flutter](https://github.com/cph-cachet/carp.sensing-flutter/blob/master/README.md).

## Using the Plugin

Add `carp_backend` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/) and import the library along with the [`carp_mobile_sensing`](https://pub.dev/packages/carp_mobile_sensing) library.

```dart
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:carp_webservices/carp_services/carp_services.dart';
import 'package:carp_core/carp_core.dart';
import 'package:carp_backend/carp_backend.dart';
```

## Downloading a study configuration from CARP

Getting a study configuration from CARP is done using a `CARPStudyProtocolManager`.
But in order to authenticate to CARP and get the available studies for the user,
we make use of the [`carp_webservices`](https://pub.dev/packages/carp_webservices) API.

To get a study, you basically go through the following steps:

 1. Create and configure a `CarpApp` that points to the correct CARP web service.
 2. Authenticate to the CARP web service
 3. Get the list of study invitations for the authenticated user.
 4. Get a specific study via a `CARPStudyProtocolManager` or deploy it directly using the `CustomProtocolDeploymentService`.

The following code illustrates how this is done:

```dart
  final String uri = "https://cans.cachet.dk:443";

  // configure an app that points to the CARP web service
  CarpApp app = CarpApp(
    name: 'any_display_friendly_name_is_fine',
    uri: Uri.parse(uri),
    oauth: OAuthEndPoint(
      clientID: 'the_client_id',
      clientSecret: 'the_client_secret',
    ),
  );
  CarpService().configure(app);

  // authenticate at CARP
  await CarpService()
      .authenticate(username: 'the_username', password: 'the_password');

  // get the invitations to studies from CARP for this user
  List<ActiveParticipationInvitation> invitations =
      await CarpService().invitations();

  // use the first (i.e. latest) invitation
  String studyDeploymentId = invitations[0].studyDeploymentId;

  // create a study manager, and initialize it
  CARPStudyProtocolManager manager = CARPStudyProtocolManager();
  await manager.initialize();

  // get the study protocol from CARP
  StudyProtocol study = await manager.getStudyProtocol(studyDeploymentId);
  print('study: $study');
  ````

If you just want to deploy and run the study deployment directly, another approach is to use the `CustomProtocolDeploymentService` directly:

```dart

  // get the status of the deployment
  StudyDeploymentStatus status = await CustomProtocolDeploymentService()
      .getStudyDeploymentStatus(studyDeploymentId);

  // create and configure a client manager for this phone
  SmartPhoneClientManager client = SmartPhoneClientManager(
    deploymentService: CustomProtocolDeploymentService(),
    deviceRegistry: DeviceController(),
  );
  await client.configure();

  String deviceRolename = status.masterDeviceStatus.device.roleName;

  // add and deploy this deployment using its rolename
  StudyDeploymentController controller =
      await client.addStudy(studyDeploymentId, deviceRolename);

  // configure the controller with the default privacy schema
  await controller.configure();
  // controller.resume();

  // listening on the data stream and print them as json to the debug console
  controller.data.listen((data) => print(toJsonString(data)));

```

## Uploading of data to CARP

Upload of sensing data to the CARP web service can be done in four different ways:

* as individual CARP data points
* as a batch upload of a file with multiple CARP data points
* as a CARP object in a collection
* as a file to the CARP file store

Using the library takes three steps.

### 1. Register the Data Manager

First you should register the data manager in the [`DataManagerRegistry`](https://pub.dartlang.org/documentation/carp_core/latest/carp_core/DataManagerRegistry-class.html).

````dart
  DataManagerRegistry().register(CarpDataManager());
````

### 2. Create a CARP Data Endpoint

Create a `CarpDataEndPoint` that specify which method to use for uploading data, and the details.
Upload methods are defined in the `CarpUploadMethod` class.

For example, a `CarpDataEndPoint` that upload data points directly looks like this:

`````dart
  CarpDataEndPoint cdep = CarpDataEndPoint(CarpUploadMethod.DATA_POINT,
      name: 'CARP Staging Server',
      uri: 'http://staging.carp.cachet.dk:8080',
      clientId: 'carp',
      clientSecret: 'a_secret',
      email: 'username@cachet.dk',
      password: 'password');
`````

A `CarpDataEndPoint` that uploads data as zipped files and keeps the file on the phone, looks like this:

`````dart
  CarpDataEndPoint cdep = CarpDataEndPoint(CarpUploadMethod.FILE,
      name: 'CARP Staging Server',
      uri: 'http://staging.carp.cachet.dk:8080',
      clientId: 'carp',
      clientSecret: 'a_secret',
      email: 'username@cachet.dk',
      password: 'password',
      bufferSize: 500 * 1000,
      zip: true);
`````

And a `CarpDataEndPoint` that batch uploads data points in a json file (which is deleted when uploaded) looks like this:

`````dart
  CarpDataEndPoint cdep = CarpDataEndPoint(
    CarpUploadMethod.BATCH_DATA_POINT,
    name: 'CARP Staging Server',
    uri: 'http://staging.carp.cachet.dk:8080',
    clientId: 'carp',
    clientSecret: 'a_secret',
    email: 'username@cachet.dk',
    password: 'password',
    bufferSize: 500 * 1000,
    deleteWhenUploaded: true,
  );
`````

### 3. Assign the CARP Data Endpoint to your Study Protocol

You can now use a CARP Data Endpoint to the study protocol.

`````dart
  // create a study protocol with a specific data endpoint
  SmartphoneStudyProtocol protocol = SmartphoneStudyProtocol(
    ownerId: 'AB',
    name: 'Track patient movement',
    dataEndPoint: cdep,
  );
`````

## Authentication to CARP

Authentication to CARP only needs to be done once. Hence, if you app is already authenticated to CARP (for example, because the study protocol has been downloaded from CARP), there is **NO** need for specifying the client id/secret and username/password in the `CarpDataEndPoint`. Hence, in this case, you would specify a data enpoint like this:

`````dart
  CarpDataEndPoint cdep = CarpDataEndPoint(CarpUploadMethod.DATA_POINT,
      name: 'CARP Staging Server',
      uri: 'http://staging.carp.cachet.dk:8080',
    );
`````

## Features and bugs

Please file feature requests and bug reports at the [issue tracker][tracker].

[tracker]: https://github.com/cph-cachet/carp.sensing/issues

## License

This software is copyright (c) [Copenhagen Center for Health Technology (CACHET)](https://www.cachet.dk/) at the [Technical University of Denmark (DTU)](https://www.dtu.dk).
This software is made available 'as-is' in a MIT [license](/LICENSE).
