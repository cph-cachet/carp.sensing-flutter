/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of managers;

/// A local (in-memory) implementation of a [DeploymentService].
class LocalDeploymentService implements DeploymentService {
  /// A default rolename for this master phone device.
  static final String DEFAULT_MASTER_DEVICE_ROLENAME = 'phone';

  final Map<String, StudyDeployment> _repository = {};

  @override
  Future<void> initialize() {}

  Future<StudyDeploymentStatus> createStudyDeployment(
      StudyProtocol protocol) async {
    StudyDeployment deployment = StudyDeployment(protocol);
    _repository[deployment.studyDeploymentId] = deployment;
    return deployment.status;
  }

  @override
  Future<StudyDeploymentStatus> deploymentSuccessful(
    String studyDeploymentId,
    String masterDeviceRoleName, {
    DateTime deviceDeploymentLastUpdateDate,
  }) async {
    masterDeviceRoleName ??= DEFAULT_MASTER_DEVICE_ROLENAME;
    deviceDeploymentLastUpdateDate ??= DateTime.now();

    StudyDeployment deployment = _repository[studyDeploymentId];
    DeviceDescriptor device = deployment.registeredDevices.keys.firstWhere(
        (descriptor) => descriptor.roleName == masterDeviceRoleName);

    deployment.deviceDeployed(device, deviceDeploymentLastUpdateDate);

    return deployment.status;
  }

  @override
  Future<MasterDeviceDeployment> getDeviceDeploymentFor(
      String studyDeploymentId, String masterDeviceRoleName) async {
    masterDeviceRoleName ??= DEFAULT_MASTER_DEVICE_ROLENAME;
    StudyDeployment deployment = _repository[studyDeploymentId];
    DeviceDescriptor device = deployment.registeredDevices.keys.firstWhere(
        (descriptor) => descriptor.roleName == masterDeviceRoleName);

    return deployment.getDeviceDeploymentFor(device);
  }

  Future<StudyDeploymentStatus> getStudyDeploymentStatus(
          String studyDeploymentId) async =>
      _repository[studyDeploymentId]?.status;

  @override
  Future<StudyDeploymentStatus> registerDevice(String studyDeploymentId,
      String deviceRoleName, DeviceRegistration registration) async {
    StudyDeployment deployment = _repository[studyDeploymentId];
    DeviceDescriptor device = DeviceDescriptor();
    // TODO - inclde this
    // getRegistrableDevice(deployment, deviceRoleName).device;

    if (!deployment.registeredDevices.values.contains(deviceRoleName)) {
      // If not alreadu registered, register device
      deployment.registerDevice(device, registration);
    }
    return deployment.status;
  }

  Future<Set<String>> removeStudyDeployments(
      Set<String> studyDeploymentIds) async {
    Set<String> removedKeys = {};
    studyDeploymentIds.forEach((key) {
      if (_repository.containsKey(key)) {
        _repository.remove(key);
        removedKeys.add(key);
      }
    });
    return removedKeys;
  }

  @override
  Future<StudyDeploymentStatus> stop(String studyDeploymentId) {
    // TODO: implement stop
    throw UnimplementedError();
  }

  @override
  Future<StudyDeploymentStatus> unregisterDevice(
      String studyDeploymentId, String deviceRoleName) {
    // TODO: implement unregisterDevice
    throw UnimplementedError();
  }
}
