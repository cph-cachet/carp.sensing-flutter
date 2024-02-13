part of carp_movesense_package;

@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class MovesenseDevice extends BLEHeartRateDevice {
  static const String DEVICE_TYPE =
      '${DeviceConfiguration.DEVICE_NAMESPACE}.MovesenseDevice';

  static const String DEFAULT_ROLENAME = 'Movesense Device';

  String? address;

  String? serial;

  String? name;

  String? identifier;

  MovesenseDevice(
      {super.roleName = MovesenseDevice.DEFAULT_ROLENAME,
      this.name,
      this.identifier});

  @override
  Function get fromJsonFunction => _$MovesenseDeviceFromJson;
  factory MovesenseDevice.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as MovesenseDevice;
  @override
  Map<String, dynamic> toJson() => _$MovesenseDeviceToJson(this);
}

class MovesenseDeviceManager extends BTLEDeviceManager<MovesenseDevice> {
  MovesenseDeviceManager(super.type);

  int? _batteryLevel;

  StreamSubscription<dynamic>? _movesensSubscription, _batterySubscription;

  String? get address => configuration?.address;

  @override
  String get btleName => configuration?.name ?? '';

  @override
  set btleName(String btleName) {
    configuration?.name = btleName;
  }

  @override
  String get btleAddress => configuration?.address ?? '';

  @override
  set btleAddress(String btleAddress) {
    configuration?.address = btleAddress;
  }

  @override
  String get id => configuration?.identifier ?? '233830000615';

  String get serial => configuration?.serial ?? '?????';

  @override
  int? get batteryLevel => _batteryLevel;

  @override
  Future<bool> canConnect() async => configuration?.identifier != null;

  @override
  String? get displayName => btleName;

  @override
  Future<DeviceStatus> onConnect() async {
    status = DeviceStatus.connecting;
    if (isConnected) return status;
    if (configuration?.identifier == null) {
      warning('$runtimeType - cannot connect to device, identifier is null.');

      return DeviceStatus.error;
    } else {
      if (btleAddress.isEmpty) {
        status = DeviceStatus.connecting;
        Mds.startScan((name, address) {
          // Typical name is "Movesense 220330000122" so only check for last part
          if (name?.split(' ').last.compareTo(id) == 0) {
            btleAddress = address!;
            Mds.stopScan();
            Mds.connect(
              address,
              (serial) {
                // When connected, we know the serial number (which should correspond to [identifier])
                configuration?.serial = serial;
                status = DeviceStatus.connected;

                debug("successfully connected");

                Mds.get(Mds.createRequestUri(serial, "/System/States/1"), "{}",
                    ((data, statusCode) {
                  final dataContent = json.decode(data);
                  num batteryState = dataContent["Content"];
                  _batteryLevel = batteryState == 1 ? 20 : 80;
                  debug("battery level: " + _batteryLevel.toString());
                }), ((error, statusCode) => {}));

                _batterySubscription = MdsAsync.subscribe(
                        Mds.createSubscriptionUri(serial, "/System/States/1"),
                        "{}")
                    .listen((event) {
                  // Save the battery level locally
                  debug(" battery event: " + event.toString());
                  num batteryState = event["Body"]["NewState"];
                  debug("battery state: " + batteryState.toString());
                  _batteryLevel = batteryState == 1 ? 20 : 80;
                  debug("battery level: " + _batteryLevel.toString());
                });
              },
              () => status = DeviceStatus.disconnected,
              () => status = DeviceStatus.error,
            );
          }
        });
      }
    }
    if (status == DeviceStatus.connecting) {
      warning('$runtimeType - cannot connect to device.');
      status = DeviceStatus.error;
    }
    debug("battery level: " + _batteryLevel.toString());
    return status;
  }

  @override
  Future<bool> onDisconnect() async {
    if (configuration?.identifier == null) {
      warning(
          '$runtimeType - cannot disconnect from device, identifier is null.');
      return false;
    }
    Mds.disconnect(btleAddress);
    _batterySubscription?.cancel();
    return true;
  }
}
