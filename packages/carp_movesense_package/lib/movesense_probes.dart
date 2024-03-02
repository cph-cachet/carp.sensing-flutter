/*
 * Copyright 2024 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of carp_movesense_package;

abstract class _MovesenseProbe extends StreamProbe {
  int? _subscriptionId;

  final StreamController<String> _streamController =
      StreamController.broadcast();

  @override
  MovesenseDeviceManager get deviceManager =>
      super.deviceManager as MovesenseDeviceManager;

  String get serial => deviceManager.serial;
  String uri;
  Function converter;

  _MovesenseProbe(this.uri, this.converter);

  @override
  Stream<Measurement>? get stream => deviceManager.isConnected
      ? _streamController.stream.map((event) =>
          Measurement.fromData(converter.call(jsonDecode(event)) as Data))
      : null;

  @override
  Future<bool> onStart() {
    var completer = Completer<bool>();

    // fast out of already subscribed to this type of measurement
    if (_subscriptionId != null) completer.complete(false);

    try {
      _subscriptionId = Mds.subscribe("$serial/$uri", "{}", (data, status) {
        debug('$runtimeType - OnSuccess, data: $data, status: $status');
        completer.complete(super.onStart());
      }, (error, status) {
        warning('$runtimeType - OnError, error: $error, status: $status');
        _streamController.addError(error);
        _subscriptionId = null;
        completer.complete(false);
      }, (data) {
        debug('$runtimeType - OnNotification, data: $data');
        _streamController.add(data);
      }, (error, status) {
        warning(
            '$runtimeType - OnSubscriptionError, error: $error, status: $status');
        _streamController.addError(error);
        _subscriptionId = null;
        completer.complete(false);
      });
    } catch (error) {
      warning('$runtimeType - Error, error: $error');
      _streamController.addError(error);
      _subscriptionId = null;
      completer.complete(false);
    }

    return completer.future;
  }

  @override
  Future<bool> onStop() async {
    super.onStop();
    debug('$runtimeType - onStop,  _id: $_subscriptionId');

    if (_subscriptionId != null) Mds.unsubscribe(_subscriptionId!);
    _subscriptionId = null;

    return true;
  }
}

/// A probe collecting [MovesenseHR] events.
class MovesenseHRProbe extends _MovesenseProbe {
  MovesenseHRProbe() : super("Meas/HR", MovesenseHR.fromMovesenseData);
}

/// A probe collecting [MovesenseECG] events at 125 Hz.
class MovesenseECGProbe extends _MovesenseProbe {
  MovesenseECGProbe() : super("Meas/ECG/125", MovesenseECG.fromMovesenseData);
}

/// A probe collecting [MovesenseTemperature] events.
///
/// Note that not all type of Movesense devices supports temperature.
class MovesenseTemperatureProbe extends _MovesenseProbe {
  MovesenseTemperatureProbe()
      : super("Meas/Temp", MovesenseTemperature.fromMovesenseData);
}

/// A probe collecting [MovesenseIMU] events at 13 Hz (lowest).
class MovesenseIMUProbe extends _MovesenseProbe {
  MovesenseIMUProbe() : super("Meas/IMU9/13", MovesenseIMU.fromMovesenseData);
}

/// A probe collecting [MovesenseStateChange] events.
/// See [MovesenseDeviceState] for an enumeration of possible states.
///
/// However, due to hardware limitation in Movesense we can only subscribe to
/// maximum one (!) state changes
/// See https://github.com/petri-lipponen-movesense/mdsflutter/issues/15
///
/// Seems like the only states we can listen to is the connectors and single tap
/// events. This has been tested on the MD and HR2 devices.
///
/// Therefore, this probe **only** listens to single tap events.
class MovesenseStateChangeProbe extends _MovesenseProbe {
  MovesenseStateChangeProbe()
      : super("System/States/4", MovesenseStateChange.fromMovesenseData);
}

// MULTI STATE CHANGE PROBE BELOW - with notes

/// Enumeration of the type of state changes available on the Movesense device.
/// See https://www.movesense.com/docs/esw/api_reference/#systemstates
enum MovensenseStateChange {
  movement,
  battery,
  connectors,
  doubleTap,
  tap,
  freeFall,
}

// State Change overview. The following table shows the state change types
// available on the different devices. This is based on testing of physical
// device. Can't find any documentation on this in the Movesense documentation
//
//   type      | MD | HR+ | HR2
//  -----------+----+-----+-----
//  movement   | -  |  ?  |  -
//  connectors | +  |  ?  |  +
//  doubleTap  | -  |  ?  |  -
//  tap        | +  |  ?  |  +
//  freeFall   | -  |  ?  |  -

/// A probe collecting all possible [MovesenseStateChange] events.
/// See [MovesenseDeviceState] for an enumeration of possible states.
///
/// In contrast to the [MovesenseStateChangeProbe], this probe tries to
/// collect all the different types of state changes. However, due to hardware
/// limitation on the device, this often will not succeed.
///
/// Therefore, this probe is not used at the moment.
class MovesenseMultiStateChangeProbe extends StreamProbe {
  /// A map from state id to subscription id.
  final Map<int, int> _subscriptionIDs = {};
  final StreamController<String> _subscriptionController =
      StreamController.broadcast();

  @override
  MovesenseDeviceManager get deviceManager =>
      super.deviceManager as MovesenseDeviceManager;

  @override
  Future<bool> onStart() async {
    _addStateSubscription(MovensenseStateChange.movement);
    _addStateSubscription(MovensenseStateChange.connectors);
    _addStateSubscription(MovensenseStateChange.doubleTap);
    _addStateSubscription(MovensenseStateChange.tap);
    _addStateSubscription(MovensenseStateChange.freeFall);

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
            '$runtimeType - OnError, stateId: $stateId, error: $error, status: $status');
        _subscriptionController.addError(error);
      }, (data) {
        debug('$runtimeType - OnNotification, stateId: $stateId, data: $data');
        _subscriptionController.add(data);
      }, (error, status) {
        warning(
            '$runtimeType - OnSubscriptionError, stateId: $stateId, error: $error, status: $status');
        _subscriptionController.addError(error);
      });

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
      Mds.unsubscribe(id);
    }
    _subscriptionIDs.clear();

    return true;
  }
}
