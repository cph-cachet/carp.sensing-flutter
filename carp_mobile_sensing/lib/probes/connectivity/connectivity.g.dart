// GENERATED CODE - DO NOT MODIFY BY HAND

part of connectivity;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConnectivityDatum _$ConnectivityDatumFromJson(Map<String, dynamic> json) {
  return ConnectivityDatum()
    ..c__ = json['c__'] as String
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

  writeNotNull('c__', instance.c__);
  writeNotNull('id', instance.id);
  writeNotNull('timestamp', instance.timestamp?.toIso8601String());
  writeNotNull('device_info', instance.deviceInfo);
  writeNotNull('connectivity_status', instance.connectivityStatus);
  return val;
}

BluetoothDatum _$BluetoothDatumFromJson(Map<String, dynamic> json) {
  return BluetoothDatum()
    ..c__ = json['c__'] as String
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

  writeNotNull('c__', instance.c__);
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

ConnectivityMeasure _$ConnectivityMeasureFromJson(Map<String, dynamic> json) {
  return ConnectivityMeasure(json['measure_type'] as String, name: json['name'])
    ..c__ = json['c__'] as String
    ..enabled = json['enabled'] as bool
    ..configuration = (json['configuration'] as Map<String, dynamic>)
        ?.map((k, e) => MapEntry(k, e as String));
}

Map<String, dynamic> _$ConnectivityMeasureToJson(ConnectivityMeasure instance) {
  var val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('c__', instance.c__);
  writeNotNull('measure_type', instance.measureType);
  writeNotNull('name', instance.name);
  writeNotNull('enabled', instance.enabled);
  writeNotNull('configuration', instance.configuration);
  return val;
}

BluetoothMeasure _$BluetoothMeasureFromJson(Map<String, dynamic> json) {
  return BluetoothMeasure(json['measure_type'] as String,
      name: json['name'],
      frequency: json['frequency'],
      duration: json['duration'])
    ..c__ = json['c__'] as String
    ..enabled = json['enabled'] as bool
    ..configuration = (json['configuration'] as Map<String, dynamic>)
        ?.map((k, e) => MapEntry(k, e as String));
}

Map<String, dynamic> _$BluetoothMeasureToJson(BluetoothMeasure instance) {
  var val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('c__', instance.c__);
  writeNotNull('measure_type', instance.measureType);
  writeNotNull('name', instance.name);
  writeNotNull('enabled', instance.enabled);
  writeNotNull('configuration', instance.configuration);
  writeNotNull('frequency', instance.frequency);
  writeNotNull('duration', instance.duration);
  return val;
}
