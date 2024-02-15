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
  // Stream<dynamic>? _movementStream;
  // Stream<dynamic>? _connectorStream;
  // Stream<dynamic>? _doubleTapStream;
  // Stream<dynamic>? _tapStream;
  // Stream<dynamic>? _fallStream;
  StreamGroup<dynamic>? _group;

  @override
  Stream<Measurement>? get stream {
    if (!deviceManager.isConnected) return null;

    if (_group == null) {
      debug('$runtimeType - creating stream group.');
      _group = StreamGroup();

      var movementStream = MdsAsync.subscribe(
          Mds.createSubscriptionUri(deviceManager.serial, "/System/States/0"),
          "{}");

      // var connectorStream = MdsAsync.subscribe(
      //     Mds.createSubscriptionUri(deviceManager.serial, "/System/States/2"),
      //     "{}");

      // var doubleTapStream = MdsAsync.subscribe(
      //     Mds.createSubscriptionUri(deviceManager.serial, "/System/States/3"),
      //     "{}");

      // var tapStream = MdsAsync.subscribe(
      //     Mds.createSubscriptionUri(deviceManager.serial, "/System/States/4"),
      //     "{}");

      // var fallStream = MdsAsync.subscribe(
      //     Mds.createSubscriptionUri(deviceManager.serial, "/System/States/5"),
      //     "{}");

      _group?..add(movementStream);
      //   ..add(connectorStream)
      //   ..add(doubleTapStream)
      //   ..add(tapStream)
      //   ..add(fallStream);
    }
    return _group?.stream
        .map((event) =>
            Measurement.fromData(MovesenseStateChange.fromMovesenseData(event)))
        .asBroadcastStream();
  }

  @override
  Future<bool> onStop() async {
    super.onStop();
    _group?.close();
    _group = null;
    return true;
  }
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
          .map((event) =>
              Measurement.fromData(MovesenseECG.fromMovesenseData(event)))
          .asBroadcastStream()
      : null;
}

/// A probe collecting [MovesenseTemperature] events.
///
/// Note that not all type of Movesense devices supports temperature.
class MovesenseTemperatureProbe extends _MovesenseProbe {
  @override
  Stream<Measurement>? get stream => (deviceManager.isConnected)
      ? MdsAsync.subscribe(
              Mds.createSubscriptionUri(deviceManager.serial, "/Meas/Temp"),
              "{}")
          .map((event) => Measurement.fromData(
              MovesenseTemperature.fromMovesenseData(event)))
          .asBroadcastStream()
      : null;
}

/// A probe collecting [MovesenseIMU] events at 13 Hz (lowest).
class MovesenseIMUProbe extends _MovesenseProbe {
  @override
  Stream<Measurement>? get stream => (deviceManager.isConnected)
      ? MdsAsync.subscribe(
              Mds.createSubscriptionUri(deviceManager.serial, "Meas/IMU9/13"),
              "{}")
          .map((event) =>
              Measurement.fromData(MovesenseIMU.fromMovesenseData(event)))
          .asBroadcastStream()
      : null;
}
