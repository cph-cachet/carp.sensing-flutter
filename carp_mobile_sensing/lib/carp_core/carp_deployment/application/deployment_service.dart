/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of carp_core_application;

/// Application service which allows deploying [StudyProtocol]s and
/// retrieving [MasterDeviceDeployment]s for participating master devices as
/// defined in the protocol.
///
/// Is mainly used to get and save a [StudyProtocol].
/// See [FileDeploymentService] for an implementation which can load and save
/// study json configurations on the local file system.
abstract class DeploymentService {
  /// Initialize the deployment service.
  Future initialize();

  /// Instantiate a study deployment for a given [StudyProtocolSnapshot].
  Future<StudyDeploymentStatus> createStudyDeployment(StudyProtocol protocol);

  /// Remove study deployments with the given [studyDeploymentIds].
  ///
  /// Returns the IDs of study deployments which were removed.
  /// IDs for which no study deployment exists are ignored.
  Future<Set<String>> removeStudyDeployments(Set<String> studyDeploymentIds);

  /// Get the status for a study deployment with the given [studyDeploymentId].
  Future<StudyDeploymentStatus> getStudyDeploymentStatus(
      String studyDeploymentId);

  /// Register the device with the specified [deviceRoleName] for the study
  /// deployment with [studyDeploymentId].
  ///
  /// [registration] is a matching configuration for the device with [deviceRoleName].
  Future<StudyDeploymentStatus> registerDevice(String studyDeploymentId,
      String deviceRoleName, DeviceRegistration registration);

  /// Unregister the device with the specified [deviceRoleName] for the study
  /// deployment with [studyDeploymentId].
  Future<StudyDeploymentStatus> unregisterDevice(
      String studyDeploymentId, String deviceRoleName);

  /// Get the deployment configuration for the master device with
  /// [masterDeviceRoleName] in the study deployment with [studyDeploymentId].
  Future<MasterDeviceDeployment> getDeviceDeploymentFor(
      String studyDeploymentId,
      {String masterDeviceRoleName});

  /// Indicate to stakeholders in the study deployment with [studyDeploymentId] that the device with [masterDeviceRoleName] was deployed successfully,
  /// using the deployment with the specified [deviceDeploymentLastUpdateDate],
  /// i.e., that the study deployment was loaded on the device and that the necessary runtime is available to run it.
  Future<StudyDeploymentStatus> deploymentSuccessful(
    String studyDeploymentId, {
    String masterDeviceRoleName,
    DateTime deviceDeploymentLastUpdateDate,
  });

  /// Stop the study deployment with the specified [studyDeploymentId].
  /// No further changes to this deployment will be allowed and no more data
  /// will be collected.
  Future<StudyDeploymentStatus> stop(String studyDeploymentId);
}
