/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of carp_services;

/// Provide a deployment endpoint reference to a CARP web service.
///
/// According to CARP core, the protocol for using the
/// [deployment sub-system](https://github.com/cph-cachet/carp.core-kotlin/blob/develop/docs/carp-deployment.md) is:
///
///   - [status()] - get the study deployment status of this deployment.
///   - [registerDevice()] - register this device - and associated devices - in this deployment
///   - [get()] - get the deployment for this master device
///   - [success()] - report the deployment as successful
///   - [unRegisterDevice()] - unregister this - or other - device if no longer used
class DeploymentReference extends CarpReference {
  /// The CARP study deployment ID.
  String get studyDeploymentId => service.app.study.deploymentId;

  MasterDeviceDeployment _deployment;
  StudyDeploymentStatus _status;

  /// The deployment status for this master device, once fetched from the server.
  StudyDeploymentStatus get status => _status;

  /// The deployment for this master device, once fetched from the server.
  MasterDeviceDeployment get deployment => _deployment;

  // /// The role name of this device as specified in the [deployment] protocol.
  //String deviceRoleName;

  String _deviceId;

  /// A unique id for this device as registered at CARP.
  ///
  /// Uses the phone's unique hardware id, if available.
  /// Otherwise uses a v4 UUID.
  String get deviceId {
    if (_deviceId == null) {
      _deviceId = Device().deviceID ?? Uuid().v4().toString();
    }
    return _deviceId;
  }

  DeploymentReference._(CarpService service) : super._(service);

  /// A generic RPC request to the CARP Server.
  Future<Map<String, dynamic>> _rpc(DeploymentServiceRequest request) async {
    final restHeaders = await headers;
    final String body = _encode(request.toJson());

    print('REQUEST: ${service.deploymentRPCEndpointUri}\n$body');
    http.Response response =
        await httpr.post(Uri.encodeFull(service.deploymentRPCEndpointUri), headers: restHeaders, body: body);
    int httpStatusCode = response.statusCode;
    String responseBody = response.body;
    print('RESPONSE: $httpStatusCode\n$responseBody');

    // check if this is a json list, and if so turn it into a json map with one item called 'items'
    if (responseBody.startsWith('[')) {
      responseBody = '{"items": $responseBody}';
    }

    Map<String, dynamic> responseJson = json.decode(responseBody);

    if (httpStatusCode == HttpStatus.ok) {
      return responseJson;
    }

    // All other cases are treated as an error.
    throw CarpServiceException(
      httpStatus: HTTPStatus(httpStatusCode, response.reasonPhrase),
      message: responseJson["message"],
    );
  }

  /// Get the deployment status for this [DeploymentReference].
  Future<StudyDeploymentStatus> getStatus() async {
    _status = StudyDeploymentStatus.fromJson(await _rpc(GetStudyDeploymentStatus(studyDeploymentId)));
    return _status;
  }

  /// Register a device for this deployment at the CARP server.
  ///  * [deviceRoleName] - the role name of the device, e.g. `phone`.
  ///  * [deviceId] - a unique id for this device. If not specified, a unique id will be generated and used.
  ///
  /// Returns the updated study deployment status if the registration is successful.
  /// Throws a [CarpServiceException] if not.
  Future<StudyDeploymentStatus> registerDevice({
    @required String deviceRoleName,
    String deviceId,
  }) async {
    assert(deviceRoleName != null && deviceRoleName.length > 0,
        'deviceRoleName has to be specified when registering a device in CARP.');

    // Set device ID, if provided
    if (deviceId != null) _deviceId = deviceId;
    _status = StudyDeploymentStatus.fromJson(
        await _rpc(RegisterDevice(studyDeploymentId, deviceRoleName, DeviceRegistration(deviceId))));
    return _status;
  }

  /// Register this device as the master device for this deployment at the CARP server.
  ///  * [deviceId] - a unique id for this device. If not specified, a unique id will be generated and used.
  ///
  /// Returns the updated study deployment status if the registration is successful.
  /// Throws a [CarpServiceException] if not.
  Future<StudyDeploymentStatus> registerMasterDevice({String deviceId}) async {
    assert(
        status != null,
        'The status of a deployment must be know before a master device can be registered. '
        'Use the getStatus() method to get the deployment status');
    return registerDevice(deviceRoleName: status.masterDeviceStatus.device.roleName, deviceId: deviceId);
  }

  /// Unregister a device for this deployment at the CARP server.
  ///  * [deviceRoleName] - the role name of the device, e.g. `phone`.
  ///
  /// Returns the updated study deployment status if the registration is successful.
  /// Throws a [CarpServiceException] if not.
  Future<StudyDeploymentStatus> unRegisterDevice({@required String deviceRoleName}) async {
    _status = StudyDeploymentStatus.fromJson(await _rpc(UnregisterDevice(studyDeploymentId, deviceRoleName)));
    return _status;
  }

  /// Get the deployment for this [DeploymentReference] for the specified [masterDeviceRoleName].
  /// If [masterDeviceRoleName] is not specified, the previously used name is used.
  Future<MasterDeviceDeployment> get() async {
    assert(
        status != null,
        'The status of a deployment must be know before a master device can be registered. '
        'Use the getStatus() method to get the deployment status.');
    _deployment = MasterDeviceDeployment.fromJson(
        await _rpc(GetDeviceDeploymentFor(studyDeploymentId, status.masterDeviceStatus.device.roleName)));
    return _deployment;
  }

  /// Mark this deployment as a success on the server.
  ///
  /// Returns the updated study deployment status if the registration is successful.
  /// Throws a [CarpServiceException] if not.
  Future<StudyDeploymentStatus> success() async {
    assert(
        deployment != null,
        'The deployment needs to be fetched before a master device can mark it successful. '
        'Use the get() method to get the master device deployment.');

    _status = StudyDeploymentStatus.fromJson(await _rpc(DeploymentSuccessful(
      studyDeploymentId,
      status.masterDeviceStatus.device.roleName,
      deployment.lastUpdateDate,
    )));

    return _status;
  }
}
