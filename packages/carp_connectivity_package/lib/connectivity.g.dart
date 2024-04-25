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

Map<String, dynamic> _$ConnectivityToJson(Connectivity instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['connectivityStatus'] = instance.connectivityStatus
      .map((e) => _$ConnectivityStatusEnumMap[e]!)
      .toList();
  return val;
}

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

Map<String, dynamic> _$BluetoothToJson(Bluetooth instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['startScan'] = instance.startScan.toIso8601String();
  writeNotNull('endScan', instance.endScan?.toIso8601String());
  val['scanResult'] = instance.scanResult;
  return val;
}

BluetoothDevice _$BluetoothDeviceFromJson(Map<String, dynamic> json) =>
    BluetoothDevice(
      advertisementName: json['advertisementName'] as String,
      bluetoothDeviceId: json['bluetoothDeviceId'] as String,
      bluetoothDeviceName: json['bluetoothDeviceName'] as String,
      connectable: json['connectable'] as bool,
      rssi: (json['rssi'] as num).toInt(),
      txPowerLevel: (json['txPowerLevel'] as num?)?.toInt(),
    );

Map<String, dynamic> _$BluetoothDeviceToJson(BluetoothDevice instance) {
  final val = <String, dynamic>{
    'advertisementName': instance.advertisementName,
    'bluetoothDeviceId': instance.bluetoothDeviceId,
    'bluetoothDeviceName': instance.bluetoothDeviceName,
    'connectable': instance.connectable,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('txPowerLevel', instance.txPowerLevel);
  val['rssi'] = instance.rssi;
  return val;
}

Wifi _$WifiFromJson(Map<String, dynamic> json) => Wifi(
      ssid: json['ssid'] as String?,
      bssid: json['bssid'] as String?,
      ip: json['ip'] as String?,
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$WifiToJson(Wifi instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  writeNotNull('ssid', instance.ssid);
  writeNotNull('bssid', instance.bssid);
  writeNotNull('ip', instance.ip);
  return val;
}
