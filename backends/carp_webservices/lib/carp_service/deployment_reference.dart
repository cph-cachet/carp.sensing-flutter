/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of carp_services;

void registerFromJsonFunctions() {
  // register all the fromJson function for the deployment domain classes.
  FromJsonFactory.registerFromJsonFunction(
    "dk.cachet.carp.deployment.infrastructure.DeploymentServiceRequest.GetStudyDeploymentStatus",
    GetStudyDeploymentStatus.fromJsonFunction,
  );

  FromJsonFactory.registerFromJsonFunction("dk.cachet.carp.deployment.domain.StudyDeploymentStatus.Invited", StudyDeploymentStatus.fromJsonFunction);
  FromJsonFactory.registerFromJsonFunction("dk.cachet.carp.deployment.domain.StudyDeploymentStatus.DeployingDevices", StudyDeploymentStatus.fromJsonFunction);
  FromJsonFactory.registerFromJsonFunction("dk.cachet.carp.deployment.domain.StudyDeploymentStatus.DeploymentReady", StudyDeploymentStatus.fromJsonFunction);
  FromJsonFactory.registerFromJsonFunction("dk.cachet.carp.deployment.domain.StudyDeploymentStatus.Stopped", StudyDeploymentStatus.fromJsonFunction);

  FromJsonFactory.registerFromJsonFunction("dk.cachet.carp.deployment.domain.DeviceDeploymentStatus.Unregistered", DeviceDeploymentStatus.fromJsonFunction);
  FromJsonFactory.registerFromJsonFunction("dk.cachet.carp.deployment.domain.DeviceDeploymentStatus.Registered", DeviceDeploymentStatus.fromJsonFunction);
  FromJsonFactory.registerFromJsonFunction(
    "dk.cachet.carp.deployment.domain.DeviceDeploymentStatus.Deployed",
    DeviceDeploymentStatus.fromJsonFunction,
  );
  FromJsonFactory.registerFromJsonFunction(
    "dk.cachet.carp.deployment.domain.DeviceDeploymentStatus.NeedsRedeployment",
    DeviceDeploymentStatus.fromJsonFunction,
  );
  FromJsonFactory.registerFromJsonFunction("dk.cachet.carp.protocols.domain.devices.Smartphone", DeviceDescriptor.fromJsonFunction);

  FromJsonFactory.registerFromJsonFunction("dk.cachet.carp.protocols.domain.MasterDeviceDeployment", MasterDeviceDeployment.fromJsonFunction);
  FromJsonFactory.registerFromJsonFunction("dk.cachet.carp.protocols.domain.devices.DeviceRegistration", DeviceRegistration.fromJsonFunction);
  FromJsonFactory.registerFromJsonFunction("dk.cachet.carp.protocols.domain.tasks.TaskDescriptor", TaskDescriptor.fromJsonFunction);
  FromJsonFactory.registerFromJsonFunction("dk.cachet.carp.protocols.domain.triggers.TriggerDescriptor", TriggerDescriptor.fromJsonFunction);
  FromJsonFactory.registerFromJsonFunction("dk.cachet.carp.protocols.domain.triggers.TriggeredTask", TriggeredTask.fromJsonFunction);
}

/// Provide a deployment endpoint reference to a CARP web service. Used to:
/// - get a deployment configuration for a master device (typically a phone)
/// - set deployment success status
/// - query deployment status
/// - register and unregister this device as part of a deployment
class DeploymentReference extends CarpReference {
  /// The CARP study deployment ID.
  String get studyDeploymentId => service.app.study.deploymentId;

  /// The device role name for this master device.
  ///
  /// Default name is `phone`.
  String masterDeviceRoleName = 'Master';

  /// The role name of this device as registered at CARP.
  String deviceRoleName;

  /// The registration at the CARP server, once this is done.
  DeviceRegistration registration;

  DeploymentReference._(CarpService service, [this.masterDeviceRoleName = 'Master']) : super._(service) {
    this.masterDeviceRoleName ??= 'Master';
  }

  /// The URL for the deployment endpoint for this [DeploymentReference].
  ///
  /// {{PROTOCOL}}://{{SERVER_HOST}}:{{SERVER_PORT}}/api/deployments
  String get deploymentEndpointUri => "${service.app.uri.toString()}/api/deployments";

  /// The URL for the deployment status endpoint for this [DeploymentReference].
  ///
  /// {{PROTOCOL}}://{{SERVER_HOST}}:{{SERVER_PORT}}/api/deployments?deploymentId={{DEPLOYMENT_ID}}
  String get deploymentStatusEndpointUri => "$deploymentEndpointUri?deploymentId=$studyDeploymentId";

  /// The URL for the device deployment endpoint for this [DeploymentReference].
  ///
  /// {{PROTOCOL}}://{{SERVER_HOST}}:{{SERVER_PORT}}/api/deployments/{{DEPLYOMENT_ID}}/devices?masterDeviceRoleName=phone
  String get deviceDeploymentEndpointUri => "$deploymentEndpointUri/$studyDeploymentId/devices?masterDeviceRoleName=$masterDeviceRoleName";

  /// The URL for the deployment RPC endpoint for this [DeploymentReference].
  ///
  /// {{PROTOCOL}}://{{SERVER_HOST}}:{{SERVER_PORT}}/api/deployments/all
  String get deploymentRPCEndpointUri => "${service.app.uri.toString()}/api/deployments/all";

  /// A generic RPC request to the CARP Server.
  Future<Map<String, dynamic>> _rpc(DeploymentServiceRequest request) async {
    final restHeaders = await headers;
    final String body = _encode(request.toJson());

    print('REQUEST:\n$body');

    http.Response response = await httpr.post(Uri.encodeFull(deploymentRPCEndpointUri), headers: restHeaders, body: body);
    int httpStatusCode = response.statusCode;
    Map<String, dynamic> responseJson = json.decode(response.body);

    print('RESPONSE:\n$httpStatusCode\n${response.body}');

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

  /// Register this device for this deployment at the CARP server.
  ///  * [deviceRoleName] - the role name of this device, e.g. `phone`.
  ///  * [deviceId] - a unique ID for this device.
  ///
  /// Returns the updated study deployment status if the registration is successful.
  /// Throws a [CarpServiceException] if not.
  Future<StudyDeploymentStatus> registerDevice(String deviceRoleName, String deviceId) async {
    assert(deviceRoleName != null, 'deviceRoleName has to be specified when registering a device in CARP.');
    assert(deviceId != null, 'deviceId has to be specified when registering a device in CARP.');
    this.deviceRoleName = deviceRoleName;

    print('device role name: ${this.deviceRoleName}, $deviceRoleName');
    registration = DeviceRegistration(deviceId: deviceId);
    return StudyDeploymentStatus.fromJson(await _rpc(RegisterDevice(studyDeploymentId, deviceRoleName, registration)));
  }

  /// Unregister this device for this deployment at the CARP server.
  ///
  /// Returns the updated study deployment status if the registration is successful.
  /// Throws a [CarpServiceException] if not.
  Future<StudyDeploymentStatus> unRegisterDevice() async => StudyDeploymentStatus.fromJson(await _rpc(UnregisterDevice(studyDeploymentId, deviceRoleName)));

  /// Get the deployment for this [DeploymentReference] for the specified [masterDeviceRoleName].
  /// Default to `Master` if not specified.
  Future<MasterDeviceDeployment> get([String masterDeviceRoleName]) async {
    if (masterDeviceRoleName != null) this.masterDeviceRoleName = masterDeviceRoleName;
    return MasterDeviceDeployment.fromJson(await _rpc(GetDeviceDeploymentFor(studyDeploymentId, this.masterDeviceRoleName)));
  }

  /// Mark this deployment as a success on the server.
  Future<StudyDeploymentStatus> success() async => StudyDeploymentStatus.fromJson(await _rpc(DeploymentSuccessful(studyDeploymentId, masterDeviceRoleName)));
}
