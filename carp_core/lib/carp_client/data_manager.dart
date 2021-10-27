/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_core_client;

/// The [DataManager] interface is used to upload [DataPoint] objects to any
/// data manager that implements this interface.
abstract class DataManager {
  /// The deployment using this data manager
  MasterDeviceDeployment get deployment;

  /// The ID of the study deployment that this manager is handling.
  String get studyDeploymentId;

  /// The type of this data manager as enumerated in [DataEndPointType].
  String get type;

  /// Initialize the data manager by specifying the study [deployment], the
  /// [dataEndPoint], and the stream of [data] events to handle.
  Future initialize(
    MasterDeviceDeployment deployment,
    DataEndPoint dataEndPoint,
    Stream<DataPoint> data,
  );

  /// Close the data manager (e.g. closing connections).
  Future close();

  /// Stream of data manager events.
  Stream<DataManagerEvent> get events;

  /// On each data event from the data stream, the [onDataPoint] handler is called.
  void onDataPoint(DataPoint dataPoint);

  /// When the data stream closes, the [onDone] handler is called.
  void onDone();

  /// When an error event is send on the stream, the [onError] handler is called.
  void onError(error);
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
