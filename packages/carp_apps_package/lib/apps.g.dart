// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'apps.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Apps _$AppsFromJson(Map<String, dynamic> json) => Apps(
      (json['installedApps'] as List<dynamic>)
          .map((e) => App.fromJson(e as Map<String, dynamic>))
          .toList(),
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$AppsToJson(Apps instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['installedApps'] = instance.installedApps;
  return val;
}

App _$AppFromJson(Map<String, dynamic> json) => App(
      packageName: json['packageName'] as String?,
      appName: json['appName'] as String?,
      apkFilePath: json['apkFilePath'] as String?,
      versionName: json['versionName'] as String?,
      versionCode: json['versionCode'] as int?,
      dataDir: json['dataDir'] as String?,
      systemApp: json['systemApp'] as bool?,
      installTimeMillis: json['installTimeMillis'] as int?,
      updateTimeMillis: json['updateTimeMillis'] as int?,
      category: json['category'] as String?,
      enabled: json['enabled'] as bool?,
    );

Map<String, dynamic> _$AppToJson(App instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('packageName', instance.packageName);
  writeNotNull('appName', instance.appName);
  writeNotNull('apkFilePath', instance.apkFilePath);
  writeNotNull('versionName', instance.versionName);
  writeNotNull('versionCode', instance.versionCode);
  writeNotNull('dataDir', instance.dataDir);
  writeNotNull('systemApp', instance.systemApp);
  writeNotNull('installTimeMillis', instance.installTimeMillis);
  writeNotNull('updateTimeMillis', instance.updateTimeMillis);
  writeNotNull('category', instance.category);
  writeNotNull('enabled', instance.enabled);
  return val;
}

AppUsage _$AppUsageFromJson(Map<String, dynamic> json) => AppUsage(
      DateTime.parse(json['start'] as String),
      DateTime.parse(json['end'] as String),
      (json['usage'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as int),
          ) ??
          const {},
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$AppUsageToJson(AppUsage instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['start'] = instance.start.toIso8601String();
  val['end'] = instance.end.toIso8601String();
  val['usage'] = instance.usage;
  return val;
}
