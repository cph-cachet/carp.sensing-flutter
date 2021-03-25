/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of movisens;

class MovisensDeviceManager extends DeviceManager {
  // the last known voltage level of the eSense device
  double _voltageLevel = 4;
  StreamSubscription<ESenseEvent> _eventSubscription;

  String get id => ESenseManager().eSenseDeviceName;

  Future initialize(String type) async {
    await super.initialize(type);

    // listen for connection events
    ESenseManager().connectionEvents.listen((event) {
      info('$runtimeType :: eSense event : $event');

      switch (event.type) {
        case ConnectionType.connected:
          status = DeviceStatus.connected;

          // when connected, listen for battery events
          _eventSubscription = ESenseManager()
              .eSenseEvents
              .where((event) => event is BatteryRead)
              .listen((event) {
            info('$runtimeType :: eSense event : $event');
            _voltageLevel = (event as BatteryRead).voltage;
          });

          // set up a timer that asks for the voltage level
          Timer.periodic(const Duration(minutes: 5), (timer) {
            if (status == DeviceStatus.connected) {
              info('$runtimeType :: requesting voltage');
              ESenseManager().getBatteryVoltage();
            }
          });
          break;
        case ConnectionType.unknown:
          status = DeviceStatus.unknown;
          break;
        case ConnectionType.device_found:
          status = DeviceStatus.paired;
          break;
        case ConnectionType.device_not_found:
        case ConnectionType.disconnected:
          status = DeviceStatus.disconnected;
          // _eventSubscription?.cancel();
          break;
      }
    });
  }

  /// A estimate of the battery level of the eSense device.
  ///
  /// It assumes a liniar relationship based on a regression on
  /// these measures:
  ///
  /// ```
  ///   B  |  V
  ///  ----+------
  ///  1.0	| 4.1
  ///  0.8	| 3.9
  ///  0.6	| 3.8
  ///  0.4	| 3.7
  ///  0.2	| 3.4
  ///  0.0  | 3.1
  /// ```
  ///
  /// which gives; `B = 1.19V - 3.91`.
  ///
  /// See e.g. https://en.wikipedia.org/wiki/State_of_charge#Voltage_method
  int get batteryLevel => ((1.19 * _voltageLevel - 3.91) * 100).toInt();

  Future connect() async => await ESenseManager().connect(id);
  Future disconnect() async => await ESenseManager().disconnect();
}
