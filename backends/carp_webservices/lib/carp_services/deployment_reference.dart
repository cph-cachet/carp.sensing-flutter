/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of carp_services;

/// Provides a reference to the deployment endpoint in a CARP web service that can
/// handle a specific [PrimaryDeviceDeployment].
///
/// According to CARP core, the protocol for using the
/// [deployment sub-system](https://github.com/cph-cachet/carp.core-kotlin/blob/develop/docs/carp-deployment.md) is:
///
///   - [status()] - get the study deployment status of this deployment.
///   - [registerDevice()] - register this device - and connected devices - in this deployment
///   - [get()] - get the deployment for this master device
///   - [success()] - report the deployment as successful
///   - [unRegisterDevice()] - unregister this - or other - device if no longer used
class DeploymentReference extends RPCCarpReference {
  /// The CARP study deployment ID.
  String studyDeploymentId;

  DeploymentReference._(CarpDeploymentService service, this.studyDeploymentId)
      : super._(service);

  PrimaryDeviceDeployment? _deployment;
  StudyDeploymentStatus? _status;

  /// The latest deployment status for this master device fetched from the server.
  /// Returns `null` if status is not yet fetched.
  StudyDeploymentStatus? get status => _status;

  /// The deployment for this master device, once fetched from the server.
  /// Returns `null` if the deployment is not yet fetched.
  PrimaryDeviceDeployment? get deployment => _deployment;

  /// The URL for the deployment endpoint.
  ///
  /// {{PROTOCOL}}://{{SERVER_HOST}}:{{SERVER_PORT}}/api/deployment-service
  @override
  String get rpcEndpointUri =>
      "${service.app!.uri.toString()}/api/deployment-service";

  String? _registeredDeviceId;

  /// A unique id for this device as registered at CARP.
  ///
  /// Uses the phone's unique hardware id, if available.
  /// Otherwise uses a v4 UUID.
  String get registeredDeviceId =>
      _registeredDeviceId ??= DeviceInfo().deviceID ?? Uuid().v4().toString();

  /// Get the deployment status for this [DeploymentReference].
  Future<StudyDeploymentStatus> getStatus() async =>
      _status = StudyDeploymentStatus.fromJson(
          await _rpc(GetStudyDeploymentStatus(studyDeploymentId)));

  /// Register a device for this deployment at the CARP server.
  ///  * [deviceRoleName] - the role name of the device, e.g. `phone`.
  ///  * [registration] - a unique id for the device.
  ///
  /// Returns the updated study deployment status if the registration is successful.
  /// Throws a [CarpServiceException] if not.
  Future<StudyDeploymentStatus> registerDevice({
    required String deviceRoleName,
    required DeviceRegistration registration,
  }) async {
    assert(deviceRoleName.length > 0,
        'deviceRoleName has to be specified when registering a device in CARP.');

    return _status = StudyDeploymentStatus.fromJson(await _rpc(RegisterDevice(
      studyDeploymentId,
      deviceRoleName,
      registration,
    )));
  }

  /// Register this device as the primary device for this deployment at the
  /// CARP server.
  ///
  /// Returns the updated study deployment status if the registration is successful.
  /// Throws a [CarpServiceException] if not.
  Future<StudyDeploymentStatus> registerPrimaryDevice() async {
    assert(
        status != null,
        'The status of a deployment must be know before a master device can be registered. '
        'Use the getStatus() method to get the deployment status');
    return registerDevice(
        deviceRoleName: status!.primaryDeviceStatus!.device.roleName,
        registration: DefaultDeviceRegistration(
          deviceId: DeviceInfo().deviceID,
          deviceDisplayName: DeviceInfo().toString(),
        ));
  }

  /// Unregister a device for this deployment at the CARP server.
  ///  * [deviceRoleName] - the role name of the device, e.g. `phone`.
  ///
  /// Returns the updated study deployment status if the registration is successful.
  /// Throws a [CarpServiceException] if not.
  Future<StudyDeploymentStatus> unRegisterDevice(
          {required String deviceRoleName}) async =>
      _status = StudyDeploymentStatus.fromJson(
          await _rpc(UnregisterDevice(studyDeploymentId, deviceRoleName)));

  /// Get the deployment for this [DeploymentReference] for the specified
  /// [masterDeviceRoleName].
  /// If [masterDeviceRoleName] is not specified, the previously used name is used.
  Future<PrimaryDeviceDeployment> get() async {
    assert(
        status != null,
        'The status of a deployment must be know before a master device can be registered. '
        'Use the getStatus() method to get the deployment status.');
    return _deployment = PrimaryDeviceDeployment.fromJson(await _rpc(
        GetDeviceDeploymentFor(
            studyDeploymentId, status!.primaryDeviceStatus!.device.roleName)));
  }

  /// Mark this deployment as a deployed on the server.
  ///
  /// Returns the updated study deployment status if successful.
  /// Throws a [CarpServiceException] if not.
  Future<StudyDeploymentStatus> deployed() async {
    assert(
        deployment != null,
        'The deployment needs to be fetched before a master device can mark it successful. '
        'Use the get() method to get the master device deployment.');

    return _status = StudyDeploymentStatus.fromJson(await _rpc(DeviceDeployed(
      studyDeploymentId,
      status!.primaryDeviceStatus!.device.roleName,
      status!.createdOn,
      // deployment!.lastUpdateDate ?? DateTime.now().toUtc(),
    )));
  }
}
