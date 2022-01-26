/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of movisens;

/// A [DeviceDescriptor] for a Movisens device used in a [StudyProtocol].
///
/// This device descriptor defined the basic configuration of the Movisens
/// device, including the BTLE MAC [address], the [sensorName], the [sensorLocation] and the
/// [weight], [height], [age], [gender] of the user using the device.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class MovisensDeviceDescriptor extends DeviceDescriptor {
  /// The type of a Movisens device.
  static const String DEVICE_TYPE =
      '${DeviceDescriptor.DEVICE_NAMESPACE}.MovisensDevice';

  /// The default rolename for a Movisens device.
  static const String DEFAULT_ROLENAME = 'movisens';

  /// The MAC address of the sensor.
  String address;

  /// The user-friendly name of the sensor.
  String sensorName;

  /// Sensor placement on body
  SensorLocation sensorLocation;

  /// Weight of the person wearing the Movisens device in kg.
  int weight;

  /// Height of the person wearing the Movisens device in cm.
  int height;

  /// Age of the person wearing the Movisens device in years.
  int age;

  /// Gender of the person wearing the Movisens device, male or female.
  Gender gender;

  MovisensDeviceDescriptor({
    String? roleName,
    required this.address,
    required this.sensorName,
    this.sensorLocation = SensorLocation.chest,
    this.gender = Gender.male,
    this.height = 178,
    this.weight = 78,
    this.age = 25,
  }) : super(
          roleName: roleName ?? DEFAULT_ROLENAME,
          isMasterDevice: false,
          supportedDataTypes: [MovisensSamplingPackage.MOVISENS_NAMESPACE],
        );

  Function get fromJsonFunction => _$MovisensDeviceDescriptorFromJson;
  factory MovisensDeviceDescriptor.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as MovisensDeviceDescriptor;
  Map<String, dynamic> toJson() => _$MovisensDeviceDescriptorToJson(this);
}

class MovisensDeviceManager extends BTLEDeviceManager {
  // the last known voltage level of the Movisens device
  int _batteryLevel = 100;
  String? _connectionStatus;
  StreamSubscription<Map<String, dynamic>>? _subscription;

  MovisensDeviceDescriptor get deviceDescriptor =>
      super.deviceDescriptor as MovisensDeviceDescriptor;

  /// The [Movisens] device handler.
  /// Only available after this device manger has been initialized via the
  /// [initialize] method.
  Movisens? movisens;

  /// Movisens user data as specified in the [MovisensDeviceDescriptor].
  /// Only available after this device manger has been initialized via the
  /// [initialize] method.
  UserData? userData;

  @override
  String get id =>
      userData?.sensorAddress ?? MovisensDeviceDescriptor.DEVICE_TYPE;

  String? get connectionStatus => _connectionStatus;

  @override
  Future onInitialize(DeviceDescriptor descriptor) async {
    assert(descriptor is MovisensDeviceDescriptor,
        '$runtimeType - can only be initialized with a MovisensDeviceDescriptor');

    userData = UserData(
      deviceDescriptor.weight,
      deviceDescriptor.height,
      deviceDescriptor.gender,
      deviceDescriptor.age,
      deviceDescriptor.sensorLocation,
      deviceDescriptor.address,
      deviceDescriptor.sensorName,
    );
  }

  /// The latest read of the battery level of the Movisens device.
  @override
  int get batteryLevel => _batteryLevel;

  @override
  String get btleAddress => deviceDescriptor.address;

  @override
  bool canConnect() => userData != null;

  @override
  Future<bool> onConnect() async {
    try {
      // create and connect to the Movisens device
      movisens = Movisens(userData!);

      // listen for Movisens events
      _subscription = movisens!.movisensStream.listen((event) {
        info('$runtimeType :: Movisens event : $event');

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
    } catch (error) {
      warning(
          "$runtimeType - could not connect to device of type '$type' - error: $error");
      return false;
    }

    return true;
  }

  @override
  Future<bool> onDisconnect() async {
    _subscription?.cancel();
    return true;
  }
}
