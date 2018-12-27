/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of connectivity;

/// A [Datum] that holds connectivity status of the phone.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class ConnectivityDatum extends CARPDatum {
  static DataFormat CARP_DATA_FORMAT = DataFormat(NameSpace.CARP, DataType.CONNECTIVITY);
  DataFormat get format => CARP_DATA_FORMAT;

  /// The status of the connectivity.
  /// - WiFi: Device connected via Wi-Fi
  /// - Mobile: Device connected to cellular network
  /// - None: Device not connected to any network
  String connectivityStatus;

  ConnectivityDatum() : super();

  ConnectivityDatum.fromConnectivityResult(ConnectivityResult result)
      : connectivityStatus = _parseConnectivityStatus(result),
        super();

  factory ConnectivityDatum.fromJson(Map<String, dynamic> json) => _$ConnectivityDatumFromJson(json);
  Map<String, dynamic> toJson() => _$ConnectivityDatumToJson(this);

  static String _parseConnectivityStatus(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
        return "wifi";
      case ConnectivityResult.mobile:
        return "mobile";
      case ConnectivityResult.none:
        return "none";
      default:
        return "unknown";
    }
  }

  String toString() => 'connectivity_status: $connectivityStatus';
}

/// A [Datum] that holds information on nearby Bluetoth devices.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class BluetoothDatum extends CARPDatum {
  static DataFormat CARP_DATA_FORMAT = DataFormat(NameSpace.CARP, DataType.BLUETOOTH);
  DataFormat get format => CARP_DATA_FORMAT;

  /// The bluetooth id of the nearby device.
  String bluetoothDeviceId;

  /// The bluetooth name of the nearby device.
  String bluetoothDeviceName;

  /// The type of bluetooth device:
  /// - classic
  /// - dual
  /// - le
  /// - unknown
  String bluetoothDeviceType;

  /// Is the device connectable.
  bool connectable;

  /// The power level of the device in percentage.
  int txPowerLevel;

  /// The RSSI signal strength to the device.
  int rssi;

  BluetoothDatum() : super();

  factory BluetoothDatum.fromScanResult(ScanResult result) => BluetoothDatum()
    ..bluetoothDeviceId = result.device.id.id
    ..bluetoothDeviceName = result.device.name
    ..connectable = result.advertisementData.connectable
    ..txPowerLevel = result.advertisementData.txPowerLevel
    ..rssi = result.rssi
    ..bluetoothDeviceType = getBluetoothDeviceType(result.device.type);

  static String getBluetoothDeviceType(BluetoothDeviceType type) {
    switch (type) {
      case BluetoothDeviceType.classic:
        return "classic";
      case BluetoothDeviceType.dual:
        return "dual";
      case BluetoothDeviceType.le:
        return "le";
      default:
        return "unknown";
    }
  }

  factory BluetoothDatum.fromJson(Map<String, dynamic> json) => _$BluetoothDatumFromJson(json);
  Map<String, dynamic> toJson() => _$BluetoothDatumToJson(this);

  String toString() =>
      'bluetooth_device: {id: $bluetoothDeviceId, name: $bluetoothDeviceName, type: $bluetoothDeviceType, connectable: $connectable, rssi: $rssi}';
}
