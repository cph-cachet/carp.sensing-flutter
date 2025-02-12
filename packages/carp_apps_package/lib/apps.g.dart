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

Map<String, dynamic> _$AppsToJson(Apps instance) => <String, dynamic>{
      if (instance.$type case final value?) '__type': value,
      'installedApps': instance.installedApps.map((e) => e.toJson()).toList(),
    };

App _$AppFromJson(Map<String, dynamic> json) => App(
      packageName: json['packageName'] as String?,
      appName: json['appName'] as String?,
      apkFilePath: json['apkFilePath'] as String?,
      versionName: json['versionName'] as String?,
      versionCode: (json['versionCode'] as num?)?.toInt(),
      dataDir: json['dataDir'] as String?,
      systemApp: json['systemApp'] as bool?,
      installTimeMillis: (json['installTimeMillis'] as num?)?.toInt(),
      updateTimeMillis: (json['updateTimeMillis'] as num?)?.toInt(),
      category: json['category'] as String?,
      enabled: json['enabled'] as bool?,
    )..builtWith = json['builtWith'] as String?;

Map<String, dynamic> _$AppToJson(App instance) => <String, dynamic>{
      if (instance.packageName case final value?) 'packageName': value,
      if (instance.appName case final value?) 'appName': value,
      if (instance.apkFilePath case final value?) 'apkFilePath': value,
      if (instance.versionName case final value?) 'versionName': value,
      if (instance.versionCode case final value?) 'versionCode': value,
      if (instance.dataDir case final value?) 'dataDir': value,
      if (instance.systemApp case final value?) 'systemApp': value,
      if (instance.installTimeMillis case final value?)
        'installTimeMillis': value,
      if (instance.updateTimeMillis case final value?)
        'updateTimeMillis': value,
      if (instance.category case final value?) 'category': value,
      if (instance.enabled case final value?) 'enabled': value,
      if (instance.builtWith case final value?) 'builtWith': value,
    };

AppUsage _$AppUsageFromJson(Map<String, dynamic> json) => AppUsage(
      DateTime.parse(json['start'] as String),
      DateTime.parse(json['end'] as String),
      (json['usage'] as Map<String, dynamic>?)?.map(
            (k, e) =>
                MapEntry(k, AppUsageInfo.fromJson(e as Map<String, dynamic>)),
          ) ??
          const {},
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$AppUsageToJson(AppUsage instance) => <String, dynamic>{
      if (instance.$type case final value?) '__type': value,
      'start': instance.start.toIso8601String(),
      'end': instance.end.toIso8601String(),
      'usage': instance.usage.map((k, e) => MapEntry(k, e.toJson())),
    };

AppUsageInfo _$AppUsageInfoFromJson(Map<String, dynamic> json) => AppUsageInfo(
      json['packageName'] as String,
      json['appName'] as String,
      Duration(microseconds: (json['usage'] as num).toInt()),
      DateTime.parse(json['startDate'] as String),
      DateTime.parse(json['endDate'] as String),
      DateTime.parse(json['lastForeground'] as String),
    );

Map<String, dynamic> _$AppUsageInfoToJson(AppUsageInfo instance) =>
    <String, dynamic>{
      'packageName': instance.packageName,
      'appName': instance.appName,
      'usage': instance.usage.inMicroseconds,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'lastForeground': instance.lastForeground.toIso8601String(),
    };
