// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connectivity_datum.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConnectivityDatum _$ConnectivityDatumFromJson(Map<String, dynamic> json) {
  return ConnectivityDatum()
    ..$ = json[r'$'] as String
    ..id = json['id'] as String
    ..timestamp = json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String)
    ..deviceInfo = json['device_info'] == null
        ? null
        : DeviceInfo.fromJson(json['device_info'] as Map<String, dynamic>)
    ..connectivityStatus = json['connectivity_status'] as String;
}

Map<String, dynamic> _$ConnectivityDatumToJson(ConnectivityDatum instance) {
  var val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$', instance.$);
  writeNotNull('id', instance.id);
  writeNotNull('timestamp', instance.timestamp?.toIso8601String());
  writeNotNull('device_info', instance.deviceInfo);
  writeNotNull('connectivity_status', instance.connectivityStatus);
  return val;
}

BluetoothDatum _$BluetoothDatumFromJson(Map<String, dynamic> json) {
  return BluetoothDatum()
    ..$ = json[r'$'] as String
    ..id = json['id'] as String
    ..timestamp = json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String)
    ..deviceInfo = json['device_info'] == null
        ? null
        : DeviceInfo.fromJson(json['device_info'] as Map<String, dynamic>)
    ..bluetoothDeviceId = json['bluetooth_device_id'] as String
    ..bluetoothDeviceName = json['bluetooth_device_name'] as String
    ..bluetoothDeviceType = json['bluetooth_device_type'] as String
    ..connectable = json['connectable'] as bool
    ..txPowerLevel = json['tx_power_level'] as int
    ..rssi = json['rssi'] as int;
}

Map<String, dynamic> _$BluetoothDatumToJson(BluetoothDatum instance) {
  var val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$', instance.$);
  writeNotNull('id', instance.id);
  writeNotNull('timestamp', instance.timestamp?.toIso8601String());
  writeNotNull('device_info', instance.deviceInfo);
  writeNotNull('bluetooth_device_id', instance.bluetoothDeviceId);
  writeNotNull('bluetooth_device_name', instance.bluetoothDeviceName);
  writeNotNull('bluetooth_device_type', instance.bluetoothDeviceType);
  writeNotNull('connectable', instance.connectable);
  writeNotNull('tx_power_level', instance.txPowerLevel);
  writeNotNull('rssi', instance.rssi);
  return val;
}
