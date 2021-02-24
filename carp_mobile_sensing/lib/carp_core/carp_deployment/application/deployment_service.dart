/*
 * Copyright 2020 Copenhagen Center for Health Technology (CACHET) at the
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
  /// Initialize the study manager.
  Future initialize();

  /// Get a [StudyProtocol] based on the study deployment ID.
  Future<StudyProtocol> getDeviceDeploymentFor(String studyDeploymentId);

  /// Save a [StudyProtocol].
  /// Returns `true` if successful, `false` otherwise.
  Future<bool> saveStudy(StudyProtocol study);
}
