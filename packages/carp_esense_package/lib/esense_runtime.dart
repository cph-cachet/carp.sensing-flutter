/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of esense;

abstract class _ESenseProbe extends StreamProbe {
  bool connected = false;
  String deviceName;
  int samplingRate = 10;

  void onInitialize(Measure measure) {
    assert(measure is ESenseMeasure);
    super.onInitialize(measure);
    deviceName = (measure as ESenseMeasure)?.deviceName;
    assert(deviceName != null,
        'Must specify a non-null device name for the eSense device.');
    samplingRate ??= (measure as ESenseMeasure)?.samplingRate;

    // if you want to get the connection events when connecting,
    // set up the listener BEFORE connecting...
    ESenseManager().connectionEvents.listen((event) {
      info('$runtimeType :: eSense event : $event');

      switch (event.type) {
        case ConnectionType.connected:
          connected = true;
          // this is a hack! - don't know why, but the sensorEvents stream
          // needs a kick in the ass to get started...
          ESenseManager().sensorEvents.listen(null);
          // ESenseManager().eSenseEvents.listen(null);
          // if the device (re)connects, then restart the sampling
          this.restart();
          break;
        default:
          // all other cases, the device is not connected
          connected = false;
          this.pause();
          break;
      }
    });

    ESenseManager().setSamplingRate(samplingRate);
    ESenseManager().connect(deviceName);
  }
}

/// Collects eSense button pressed events. It generates an [ESenseButtonDatum]
/// every time the button is pressed or released.
class ESenseButtonProbe extends _ESenseProbe {
  Stream<Datum> get stream => (ESenseManager().connected)
      ? ESenseManager()
          .eSenseEvents
          .where((event) => event.runtimeType == ButtonEventChanged)
          .map((event) => ESenseButtonDatum(
              deviceName: deviceName,
              pressed: (event as ButtonEventChanged).pressed))
          .asBroadcastStream()
      : null;
}

/// Collects eSense sensor events.
/// It generates an [ESenseSensorDatum] for each sensor event.
class ESenseSensorProbe extends _ESenseProbe {
  Stream<Datum> get stream => (ESenseManager().connected)
      ? ESenseManager()
          .sensorEvents
          .map((event) => ESenseSensorDatum.fromSensorEvent(
              deviceName: deviceName, event: event))
          .asBroadcastStream()
      : null;
}

class ESenseDeviceManager extends DeviceManager {
  // the voltage level of the eSense device
  double _voltageLevel = 4;
  StreamSubscription<ESenseEvent> _eventSubscription;

  String get id => ESenseManager().eSenseDeviceName;

  Future initialize(DeviceDescriptor device) async {
    await super.initialize(device);

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

          // set up a timer that asks for the voltage level every minute
          Timer.periodic(const Duration(seconds: 10), (timer) {
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
          _eventSubscription?.cancel();
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
