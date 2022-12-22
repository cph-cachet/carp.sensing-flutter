// GENERATED CODE - DO NOT MODIFY BY HAND

part of connectivity;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Connectivity _$ConnectivityFromJson(Map<String, dynamic> json) => Connectivity()
  ..$type = json['__type'] as String?
  ..connectivityStatus = json['connectivity_status'] as String;

Map<String, dynamic> _$ConnectivityToJson(Connectivity instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['connectivity_status'] = instance.connectivityStatus;
  return val;
}

Bluetooth _$BluetoothFromJson(Map<String, dynamic> json) => Bluetooth(
      startScan: json['start_scan'] == null
          ? null
          : DateTime.parse(json['start_scan'] as String),
      endScan: json['end_scan'] == null
          ? null
          : DateTime.parse(json['end_scan'] as String),
    )
      ..$type = json['__type'] as String?
      ..scanResult = (json['scan_result'] as List<dynamic>)
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
  val['start_scan'] = instance.startScan.toIso8601String();
  writeNotNull('end_scan', instance.endScan?.toIso8601String());
  val['scan_result'] = instance.scanResult;
  return val;
}

BluetoothDevice _$BluetoothDeviceFromJson(Map<String, dynamic> json) =>
    BluetoothDevice(
      advertisementName: json['advertisement_name'] as String,
      bluetoothDeviceId: json['bluetooth_device_id'] as String,
      bluetoothDeviceName: json['bluetooth_device_name'] as String,
      bluetoothDeviceType: json['bluetooth_device_type'] as String,
      connectable: json['connectable'] as bool,
      rssi: json['rssi'] as int,
      txPowerLevel: json['tx_power_level'] as int?,
    );

Map<String, dynamic> _$BluetoothDeviceToJson(BluetoothDevice instance) {
  final val = <String, dynamic>{
    'advertisement_name': instance.advertisementName,
    'bluetooth_device_id': instance.bluetoothDeviceId,
    'bluetooth_device_name': instance.bluetoothDeviceName,
    'bluetooth_device_type': instance.bluetoothDeviceType,
    'connectable': instance.connectable,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('tx_power_level', instance.txPowerLevel);
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
