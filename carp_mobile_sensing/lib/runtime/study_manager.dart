/*
 * Copyright 2020 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of runtime;

/// An interface defining a manger of a [StudyProtocol].
///
/// Is mainly used to get and save a [StudyProtocol].
/// See [FileStudyProtocol] for an implementation which can load and save
/// study json configurations on the local file system.
abstract class StudyProtocolManager {
  /// Initialize the study manager.
  Future initialize();

  /// Get a [StudyProtocol] based on its ID.
  Future<StudyProtocol?> getStudyProtocol(String studyId);

  /// Save a [StudyProtocol] with the ID [studyId].
  /// Returns `true` if successful, `false` otherwise.
  Future<bool> saveStudyProtocol(String studyId, StudyProtocol protocol);
}
