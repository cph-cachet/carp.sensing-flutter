// GENERATED CODE - DO NOT MODIFY BY HAND

part of carp_apps_package;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppsDatum _$AppsDatumFromJson(Map<String, dynamic> json) => AppsDatum()
  ..id = json['id'] as String?
  ..timestamp = DateTime.parse(json['timestamp'] as String)
  ..installedApps = (json['installed_apps'] as List<dynamic>)
      .map((e) => e as String)
      .toList();

Map<String, dynamic> _$AppsDatumToJson(AppsDatum instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['timestamp'] = instance.timestamp.toIso8601String();
  val['installed_apps'] = instance.installedApps;
  return val;
}

AppUsageDatum _$AppUsageDatumFromJson(Map<String, dynamic> json) =>
    AppUsageDatum(
      DateTime.parse(json['start'] as String),
      DateTime.parse(json['end'] as String),
    )
      ..id = json['id'] as String?
      ..timestamp = DateTime.parse(json['timestamp'] as String)
      ..usage = Map<String, int>.from(json['usage'] as Map)
      ..startRange = (json['start_range'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, DateTime.parse(e as String)),
      )
      ..stopRange = (json['stop_range'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, DateTime.parse(e as String)),
      )
      ..lastUseForeground =
          (json['last_use_foreground'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, DateTime.parse(e as String)),
      );

Map<String, dynamic> _$AppUsageDatumToJson(AppUsageDatum instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['timestamp'] = instance.timestamp.toIso8601String();
  val['start'] = instance.start.toIso8601String();
  val['end'] = instance.end.toIso8601String();
  val['usage'] = instance.usage;
  val['start_range'] =
      instance.startRange.map((k, e) => MapEntry(k, e.toIso8601String()));
  val['stop_range'] =
      instance.stopRange.map((k, e) => MapEntry(k, e.toIso8601String()));
  val['last_use_foreground'] = instance.lastUseForeground
      .map((k, e) => MapEntry(k, e.toIso8601String()));
  return val;
}
