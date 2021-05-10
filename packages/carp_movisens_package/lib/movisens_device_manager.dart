/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of movisens;

/// A [DeviceDescriptor] for a Movisens device used in a [StudyProtocol].
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class MovisensDevice extends DeviceDescriptor {
  /// The type of a Movisens device.
  static const String DEVICE_TYPE =
      '${DeviceDescriptor.DEVICE_NAMESPACE}.MovisensDevice';

  /// The default rolename for a Movisens device.
  static const String DEFAULT_ROLENAME = 'movisens';

  MovisensDevice({
    String roleName = DEFAULT_ROLENAME,
    List<String> supportedDataTypes,
  })
      : super(
          roleName: roleName,
          isMasterDevice: false,
          supportedDataTypes: supportedDataTypes,
        );

  Function get fromJsonFunction => _$MovisensDeviceFromJson;
  factory MovisensDevice.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json);
  Map<String, dynamic> toJson() => _$MovisensDeviceToJson(this);
}

class MovisensDeviceManager extends DeviceManager {
  // the last known voltage level of the Movisens device
  int _batteryLevel = 100;
  String _connectionStatus;
  // StreamSubscription<Map<String, dynamic>> _eventSubscription;

  String get id => userData?.sensorName ?? 'movisens-123';
  String get connectionStatus => _connectionStatus;

  Future initialize(String type) async {
    super.initialize(type);

    // TODO - should be possible to init a device manager before connecting to the probe.....
    assert(movisens != null, 'The Movisens probe has not been initialized.');

    // listen for Movisens events
    movisens.movisensStream.listen((event) {
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
  }

  /// The latest read of the battery level of the Movisens device.
  int get batteryLevel => _batteryLevel;

  bool canConnect() => true;
  Future connect() async {}
  Future disconnect() async {}
}
