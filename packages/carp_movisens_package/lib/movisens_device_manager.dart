/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of movisens;

class MovisensDeviceManager extends DeviceManager {
  // the last known voltage level of the eSense device
  int _batteryLevel = 100;
  String _connectionStatus;
  StreamSubscription<Map<String, dynamic>> _eventSubscription;

  String get id => userData?.sensorName ?? 'movisens-123';

  Future initialize(String type) async {
    await super.initialize(type);

    // TODO - should be possible to init a device manager before connecting to the probe.....
    assert(movisens != null, 'The Movisens probe has not been initialized.');

    // listen for Movisens events
    movisens.movisensStream.listen((event) {
      info('$runtimeType :: eSense event : $event');

      if (event.containsKey("BatteryLevel"))
        _batteryLevel =
            int.parse(jsonDecode(event["BatteryLevel"])[BATTERY_LEVEL]);

      if (event.containsKey("ConnectionStatus")) {
        _connectionStatus =
            jsonDecode(event["ConnectionStatus"])[CONNECTION_STATUS];
        // TODO - set the right connection status - can this be other than connected?
        status = DeviceStatus.connected;
      }
    });
  }

  /// The latest read of the battery level of the Movisens device.
  int get batteryLevel => _batteryLevel;

  Future connect() async {}
  Future disconnect() async {}
}
