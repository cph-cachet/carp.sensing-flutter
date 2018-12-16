import 'package:carp_webservices/carp_auth/carp_auth.dart';
import 'package:carp_webservices/carp_service/carp_service.dart';
import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'dart:convert';
import 'dart:io';

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
  final FileUploadTask uploadTask = CarpService.instance
      .getFileStorageReference()
      .upload(uploadFile, {'content-type': 'image/jpg', 'content-language': 'en', 'activity': 'test'});
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
  String data_point_id = await CarpService.instance.getDataPointReference().postDataPoint(data);

  // get the data point back from the server
  CARPDataPoint data_point = await CarpService.instance.getDataPointReference().getDataPoint(data_point_id);

  // delete the data point
  await CarpService.instance.getDataPointReference().deleteDataPoint(data_point_id);

  // ------------------- COLLECTIONS AND OBJECTS --------------------------------

  // access an object
  //  - if the object id is not specified, a new object (with a new id) is created
  //  - if the collection (users) don't exist, it is created
  ObjectSnapshot object =
      await CarpService.instance.collection('/users').object().setData({'email': username, 'name': 'Administrator'});

  // update the object
  ObjectSnapshot updated_object = await CarpService.instance
      .collection('/users')
      .object(object.id)
      .updateData({'email': username, 'name': 'Super User'});

  // get the object
  ObjectSnapshot new_object = await CarpService.instance.collection('/users').object(object.id).get();

  // delete the object
  await CarpService.instance.collection('/users').object(object.id).delete();

  // get all collections in the root
  List<String> root = await CarpService.instance.collection("").collections;

  // get all objects in a collection.
  List<ObjectSnapshot> objects = await CarpService.instance.collection("/users").objects;
}
