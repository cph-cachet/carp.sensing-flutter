# CARP Data Backend

This package supports uploading of data from the [CARP Mobile Sensing Framework](https://github.com/cph-cachet/carp.sensing) 
to the [CARP web service backend](https://github.com/cph-cachet/carp.webservices).

[![pub package](https://img.shields.io/pub/v/carp_backend.svg)](https://pub.dartlang.org/packages/carp_backend)

For Flutter plugins for other CARP products, see [CARP Mobile Sensing in Flutter](https://github.com/cph-cachet/carp.sensing-flutter/blob/master/README.md).


Upload of sensing data to the CARP web service can be done in four different ways:

* as [CARP data points](http://staging.carp.cachet.dk:8080/swagger-ui.html#/data-point-controller)
* as a CARP object in a [collection](http://staging.carp.cachet.dk:8080/swagger-ui.html#/collection-controller)
* as a file to the CARP [file store](http://staging.carp.cachet.dk:8080/swagger-ui.html#/file-controller)
* [batch upload](http://staging.carp.cachet.dk:8080/swagger-ui.html#/data-point-controller)
## Using the Plugin

Add `carp_backend` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/) 
and import the library along with the [`carp_core`](https://pub.dartlang.org/packages/carp_core) library.

```dart
import 'package:carp_core/carp_core.dart';
import 'package:carp_backend/carp_backend.dart';
```

Using the library takes three steps.

### 1. Register the Data Manager

First you should register the data manager in the [`DataManagerRegistry`](https://pub.dartlang.org/documentation/carp_core/latest/carp_core/DataManagerRegistry-class.html).

````dart
DataManagerRegistry.register(DataEndPointType.CARP, new CarpDataManager());
````

### 2. Create a CARP Data Endpoint 

Create a `CarpDataEndPoint` that specify which method to use for upload of data, and the details. 
Upload methods are defined in the `CarpUploadMethod` class.

For example, a `CarpDataEndPoint` that upload data points directly looks like this:

`````dart
CarpDataEndPoint cdep = CarpDataEndPoint(CarpUploadMethod.DATA_POINT,
      name: 'CARP Staging Server',
      uri: uri,
      clientId: clientID,
      clientSecret: clientSecret,
      email: username,
      password: password);
`````

A `CarpDataEndPoint` that uploads data as zipped files looks like this:

`````dart
  CarpDataEndPoint cdep_2 = CarpDataEndPoint(CarpUploadMethod.FILE,
      name: 'CARP Staging Server',
      uri: uri,
      clientId: clientID,
      clientSecret: clientSecret,
      email: username,
      password: password,
      bufferSize: 500 * 1000,
      zip: true);
`````

And a `CarpDataEndPoint` that batch uploads data points in a json files looks like this:


`````dart
  CarpDataEndPoint cdep_3 = CarpDataEndPoint(CarpUploadMethod.BATCH_DATA_POINT,
      name: 'CARP Staging Server',
      uri: uri,
      clientId: clientID,
      clientSecret: clientSecret,
      email: username,
      password: password,
      bufferSize: 500 * 1000);

`````

### 3. Assign the CARP Data Endpoint to your Study

To use the CARP Data Endpoint in you study, assign it to the study. And then start the study.

`````dart
  Study study = new Study(testStudyId, username, name: "Test study #$testStudyId");
  study.dataEndPoint = cdep;
  
  // create a new executor, initialize it, and start it
  executor = new StudyExecutor(study);
  executor.initialize();
  executor.start();
`````
 
## Features and bugs

Please file feature requests and bug reports at the [issue tracker][tracker].

[tracker]: https://github.com/cph-cachet/carp.sensing/issues

## License

This software is copyright (c) 2018 [Copenhagen Center for Health Technology (CACHET)](http://www.cachet.dk/) at the [Technical University of Denmark (DTU)](http://www.dtu.dk).
This software is made available 'as-is' in a MIT [license](/LICENSE).

