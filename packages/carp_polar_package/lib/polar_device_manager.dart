/*
 * Copyright 2022-23 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of carp_polar_package;

/// Enumeration of supported Polar devices.
enum PolarDeviceType {
  /// Unknown Polar type
  UNKNOWN,

  /// Polar H9 Heart rate sensor
  H9,

  /// Polar H10 Heart rate sensor
  H10,

  /// Polar Verity Sense heart rate sensor
  SENSE,
}

/// A [DeviceConfiguration] for a Polar device used in a [StudyProtocol].
///
/// This device descriptor defined the basic configuration of the Polar
/// device, including the [polarDeviceType], the [identifier], and the [name]
/// of the device.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class PolarDevice extends BLEHeartRateDevice {
  /// The type of a Polar device.
  static const String DEVICE_TYPE =
      '${DeviceConfiguration.DEVICE_NAMESPACE}.PolarDevice';

  /// The default role name for a Polar device.
  static const String DEFAULT_ROLENAME = 'Polar HR Device';

  /// The polar sensor settings.
  /// This is know only **after** a polar device is connected.
  // @JsonKey(ignore: true)
  PolarSensorSetting? settings;

  /// Polar device id printed on the sensor/device or UUID.
  /// This [identifier] is required for connecting to a Polar device.
  String? identifier;

  /// The Bluetooth address of the sensor.
  String? address;

  /// The type of Polar device, if known.
  PolarDeviceType? polarDeviceType;

  /// The user-friendly name of the sensor.
  String? name;

  /// RSSI (Received Signal Strength Indicator) value from advertisement
  int? rssi;

  /// Create a new [PolarDevice].
  PolarDevice({
    super.roleName = PolarDevice.DEFAULT_ROLENAME,
    super.isOptional = true,
    this.polarDeviceType,
    this.identifier,
    this.name,
  });

  @override
  Function get fromJsonFunction => _$PolarDeviceFromJson;
  factory PolarDevice.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as PolarDevice;
  @override
  Map<String, dynamic> toJson() => _$PolarDeviceToJson(this);
}

/// A Polar [DeviceManager].
class PolarDeviceManager extends BTLEDeviceManager<PolarDevice> {
  int? _batteryLevel;
  bool _polarFeaturesAvailable = false;
  StreamSubscription<PolarBatteryLevelEvent>? _batterySubscription;
  StreamSubscription<PolarDeviceInfo>? _connectingSubscription;
  StreamSubscription<PolarDeviceInfo>? _connectedSubscription;
  StreamSubscription<PolarDeviceDisconnectedEvent>? _disconnectedSubscription;

  /// The [Polar] device handler.
  final Polar polar = Polar();

  /// List of [PolarDataType]s that are available in Polar devices for online
  /// streaming or offline recording.
  ///
  /// Only available **after** a Polar device is successfully connected.
  List<PolarDataType> features = [];

  @override
  String get id => configuration?.identifier ?? '?????';

  @override
  String? get displayName => btleName;

  @override
  String get btleName => configuration?.name ?? '';

  @override
  set btleName(String btleName) {
    configuration?.name = btleName;

    // the polar BTLE name is typically of the form
    //  *  Polar Sense B34B4B56
    //  *  Polar H10 B36KB56
    // I.e., on the form "Polar <type> <identifier>
    if (btleName.split(' ').first.toUpperCase() == 'POLAR') {
      configuration?.identifier = btleName.split(' ').last;

      switch (btleName.split(' ').elementAt(1).toUpperCase()) {
        case 'H9':
          configuration?.polarDeviceType = PolarDeviceType.H9;
          break;
        case 'H10':
          configuration?.polarDeviceType = PolarDeviceType.H10;
          break;
        case 'SENSE':
          configuration?.polarDeviceType = PolarDeviceType.SENSE;
          break;
        default:
          configuration?.polarDeviceType = PolarDeviceType.UNKNOWN;
          break;
      }
    }
  }

  /// Are the [features] available (i.e., received from the device)?
  bool get polarFeaturesAvailable => _polarFeaturesAvailable;

  /// The latest read of the battery level of the Polar device.
  @override
  int? get batteryLevel => _batteryLevel;

  @override
  String get btleAddress => configuration?.address ?? '';

  @override
  set btleAddress(String btleAddress) => configuration?.address = btleAddress;

  PolarDeviceManager(
    super.type, [
    super.configuration,
  ]);

  @override
  Future<bool> canConnect() async => configuration?.identifier != null;

  @override
  Future<DeviceStatus> onConnect() async {
    // fast out if already connected.
    if (isConnected) return status;

    if (configuration?.identifier == null) {
      warning('$runtimeType - cannot connect to device, identifier is null.');
      return DeviceStatus.error;
    } else {
      try {
        // listen for battery level events
        _batterySubscription = polar.batteryLevel.listen((event) {
          debug('$runtimeType - Polar event : $event');
          _batteryLevel = event.level;
        });

        // listen for what features the connected Polar device supports
        polar.sdkFeatureReady.listen((event) {
          debug('$runtimeType - Polar event : $event');

          if (configuration!.identifier == event.identifier) {
            polar
                .getAvailableOnlineStreamDataTypes(event.identifier)
                .then((dataTypes) {
              features = dataTypes.toList();
              debug('$runtimeType - features: $features');
              _polarFeaturesAvailable = true;
              status = DeviceStatus.connected;
            });
          }
        });

        // listen for connection events
        _connectingSubscription = polar.deviceConnecting.listen((event) {
          debug('$runtimeType - Polar event : $event');
          status = DeviceStatus.connecting;
          configuration?.address = event.address;
          configuration?.name = event.name;
          configuration?.rssi = event.rssi;
        });

        _connectedSubscription = polar.deviceConnected.listen((event) {
          debug('$runtimeType - Polar event : $event');
          // we do not mark the device as fully connected before the features are available
          status = DeviceStatus.connecting;
          configuration?.address = event.address;
          configuration?.name = event.name;
          configuration?.rssi = event.rssi;
        });

        _disconnectedSubscription = polar.deviceDisconnected.listen((event) {
          debug('$runtimeType - Polar event : $event');
          status = DeviceStatus.disconnected;
          _batteryLevel = null;
        });

        polar.connectToDevice(id, requestPermissions: true);

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
    if (configuration?.identifier == null) {
      warning(
          '$runtimeType - cannot disconnect from device, identifier is null.');
      return false;
    }

    polar.disconnectFromDevice(configuration!.identifier!);

    _batterySubscription?.cancel();
    _connectingSubscription?.cancel();
    _connectedSubscription?.cancel();
    _disconnectedSubscription?.cancel();

    return true;
  }
}
