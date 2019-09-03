// GENERATED CODE - DO NOT MODIFY BY HAND

part of apps;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppUsageMeasure _$AppUsageMeasureFromJson(Map<String, dynamic> json) {
  return AppUsageMeasure(
    json['type'] == null
        ? null
        : MeasureType.fromJson(json['type'] as Map<String, dynamic>),
    name: json['name'],
    enabled: json['enabled'],
    duration: json['duration'] as int,
  )
    ..c__ = json['c__'] as String
    ..configuration = (json['configuration'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as String),
    );
}

Map<String, dynamic> _$AppUsageMeasureToJson(AppUsageMeasure instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('c__', instance.c__);
  writeNotNull('type', instance.type);
  writeNotNull('name', instance.name);
  writeNotNull('enabled', instance.enabled);
  writeNotNull('configuration', instance.configuration);
  writeNotNull('duration', instance.duration);
  return val;
}

AppsDatum _$AppsDatumFromJson(Map<String, dynamic> json) {
  return AppsDatum()
    ..id = json['id'] as String
    ..timestamp = json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String)
    ..installedApps =
        (json['installed_apps'] as List)?.map((e) => e as String)?.toList();
}

Map<String, dynamic> _$AppsDatumToJson(AppsDatum instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('timestamp', instance.timestamp?.toIso8601String());
  writeNotNull('installed_apps', instance.installedApps);
  return val;
}

AppUsageDatum _$AppUsageDatumFromJson(Map<String, dynamic> json) {
  return AppUsageDatum()
    ..id = json['id'] as String
    ..timestamp = json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String)
    ..start =
        json['start'] == null ? null : DateTime.parse(json['start'] as String)
    ..end = json['end'] == null ? null : DateTime.parse(json['end'] as String)
    ..usage = (json['usage'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, (e as num)?.toDouble()),
    );
}

Map<String, dynamic> _$AppUsageDatumToJson(AppUsageDatum instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('timestamp', instance.timestamp?.toIso8601String());
  writeNotNull('start', instance.start?.toIso8601String());
  writeNotNull('end', instance.end?.toIso8601String());
  writeNotNull('usage', instance.usage);
  return val;
}
