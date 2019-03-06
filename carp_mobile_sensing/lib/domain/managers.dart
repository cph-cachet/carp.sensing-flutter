/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of core;

/// The [DataManager] interface is used to upload [Datum] objects to any
/// data manager that implements this interface.
abstract class DataManager {
  /// Initialize the data manager by specifying the running [Study]
  /// and the stream of [Datum] events to handle.
  Future<void> initialize(Study study, Stream<Datum> events);

  /// Close the data manager (e.g. closing connections).
  Future<void> close();

  // Stream handlers below

  /// On each data event from the data stream, the [onData] handler is called.
  void onData(Datum datum);

  /// When the data stream closes, the [onDone] handler is called.
  void onDone();

  /// When an error event is send on the stream, the [onError] handler is called.
  void onError(error);
}

/// An abstract [DataManager] implementation useful for extension.
///
/// Takes data from a [Stream] and uploads these. Also supports JSON encoding.
abstract class AbstractDataManager implements DataManager {
  Study study;

  Future<void> initialize(Study study, Stream<Datum> events) async {
    this.study = study;
    events.listen(onData, onError: onError, onDone: onDone);
  }

  void onData(Datum datum);
  void onDone();
  void onError(error);

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

/// An interface defining a way to get a [Study].
abstract class StudyManager {
  /// Initialize the study receiver.
  Future<void> initialize();

  /// Get a [Study] based on its ID.
  Future<Study> getStudy(String studyId);
}
