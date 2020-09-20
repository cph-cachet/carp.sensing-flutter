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

  /// The role name of this device as registered at CARP.
  String deviceRoleName;

  DeploymentReference._(CarpService service, [this.masterDeviceRoleName = 'phone']) : super._(service) {
    this.masterDeviceRoleName ??= 'phone';

    // register all the fromJson function for the deployment domain classes.
    FromJsonFactory.registerFromJsonFunction("dk.cachet.carp.deployment.domain.StudyDeploymentStatus.Invited", StudyDeploymentStatus.fromJsonFunction);
    FromJsonFactory.registerFromJsonFunction("dk.cachet.carp.deployment.domain.StudyDeploymentStatus.DeployingDevices", StudyDeploymentStatus.fromJsonFunction);
    FromJsonFactory.registerFromJsonFunction("dk.cachet.carp.deployment.domain.StudyDeploymentStatus.DeploymentReady", StudyDeploymentStatus.fromJsonFunction);
    FromJsonFactory.registerFromJsonFunction("dk.cachet.carp.deployment.domain.StudyDeploymentStatus.Stopped", StudyDeploymentStatus.fromJsonFunction);
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
    print(response.body);
    Map<String, dynamic> responseJson = json.decode(response.body);
    //print(responseJson.toString());

    if (httpStatusCode == HttpStatus.ok) {
      print(responseJson.toString());
      //return StudyDeploymentStatus(id);
      return StudyDeploymentStatus.fromJson(responseJson);
    }

    // All other cases are treated as an error.
    throw CarpServiceException(
      httpStatus: HTTPStatus(httpStatusCode, response.reasonPhrase),
      message: responseJson["message"],
    );
  }

  /// Register this device for this deployment at the CARP server.
  ///  * [deviceRoleName] - the role name of this device, e.g. `phone`.
  ///  * [deviceId] - a unique ID for this device.
  ///
  /// Returns the updated study deployment status if the registration is successful.
  /// Throws a [CarpServiceException] if not.
  Future<StudyDeploymentStatus> registerDevice(deviceRoleName, String deviceId) async {
    assert(deviceRoleName != null);
    assert(deviceId != null);

    this.deviceRoleName = deviceRoleName;

    final restHeaders = await headers;
    String body = _encode(DeviceRegistring(id, deviceRoleName, deviceId).toJson());

    print(deploymentEndpointUri);
    print(body);

    http.Response response = await httpr.put(Uri.encodeFull(deploymentEndpointUri), headers: restHeaders, body: body);
    int httpStatusCode = response.statusCode;
    print(httpStatusCode);

    Map<String, dynamic> responseJson = json.decode(response.body);
    print(responseJson.toString());

    if (httpStatusCode == HttpStatus.ok) return StudyDeploymentStatus.fromJson(responseJson);

    // All other cases are treated as an error.
    throw CarpServiceException(
      httpStatus: HTTPStatus(httpStatusCode, response.reasonPhrase),
      message: responseJson["message"],
    );
  }

  /// Unregister this device for this deployment at the CARP server.
  ///
  /// Returns true if the unregister is successful; throws a [CarpServiceException] if not.
  Future<StudyDeploymentStatus> unRegisterDevice() async {
    final restHeaders = await headers;
    final String uri = "deploymentEndpointUri/$id/devices";
    String body = _encode(DeviceUnregistring(id, deviceRoleName).toJson());

    print(uri);
    print(body);

    http.Response response = await httpr.post(Uri.encodeFull(deploymentEndpointUri), headers: restHeaders, body: body);
    int httpStatusCode = response.statusCode;
    Map<String, dynamic> responseJson = json.decode(response.body);
    print(httpStatusCode);

    if (httpStatusCode == HttpStatus.ok) return StudyDeploymentStatus.fromJson(responseJson);

    // All other cases are treated as an error.
    throw CarpServiceException(
      httpStatus: HTTPStatus(httpStatusCode, response.reasonPhrase),
      message: responseJson["message"],
    );
  }

  /// Get the deployment object at the server for this [DeploymentReference]
  /// for the specified [deviceRoleName]. Default to `phone` is not specified.
  Future<StudyDeployment> get([String deviceRoleName]) async {
    final restHeaders = await headers;

    this.masterDeviceRoleName = deviceRoleName ?? 'phone';

    print('uri :: $deviceDeploymentEndpointUri');

    http.Response response = await httpr.get(Uri.encodeFull(deviceDeploymentEndpointUri), headers: restHeaders);
    int httpStatusCode = response.statusCode;

    Map<String, dynamic> responseJson = json.decode(response.body);

    print(httpStatusCode);
    print(responseJson.toString());

    if (httpStatusCode == HttpStatus.ok) return StudyDeployment._(id, masterDeviceRoleName, null);

    // All other cases are treated as an error.
    throw CarpServiceException(
      httpStatus: HTTPStatus(httpStatusCode, response.reasonPhrase),
      message: responseJson["message"],
    );
  }

  /// Mark this deployment as a success on the CARP server.
  Future<StudyDeploymentStatus> success() async {
    final restHeaders = await headers;
    final String uri = "$deploymentEndpointUri/$id/success";
    final String body = _encode(DeploymentServiceRequest(id, masterDeviceRoleName).toJson());

    print(uri);
    print(body);

    http.Response response = await httpr.post(Uri.encodeFull(deploymentEndpointUri), headers: restHeaders, body: body);
    int httpStatusCode = response.statusCode;
    print(httpStatusCode);
    Map<String, dynamic> responseJson = json.decode(response.body);

    if (httpStatusCode == HttpStatus.ok) return StudyDeploymentStatus.fromJson(responseJson);

    // All other cases are treated as an error.
    throw CarpServiceException(
      httpStatus: HTTPStatus(httpStatusCode, response.reasonPhrase),
      message: responseJson["message"],
    );
  }
}

// -----------------------------------------------------
// Deployment Domain Classes
// -----------------------------------------------------

/// A [StudyDeployment] contains data read from a deployment in the CARP web service
///
/// The data can be extracted with the [data] property or by using subscript
/// syntax to access a specific field.
class StudyDeployment {
  StudyDeployment._(this._id, this._masterDeviceRoleName, this._snapshot);

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

  String toString() => "$runtimeType - deploymentId: $id, masterDeviceRoleName: $masterDeviceRoleName,  size: ${data?.length}";
}

/// A [StudyDeploymentStatus] represents the status of a deployment as returned from the CARP web service.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class StudyDeploymentStatus extends Serializable {
  StudyDeploymentStatus(this.studyDeploymentId);

  /// The CARP study deployment ID.
  String studyDeploymentId;
  List<DeviceDeploymentStatus> devicesStatus;
  DateTime startTime;

  /// Get the status of this device deployment:
  /// * Invited
  /// * DeployingDevices
  /// * DeploymentReady
  /// * Stopped
  String get status => $type.split('.').last;

  //factory StudyDeploymentStatus.fromJson(Map<String, dynamic> json) => StudyDeploymentStatus(json[1]['studyDeploymentId'].toString());

  static Function get fromJsonFunction => _$StudyDeploymentStatusFromJson;
  factory StudyDeploymentStatus.fromJson(Map<String, dynamic> json) => FromJsonFactory.fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$StudyDeploymentStatusToJson(this);

  String toString() => "$runtimeType - deploymentId: $studyDeploymentId, status: $status";
}

/// A [DeviceDeploymentStatus] represents the status of a device in a deployment.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class DeviceDeploymentStatus extends Serializable {
  DeviceDeploymentStatus();

  DeviceDescriptor device;
  bool requiresDeployment;
  List<String> remainingDevicesToRegisterToObtainDeployment;
  List<String> remainingDevicesToRegisterBeforeDeployment;

  /// Get the status of this device deployment:
  /// * Unregistered
  /// * Registered
  /// * Deployed
  /// * NeedsRedeployment
  String get status => $type.split('.').last;

  static Function get fromJsonFunction => _$DeviceDeploymentStatusFromJson;
  factory DeviceDeploymentStatus.fromJson(Map<String, dynamic> json) => FromJsonFactory.fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$DeviceDeploymentStatusToJson(this);

  String toString() => "$runtimeType - status: $status";
}

/// A [DeviceDescriptor] represents the status of a deployment as returned from the CARP web service.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class DeviceDescriptor extends Serializable {
  DeviceDescriptor();

  bool isMasterDevice;
  String roleName;
  Map<String, dynamic> samplingConfiguration;

  /// Get the type of this device, like `Smartphone`.
  String get deviceType => $type.split('.').last;

  static Function get fromJsonFunction => _$DeviceDescriptorFromJson;
  factory DeviceDescriptor.fromJson(Map<String, dynamic> json) => FromJsonFactory.fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$DeviceDescriptorToJson(this);

  String toString() => "$runtimeType - isMasterDevice: $isMasterDevice, : $roleName, deviceType: $deviceType";
}

/// A [DeviceRegistring] contains the data for registering this device for
/// this deployment in the CARP web service
class DeviceRegistring {
  DeviceRegistring(this.studyDeploymentId, this.deviceRoleName, this.deviceId);

  /// The CARP study deployment ID.
  String studyDeploymentId;

  /// The role name of this device.
  String deviceRoleName;

  /// The ID of this device.
  String deviceId;

  String get registerDeviceJson => '{  '
      '"\$type": "dk.cachet.carp.deployment.infrastructure.DeploymentServiceRequest.RegisterDevice",  '
      '"studyDeploymentId": "$studyDeploymentId",  '
      '"deviceRoleName": "$deviceRoleName",  '
      '"registration": {  '
      '"\$type": "dk.cachet.carp.protocols.domain.devices.DefaultDeviceRegistration",  '
      '"registrationCreationDate": ${DateTime.now().millisecondsSinceEpoch},  '
      '"deviceId": "$deviceId"  '
      '}}';

  Map<String, dynamic> toJson() => json.decode(registerDeviceJson);

  String toString() => "$runtimeType - studyDeploymentId: $studyDeploymentId, deviceRoleName: $deviceRoleName, deviceId: $deviceId";
}

/// A [DeviceUnregistring] contains the data for unregistering this device for
/// this deployment in the CARP web service
class DeviceUnregistring {
  DeviceUnregistring(this.studyDeploymentId, this.deviceRoleName);

  /// The CARP study deployment ID.
  String studyDeploymentId;

  /// The role name of this device.
  String deviceRoleName;

  String get unregisterDeviceJson => '{  '
      '"\$type": "dk.cachet.carp.deployment.infrastructure.DeploymentServiceRequest.UnregisterDevice",  '
      '"studyDeploymentId": "$studyDeploymentId",  '
      '"deviceRoleName": "$deviceRoleName"'
      '}';

  Map<String, dynamic> toJson() => json.decode(unregisterDeviceJson);

  String toString() => "$runtimeType - studyDeploymentId: $studyDeploymentId, deviceRoleName: $deviceRoleName";
}

/// A [DeploymentServiceRequest] contains the data for registering a successful
/// registration of a deployment in the CARP web service
class DeploymentServiceRequest {
  DeploymentServiceRequest(this.studyDeploymentId, this.masterDeviceRoleName);

  /// The CARP study deployment ID.
  String studyDeploymentId;

  /// The role name of this device.
  String masterDeviceRoleName;

  String get registerDeviceJson => ''
      '{"\$type": "dk.cachet.carp.deployment.infrastructure.DeploymentServiceRequest.DeploymentSuccessful",   '
      '"studyDeploymentId": "$studyDeploymentId",  '
      '"masterDeviceRoleName": "$masterDeviceRoleName",  '
      '"deviceDeploymentLastUpdateDate": ${DateTime.now().millisecondsSinceEpoch}'
      '}';

  Map<String, dynamic> toJson() => json.decode(registerDeviceJson);

  String toString() => "$runtimeType - studyDeploymentId: $studyDeploymentId, masterDeviceRoleName: $masterDeviceRoleName";
}
