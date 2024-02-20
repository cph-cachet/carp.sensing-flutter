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

enum MovensenseStateChange {
  movement,
  battery,
  connectors,
  doubleTap,
  tap,
  freeFall,
}

/// A probe collecting [MovesenseStateChange] events.
/// See [MovesenseDeviceState] for an enumeration of possible states.
class MovesenseStateChangeProbe extends _MovesenseProbe {
  /// A map from state id to subscription id.
  final Map<int, int> _subscriptionIDs = {};
  final StreamController<String> _subscriptionController =
      StreamController.broadcast();

  @override
  Future<bool> onStart() async {
    // Due to an error in Movesense we can only subscribe to MAX 2 state changes
    // See https://github.com/petri-lipponen-movesense/mdsflutter/issues/15
    //
    // Seems like the only states we can listen to is the connectors and tap events.....
    // Tested on the MD 00122 device.

    // _addStateSubscription(MovensenseStateChange.movement); // error
    _addStateSubscription(MovensenseStateChange.connectors); // ok
    // _addStateSubscription(MovensenseStateChange.doubleTap); // error
    _addStateSubscription(MovensenseStateChange.tap); // ok
    // _addStateSubscription(MovensenseStateChange.freeFall); // error

    return super.onStart();
  }

  @override
  Stream<Measurement>? get stream => deviceManager.isConnected
      ? _subscriptionController.stream.map((event) => Measurement.fromData(
          MovesenseStateChange.fromMovesenseData(jsonDecode(event))))
      : null;

  void _addStateSubscription(MovensenseStateChange state) {
    int stateId = state.index;

    // fast out of already subscribed to this type of state change.
    if (_subscriptionIDs.containsKey(stateId)) return;

    try {
      final int id =
          Mds.subscribe("${deviceManager.serial}/System/States/$stateId", "{}",
              (data, status) {
        debug(
            '$runtimeType - OnSuccess, stateId: $stateId, data: $data, status: $status');
      }, (error, status) {
        warning(
            '$runtimeType - OnError, stateId: $stateId, data: $error, status: $status');
        _subscriptionController.addError(error);
      }, (data) {
        debug('$runtimeType - OnNotification, stateId: $stateId, data: $data');
        _subscriptionController.add(data);
      }, (error, status) {
        warning(
            '$runtimeType - OnSubscriptionError, stateId: $stateId, error: $error, status: $status');
        _subscriptionController.addError(error);
      });

      debug('$runtimeType - Adding subscription, stateId: $stateId, id: $id');
      _subscriptionIDs[stateId] = id;
    } catch (error) {
      warning('$runtimeType - Error, stateId: $stateId, error: $error');
      _subscriptionController.addError(error);
    }
  }

  @override
  Future<bool> onStop() async {
    super.onStop();

    // unsubscribed to all state subscriptions
    for (var id in _subscriptionIDs.values) {
      debug('$runtimeType - Removing subscription, id: $id');
      Mds.unsubscribe(id);
    }
    _subscriptionIDs.clear();

    return true;
  }
}

/// A probe collecting [MovesenseHR] events.
class MovesenseHRProbe extends _MovesenseProbe {
  @override
  Stream<Measurement>? get stream => (deviceManager.isConnected)
      ? MdsAsync.subscribe("${deviceManager.serial}/Meas/HR", "{}")
          .map((event) =>
              Measurement.fromData(MovesenseHR.fromMovesenseData(event)))
          .asBroadcastStream()
      : null;
}

/// A probe collecting [MovesenseECG] events at 125 Hz.
class MovesenseECGProbe extends _MovesenseProbe {
  @override
  Stream<Measurement>? get stream => (deviceManager.isConnected)
      ? MdsAsync.subscribe("${deviceManager.serial}/Meas/ECG/125", "{}")
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
      ? MdsAsync.subscribe("${deviceManager.serial}/Meas/Temp", "{}")
          .map((event) => Measurement.fromData(
              MovesenseTemperature.fromMovesenseData(event)))
          .asBroadcastStream()
      : null;
}

/// A probe collecting [MovesenseIMU] events at 13 Hz (lowest).
class MovesenseIMUProbe extends _MovesenseProbe {
  @override
  Stream<Measurement>? get stream => (deviceManager.isConnected)
      ? MdsAsync.subscribe("${deviceManager.serial}/Meas/IMU9/13", "{}")
          .map((event) =>
              Measurement.fromData(MovesenseIMU.fromMovesenseData(event)))
          .asBroadcastStream()
      : null;
}
