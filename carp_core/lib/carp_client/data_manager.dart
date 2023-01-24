/*
 * Copyright 2021-2023 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_core_client;

/// The [DataManager] interface is used to upload [DataPoint] data to any
/// data manager that implements this interface.
///
/// Note that each instance of a data manager supports one deployment
/// ([MasterDeviceDeployment]). A data manager should hence be able to handle
/// separate data management of concurrently running deployments.
/// Hence, caution on resource starvation should be considered, such as not
/// accessing the same file or network socket.
abstract class DataManager {
  /// The deployment using this data manager.
  MasterDeviceDeployment get deployment;

  /// The type of this data manager as enumerated in [DataEndPointTypes].
  String get type;

  /// Initialize the data manager by specifying the [dataEndPoint], study
  /// [deployment], and the stream of [data] events to handle.
  Future<void> initialize(
    DataEndPoint dataEndPoint,
    MasterDeviceDeployment deployment,
    Stream<DataPoint> data,
  );

  /// Flush any buffered data and close this data manager.
  /// After calling [close] the data manager can no longer be used.
  Future<void> close();

  /// Stream of data manager events.
  Stream<DataManagerEvent> get events;

  /// On each data event from the data stream, the [onDataPoint] handler is
  /// called. Implementations of this interface should handle how to save
  /// or upload the [dataPoint].
  Future<void> onDataPoint(DataPoint dataPoint);

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

/// An enumeration of data manager event types.
class DataManagerEventTypes {
  static const String INITIALIZED = 'INITIALIZED';
  static const String CLOSED = 'CLOSED';
}
