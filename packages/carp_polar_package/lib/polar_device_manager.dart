/*
 * Copyright 2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of carp_polar_package;

/// Enumeration of supported Polar devices.
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

  /// The polar sensor settings.
  /// This is know only **after** a polar device is connected.
  // @JsonKey(ignore: true)
  PolarSensorSetting? settings;

  /// Polar device id printed on the sensor/device or UUID.
  /// This [identifier] is required for connecting to a Polar device.
  String? identifier;

  /// The MAC address of the sensor.
  /// Definitely empty on iOS. Probably empty on modern Android versions.
  String? address;

  /// The type of Polar device, if known.
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
          supportedDataTypes: [
            PolarSamplingPackage.POLAR_ACCELEROMETER,
            PolarSamplingPackage.POLAR_GYROSCOPE,
            PolarSamplingPackage.POLAR_MAGNETOMETER,
            PolarSamplingPackage.POLAR_PPG,
            PolarSamplingPackage.POLAR_PPI,
            PolarSamplingPackage.POLAR_ECG,
          ],
        );

  @override
  Function get fromJsonFunction => _$PolarDeviceFromJson;
  factory PolarDevice.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as PolarDevice;
  @override
  Map<String, dynamic> toJson() => _$PolarDeviceToJson(this);
}

/// A Polar [DeviceManager].
class PolarDeviceManager extends BTLEDeviceManager {
  int? _batteryLevel;
  bool _polarFeaturesAvailable = false;
  StreamSubscription<PolarBatteryLevelEvent>? _batterySubscription;
  StreamSubscription<PolarDeviceInfo>? _connectingSubscription;
  StreamSubscription<PolarDeviceInfo>? _connectedSubscription;
  StreamSubscription<PolarDeviceInfo>? _disconnectedSubscription;

  @override
  PolarDevice get deviceDescriptor => super.deviceDescriptor as PolarDevice;

  /// The [Polar] device handler.
  final Polar polar = Polar();

  /// List of [DeviceStreamingFeature]s that are ready. Only available **after**
  /// a Polar device is successfully connected.
  List<DeviceStreamingFeature> features = [];

  @override
  String get id => deviceDescriptor.identifier ?? PolarDevice.DEVICE_TYPE;

  /// Are the [features] available (i.e., received from the device)?
  bool get polarFeaturesAvailable => _polarFeaturesAvailable;

  @override
  Future<void> onInitialize(DeviceDescriptor descriptor) async {
    assert(descriptor is PolarDevice,
        '$runtimeType - can only be initialized with a PolarDevice device descriptor');
    super.onInitialize(descriptor);
  }

  /// The latest read of the battery level of the Polar device.
  @override
  int? get batteryLevel => _batteryLevel;

  @override
  String? get btleAddress => deviceDescriptor.address;

  @override
  Future<bool> canConnect() async => deviceDescriptor.identifier != null;

  @override
  Future<DeviceStatus> onConnect() async {
    if (deviceDescriptor.identifier == null) {
      warning('$runtimeType - cannot connect to device, identifier is null.');
      return DeviceStatus.error;
    } else {
      try {
        // listen for battery  events
        _batterySubscription = polar.batteryLevelStream.listen((event) {
          debug('$runtimeType - Polar event : $event');
          _batteryLevel = event.level;
        });

        // listen for what features the connected Polar device supports
        polar.streamingFeaturesReadyStream.listen((event) {
          debug('$runtimeType - Polar event : $event');
          features = event.features;
          _polarFeaturesAvailable = true;
          status = DeviceStatus.connected;
        });

        // listen for connection events
        _connectingSubscription = polar.deviceConnectingStream.listen((event) {
          debug('$runtimeType - Polar event : $event');
          status = DeviceStatus.connecting;
          deviceDescriptor.address = event.address;
          deviceDescriptor.name = event.name;
          deviceDescriptor.rssi = event.rssi;
        });

        _connectedSubscription = polar.deviceConnectedStream.listen((event) {
          debug('$runtimeType - Polar event : $event');
          // we do not mark the device as fully connected before the features are available
          status = DeviceStatus.connecting;
          deviceDescriptor.address = event.address;
          deviceDescriptor.name = event.name;
          deviceDescriptor.rssi = event.rssi;
        });

        _disconnectedSubscription =
            polar.deviceDisconnectedStream.listen((event) {
          debug('$runtimeType - Polar event : $event');
          status = DeviceStatus.disconnected;
          _batteryLevel = null;
          deviceDescriptor.address = event.address;
          deviceDescriptor.name = event.name;
          deviceDescriptor.rssi = event.rssi;
        });

        polar.connectToDevice(id);

        return DeviceStatus.connecting;
      } catch (error) {
        warning(
            "$runtimeType - could not connect to device of type '$type' and id '$id' - error: $error");
        return DeviceStatus.error;
      }
    }
  }

  @override
  Future<bool> onDisconnect() async {
    if (deviceDescriptor.identifier == null) {
      warning(
          '$runtimeType - cannot disconnect from device, identifier is null.');
      return false;
    }

    polar.disconnectFromDevice(deviceDescriptor.identifier!);

    _batterySubscription?.cancel();
    _connectingSubscription?.cancel();
    _connectedSubscription?.cancel();
    _disconnectedSubscription?.cancel();

    return true;
  }
}
