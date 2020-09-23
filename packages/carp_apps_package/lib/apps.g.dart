// GENERATED CODE - DO NOT MODIFY BY HAND

part of carp_apps_package;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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
    ..usage = json['usage'] as Map<String, dynamic>;
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
