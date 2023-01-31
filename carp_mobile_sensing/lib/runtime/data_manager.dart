/*
 * Copyright 2018-2023 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of runtime;

/// A factory which can create a [DataManager] based on the `type` of an
/// [DataEndPoint].
abstract class DataManagerFactory {
  /// The [DataEndPoint] type.
  String get type;

  /// Create a [DataManager] that wraps [executor].
  DataManager create();
}

/// A registry of [DataManagerFactory]s.
///
/// In order to be able to create a new [DataManager], you must [register] a
/// [DataManagerFactory] here, which then later is used to call [create]
/// an appropriate [DataManager] for a specific [DataEndPoint] type.
class DataManagerRegistry {
  static final DataManagerRegistry _instance = DataManagerRegistry._();
  factory DataManagerRegistry() => _instance;
  final Map<String, DataManagerFactory> _registry = {};
  DataManagerRegistry._();

  /// Register a [DataManagerFactory] which can create a [DataManager] for
  /// a specific data endpoint type.
  void register(DataManagerFactory factory) =>
      _registry[factory.type] = factory;

  /// Register all [factories].
  /// A convenient way to call [register] for multiple types.
  void registerAll(List<DataManagerFactory> factories) {
    for (var factory in factories) {
      register(factory);
    }
  }

  DataManager? create(String type) => _registry[type]?.create();
}

/// An abstract [DataManager] implementation useful for extension.
abstract class AbstractDataManager implements DataManager {
  late SmartphoneDeployment _deployment;
  StreamSubscription? _subscription;
  DataEndPoint? _dataEndPoint;

  @override
  SmartphoneDeployment get deployment => _deployment;

  String get studyDeploymentId => deployment.studyDeploymentId;

  /// The [DataEndPoint] that this data manager is handling.
  /// Set in the [initialize] method.
  DataEndPoint? get dataEndPoint => _dataEndPoint;

  StreamController<DataManagerEvent> controller = StreamController.broadcast();

  @override
  @protected
  Stream<DataManagerEvent> get events => controller.stream;

  /// Add [event] to the [events] stream.
  @mustCallSuper
  @protected
  void addEvent(DataManagerEvent event) => controller.add(event);

  @override
  @mustCallSuper
  Future<void> initialize(
    DataEndPoint dataEndPoint,
    MasterDeviceDeployment deployment,
    Stream<DataPoint> data,
  ) async {
    assert(deployment is SmartphoneDeployment,
        'Deployment must be a SmartphoneDeployment');

    info('Initializing $runtimeType...');
    _deployment = deployment as SmartphoneDeployment;
    _dataEndPoint = dataEndPoint;

    _subscription = data.listen(
      (dataPoint) => onDataPoint(dataPoint),
      onError: onError,
      onDone: onDone,
    );

    // TODO - remove...
    events.listen((event) => debug('$runtimeType - $event'));
    addEvent(DataManagerEvent(DataManagerEventTypes.INITIALIZED));
  }

  /// When the data stream closes, the [onDone] handler is called.
  /// Default implementation is a no-op function. If another behavior is wanted,
  /// implementations of this abstract data manager should handle closing of
  /// the data stream.
  @override
  Future<void> onDone() async {}

  @override
  Future<void> onError(Object? error) async =>
      await onDataPoint(DataPoint.fromData(ErrorDatum(error.toString()))
        ..carpHeader.dataFormat = DataFormat.fromString(CAMSDataType.ERROR)
        ..carpHeader.studyId = deployment.studyDeploymentId
        ..carpHeader.userId = deployment.userId);

  @override
  @mustCallSuper
  Future<void> close() async {
    _subscription?.cancel();
    addEvent(DataManagerEvent(DataManagerEventTypes.CLOSED));
  }

  @override
  String toString() => runtimeType.toString();
}

// /// A registry of [DataManager]s.
// ///
// /// When creating a new [DataManager] you can register it here using the
// /// [register] method which is later used to call [lookup] when trying to find
// /// an appropriate [DataManager] for a specific [DataEndPointTypes].
// class DataManagerRegistry {
//   static final DataManagerRegistry _instance = DataManagerRegistry._();

//   DataManagerRegistry._();
//   final Map<String, DataManager> _registry = {};

//   /// Get the singleton [DataManagerRegistry].
//   factory DataManagerRegistry() => _instance;

//   /// Register a [DataManager].
//   void register(DataManager manager) => _registry[manager.type] = manager;

//   /// Lookup an instance of a [DataManager] based on the [type] as specified in
//   /// [DataEndPointTypes].
//   DataManager? lookup(String type) => _registry[type];
// }
