/*
 * Copyright 2018-2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of runtime;

/// The [DataManager] interface is used to upload [Measurement] objects to any
/// data manager that implements this interface.
abstract class DataManager {
  /// The deployment using this data manager
  PrimaryDeviceDeployment get deployment;

  /// The ID of the study deployment that this manager is handling.
  String get studyDeploymentId;

  /// The type of this data manager as enumerated in [DataEndPointTypes].
  String get type;

  /// Initialize the data manager by specifying the study [deployment], the
  /// [dataEndPoint], and the stream of [measurements] events to handle.
  Future<void> initialize(
    PrimaryDeviceDeployment deployment,
    DataEndPoint dataEndPoint,
    Stream<Measurement> measurements,
  );

  /// Close the data manager (e.g. closing connections).
  Future<void> close();

  /// Stream of data manager events.
  Stream<DataManagerEvent> get events;

  /// On each measurement collected, the [onMeasurement] handler is called.
  Future<void> onMeasurement(Measurement measurement);

  /// When the data stream closes, the [onDone] handler is called.
  Future<void> onDone();

  /// When an error event is send on the stream, the [onError] handler is called.
  Future<void> onError(Object error);
}

/// An event for a data manager.
class DataManagerEvent {
  /// The event type, see [DataManagerEventTypes].
  String type;

  /// Create a [DataManagerEvent].
  DataManagerEvent(this.type);

  @override
  String toString() => 'DataManagerEvent - type: $type';
}

/// An enumeration of data manager event types
class DataManagerEventTypes {
  /// DATA MANAGER INITIALIZED event
  static const String INITIALIZED = 'initialized';

  /// DATA MANAGER CLOSED event
  static const String CLOSED = 'closed';
}

/// An abstract [DataManager] implementation useful for extension.
///
/// Takes data from a [Stream<DataPoint>] and uploads these.
/// Also supports JSON encoding via the [toJsonString] method.
abstract class AbstractDataManager implements DataManager {
  late SmartphoneDeployment _deployment;
  DataEndPoint? _dataEndPoint;
  DataEndPoint? get dataEndPoint => _dataEndPoint;

  StreamController<DataManagerEvent> controller = StreamController.broadcast();

  @override
  SmartphoneDeployment get deployment => _deployment;

  @override
  String get studyDeploymentId => deployment.studyDeploymentId;

  @override
  Stream<DataManagerEvent> get events => controller.stream;

  /// Add [event] to the [events] stream.
  @mustCallSuper
  void addEvent(DataManagerEvent event) => controller.add(event);

  @override
  @mustCallSuper
  Future<void> initialize(
    PrimaryDeviceDeployment deployment,
    DataEndPoint dataEndPoint,
    Stream<Measurement> measurements,
  ) async {
    assert(deployment is SmartphoneDeployment,
        'Deployment must be a SmartphoneDeployment');
    _deployment = deployment as SmartphoneDeployment;
    _dataEndPoint = dataEndPoint;
    measurements.listen(
      (dataPoint) => onMeasurement(dataPoint),
      onError: onError,
      onDone: onDone,
    );
    addEvent(DataManagerEvent(DataManagerEventTypes.INITIALIZED));
  }

  @override
  @mustCallSuper
  Future<void> close() async =>
      addEvent(DataManagerEvent(DataManagerEventTypes.CLOSED));

  /// Encode [object] to a JSON string.
  String toJsonString(Object object) =>
      const JsonEncoder.withIndent(' ').convert(object);

  @override
  String toString() => runtimeType.toString();
}

/// A registry of [DataManager]s.
///
/// When creating a new [DataManager] you can register it here using the
/// [register] method which is later used to call [lookup] when trying to find
/// an appropriate [DataManager] for a specific [DataEndPointTypes].
class DataManagerRegistry {
  static final DataManagerRegistry _instance = DataManagerRegistry._();

  DataManagerRegistry._();
  final Map<String, DataManager> _registry = {};

  /// Get the singleton [DataManagerRegistry].
  factory DataManagerRegistry() => _instance;

  /// Register a [DataManager].
  void register(DataManager manager) => _registry[manager.type] = manager;

  /// Lookup an instance of a [DataManager] based on the [type] as specified in
  /// [DataEndPointTypes].
  DataManager? lookup(String type) => _registry[type];
}
