/*
 * Copyright 2021-2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of esense;

// This is the debug sampling schema used by bardram
// His eSense devices are
//
//        |     name    |     id
//  ------+-------------+--------------------
//  right | eSense-0917 |  00:04:79:00:0F:4D
//  left  | eSense-0332 |  00:04:79:00:0D:04
//
// As recommended;:
//   "it would be better to use the right earbud to record only sound samples
//    and the left earbud to record only IMU data."
//
// Hence, connect the RIGHT earbud to the phone using classic Bluetooth (for
// audio streaming), and use the LEFT earbud for IMU data collection using BLE
// as part of a mobile sensing study.

/// A [DeviceDescriptor] for an eSense device used in a [StudyProtocol].
///
/// **From the eSense User Documentation:**
///
/// Both the left and right earbud have a microphone onboard. The microphone can
/// be used to record audio samples as well as input source for phone or VoIP calls.
///
/// There is no need for special configuration to use the microphone on the earbud.
/// Once the earbud is paired (Bluetooth Classic interface), the host device will
/// recognise the earbud as a new input source. The audio recorded is mono, only
/// from the earbud paired with the host device. The same happens for calls, only
/// the speaker and microphone on the earbud paired with the host will be used
/// during an active call.
///
/// Either the right or left earbud (but not both) can be paired
/// with a host device. If the left earbud is paired, the same host device can
/// also connect to the BLE interface of the earbud to collect IMU data at the
/// same time as audio is recorded from its microphone. The earbuds are limited
/// devices and the achievable data rate of the sensors (microphone and IMU)
/// might be affected by the number of operations performed. For example, if
/// the IMU and the microphone are enabled on the same earbud while the user is
/// also listening to music, it might not be possible to achieve the desired data
/// rate and the music might be interrupted. In this situation it would be better
/// to use the right earbud to record only sound samples and the left earbud to
/// record only IMU data.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class ESenseDevice extends DeviceDescriptor {
  /// The type of a eSense device.
  static const String DEVICE_TYPE =
      '${DeviceDescriptor.DEVICE_NAMESPACE}.ESenseDevice';

  /// The default rolename for a eSense device.
  static const String DEFAULT_ROLENAME = 'esense';

  /// The name of the eSense device.
  /// Used for connecting to the eSense hardware device over BTLE.
  /// eSense devices are typically named `eSense-xxxx`.
  String? deviceName;

  /// The sampling rate in Hz of getting sensor data from the device.
  int? samplingRate;

  ESenseDevice({
    super.roleName = ESenseDevice.DEFAULT_ROLENAME,
    this.deviceName,
    this.samplingRate,
  }) : super(isMasterDevice: false, supportedDataTypes: [
          ESenseSamplingPackage.ESENSE_BUTTON,
          ESenseSamplingPackage.ESENSE_SENSOR,
        ]);

  @override
  Function get fromJsonFunction => _$ESenseDeviceFromJson;
  factory ESenseDevice.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as ESenseDevice;
  @override
  Map<String, dynamic> toJson() => _$ESenseDeviceToJson(this);
}

/// A [DeviceManager] for the eSense device.
class ESenseDeviceManager
    extends BTLEDeviceManager<DeviceRegistration, ESenseDevice> {
  // the last known voltage level of the eSense device
  double? _voltageLevel;

  /// A handle to the [ESenseManager] plugin.
  ESenseManager? manager;

  @override
  String get id => deviceDescriptor?.deviceName ?? 'eSense-????';

  @override
  String get btleName => deviceDescriptor?.deviceName ?? 'eSense-????';

  /// Set the name of this device based on the Bluetooth name.
  /// This name is used for connection.
  @override
  set btleName(String btleName) => deviceDescriptor?.deviceName = btleName;

  /// A estimate of the battery level of the eSense device.
  ///
  /// It assumes a liniar relationship based on a regression on
  /// these measures of battery and voltages levels:
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
  @override
  int? get batteryLevel => (_voltageLevel != null)
      ? ((1.19 * _voltageLevel! - 3.91) * 100).toInt()
      : null;

  @override
  Future<bool> canConnect() async => (deviceDescriptor?.deviceName != null &&
      deviceDescriptor!.deviceName!.isNotEmpty);

  @override
  Future<DeviceStatus> onConnect() async {
    if (deviceDescriptor?.deviceName == null ||
        deviceDescriptor!.deviceName!.isEmpty) return DeviceStatus.error;

    manager = ESenseManager(id);

    // listen for connection events
    manager?.connectionEvents.listen((event) {
      debug('$runtimeType - $event');

      switch (event.type) {
        case ConnectionType.connected:
          status = DeviceStatus.connected;

          // this is a hack! - don't know why, but the sensorEvents stream
          // needs a kick in the ass to get started...
          manager?.sensorEvents.listen(null);

          // when connected, listen for battery events
          manager!.eSenseEvents.listen((event) {
            if (event is BatteryRead) {
              _voltageLevel = event.voltage ?? 4;
            }
          });

          // set up a timer that asks for the voltage level
          Timer.periodic(const Duration(minutes: 2), (_) {
            if (status == DeviceStatus.connected) {
              manager?.getBatteryVoltage();
            }
          });
          break;
        case ConnectionType.unknown:
          status = DeviceStatus.unknown;
          break;
        case ConnectionType.device_found:
          status = DeviceStatus.connecting;
          break;
        case ConnectionType.device_not_found:
        case ConnectionType.disconnected:
          status = DeviceStatus.disconnected;
          _voltageLevel = null;
          // _eventSubscription?.cancel();
          break;
      }
    });

    manager?.connect();
    return DeviceStatus.connecting;
  }

  @override
  Future<bool> onDisconnect() async => await manager?.disconnect() ?? false;
}
