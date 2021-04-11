/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_services;

/// A [DeploymentService] that talks to the CARP Nervous System (CANS), i.e.,
/// the CARP backend server(s).
class CANSDeploymentService implements DeploymentService {
  static CANSDeploymentService _instance = CANSDeploymentService._();

  CANSDeploymentService._();

  /// Returns the singleton default instance of the [CANSDeploymentService].
  /// Before this instance can be used, it must be configured using the [configure] method.
  factory CANSDeploymentService() => _instance;

  /// Has this service been configured?
  bool get isConfigured => CarpService().isConfigured;

  /// Configure the default instance of the [CarpService].
  void configure(CarpApp app) async => CarpService().configure(app);

  /// Create a new deployment in CANS based on a [StudyProtocol].
  /// The [studyDeploymentId] is ignored, since CANS generated its own
  /// study deployment id.
  Future<StudyDeploymentStatus> createStudyDeployment(
    StudyProtocol protocol, [
    String studyDeploymentId,
  ]) async =>
      await CarpService().createStudyDeployment(protocol);

  Future<Set<String>> removeStudyDeployments(Set<String> studyDeploymentIds) =>
      throw CarpServiceException(
          message:
              'Removing study deployments is not supported from the client side.');

  Future<StudyDeploymentStatus> getStudyDeploymentStatus(
          String studyDeploymentId) async =>
      await CarpService().deployment(studyDeploymentId).getStatus();

  Future<StudyDeploymentStatus> registerDevice(
    String studyDeploymentId,
    String deviceRoleName,
    DeviceRegistration registration,
  ) async =>
      await CarpService().deployment(studyDeploymentId).registerDevice(
          deviceRoleName: deviceRoleName, deviceId: registration.deviceId);

  Future<StudyDeploymentStatus> unregisterDevice(
          String studyDeploymentId, String deviceRoleName) async =>
      await CarpService()
          .deployment(studyDeploymentId)
          .unRegisterDevice(deviceRoleName: deviceRoleName);

  Future<MasterDeviceDeployment> getDeviceDeploymentFor(
          String studyDeploymentId, String masterDeviceRoleName) async =>
      await CarpService().deployment(studyDeploymentId).get();

  Future<StudyDeploymentStatus> deploymentSuccessfulFor(
          String studyDeploymentId, String masterDeviceRoleName,
          {DateTime deviceDeploymentLastUpdateDate}) async =>
      await CarpService().deployment(studyDeploymentId).success();

  Future<StudyDeploymentStatus> stop(String studyDeploymentId) =>
      throw CarpServiceException(
          message:
              'Stopping study deployments is not supported from the client side.');
}
