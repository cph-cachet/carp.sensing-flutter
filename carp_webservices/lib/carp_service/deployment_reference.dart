/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of carp_services;

/// Provide a deployment endpoint reference to a CARP web service. Used to:
/// - get a deployment configuration for a master device (typically a phone)
/// - set deployment success status
/// - query deployment status
/// - register and unregister this device as part of a deployment
class DeploymentReference extends CarpReference {
  /// The CARP deployment ID.
  String get id => service.app.study.deploymentId;

  /// The device role name for this master device.
  ///
  /// Default name is `phone`.
  String masterDeviceRoleName = 'phone';

  DeploymentReference._(CarpService service, [this.masterDeviceRoleName = 'phone']) : super._(service) {
    this.masterDeviceRoleName ??= 'phone';
  }

  /// The URL for the deployment endpoint for this [DeploymentReference].
  ///
  /// {{PROTOCOL}}://{{SERVER_HOST}}:{{SERVER_PORT}}/api/deployments
  String get deploymentEndpointUri => "${service.app.uri.toString()}/api/deployments";

  /// The URL for the deployment status endpoint for this [DeploymentReference].
  ///
  /// {{PROTOCOL}}://{{SERVER_HOST}}:{{SERVER_PORT}}/api/deployments?deploymentId={{DEPLOYMENT_ID}}
  String get deploymentStatusEndpointUri => "$deploymentEndpointUri?deploymentId=$id";

  /// The URL for the device deployment endpoint for this [DeploymentReference].
  ///
  /// {{PROTOCOL}}://{{SERVER_HOST}}:{{SERVER_PORT}}/api/deployments/{{DEPLYOMENT_ID}}/devices?masterDeviceRoleName=phone
  String get deviceDeploymentEndpointUri => "$deploymentEndpointUri/$id/devices?masterDeviceRoleName=$masterDeviceRoleName";

  /// Get the deployment status for this [DeploymentReference].
  Future<StudyDeploymentStatus> status() async {
    final restHeaders = await headers;

    print('uri :: $deploymentStatusEndpointUri');

    http.Response response = await httpr.get(Uri.encodeFull(deploymentStatusEndpointUri), headers: restHeaders);
    int httpStatusCode = response.statusCode;

    print(httpStatusCode);

    if (httpStatusCode == HttpStatus.ok) {
      List<dynamic> responseJson = json.decode(response.body);
      print(responseJson.toString());
      return StudyDeploymentStatus.fromJson(responseJson);
    }

    // All other cases are treated as an error.

    Map<String, dynamic> responseJson = json.decode(response.body);
    print(responseJson.toString());

    throw CarpServiceException(
      httpStatus: HTTPStatus(httpStatusCode, response.reasonPhrase),
      message: responseJson["message"],
    );
  }

  /// Register this device for this deployment at the CARP server.
  ///
  /// Returns true if the registration is successful; throws a [CarpServiceException] if not.
  Future<bool> registerDevice(String deviceRoleName, String deviceId) async {
    assert(deviceRoleName != null);
    assert(deviceId != null);

    final restHeaders = await headers;
    String body = _encode(DeviceRegistring(id, deviceRoleName, deviceId).toJson());

    print(deploymentEndpointUri);
    print(body);

    http.Response response = await httpr.put(Uri.encodeFull(deploymentEndpointUri), headers: restHeaders, body: body);
    int httpStatusCode = response.statusCode;
    print(httpStatusCode);

    if (httpStatusCode == HttpStatus.ok) {
      List<dynamic> responseJson = json.decode(response.body);
      print(responseJson.toString());
      return true;
    }

    // All other cases are treated as an error.

    Map<String, dynamic> responseJson = json.decode(response.body);
    print(responseJson.toString());

    throw CarpServiceException(
      httpStatus: HTTPStatus(httpStatusCode, response.reasonPhrase),
      message: responseJson["message"],
    );
  }

  /// Unregister this device for this deployment at the CARP server.
  ///
  /// Returns true if the unregister is successful; throws a [CarpServiceException] if not.
  Future<bool> unRegisterDevice() async {
    final restHeaders = await headers;
    final String uri = "deploymentEndpointUri/$id/devices";

    print(uri);

    http.Response response = await httpr.post(Uri.encodeFull(deploymentEndpointUri), headers: restHeaders, body: '');
    int httpStatusCode = response.statusCode;
    print(httpStatusCode);

    if (httpStatusCode == HttpStatus.ok) return true;

    // All other cases are treated as an error.
    Map<String, dynamic> responseJson = json.decode(response.body);
    throw CarpServiceException(
      httpStatus: HTTPStatus(httpStatusCode, response.reasonPhrase),
      message: responseJson["message"],
    );
  }

  /// Get the deployment object at the server for this [DeploymentReference]
  /// for the specified [deviceRoleName]. Default to `phone` is not specified.
  Future<StudyDeploymentSnapshot> get([String deviceRoleName]) async {
    final restHeaders = await headers;

    this.masterDeviceRoleName = deviceRoleName ?? 'phone';

    print('uri :: $deviceDeploymentEndpointUri');

    http.Response response = await httpr.get(Uri.encodeFull(deviceDeploymentEndpointUri), headers: restHeaders);
    int httpStatusCode = response.statusCode;

    Map<String, dynamic> responseJson = json.decode(response.body);

    print(httpStatusCode);
    print(responseJson.toString());

    if (httpStatusCode == HttpStatus.ok) return StudyDeploymentSnapshot._(id, masterDeviceRoleName, null);

    // All other cases are treated as an error.
    throw CarpServiceException(
      httpStatus: HTTPStatus(httpStatusCode, response.reasonPhrase),
      message: responseJson["message"],
    );
  }

  /// Mark this deployment as a success on the CARP server.
  Future<bool> success() async {
    final restHeaders = await headers;
    final String uri = "deploymentEndpointUri/$id/success";

    print(uri);

    http.Response response = await httpr.post(Uri.encodeFull(deploymentEndpointUri), headers: restHeaders, body: '');
    int httpStatusCode = response.statusCode;
    print(httpStatusCode);

    if (httpStatusCode == HttpStatus.ok) return true;

    // All other cases are treated as an error.
    Map<String, dynamic> responseJson = json.decode(response.body);
    throw CarpServiceException(
      httpStatus: HTTPStatus(httpStatusCode, response.reasonPhrase),
      message: responseJson["message"],
    );
  }
}

/// A [StudyDeploymentSnapshot] contains data read from a deployment in the CARP web service
///
/// The data can be extracted with the [data] property or by using subscript
/// syntax to access a specific field.
class StudyDeploymentSnapshot {
  StudyDeploymentSnapshot._(this._id, this._masterDeviceRoleName, this._snapshot);

  String _id;
  String _masterDeviceRoleName;
  final Map<String, dynamic> _snapshot;

  /// The CARP deployment ID.
  String get id => _id;

  /// The device role name for this master device.
  String get masterDeviceRoleName => _masterDeviceRoleName;

  /// The full data snapshot
  Map<String, dynamic> get snapshot => _snapshot;

//  /// The ID of the snapshot's document
//  int get id => _snapshot['id'];
//
//  /// The name of the snapshot's document
//  String get name => _snapshot['name'];
//
//  /// The id of the collection this document belongs to
//  int get collectionId => _snapshot['collection_id'];
//
//  /// The id of the user who created this document
//  String get createdByUserId => _snapshot['created_by_user_id'];
//
//  /// The timestamp of creation of this document
//  DateTime get createdAt => DateTime.parse(_snapshot['created_at']);
//
//  /// The timestamp of latest update of this document
//  DateTime get updatedAt => DateTime.parse(_snapshot['updated_at']);

  /// Contains all the data of this snapshot
  Map<String, dynamic> get data => _snapshot['data'];

  /// Reads individual data values from the snapshot
  dynamic operator [](String key) => data[key];

  /// Returns `true` if the document exists.
  bool get exists => data != null;

  String toString() => "${this.runtimeType} - deploymentId: $id, masterDeviceRoleName: $masterDeviceRoleName,  size: ${data?.length}";
}

/// A [StudyDeploymentStatus] contains data read from a deployment in the CARP web service
class StudyDeploymentStatus {
  StudyDeploymentStatus(this.id);

  /// The CARP deployment ID.
  String id;

  factory StudyDeploymentStatus.fromJson(List<dynamic> json) => StudyDeploymentStatus(json[1]['studyDeploymentId'].toString());

  String toString() => "${this.runtimeType} - deploymentId: $id";
}

/// A [DeviceRegistring] contains the data for registering this device for this deployment
/// in the CARP web service
///
class DeviceRegistring {
  DeviceRegistring(this.id, this.deviceRoleName, this.deviceId);

  /// The CARP deployment ID.
  String id;

  /// The role name of this device.
  String deviceRoleName;

  /// The ID of this device.
  String deviceId;

  String get registerDeviceJson => '['
      '"dk.cachet.carp.deployment.infrastructure.DeploymentServiceRequest.RegisterDevice",'
      '{'
      '  "studyDeploymentId":"$id",'
      '  "deviceRoleName":"$deviceRoleName",'
      '  "registration":['
      '    "dk.cachet.carp.protocols.domain.devices.DefaultDeviceRegistration",'
      '    {'
      '      "deviceId":"$deviceId"'
      '    }'
      '  ]'
      '}]';

  List<dynamic> toJson() => json.decode(registerDeviceJson);

  String toString() => "${this.runtimeType} - deploymentId: $id, deviceRoleName: $deviceRoleName, deviceId: $deviceId";
}
