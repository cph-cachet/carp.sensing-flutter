# CARP Data Backend

[![pub package](https://img.shields.io/pub/v/carp_backend.svg)](https://pub.dartlang.org/packages/carp_backend)
[![pub points](https://img.shields.io/pub/points/carp_backend?color=2E8B57&label=pub%20points)](https://pub.dev/packages/carp_backend/score)
[![github stars](https://img.shields.io/github/stars/cph-cachet/carp.sensing-flutter.svg?style=flat&logo=github&colorB=deeppink&label=stars)](https://github.com/cph-cachet/carp.sensing-flutter)
[![MIT License](https://img.shields.io/badge/license-MIT-purple.svg)](https://opensource.org/licenses/MIT)
[![arXiv](https://img.shields.io/badge/arXiv-2006.11904-green.svg)](https://arxiv.org/abs/2006.11904)

This package integrates the [CARP Mobile Sensing](https://carp.cachet.dk/cams/) Framework with the [CARP Web Services (CAWS)](https://carp.cachet.dk/caws/) backend.

For an overview of all CAMS packages, see [CARP Mobile Sensing in Flutter](https://github.com/cph-cachet/carp.sensing-flutter).
For documentation on how to use CAMS, see the [CAMS wiki][wiki].

This library supports;

* downloading a study invitation
* download a study deployment
* downloading translations
* downloading messages
* uploading collected data, and
* uploading an informed consent document

from/to a CAWS server.

> Note that this library makes little sense on its own and is only to be used as part of the overall [CARP Mobile Sensing](https://pub.dev/packages/carp_mobile_sensing) ecosystem. See the [CAMS wiki][wiki] for documentation on how to use CAMS, and checkout the [CARP Mobile Sening Demo App](https://github.com/cph-cachet/carp.sensing-flutter/tree/master/apps/carp_mobile_sensing_app) for a full example of an app using CARP Mobile Sensing and CAWS, including this library.

## Using the Plugin

Add `carp_backend` as a [dependency in your pubspec.yaml](https://flutter.io/platform-plugins/) file and import the library along with the other CAMS libraries.

```dart
import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:carp_webservices/carp_services/carp_services.dart';
import 'package:carp_backend/carp_backend.dart';
```

## Configuration

This library uses the [`carp_webservices`](https://pub.dev/packages/carp_webservices) API for accessing CAWS. In order to access CAWS, a [`CarpApp`](https://pub.dev/documentation/carp_webservices/latest/carp_services/CarpApp-class.html) needs to be configured like this:

```dart
final String uri = "https://cans.cachet.dk";

// Configure an app that points to the CARP web services (CAWS)
CarpApp app = CarpApp(
  name: 'any_display_friendly_name_is_fine',
  uri: Uri.parse(uri),
  oauth: OAuthEndPoint(
    clientID: 'the_client_id',
    clientSecret: 'the_client_secret',
  ),
);

// Configure the CAWS service
CarpService().configure(app);

// Authenticate at CAWS
await CarpService().authenticate(
  username: 'the_username',
  password: 'the_password',
);

// Configure the other services needed.
// Note that these CAWS services work as singletons and can be
// accessed throughout the app.
CarpParticipationService().configureFrom(CarpService());
CarpDeploymentService().configureFrom(CarpService());
```

## Downloading a study invitation and deployment from CAWS

Getting a study invitation and deployment from CAWS is done using the `CarpParticipationService` and `CarpDeploymentService` services, respectively.

```dart
// Get the invitations to studies from CARP for this user.
List<ActiveParticipationInvitation> invitations =
    await CarpParticipationService().getActiveParticipationInvitations();

// Use the first (i.e. latest) invitation.
final invitation = invitations[0];
```

The invitation contains information about the deployment, including the `studyDeploymentId` and the device `roleName`. This invitation is used to configure a study, which can be deployed and started in a [`SmartPhoneClientManager`](https://pub.dev/documentation/carp_mobile_sensing/latest/runtime/SmartPhoneClientManager-class.html).

```dart
// Create and configure a client manager for this phone.
// If no deployment service is specified in the configure method,
// the default CarpDeploymentService() singleton is used.
final client = SmartPhoneClientManager();
await client.configure();

// Define the study based on the invitation and add it to the client.
final study = await client.addStudy(
  invitation.studyDeploymentId!,
  invitation.assignedDevices!.first.device.roleName,
);

// Get the study controller and try to deploy the study.
//
// If "useCached" is true and the study has already been deployed on this
// phone, the local cache will be used (default behavior).
// If not deployed before (i.e., cached) the study deployment will be
// fetched from the deployment service.
final controller = client.getStudyRuntime(study);
await controller?.tryDeployment(useCached: false);

// Configure the controller
await controller?.configure();

// Start sampling
controller?.start();
```

## Uploading of data to CARP

Configuration of data upload is done as a [`DataEndPoint`](https://pub.dev/documentation/carp_mobile_sensing/latest/domain/DataEndPoint-class.html), which is part of a [`SmartphoneStudyProtocol`](https://pub.dev/documentation/carp_mobile_sensing/latest/domain/SmartphoneStudyProtocol-class.html).

CAWS and hence this plugin supports three methods of data upload:

* The (default) data stream batch upload using the [CARP Core Data subsystem](https://github.com/cph-cachet/carp.core-kotlin/blob/develop/docs/carp-data.md)
* The (legacy) [`DataPoint`](https://pub.dev/documentation/carp_webservices/latest/carp_services/DataPoint-class.html) batch upload
* File upload of raw SQLite `.db` files

### Specifying a CARP Data Endpoint

Create a `CarpDataEndPoint` that specify which method to use for uploading data, and the details. Upload methods are defined in the `CarpUploadMethod` property. For example, a streaming data upload is created like this:

```dart
// Using the (default) data stream batch upload method
CarpDataEndPoint streamingEndPoint = CarpDataEndPoint(
  uploadMethod: CarpUploadMethod.stream,
  deleteWhenUploaded: true,
);
```

Or a [`DataPoint`](https://pub.dev/documentation/carp_webservices/latest/carp_services/DataPoint-class.html) upload method is created like this:

```dart
// Using the "old" DataPoint endpoint for uploading batches of data points.
//
// Note that if a user is already authenticated to a CAWS server - for example
// based on the download of invitations and deployments - specification
// authentication info is not needed in the CarpDataEndPoint.
CarpDataEndPoint dataPointEndPoint = CarpDataEndPoint(
    uploadMethod: CarpUploadMethod.datapoint,
    name: 'CARP Staging Server',
    uri: 'http://staging.carp.cachet.dk:8080',
    clientId: 'carp',
    clientSecret: 'a_secret',
    email: 'username@cachet.dk',
    password: 'password');
```

To use the data endpoint, add it to the study protocol like this:

```dart
// Create a study protocol with a specific data endpoint.
SmartphoneStudyProtocol protocol = SmartphoneStudyProtocol(
  ownerId: 'AB',
  name: 'Track patient movement',
  dataEndPoint: streamingEndPoint,
);
```

### Register the Data Manager

In order to use the CAWS data manger for uploading of data, you should register it in the [`DataManagerRegistry`](https://pub.dev/documentation/carp_mobile_sensing/latest/runtime/DataManagerRegistry-class.html).

````dart
// Register CAWS as a data backend where data can be uploaded.
DataManagerRegistry().register(CarpDataManagerFactory());
````

## Authentication to CAWS

Configuration and authentication to CAWS only needs to be done once. Hence, if you app is already authenticated to CARP (for example, because the study deployment has been downloaded from CAWS), there is **NO** need for specifying the server information (`name` and `uri`) and authentication information (`client_id`, `client_secret`, `username`, and `password`) in the `CarpDataEndPoint`. Hence, in this case, you would specify a data endpoint like this:

`````dart
var endpoint = CarpDataEndPoint(uploadMethod: CarpUploadMethod.datapoint);
`````

## Features and bugs

Please file feature requests and bug reports at the [issue tracker][tracker]. Remember to specify which CARP library you're filing an issue for (in this case `carp_backend`).

## License

This software is copyright (c) [Copenhagen Center for Health Technology (CACHET)](https://www.cachet.dk/) at the [Technical University of Denmark (DTU)](https://www.dtu.dk).
This software is made available 'as-is' in a MIT [license](/LICENSE).

<!-- LINKS  -->

[tracker]: https://github.com/cph-cachet/carp.sensing/issues
[wiki]: https://github.com/cph-cachet/carp.sensing-flutter/wiki
