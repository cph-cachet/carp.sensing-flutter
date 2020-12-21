/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of runtime;

/// The [DataManager] interface is used to upload [Datum] objects to any
/// data manager that implements this interface.
abstract class DataManager {
  /// The type of this data manager as enumerated in [DataEndPointType].
  String get type;

  /// Initialize the data manager by specifying the running [Study]
  /// and the stream of [Datum] events to handle.
  Future initialize(Study study, Stream<Datum> data);

  /// Close the data manager (e.g. closing connections).
  Future close();

  /// Stream of data manager events.
  Stream<DataManagerEvent> get events;

  /// On each data event from the data stream, the [onDatum] handler is called.
  void onDatum(Datum datum);

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

  StreamController<DataManagerEvent> controller = StreamController.broadcast();
  Stream<DataManagerEvent> get events => controller.stream;
  void addEvent(DataManagerEvent event) => controller.add(event);

  Future initialize(Study study, Stream<Datum> data) async {
    this.study = study;
    data.listen(onDatum, onError: onError, onDone: onDone);
    addEvent(DataManagerEvent(DataManagerEventTypes.INITIALIZED));
  }

  Future close() async =>
      addEvent(DataManagerEvent(DataManagerEventTypes.CLOSED));

  void onDatum(Datum datum);
  void onDone();
  void onError(error);

  /// JSON encode an object.
  String jsonEncode(Object object) =>
      const JsonEncoder.withIndent(' ').convert(object);
}

/// A registry of [DataManager]s.
///
/// When creating a new [DataManager] you can register it here using the
/// [register] method which is later used to call [lookup] when trying to find
/// an appropriate [DataManager] for a specific [DataEndPointType].
class DataManagerRegistry {
  static final DataManagerRegistry _instance = DataManagerRegistry._();

  DataManagerRegistry._();

  /// Get the singleton [DataManagerRegistry].
  factory DataManagerRegistry() => _instance;

  final Map<String, DataManager> _registry = {};

  /// Register a [DataManager] with a specific type.
  void register(DataManager manager) {
    _registry[manager.type] = manager;
  }

  /// Lookup an instance of a [DataManager] based on the [DataEndPointType].
  DataManager lookup(String type) {
    return _registry[type];
  }
}

/// An interface defining a manger of a [Study].
///
/// Is mainly used to get and save a [Study].
abstract class StudyManager {
  /// Initialize the study receiver.
  Future initialize();

  /// Get a [Study] based on its ID.
  Future<Study> getStudy(String studyId);

  /// Save a [Study].
  /// Returns `true` if successful, `false` otherwise.
  Future<bool> saveStudy(Study study);
}

/// An event for a data manager.
class DataManagerEvent {
  /// The event type, see [DataManagerEventTypes].
  String type;

  /// Create a [DataManagerEvent].
  DataManagerEvent(this.type);

  String toString() => 'DataManagerEvent - type: $type';
}

/// An enumeration of data manager event types
class DataManagerEventTypes {
  /// DATA MANAGER INITIALIZED event
  static const String INITIALIZED = 'initialized';

  /// DATA MANAGER CLOSED event
  static const String CLOSED = 'closed';
}
