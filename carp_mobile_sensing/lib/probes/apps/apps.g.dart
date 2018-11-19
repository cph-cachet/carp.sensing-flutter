// GENERATED CODE - DO NOT MODIFY BY HAND

part of apps;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppsDatum _$AppsDatumFromJson(Map<String, dynamic> json) {
  return AppsDatum()
    ..c__ = json['c__'] as String
    ..id = json['id'] as String
    ..timestamp = json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String)
    ..deviceInfo = json['device_info'] == null
        ? null
        : DeviceInfo.fromJson(json['device_info'] as Map<String, dynamic>)
    ..installedApps =
        (json['installed_apps'] as List)?.map((e) => e as String)?.toList();
}

Map<String, dynamic> _$AppsDatumToJson(AppsDatum instance) {
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
  writeNotNull('installed_apps', instance.installedApps);
  return val;
}

AppUsageDatum _$AppUsageDatumFromJson(Map<String, dynamic> json) {
  return AppUsageDatum()
    ..c__ = json['c__'] as String
    ..id = json['id'] as String
    ..timestamp = json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String)
    ..deviceInfo = json['device_info'] == null
        ? null
        : DeviceInfo.fromJson(json['device_info'] as Map<String, dynamic>)
    ..usage = (json['usage'] as Map<String, dynamic>)
        ?.map((k, e) => MapEntry(k, (e as num)?.toDouble()));
}

Map<String, dynamic> _$AppUsageDatumToJson(AppUsageDatum instance) {
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
  writeNotNull('usage', instance.usage);
  return val;
}

AppUsageMeasure _$AppUsageMeasureFromJson(Map<String, dynamic> json) {
  return AppUsageMeasure(json['measure_type'],
      name: json['name'],
      frequency: json['frequency'],
      duration: json['duration'])
    ..c__ = json['c__'] as String
    ..enabled = json['enabled'] as bool
    ..configuration = (json['configuration'] as Map<String, dynamic>)
        ?.map((k, e) => MapEntry(k, e as String));
}

Map<String, dynamic> _$AppUsageMeasureToJson(AppUsageMeasure instance) {
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
