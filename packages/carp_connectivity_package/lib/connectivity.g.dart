// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connectivity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Connectivity _$ConnectivityFromJson(Map<String, dynamic> json) => Connectivity()
  ..$type = json['__type'] as String?
  ..connectivityStatus = (json['connectivityStatus'] as List<dynamic>)
      .map((e) => $enumDecode(_$ConnectivityStatusEnumMap, e))
      .toList();

Map<String, dynamic> _$ConnectivityToJson(Connectivity instance) =>
    <String, dynamic>{
      if (instance.$type case final value?) '__type': value,
      'connectivityStatus': instance.connectivityStatus
          .map((e) => _$ConnectivityStatusEnumMap[e]!)
          .toList(),
    };

const _$ConnectivityStatusEnumMap = {
  ConnectivityStatus.bluetooth: 'bluetooth',
  ConnectivityStatus.wifi: 'wifi',
  ConnectivityStatus.ethernet: 'ethernet',
  ConnectivityStatus.mobile: 'mobile',
  ConnectivityStatus.none: 'none',
  ConnectivityStatus.vpn: 'vpn',
  ConnectivityStatus.unknown: 'unknown',
};

Bluetooth _$BluetoothFromJson(Map<String, dynamic> json) => Bluetooth(
      startScan: json['startScan'] == null
          ? null
          : DateTime.parse(json['startScan'] as String),
      endScan: json['endScan'] == null
          ? null
          : DateTime.parse(json['endScan'] as String),
    )
      ..$type = json['__type'] as String?
      ..scanResult = (json['scanResult'] as List<dynamic>)
          .map((e) => BluetoothDevice.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$BluetoothToJson(Bluetooth instance) => <String, dynamic>{
      if (instance.$type case final value?) '__type': value,
      'startScan': instance.startScan.toIso8601String(),
      if (instance.endScan?.toIso8601String() case final value?)
        'endScan': value,
      'scanResult': instance.scanResult.map((e) => e.toJson()).toList(),
    };

BluetoothDevice _$BluetoothDeviceFromJson(Map<String, dynamic> json) =>
    BluetoothDevice(
      advertisementName: json['advertisementName'] as String,
      bluetoothDeviceId: json['bluetoothDeviceId'] as String,
      bluetoothDeviceName: json['bluetoothDeviceName'] as String,
      connectable: json['connectable'] as bool,
      rssi: (json['rssi'] as num).toInt(),
      txPowerLevel: (json['txPowerLevel'] as num?)?.toInt(),
    );

Map<String, dynamic> _$BluetoothDeviceToJson(BluetoothDevice instance) =>
    <String, dynamic>{
      'advertisementName': instance.advertisementName,
      'bluetoothDeviceId': instance.bluetoothDeviceId,
      'bluetoothDeviceName': instance.bluetoothDeviceName,
      'connectable': instance.connectable,
      if (instance.txPowerLevel case final value?) 'txPowerLevel': value,
      'rssi': instance.rssi,
    };

Wifi _$WifiFromJson(Map<String, dynamic> json) => Wifi(
      ssid: json['ssid'] as String?,
      bssid: json['bssid'] as String?,
      ip: json['ip'] as String?,
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$WifiToJson(Wifi instance) => <String, dynamic>{
      if (instance.$type case final value?) '__type': value,
      if (instance.ssid case final value?) 'ssid': value,
      if (instance.bssid case final value?) 'bssid': value,
      if (instance.ip case final value?) 'ip': value,
    };
