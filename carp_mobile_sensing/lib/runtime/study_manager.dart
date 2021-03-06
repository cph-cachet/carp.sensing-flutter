/*
 * Copyright 2020 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of runtime;

/// An interface defining a manger of a [Study].
///
/// Is mainly used to get and save a [Study].
/// See [FileStudyManager] for an implementation which can load and save
/// study json configurations on the local file system.
abstract class StudyManager {
  /// Initialize the study manager.
  Future initialize();

  /// Get a [Study] based on its ID.
  Future<Study> getStudy(String studyId);

  /// Save a [Study].
  /// Returns `true` if successful, `false` otherwise.
  Future<bool> saveStudy(Study study);
}
