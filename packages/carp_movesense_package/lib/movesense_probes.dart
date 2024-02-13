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

class MovesenseHRProbe extends _MovesenseProbe {
  @override
  Stream<Measurement>? get stream => (deviceManager.isConnected)
      ? MdsAsync.subscribe(
              Mds.createSubscriptionUri(deviceManager.serial, "/Meas/HR"), "{}")
          .map((event) =>
              Measurement.fromData(MovesenseECG.fromMovesenseData(event)))
          .asBroadcastStream()
      : null;
}

/// Collects ECG data from the Movesense device.
class MovesenseECGProbe extends _MovesenseProbe {
  @override
  Stream<Measurement>? get stream => (deviceManager.isConnected)
      ? MdsAsync.subscribe(
              Mds.createSubscriptionUri(deviceManager.serial, "/Meas/ECG/125"),
              "{}")
          .map((event) =>
              Measurement.fromData(MovesenseECG.fromMovesenseData(event)))
          .asBroadcastStream()
      : null;
}
