/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of carp_core;

/// The [DataManager] interface is used to upload [Datum] objects to any
/// data manager that implements this interface.
abstract class DataManager {
  /// Initialize the data manager by specifying the running [Study].
  Future<void> initialize(Study study);

  /// Upload data to the data store.
  /// Returns [true] if data was successfully uploaded; [false] otherwise.
  Future<bool> uploadData(Datum data);

  /// Close the data manager (e.g. closing connections).
  Future<void> close();
}

/// An abstract [DataManager] implementation useful for extension.
/// Also supports JSON encoding.
abstract class AbstractDataManager implements DataManager {
  Study study;

  Future<void> initialize(Study study) async {
    assert(study != null);
    this.study = study;
  }

  /// JSON encode an object.
  String jsonEncode(Object object) => const JsonEncoder.withIndent(' ').convert(object);
}

/// A registry of [DataManager]s.
///
/// When creating a new [DataManager] you can register it here using the [register] method
/// which is later used to call [lookup] when trying to find an appropriate [DataManager] for
/// a specific [DataEndPointType].
class DataManagerRegistry {
  static Map<String, DataManager> _registry = new Map<String, DataManager>();

  /// Register a [DataManager] with a specific type.
  static register(String type, DataManager manager) {
    _registry[type] = manager;
  }

  /// Lookup an instance of a [DataManager] based on the [DataEndPointType].
  static DataManager lookup(String type) {
    return _registry[type];
  }
}

/// An interface for defining a way to get a [Study].
abstract class StudyManager {
  /// Initialize the study manager.
  Future<void> initialize();

  /// Get a [Study] based on its ID.
  Future<Study> getStudy(String studyId);
}
