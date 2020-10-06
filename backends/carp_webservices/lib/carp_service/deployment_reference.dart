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

  /// The device role name for this master device.
  /// Default name is `Master`.
  String masterDeviceRoleName = 'Master';

  /// The role name of this device as specified in the [deployment] protocol.
  String deviceRoleName;

  /// A unique id for this device as registered at CARP.
  String deviceId;

  MasterDeviceDeployment _deployment;

  /// The deployment for this master device, once fetched from the server.
  MasterDeviceDeployment get deployment => _deployment;

  DeploymentReference._(CarpService service, [this.masterDeviceRoleName = 'Master']) : super._(service);

  /// A generic RPC request to the CARP Server.
  Future<Map<String, dynamic>> _rpc(DeploymentServiceRequest request) async {
    final restHeaders = await headers;
    final String body = _encode(request.toJson());

    print('REQUEST: ${service.deploymentRPCEndpointUri}\n$body');
    http.Response response = await httpr.post(Uri.encodeFull(service.deploymentRPCEndpointUri), headers: restHeaders, body: body);
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
  Future<StudyDeploymentStatus> status() async => StudyDeploymentStatus.fromJson(await _rpc(GetStudyDeploymentStatus(studyDeploymentId)));

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
    assert(deviceRoleName != null && deviceRoleName.length > 0, 'deviceRoleName has to be specified when registering a device in CARP.');
    deviceId ??= Uuid().v4().toString();
    this.deviceRoleName = deviceRoleName;
    this.deviceId = deviceId;
    return StudyDeploymentStatus.fromJson(await _rpc(RegisterDevice(studyDeploymentId, deviceRoleName, DeviceRegistration(deviceId))));
  }

  /// Unregister a device for this deployment at the CARP server.
  ///  * [deviceRoleName] - the role name of the device, e.g. `phone`.
  ///
  /// If [deviceRoleName] is not specified, then the name specified in when registering
  /// this device in the [registerDevice] method is used.
  ///
  /// Returns the updated study deployment status if the registration is successful.
  /// Throws a [CarpServiceException] if not.
  Future<StudyDeploymentStatus> unRegisterDevice([String deviceRoleName]) async =>
      StudyDeploymentStatus.fromJson(await _rpc(UnregisterDevice(studyDeploymentId, (deviceRoleName != null) ? deviceRoleName : this.deviceRoleName)));

  /// Get the deployment for this [DeploymentReference] for the specified [masterDeviceRoleName].
  /// If [masterDeviceRoleName] is not specified, the previously used name is used, which is `Master` as default.
  Future<MasterDeviceDeployment> get([String masterDeviceRoleName]) async {
    if (masterDeviceRoleName != null) this.masterDeviceRoleName = masterDeviceRoleName;
    _deployment = MasterDeviceDeployment.fromJson(await _rpc(GetDeviceDeploymentFor(studyDeploymentId, this.masterDeviceRoleName)));
    return _deployment;
  }

  /// Mark this deployment as a success on the server.
  Future<StudyDeploymentStatus> success() async => StudyDeploymentStatus.fromJson(await _rpc(DeploymentSuccessful(studyDeploymentId, masterDeviceRoleName, deployment.lastUpdateDate)));
}
