/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of managers;

/// A local (in-memory) implementation of a [DeploymentService].
class LocalDeploymentService implements DeploymentService {
  final Map<String, StudyDeployment> repository = {};

  @override
  Future initialize() {
    // TODO: implement initialize
    throw UnimplementedError();
  }

  Future<StudyDeploymentStatus> createStudyDeployment(
      StudyProtocol protocol) async {
    StudyDeployment deployment = StudyDeployment(protocol);
    repository[deployment.studyDeploymentId] = deployment;
    return deployment.status;
  }

  @override
  Future<StudyDeploymentStatus> deploymentSuccessful(
    String studyDeploymentId, {
    String masterDeviceRoleName,
    DateTime deviceDeploymentLastUpdateDate,
  }) {
    // TODO: implement deploymentSuccessful
    throw UnimplementedError();
  }

  @override
  Future<MasterDeviceDeployment> getDeviceDeploymentFor(
      String studyDeploymentId,
      {String masterDeviceRoleName}) {
    // TODO: implement getDeviceDeploymentFor
    throw UnimplementedError();
  }

  Future<StudyDeploymentStatus> getStudyDeploymentStatus(
          String studyDeploymentId) async =>
      repository[studyDeploymentId]?.status;

  @override
  Future<StudyDeploymentStatus> registerDevice(String studyDeploymentId,
      String deviceRoleName, DeviceRegistration registration) async {
    StudyDeployment deployment = repository[studyDeploymentId];
    DeviceDescriptor device = DeviceDescriptor();
    // TODO - inclde this
    // getRegistrableDevice(deployment, deviceRoleName).device;

    // Early out when the device is already registered.
    if (deployment.registeredDevices.contains(deviceRoleName))
      return deployment.status;

    // Register device and save/distribute changes.
    deployment.registerDevice(device, registration);

    // repository.update( deployment )
    // val registered = DeploymentService.Event.DeviceRegistrationChanged( studyDeploymentId, device, registration )
    // eventBus.publish( registered )

    return deployment.status;
  }

  Future<Set<String>> removeStudyDeployments(
      Set<String> studyDeploymentIds) async {
    Set<String> removedKeys = {};
    studyDeploymentIds.forEach((key) {
      if (repository.containsKey(key)) {
        repository.remove(key);
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

  //   RegistrableDevice _getRegistrableDevice( StudyDeployment deployment , String deviceRoleName)
  // {
  //     return deployment.registrableDevices.firstOrNull { it.device.roleName == deviceRoleName }
  //         ?: throw IllegalArgumentException( "A device with the role name '$deviceRoleName' could not be found in the study deployment." )
  // }
}
