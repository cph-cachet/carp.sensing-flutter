/*
 * Copyright 2018-2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of connectivity;

/// Connection status of a device.
enum ConnectivityStatus {
  /// Device connected via Bluetooth.
  bluetooth,

  /// Device connected via WiFi.
  wifi,

  /// Device connected to ethernet network.
  ethernet,

  /// Device connected to cellular network.
  mobile,

  /// Device not connected to any network.
  none,

  /// Device connected to a VPN.
  vpn,

  /// Unknown connectivity status.
  unknown,
}

/// Holds connectivity status of the phone.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class Connectivity extends Data {
  static const dataType = ConnectivitySamplingPackage.CONNECTIVITY;

  /// The status of the connectivity.
  ConnectivityStatus connectivityStatus = ConnectivityStatus.unknown;

  Connectivity() : super();

  Connectivity.fromConnectivityResult(connectivity.ConnectivityResult result)
      : connectivityStatus = _parseConnectivityStatus(result),
        super();

  @override
  Function get fromJsonFunction => _$ConnectivityFromJson;
  factory Connectivity.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as Connectivity;
  @override
  Map<String, dynamic> toJson() => _$ConnectivityToJson(this);

  static ConnectivityStatus _parseConnectivityStatus(
      connectivity.ConnectivityResult result) {
    switch (result) {
      case connectivity.ConnectivityResult.bluetooth:
        return ConnectivityStatus.bluetooth;
      case connectivity.ConnectivityResult.wifi:
        return ConnectivityStatus.wifi;
      case connectivity.ConnectivityResult.mobile:
        return ConnectivityStatus.mobile;
      case connectivity.ConnectivityResult.ethernet:
        return ConnectivityStatus.ethernet;
      case connectivity.ConnectivityResult.vpn:
        return ConnectivityStatus.vpn;
      case connectivity.ConnectivityResult.none:
        return ConnectivityStatus.none;
      default:
        return ConnectivityStatus.unknown;
    }
  }

  @override
  String toString() =>
      '${super.toString()}, connectivityStatus: ${connectivityStatus.name}';
}

/// A [Datum] that holds information of nearby Bluetooth devices.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class Bluetooth extends Data {
  static const dataType = ConnectivitySamplingPackage.BLUETOOTH;

  /// Timestamp of scan start.
  late DateTime startScan;

  /// Timestamp of scan end, if available.
  DateTime? endScan;

  /// A map of [BluetoothDevice] indexed by their [bluetoothDeviceId] to make
  /// sure that the same device only appears once.
  final Map<String, BluetoothDevice> _scanResult = {};

  /// The list of [BluetoothDevice] found in a scan.
  List<BluetoothDevice> get scanResult => _scanResult.values.toList();
  set scanResult(List<BluetoothDevice> devices) => _scanResult.addEntries(
      devices.map((device) => MapEntry(device.bluetoothDeviceId, device)));

  Bluetooth({DateTime? startScan, this.endScan}) : super() {
    this.startScan = startScan ?? DateTime.now();
  }

  void addBluetoothDevice(BluetoothDevice device) =>
      _scanResult[device.bluetoothDeviceId] = device;

  void addBluetoothDevicesFromScanResults(List<ScanResult> results) {
    for (var scanResult in results) {
      addBluetoothDevice(BluetoothDevice.fromScanResult(scanResult));
    }
  }

  @override
  Function get fromJsonFunction => _$BluetoothFromJson;
  factory Bluetooth.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as Bluetooth;
  @override
  Map<String, dynamic> toJson() => _$BluetoothToJson(this);

  @override
  String toString() => '${super.toString()}, scanResult: $scanResult';
}

/// Bluetooth device data.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class BluetoothDevice {
  /// The bluetooth advertising name of the device.
  String advertisementName;

  /// The bluetooth id of the nearby device.
  String bluetoothDeviceId;

  /// The bluetooth name of the nearby device.
  String bluetoothDeviceName;

  /// Is the device connectable.
  bool connectable;

  /// The power level of the device in percentage.
  int? txPowerLevel;

  /// The RSSI signal strength to the device.
  int rssi;

  BluetoothDevice({
    required this.advertisementName,
    required this.bluetoothDeviceId,
    required this.bluetoothDeviceName,
    required this.connectable,
    required this.rssi,
    this.txPowerLevel,
  }) : super();

  factory BluetoothDevice.fromScanResult(ScanResult result) => BluetoothDevice(
        bluetoothDeviceId: result.device.remoteId.str,
        bluetoothDeviceName: result.device.platformName,
        connectable: result.advertisementData.connectable,
        txPowerLevel: result.advertisementData.txPowerLevel,
        advertisementName: result.advertisementData.localName,
        rssi: result.rssi,
      );

  factory BluetoothDevice.fromJson(Map<String, dynamic> json) =>
      _$BluetoothDeviceFromJson(json);
  Map<String, dynamic> toJson() => _$BluetoothDeviceToJson(this);

  @override
  String toString() => '$runtimeType - '
      ', advertisementName: $advertisementName'
      ', id: $bluetoothDeviceId'
      ', name: $bluetoothDeviceName'
      ', connectable: $connectable'
      ', rssi: $rssi';
}

/// A [Datum] that holds wifi connectivity status in terms of connected SSID
/// and BSSID.
///
/// Note that it wifi information cannot be collected on emulators.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class Wifi extends Data {
  static const dataType = ConnectivitySamplingPackage.WIFI;

  /// The wifi service set ID (SSID) of the connected network
  String? ssid;

  /// The basic service set identifier (BSSID) of the connected network
  String? bssid;

  /// The internet protocol (IP) address of the connected network
  String? ip;

  Wifi({
    this.ssid,
    this.bssid,
    this.ip,
  }) : super();

  @override
  Function get fromJsonFunction => _$WifiFromJson;
  factory Wifi.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as Wifi;
  @override
  Map<String, dynamic> toJson() => _$WifiToJson(this);

  @override
  String toString() =>
      '${super.toString()}, SSID: $ssid, BSSID: $bssid, IP: $ip';
}
