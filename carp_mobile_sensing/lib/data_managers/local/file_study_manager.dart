/*
 * Copyright 2020 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of managers;

/// Retrieve and store [Study] json definitions on the device's local file system.
///
/// The path and filename format is
///
///   `carp/study/study-<study_id>.json`
///
class FileStudyManager implements StudyManager {
  /// The path to use on the device for storing CARP study files.
  static const String CARP_STUDY_FILE_PATH = 'carp/study';

  String _path;

  /// Initializing the the local study manager
  Future initialize() async {
    final _studyPath = await path;

    info('Initializing FileStudyManager...');
    info('Study file path : $_studyPath');
  }

  /// Get a study stored on the local file system.
  Future<Study> getStudy(String studyId) async {
    info("Loading study '$studyId'.");
    Study study;

    try {
      String jsonString = File(filename(studyId)).readAsStringSync();
      study = Study.fromJson(json.decode(jsonString) as Map<String, dynamic>);
    } catch (exception) {
      warning("Failed to load study '$studyId' - $exception");
    }
    return study;
  }

  /// Save a study on the local file system.
  /// Returns `true` if successful.
  Future<bool> saveStudy(Study study) async {
    bool success = true;
    info("Saving study '${study.id}}'.");
    try {
      final json = jsonEncode(study);
      File(filename(study.id)).writeAsStringSync(json);
    } catch (exception) {
      success = false;
      warning("Failed to save study '${study.id}' - $exception");
    }
    return success;
  }

  ///Returns the local study path on the device where studies are stored.
  Future<String> get path async {
    if (_path == null) {
      // get local working directory
      final localApplicationDir = await getApplicationDocumentsDirectory();
      // create a sub-directory for storing studies
      final directory =
          await Directory('${localApplicationDir.path}/$CARP_STUDY_FILE_PATH')
              .create(recursive: true);
      _path = directory.path;
    }
    return _path;
  }

  /// Current path and filename according to this format:
  ///
  ///   `carp/study/study-<study_id>.json`
  ///
  String filename(String studyId) => '$_path/study-$studyId.json';
}
