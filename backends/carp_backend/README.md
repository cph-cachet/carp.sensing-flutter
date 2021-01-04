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

Add `carp_backend` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/) 
and import the library along with the [`carp_mobile_sensing`](https://pub.dev/packages/carp_mobile_sensing) library.

```dart
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:carp_backend/carp_backend.dart';
```

## Downloading a study configuration from CARP

Getting a study configuration from CARP is done using a `CarpStudyManager`.
But in order to authenticate to CARP and get the available studies for the user, 
we make use of the [`carp_webservices`](https://pub.dev/packages/carp_webservices) API.

To get a study, you basically go through the following steps:

 1. Create and configure a `CarpApp` that points to the correct CARP web service.
 2. Authenticate to the CARP web service
 3. Get the list of study invitations for the authenticated user.
 4. Get a specific study via a `CarpStudyManager`

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
  CarpStudyManager manager = CarpStudyManager();
  await manager.initialize();

  // get the study from CARP
  Study study = await manager.getStudy(studyDeploymentId);
  print('study: $study');
  ````


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
  DataManagerRegistry().register(DataEndPointType.CARP, CarpDataManager());
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

### 3. Assign the CARP Data Endpoint to your Study

To use the CARP Data Endpoint in you study, assign it to the study. 

`````dart
  Study study = new Study(
    id: '1234',
    userId: 'username@cachet.dk',
    name: 'Test study #1234',
  );
  study.dataEndPoint = cdep;
````` 

## Features and bugs

Please file feature requests and bug reports at the [issue tracker][tracker].

[tracker]: https://github.com/cph-cachet/carp.sensing/issues

## License

This software is copyright (c) [Copenhagen Center for Health Technology (CACHET)](https://www.cachet.dk/) at the [Technical University of Denmark (DTU)](https://www.dtu.dk).
This software is made available 'as-is' in a MIT [license](/LICENSE).

