/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of esense;

abstract class _ESenseProbe extends StreamProbe {
  @override
  ESenseDeviceManager get deviceManager =>
      super.deviceManager as ESenseDeviceManager;
}

/// Collects eSense button pressed events. It generates an [ESenseButtonDatum]
/// every time the button is pressed or released.
class ESenseButtonProbe extends _ESenseProbe {
  @override
  Stream<Datum>? get stream {
    debug(
        '$runtimeType - deviceManager.isConnected = ${deviceManager.isConnected}');
    debug('$deviceManager');
    debug('${deviceManager.status}');

    Stream<Datum>? str = (deviceManager.isConnected)
        ? deviceManager.manager!.eSenseEvents
            .where((event) => event.runtimeType == ButtonEventChanged)
            .map((event) => ESenseButtonDatum(
                deviceName: deviceManager.manager!.deviceName,
                pressed: (event as ButtonEventChanged).pressed))
            .asBroadcastStream()
        : null;

    debug('stream = $str');
    return str;
  }
}

/// Collects eSense sensor events.
/// It generates an [ESenseSensorDatum] for each sensor event.
class ESenseSensorProbe extends _ESenseProbe {
  @override
  Stream<Datum>? get stream => (deviceManager.isConnected)
      ? deviceManager.manager!.sensorEvents
          .map((event) => ESenseSensorDatum.fromSensorEvent(
                deviceName: deviceManager.manager!.deviceName,
                event: event,
              ))
          .asBroadcastStream()
      : null;
}
