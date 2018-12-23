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
  static DataType CARP_DATA_FORMAT = new DataType(NameSpace.CARP_NAMESPACE, MeasureType.CONNECTIVITY);

  /// The status of the connectivity.
  /// - WiFi: Device connected via Wi-Fi
  /// - Mobile: Device connected to cellular network
  /// - None: Device not connected to any network
  String connectivityStatus;

  ConnectivityDatum({Measure measure}) : super(measure: measure);

  factory ConnectivityDatum.fromJson(Map<String, dynamic> json) => _$ConnectivityDatumFromJson(json);
  Map<String, dynamic> toJson() => _$ConnectivityDatumToJson(this);

  DataType getCARPDataFormat() => CARP_DATA_FORMAT;

  String toString() => 'connectivity_status: $connectivityStatus';
}

/// A [Datum] that holds information on nearby Bluetoth devices.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class BluetoothDatum extends CARPDatum {
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

  BluetoothDatum({Measure measure}) : super(measure: measure);

  factory BluetoothDatum.fromJson(Map<String, dynamic> json) => _$BluetoothDatumFromJson(json);
  Map<String, dynamic> toJson() => _$BluetoothDatumToJson(this);

  String toString() =>
      'bluetooth_device: {id: $bluetoothDeviceId, name: $bluetoothDeviceName, type: $bluetoothDeviceType, connectable: $connectable, rssi: $rssi}';
}
