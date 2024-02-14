part of carp_movesense_package;

/// Enumeration of supported Polar devices.
enum MovesenseDeviceType {
  /// Unknown Movesense type
  UNKNOWN,

  /// Movesense Medical sensor
  MD,

  /// Movesense ACTIVE HR+ and HR2 sensor
  ACTIVE,

  /// Movesense FLASH sensor
  FLASH,
}

@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class MovesenseDevice extends BLEHeartRateDevice {
  static const String DEVICE_TYPE =
      '${DeviceConfiguration.DEVICE_NAMESPACE}.MovesenseDevice';

  static const String DEFAULT_ROLE_NAME = 'Movesense Device';

  /// The Movesense device address.
  ///
  /// Address is Bluetooth MAC address for Android devices and UUID for iOS devices.
  String? address;

  /// The Movesense device serial number.
  String? serial;

  /// The Movesense device name.
  String? name;

  /// The type of Movesense device, if known.
  MovesenseDeviceType? deviceType;

  MovesenseDevice(
      {super.roleName = MovesenseDevice.DEFAULT_ROLE_NAME,
      super.isOptional = true,
      this.name,
      this.address,
      this.serial,
      this.deviceType});

  @override
  Function get fromJsonFunction => _$MovesenseDeviceFromJson;
  factory MovesenseDevice.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as MovesenseDevice;
  @override
  Map<String, dynamic> toJson() => _$MovesenseDeviceToJson(this);
}

class MovesenseDeviceManager extends BTLEDeviceManager<MovesenseDevice> {
  MovesenseDeviceManager(super.type);

  @override
  String get btleAddress => configuration?.address ?? '';

  @override
  set btleAddress(String btleAddress) {
    configuration?.address = btleAddress;
  }

  @override
  String get btleName => configuration?.name ?? 'Unknown';

  @override
  set btleName(String btleName) {
    configuration?.name = btleName;

    // the typical name is "Movesense 220330000122" where the last part is the serial number
    if (btleName.split(' ').first.toUpperCase() == 'MOVESENSE') {
      configuration?.serial = btleName.split(' ').last;
    }
  }

  @override
  String get id => configuration?.address ?? '???';

  int? _batteryLevel;

  @override
  int? get batteryLevel => _batteryLevel;

  @override
  Future<bool> canConnect() async => configuration?.address != null;

  @override
  String? get displayName => btleName;

  final StreamController<int> _batteryEventController =
      StreamController.broadcast();

  @override
  Stream<int> get batteryEvents => _batteryEventController.stream;

  String? get address => configuration?.address;

  String get serial => configuration?.serial ?? '???';

  @override
  Future<DeviceStatus> onConnect() async {
    if (isConnected) return status;
    if (btleAddress.isEmpty) {
      warning(
          '$runtimeType - cannot connect to device, BLE address is missing.');
      return status;
    }

    status = DeviceStatus.connecting;

    Mds.connect(
      btleAddress,
      // onConnected
      (serial) {
        configuration?.serial = serial;
        status = DeviceStatus.connected;

        debug("$runtimeType - Successfully connected.");

        _setupBatteryMonitoring();
      },
      // onDisconnected
      () {
        debug("$runtimeType - Device disconnected.");
        status = DeviceStatus.disconnected;
        _batteryLevel = null;
      },
      // onConnectionError
      () {
        warning("$runtimeType - Error in connecting to device.");
        status = DeviceStatus.error;
      },
    );

    return status;
  }

  void _setupBatteryMonitoring() {
    Timer.periodic(const Duration(minutes: 1), (_) {
      Mds.get(
        Mds.createRequestUri(serial, "/System/States/1"),
        "{}",
        ((data, statusCode) {
          final dataContent = json.decode(data);
          num batteryState = dataContent["content"] as num;
          debug("$runtimeType - Battery state: $batteryState");
          _batteryLevel = batteryState == 1 ? 10 : 80;
          _batteryEventController.add(_batteryLevel ?? 0);
        }),
        (error, statusCode) => {},
      );
    });
  }

  @override
  Future<bool> onDisconnect() async {
    if (configuration?.address == null) {
      warning('$runtimeType - cannot disconnect from device, address is null.');
      return false;
    }
    Mds.disconnect(configuration!.address!);
    return true;
  }
}
