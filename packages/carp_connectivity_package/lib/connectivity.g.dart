// GENERATED CODE - DO NOT MODIFY BY HAND

part of connectivity;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConnectivityDatum _$ConnectivityDatumFromJson(Map<String, dynamic> json) =>
    ConnectivityDatum()
      ..id = json['id'] as String?
      ..timestamp = DateTime.parse(json['timestamp'] as String)
      ..connectivityStatus = json['connectivity_status'] as String;

Map<String, dynamic> _$ConnectivityDatumToJson(ConnectivityDatum instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['timestamp'] = instance.timestamp.toIso8601String();
  val['connectivity_status'] = instance.connectivityStatus;
  return val;
}

BluetoothDatum _$BluetoothDatumFromJson(Map<String, dynamic> json) =>
    BluetoothDatum()
      ..id = json['id'] as String?
      ..timestamp = DateTime.parse(json['timestamp'] as String)
      ..scanResult = (json['scan_result'] as List<dynamic>)
          .map((e) => BluetoothDevice.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$BluetoothDatumToJson(BluetoothDatum instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['timestamp'] = instance.timestamp.toIso8601String();
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

WifiDatum _$WifiDatumFromJson(Map<String, dynamic> json) => WifiDatum(
      ssid: json['ssid'] as String?,
      bssid: json['bssid'] as String?,
      ip: json['ip'] as String?,
    )
      ..id = json['id'] as String?
      ..timestamp = DateTime.parse(json['timestamp'] as String);

Map<String, dynamic> _$WifiDatumToJson(WifiDatum instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['timestamp'] = instance.timestamp.toIso8601String();
  writeNotNull('ssid', instance.ssid);
  writeNotNull('bssid', instance.bssid);
  writeNotNull('ip', instance.ip);
  return val;
}
