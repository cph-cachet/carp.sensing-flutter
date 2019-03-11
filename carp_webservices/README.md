# CARP Web Service Plugin for Flutter

A Flutter plugin to access the [CARP Web Service API](https://github.com/cph-cachet/carp.webservices).

[![pub package](https://img.shields.io/pub/v/carp_webservices.svg)](https://pub.dartlang.org/packages/carp_webservices)

For Flutter plugins for other CARP products, see [CARP Mobile Sensing in Flutter](https://github.com/cph-cachet/carp.sensing-flutter/blob/master/README.md).

*Note*: This plugin is still under development, and some APIs might not be available yet. 
[Feedback](https://github.com/cph-cachet/carp.sensing-flutter/issues) and 
[Pull Requests](https://github.com/cph-cachet/carp.sensing-flutter/pulls) are most welcome!

## Setup

1. You need a CARP Web Service host running. See the [CARP Web Service API](https://github.com/cph-cachet/carp.webservices) 
documentation for how to do this. If you're part of the [CACHET](http://www.cachet.dk/) team, you can use the specified 
development, staging, and production servers.

1. Add `carp_services` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

## Usage

```dart
import 'package:carp_webservices/carp_service/carp_service.dart';
```

### Configuration

The [`CarpService`](https://pub.dartlang.org/documentation/carp_webservices/latest/carp_services/CarpService-class.html)
is a singleton and needs to be configured once.
Note that a valid [`Study`](https://pub.dartlang.org/documentation/carp_core/latest/carp_core/Study-class.html) with a valid study ID is needed.

````dart
final String uri = "http://staging.carp.cachet.dk:8080";

CarpApp app;
Study study;

study = new Study(testStudyId, "user@dtu.dk", name: "Test study #$testStudyId");
app = new CarpApp(
      study: study,
      name: "any_display_friendly_name_is_fine",
      uri: Uri.parse(uri),
      oauth: OAuthEndPoint(clientID: "the_client_id", clientSecret: "the_client_secret"));

CarpService.configure(app);

```` 

The singleton can then be accessed via `CarpService.instance`.

### Authentication

Authentication is currently only supported using username and password.

```dart
CarpUser user;
try {
   user = await CarpService.instance.authenticate(username: "a_username", password: "the_password");
} catch (excp) {
   ...;
}
```

### Data Points

A [`DataPointReference`](https://pub.dartlang.org/documentation/carp_webservices/latest/carp_services/DataPointReference-class.html)
is used to manage [data points](http://staging.carp.cachet.dk:8080/swagger-ui.html#/data-point-controller) 
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
is used to manage [collections](http://staging.carp.cachet.dk:8080/swagger-ui.html#/collection-controller) 
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

  // get the document
  DocumentSnapshot new_document = await CarpService.instance.collection('users').document(document.name).get();

  // delete the document
  await CarpService.instance.collection('users').document(document.name).delete();

  // get all collections from a document
  List<String> collections = new_document.collections;

  // get all documents in a collection.
  List<DocumentSnapshot> documents = await CarpService.instance.collection("users").documents;
`````


### File Management

A [`FileStorageReference`](https://pub.dartlang.org/documentation/carp_webservices/latest/carp_services/FileStorageReference-class.html)
 is used to manage [files](http://staging.carp.cachet.dk:8080/swagger-ui.html#/file-controller) on a CARP web service and have methods for:

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


## Features and bugs

Please file feature requests and bug reports at the [issue tracker][tracker].

[tracker]: https://github.com/cph-cachet/carp.sensing/issues

## License

This software is copyright (c) 2018 [Copenhagen Center for Health Technology (CACHET)](http://www.cachet.dk/) at the [Technical University of Denmark (DTU)](http://www.dtu.dk).
This software is made available 'as-is' in a MIT [license](/LICENSE).

