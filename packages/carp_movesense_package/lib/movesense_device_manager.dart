part of carp_movesense_package;

/// Enumeration of supported Movesense devices.
enum MovesenseDeviceType {
  /// Unknown Movesense type
  UNKNOWN,

  /// Movesense Medical sensor
  MD,

  /// Movesense ACTIVE HR+
  HR_PLUS,

  /// Movesense ACTIVE HR2 sensor
  HR2,

  /// Movesense FLASH sensor
  FLASH,
}

@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class MovesenseDevice extends BLEHeartRateDevice {
  static const String DEVICE_TYPE =
      '${DeviceConfiguration.DEVICE_NAMESPACE}.MovesenseDevice';

  static const String DEFAULT_ROLE_NAME = 'Movesense ECG Device';

  /// The Movesense device address.
  ///
  /// Address is Bluetooth MAC address for Android devices and UUID for iOS devices.
  String? address;

  /// The Movesense device serial number.
  String? serial;

  /// The Movesense device name.
  String? name;

  /// The type of Movesense device, if known.
  MovesenseDeviceType deviceType;

  MovesenseDevice(
      {super.roleName = MovesenseDevice.DEFAULT_ROLE_NAME,
      super.isOptional = true,
      this.name,
      this.address,
      this.serial,
      this.deviceType = MovesenseDeviceType.UNKNOWN});

  @override
  Function get fromJsonFunction => _$MovesenseDeviceFromJson;
  factory MovesenseDevice.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as MovesenseDevice;
  @override
  Map<String, dynamic> toJson() => _$MovesenseDeviceToJson(this);
}

class MovesenseDeviceManager extends BTLEDeviceManager<MovesenseDevice> {
  int? _batteryLevel;
  final StreamController<int> _batteryEventController =
      StreamController.broadcast();

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

  @override
  int? get batteryLevel => _batteryLevel;

  @override
  Future<bool> canConnect() async => configuration?.address != null;

  @override
  String? get displayName => btleName;

  @override
  Stream<int> get batteryEvents => _batteryEventController.stream;

  /// The device info for the connected Movesense device.
  /// Only available after device is connected.
  /// See https://www.movesense.com/docs/esw/api_reference/#info
  Map<String, dynamic>? deviceInfo;

  /// The BLE address of the Movesense device.
  // String? get address => configuration?.address;

  /// The serial number of the connected Movesense device.
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

        _getDeviceInfo();
        _getBatteryStatus();
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

  /// Get the detailed info about this Movesense device.
  ///
  /// See https://www.movesense.com/docs/esw/api_reference/#info
  void _getDeviceInfo() {
    debug('$runtimeType - Getting device info.');

    Mds.get(
      Mds.createRequestUri(serial, "/Info"),
      "{}",
      ((data, statusCode) {
        debug('$runtimeType - Movesense Device Info:\n$data');
        final dataContent = json.decode(data);
        deviceInfo = dataContent["Content"] as Map<String, dynamic>;
        String hw = (deviceInfo!["hw"] as String).toUpperCase();
        debug('$runtimeType - HW: $hw');

        // Try to figure out the type of device based on the "hw" property
        //
        // H3 is "HR+", H4 is "HR2", A1 is "MD"
        switch (hw) {
          case 'A1':
            configuration?.deviceType = MovesenseDeviceType.MD;
            break;
          case 'H3':
            configuration?.deviceType = MovesenseDeviceType.HR_PLUS;
            break;
          case 'H4':
            configuration?.deviceType = MovesenseDeviceType.HR2;
            break;
          default:
            configuration?.deviceType = MovesenseDeviceType.UNKNOWN;
        }
        debug('$runtimeType - deviceType: ${configuration?.deviceType}');
      }),
      (error, statusCode) => {},
    );
  }

  /// Setting up a request (GET) for battery status at a regular interval.
  /// We can subscribe to battery state changes, but they come so rarely that its
  /// better to request the status.
  void _getBatteryStatus() {
    _batteryLevel = 80;
    debug('$runtimeType - Setting up battery monitoring.');

    Timer.periodic(const Duration(minutes: 10), (_) {
      Mds.get(
        Mds.createRequestUri(serial, "/System/States/1"),
        "{}",
        ((data, statusCode) {
          final dataContent = json.decode(data);
          num batteryState = dataContent["Content"] as num;
          // Movesense only reports "OK" (0) or "LOW" (1) battery state
          // This is translated to 80% & 10% battery level
          _batteryLevel = batteryState == 0 ? 80 : 10;
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
    debug(
        "$runtimeType - Disconnecting... address: '${configuration!.address}'");

    Mds.disconnect(configuration!.address!);
    return true;
  }
}
