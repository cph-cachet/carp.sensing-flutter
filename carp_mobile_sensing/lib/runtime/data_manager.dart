/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of runtime;

// /// The [DataManager] interface is used to upload [DataPoint] objects to any
// /// data manager that implements this interface.
// abstract class DataManager {
//   /// The ID of the study deployment that this manager is handling.
//   String get studyDeploymentId;

//   /// The type of this data manager as enumerated in [DataEndPointType].
//   String get type;

//   /// Initialize the data manager by specifying the study deployment id, the
//   /// [DataEndPoint], and the stream of [DataPoint] events to handle.
//   Future initialize(
//     String studyDeploymentId,
//     DataEndPoint dataEndPoint,
//     Stream<DataPoint> data,
//   );

//   /// Close the data manager (e.g. closing connections).
//   Future close();

//   /// Stream of data manager events.
//   Stream<DataManagerEvent> get events;

//   /// On each data event from the data stream, the [onDataPoint] handler is called.
//   void onDataPoint(DataPoint dataPoint);

//   /// When the data stream closes, the [onDone] handler is called.
//   void onDone();

//   /// When an error event is send on the stream, the [onError] handler is called.
//   void onError(error);
// }

/// An abstract [DataManager] implementation useful for extension.
///
/// Takes data from a [Stream<DataPoint>] and uploads these. Also supports JSON encoding.
abstract class AbstractDataManager implements DataManager {
  String _studyDeploymentId;
  String get studyDeploymentId => _studyDeploymentId;
  DataEndPoint _dataEndPoint;
  DataEndPoint get dataEndPoint => _dataEndPoint;

  StreamController<DataManagerEvent> controller = StreamController.broadcast();
  Stream<DataManagerEvent> get events => controller.stream;
  void addEvent(DataManagerEvent event) => controller.add(event);

  Future initialize(
    String studyDeploymentId,
    DataEndPoint dataEndPoint,
    Stream<DataPoint> data,
  ) async {
    _dataEndPoint = dataEndPoint;
    _studyDeploymentId = studyDeploymentId;
    data.listen(
      (dataPoint) => onDataPoint(dataPoint),
      onError: onError,
      onDone: onDone,
    );
    addEvent(DataManagerEvent(DataManagerEventTypes.INITIALIZED));
  }

  Future close() async =>
      addEvent(DataManagerEvent(DataManagerEventTypes.CLOSED));

  void onDataPoint(DataPoint dataPoint);
  void onDone();
  void onError(error);

  /// Encode [object] to a JSON string.
  String toJsonString(Object object) =>
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
  void register(DataManager manager) => _registry[manager.type] = manager;

  /// Lookup an instance of a [DataManager] based on the [DataEndPointType].
  DataManager lookup(String type) {
    return _registry[type];
  }
}

// /// An event for a data manager.
// class DataManagerEvent {
//   /// The event type, see [DataManagerEventTypes].
//   String type;

//   /// Create a [DataManagerEvent].
//   DataManagerEvent(this.type);

//   String toString() => 'DataManagerEvent - type: $type';
// }

// /// An enumeration of data manager event types
// class DataManagerEventTypes {
//   /// DATA MANAGER INITIALIZED event
//   static const String INITIALIZED = 'initialized';

//   /// DATA MANAGER CLOSED event
//   static const String CLOSED = 'closed';
// }
