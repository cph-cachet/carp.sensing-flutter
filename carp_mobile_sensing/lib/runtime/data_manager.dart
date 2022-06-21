/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of runtime;

/// An abstract [DataManager] implementation useful for extension.
///
/// Takes data from a [Stream<DataPoint>] and uploads these.
/// Also supports JSON encoding via the [toJsonString] method.
abstract class AbstractDataManager implements DataManager {
  late SmartphoneDeployment _deployment;
  SmartphoneDeployment get deployment => _deployment;
  String get studyDeploymentId => deployment.studyDeploymentId;
  DataEndPoint? _dataEndPoint;
  DataEndPoint? get dataEndPoint => _dataEndPoint;

  StreamController<DataManagerEvent> controller = StreamController.broadcast();
  Stream<DataManagerEvent> get events => controller.stream;

  /// Add [event] to the [events] stream.
  @mustCallSuper
  void addEvent(DataManagerEvent event) => controller.add(event);

  @override
  @mustCallSuper
  Future<void> initialize(
    MasterDeviceDeployment deployment,
    DataEndPoint dataEndPoint,
    Stream<DataPoint> data,
  ) async {
    assert(deployment is SmartphoneDeployment,
        'Deployment must be a SmartphoneDeployment');
    _deployment = deployment as SmartphoneDeployment;
    _dataEndPoint = dataEndPoint;
    data.listen(
      (dataPoint) => onDataPoint(dataPoint),
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
