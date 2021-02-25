/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of managers;

/// A local (in-memory) implementation of a [DeploymentService].
class LocalDeploymentService implements DeploymentService {
  @override
  Future<StudyDeploymentStatus> createStudyDeployment(StudyProtocol protocol) {
    // TODO: implement createStudyDeployment
    throw UnimplementedError();
  }

  @override
  Future<StudyDeploymentStatus> deploymentSuccessful(
      String studyDeploymentId, String masterDeviceRoleName,
      {DateTime deviceDeploymentLastUpdateDate}) {
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

  @override
  StudyDeploymentStatus getStudyDeploymentStatus(String studyDeploymentId) {
    // TODO: implement getStudyDeploymentStatus
    throw UnimplementedError();
  }

  @override
  Future initialize() {
    // TODO: implement initialize
    throw UnimplementedError();
  }

  @override
  Future<StudyDeploymentStatus> registerDevice(String studyDeploymentId,
      String deviceRoleName, DeviceRegistration registration) {
    // TODO: implement registerDevice
    throw UnimplementedError();
  }

  @override
  Future<Set<String>> removeStudyDeployments(Set<String> studyDeploymentIds) {
    // TODO: implement removeStudyDeployments
    throw UnimplementedError();
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
