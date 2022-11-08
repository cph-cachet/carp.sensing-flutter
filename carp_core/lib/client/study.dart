/*
 * Copyright 2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_core_client;

/// A study deployment, identified by [studyDeploymentId], which a client
/// device participates in with the role [deviceRoleName].
class Study {
  /// The ID of the deployed study for which to collect data.
  String studyDeploymentId;

  /// The role name of the device in the deployment this study runtime participates in.
  String deviceRoleName;

  Study(this.studyDeploymentId, this.deviceRoleName);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Study &&
          runtimeType == other.runtimeType &&
          studyDeploymentId == other.studyDeploymentId &&
          deviceRoleName == other.deviceRoleName;

  @override
  int get hashCode => (studyDeploymentId + deviceRoleName).hashCode;

  @override
  String toString() =>
      '$runtimeType - studyDeploymentId: $studyDeploymentId, deviceRoleName: $deviceRoleName';
}

/// Describes the possible status' of a [StudyRuntime].
enum StudyStatus {
  /// The study deployment process hasn't been started yet.
  DeploymentNotStarted,

  /// The study deployment process is ongoing, but not yet completed.
  /// The state of the deployment can be tracked using [deploymentStatus].
  Deploying,

  /// The study deployment is ready to deliver the deployment information to
  /// this primary device.
  AwaitingDeviceDeployment,

  /// Deployment information has been received.
  DeploymentReceived,

  /// Deployment can complete after [remainingDevicesToRegister] have been registered.
  RegisteringDevices,

  /// Study runtime status when deployment has been successfully completed.
  /// The [MasterDeviceDeployment] has been retrieved and all necessary plugins
  /// to execute the study have been loaded.
  Deployed,

  /// The study is resumed and is sampling data.
  Running,

  /// The deployment has been stopped, either by this client or researcher.
  Stopped,
}