/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_movisens_package;

/// A [DeviceConfiguration] for a Movisens device used in a [StudyProtocol].
///
/// This device descriptor defined the basic configuration of the Movisens
/// device, including the BTLE MAC [address], the [deviceName], the [sensorLocation]
/// and the [weight], [height], [age], [sex] of the user using the device.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class MovisensDevice extends DeviceConfiguration {
  /// The type of a Movisens device.
  static const String DEVICE_TYPE =
      '${DeviceConfiguration.DEVICE_NAMESPACE}.MovisensDevice';

  /// The default role name for a Movisens device.
  static const String DEFAULT_ROLENAME = 'movisens';

  /// The user-friendly name of the device.
  /// Used for connecting to the device.
  String deviceName;

  /// Sensor placement on body
  SensorLocation sensorLocation;

  /// Weight of the person wearing the Movisens device in kg.
  int weight;

  /// Height of the person wearing the Movisens device in cm.
  int height;

  /// Age of the person wearing the Movisens device in years.
  int age;

  /// Biological sex of the person wearing the Movisens device, male or female.
  Sex sex;

  /// Create a new [MovisensDevice].
  ///
  /// Default user settings are a 25 year old male, height 178 cm high, weight
  /// 78 kg with the sensor place on the chest.
  MovisensDevice({
    String? roleName,
    required this.deviceName,
    this.sensorLocation = SensorLocation.Chest,
    this.sex = Sex.Male,
    this.height = 178,
    this.weight = 78,
    this.age = 25,
  }) : super(
          roleName: roleName ?? DEFAULT_ROLENAME,
          isOptional: true,
          supportedDataTypes: [
            MovisensSamplingPackage.ACTIVITY,
            MovisensSamplingPackage.HR,
            MovisensSamplingPackage.EDA,
            MovisensSamplingPackage.TAP_MARKER,
            MovisensSamplingPackage.SKIN_TEMPERATURE,
          ],
        );

  @override
  Function get fromJsonFunction => _$MovisensDeviceFromJson;
  factory MovisensDevice.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as MovisensDevice;
  @override
  Map<String, dynamic> toJson() => _$MovisensDeviceToJson(this);
}

/// A Movisens [DeviceManager].
class MovisensDeviceManager
    extends BTLEDeviceManager<DeviceRegistration, MovisensDevice> {
  // the last known voltage level of the Movisens device
  int _batteryLevel = -1;
  String? _connectionStatus;
  // StreamSubscription<Map<String, dynamic>>? _subscription;
  StreamSubscription<BluetoothDeviceState>? _subscription;

  @override
  MovisensDevice get deviceDescriptor =>
      super.deviceConfiguration as MovisensDevice;

  /// The [Movisens] device handler.
  /// Only available after this device manger has been initialized via the
  /// [initialize] method.
  movisens.MovisensDevice? device;

  // /// Movisens user data as specified in the [MovisensDevice] device descriptor.
  // /// Only available after this device manger has been initialized via the
  // /// [initialize] method.
  // UserData? userData;

  @override
  String get id => device?.name ?? MovisensDevice.DEVICE_TYPE;

  String? get connectionStatus => _connectionStatus;

  @override
  Future<void> onInitialize(MovisensDevice configuration) async {
    super.onInitialize(configuration);
    device = movisens.MovisensDevice(name: configuration.deviceName);

    // // assert(descriptor is MovisensDevice,
    // //     '$runtimeType - can only be initialized with a MovisensDevice device descriptor');

    // userData = UserData(
    //   deviceDescriptor.weight,
    //   deviceDescriptor.height,
    //   deviceDescriptor.gender,
    //   deviceDescriptor.age,
    //   deviceDescriptor.sensorLocation,
    //   deviceDescriptor.address,
    //   deviceDescriptor.sensorName,
    // );
  }

  /// The latest read of the battery level of the Movisens device.
  @override
  int get batteryLevel => _batteryLevel;

  @override
  String get btleAddress => device?.id ?? super.btleAddress;

  @override
  Future<bool> canConnect() async => device != null;

  @override
  Future<DeviceStatus> onConnect() async {
    try {
      await device?.connect();

      // listen for BTLE connection events
      _subscription = device?.state?.listen((state) {
        switch (state) {
          case BluetoothDeviceState.connecting:
            status = DeviceStatus.connecting;

            break;
          case BluetoothDeviceState.connected:
            status = DeviceStatus.connected;

            break;
          case BluetoothDeviceState.disconnecting:
          case BluetoothDeviceState.disconnected:
            status = DeviceStatus.disconnected;
            break;
        }
      });

      // TODO - how can I listen to battery information?

      // device._subscription = movisens?.movisensStream.listen((event) {
      //   debug('$runtimeType :: Movisens event : $event');

      //   if (event.containsKey("BatteryLevel")) {
      //     _batteryLevel = int.tryParse(
      //             jsonDecode(event["BatteryLevel"].toString())[BATTERY_LEVEL]
      //                 .toString()) ??
      //         -1;
      //   }
      // });

      // set user data parameters
      await device?.userDataService
          ?.setAgeFloat(deviceDescriptor.age.toDouble());
      await device?.userDataService?.setSensorLocation(movisens
          .SensorLocation.values[deviceDescriptor.sensorLocation.index]);

      // TODO - how do I set the weight and gender of the user => https://github.com/cph-cachet/flutter-plugins/issues/648

    } catch (error) {
      warning(
          "$runtimeType - could not connect to device of type '$type' - error: $error");
      return DeviceStatus.error;
    }

    return DeviceStatus.connecting;
  }

  @override
  Future<bool> onDisconnect() async {
    _subscription?.cancel();
    await device?.disconnect();
    return true;
  }
}
