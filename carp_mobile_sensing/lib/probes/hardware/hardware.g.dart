// GENERATED CODE - DO NOT MODIFY BY HAND

part of hardware;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BatteryDatum _$BatteryDatumFromJson(Map<String, dynamic> json) {
  return BatteryDatum()
    ..$ = json[r'$'] as String
    ..id = json['id'] as String
    ..timestamp = json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String)
    ..deviceInfo = json['device_info'] == null
        ? null
        : DeviceInfo.fromJson(json['device_info'] as Map<String, dynamic>)
    ..batteryLevel = json['battery_level'] as int
    ..batteryStatus = json['battery_status'] as String;
}

Map<String, dynamic> _$BatteryDatumToJson(BatteryDatum instance) {
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
  writeNotNull('battery_level', instance.batteryLevel);
  writeNotNull('battery_status', instance.batteryStatus);
  return val;
}

FreeMemoryDatum _$FreeMemoryDatumFromJson(Map<String, dynamic> json) {
  return FreeMemoryDatum()
    ..$ = json[r'$'] as String
    ..id = json['id'] as String
    ..timestamp = json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String)
    ..deviceInfo = json['device_info'] == null
        ? null
        : DeviceInfo.fromJson(json['device_info'] as Map<String, dynamic>)
    ..freePhysicalMemory = json['free_physical_memory'] as int
    ..freeVirtualMemory = json['free_virtual_memory'] as int;
}

Map<String, dynamic> _$FreeMemoryDatumToJson(FreeMemoryDatum instance) {
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
  writeNotNull('free_physical_memory', instance.freePhysicalMemory);
  writeNotNull('free_virtual_memory', instance.freeVirtualMemory);
  return val;
}

ScreenDatum _$ScreenDatumFromJson(Map<String, dynamic> json) {
  return ScreenDatum()
    ..$ = json[r'$'] as String
    ..id = json['id'] as String
    ..timestamp = json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String)
    ..deviceInfo = json['device_info'] == null
        ? null
        : DeviceInfo.fromJson(json['device_info'] as Map<String, dynamic>)
    ..screenEvent = json['screen_event'] as String;
}

Map<String, dynamic> _$ScreenDatumToJson(ScreenDatum instance) {
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
  writeNotNull('screen_event', instance.screenEvent);
  return val;
}

BatteryMeasure _$BatteryMeasureFromJson(Map<String, dynamic> json) {
  return BatteryMeasure(json['measure_type'] as String, name: json['name'])
    ..$ = json[r'$'] as String
    ..enabled = json['enabled'] as bool
    ..configuration = (json['configuration'] as Map<String, dynamic>)
        ?.map((k, e) => MapEntry(k, e as String));
}

Map<String, dynamic> _$BatteryMeasureToJson(BatteryMeasure instance) {
  var val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$', instance.$);
  writeNotNull('measure_type', instance.measureType);
  writeNotNull('name', instance.name);
  writeNotNull('enabled', instance.enabled);
  writeNotNull('configuration', instance.configuration);
  return val;
}

ScreenMeasure _$ScreenMeasureFromJson(Map<String, dynamic> json) {
  return ScreenMeasure(json['measure_type'] as String, name: json['name'])
    ..$ = json[r'$'] as String
    ..enabled = json['enabled'] as bool
    ..configuration = (json['configuration'] as Map<String, dynamic>)
        ?.map((k, e) => MapEntry(k, e as String));
}

Map<String, dynamic> _$ScreenMeasureToJson(ScreenMeasure instance) {
  var val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$', instance.$);
  writeNotNull('measure_type', instance.measureType);
  writeNotNull('name', instance.name);
  writeNotNull('enabled', instance.enabled);
  writeNotNull('configuration', instance.configuration);
  return val;
}
