/*
 * Copyright 2024 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of carp_movesense_package;

abstract class _MovesenseProbe extends StreamProbe {
  @override
  MovesenseDeviceManager get deviceManager =>
      super.deviceManager as MovesenseDeviceManager;
}

/// A probe collecting [MovesenseStateChange] events.
/// See [MovesenseDeviceState] for an enumeration of possible states.
class MovesenseStateChangeProbe extends _MovesenseProbe {
  // TODO - include ALL state events in a stream group
  @override
  Stream<Measurement>? get stream => (deviceManager.isConnected)
      ? MdsAsync.subscribe(
              Mds.createSubscriptionUri(
                  deviceManager.serial, "/System/States/0"),
              "{}")
          .map((event) => Measurement.fromData(
              MovesenseStateChange.fromMovesenseData(event)))
          .asBroadcastStream()
      : null;
}

/// A probe collecting [MovesenseHR] events.
class MovesenseHRProbe extends _MovesenseProbe {
  @override
  Stream<Measurement>? get stream => (deviceManager.isConnected)
      ? MdsAsync.subscribe(
              Mds.createSubscriptionUri(deviceManager.serial, "/Meas/HR"), "{}")
          .map((event) =>
              Measurement.fromData(MovesenseHR.fromMovesenseData(event)))
          .asBroadcastStream()
      : null;
}

/// A probe collecting [MovesenseECG] events at 125 Hz.
class MovesenseECGProbe extends _MovesenseProbe {
  @override
  Stream<Measurement>? get stream => (deviceManager.isConnected)
      ? MdsAsync.subscribe(
              Mds.createSubscriptionUri(deviceManager.serial, "/Meas/ECG/125"),
              "{}")
          .map((event) {
          var data = MovesenseECG.fromMovesenseData(event);
          return Measurement.fromData(data, data.timestamp * 1000);
        }).asBroadcastStream()
      : null;
}
