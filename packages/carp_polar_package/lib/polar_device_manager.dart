/*
 * Copyright 2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_polar_package;

enum PolarDeviceType {
  /// H9 Heart rate sensor
  H9,

  /// H10 Heart rate sensor
  H10,

  /// Polar Verity Sense Optical heart rate sensor
  PVSO,
}

/// A [DeviceDescriptor] for a Polar device used in a [StudyProtocol].
///
/// This device descriptor defined the basic configuration of the Polar
/// device, including the [polarDeviceType], the [identifier], and the [name]
/// of the device.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class PolarDevice extends DeviceDescriptor {
  /// The type of a Movisens device.
  static const String DEVICE_TYPE =
      '${DeviceDescriptor.DEVICE_NAMESPACE}.PolarDevice';

  /// The default rolename for a Movisens device.
  static const String DEFAULT_ROLENAME = 'polar';

  /// Polar device id printed on the sensor/device or UUID.
  /// This [identifier] is required for connecting to a Polar device.
  String? identifier;

  /// The MAC address of the sensor.
  /// Definitely empty on iOS. Probably empty on modern Android versions.
  String? address;

  /// The type of Polar device.
  PolarDeviceType? polarDeviceType;

  /// The user-friendly name of the sensor.
  String? name;

  /// RSSI (Received Signal Strength Indicator) value from advertisement
  int? rssi;

  /// Create a new [MovisensDevice].
  PolarDevice({
    String? roleName,
    this.polarDeviceType,
    this.identifier,
    this.name,
  }) : super(
          roleName: roleName ?? DEFAULT_ROLENAME,
          isMasterDevice: false,
          supportedDataTypes: [PolarSamplingPackage.MOVISENS],
        );

  @override
  Function get fromJsonFunction => _$PolarDeviceFromJson;
  factory PolarDevice.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as PolarDevice;
  @override
  Map<String, dynamic> toJson() => _$PolarDeviceToJson(this);
}

/// A Movisens [DeviceManager].
class PolarDeviceManager extends BTLEDeviceManager {
  // the last known voltage level of the Polar device
  int _batteryLevel = -1;
  String? _connectionStatus;
  StreamSubscription<PolarBatteryLevelEvent>? _batterySubscription;
  StreamSubscription<PolarDeviceInfo>? _connectingSubscription;
  StreamSubscription<PolarDeviceInfo>? _connectedSubscription;
  StreamSubscription<PolarDeviceInfo>? _disconnectedSubscription;

  @override
  PolarDevice get deviceDescriptor => super.deviceDescriptor as PolarDevice;

  /// The [Polar] device handler.
  /// Only available after this device manger has been initialized via the
  /// [initialize] method.
  Polar? polar;

  @override
  String get id => deviceDescriptor.identifier ?? PolarDevice.DEVICE_TYPE;

  String? get connectionStatus => _connectionStatus;

  @override
  Future<void> onInitialize(DeviceDescriptor descriptor) async {
    assert(descriptor is PolarDevice,
        '$runtimeType - can only be initialized with a PolarDevice device descriptor');
  }

  /// The latest read of the battery level of the Movisens device.
  @override
  int get batteryLevel => _batteryLevel;

  @override
  String? get btleAddress => deviceDescriptor.address;

  @override
  Future<bool> canConnect() async => deviceDescriptor.identifier != null;

  @override
  Future<bool> onConnect() async {
    if (deviceDescriptor.identifier == null) {
      warning('$runtimeType - cannot connect to device, identifier is null.');
      return false;
    } else {
      try {
        // create and connect to the Polar device
        polar = Polar();

        // listen for battery & connection events
        _batterySubscription = polar?.batteryLevelStream.listen((event) {
          debug('$runtimeType - Polar event : $event');
          _batteryLevel = event.level;
        });

        _connectingSubscription = polar?.deviceConnectingStream.listen((event) {
          debug('$runtimeType - Polar event : $event');
          status = DeviceStatus.connecting;
          deviceDescriptor.address = event.address;
          deviceDescriptor.name = event.name;
          deviceDescriptor.rssi = event.rssi;
        });

        _connectedSubscription = polar?.deviceConnectedStream.listen((event) {
          debug('$runtimeType - Polar event : $event');
          status = DeviceStatus.connected;
          deviceDescriptor.address = event.address;
          deviceDescriptor.name = event.name;
          deviceDescriptor.rssi = event.rssi;
        });

        _disconnectedSubscription =
            polar?.deviceDisconnectedStream.listen((event) {
          debug('$runtimeType - Polar event : $event');
          status = DeviceStatus.disconnected;
          deviceDescriptor.address = event.address;
          deviceDescriptor.name = event.name;
          deviceDescriptor.rssi = event.rssi;
        });

        info('$runtimeType - connecting to Polar device, identifier: $id');
        polar?.connectToDevice(id);
      } catch (error) {
        warning(
            "$runtimeType - could not connect to device of type '$type' - error: $error");
        return false;
      }
    }
    return true;
  }

  @override
  Future<bool> onDisconnect() async {
    if (deviceDescriptor.identifier == null) {
      warning(
          '$runtimeType - cannot disconnect from device, identifier is null.');
      return false;
    }

    polar?.disconnectFromDevice(deviceDescriptor.identifier!);

    _batterySubscription?.cancel();
    _connectingSubscription?.cancel();
    _connectedSubscription?.cancel();
    _disconnectedSubscription?.cancel();

    return true;
  }
}
