// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceInformation _$DeviceInformationFromJson(Map<String, dynamic> json) =>
    DeviceInformation(
      deviceData: json['deviceData'] as Map<String, dynamic>? ?? const {},
      platform: json['platform'] as String?,
      deviceId: json['deviceId'] as String?,
      deviceName: json['deviceName'] as String?,
      deviceModel: json['deviceModel'] as String?,
      deviceManufacturer: json['deviceManufacturer'] as String?,
      operatingSystem: json['operatingSystem'] as String?,
      hardware: json['hardware'] as String?,
    )
      ..$type = json['__type'] as String?
      ..sdk = json['sdk'] as String?
      ..release = json['release'] as String?;

Map<String, dynamic> _$DeviceInformationToJson(DeviceInformation instance) =>
    <String, dynamic>{
      if (instance.$type case final value?) '__type': value,
      if (instance.platform case final value?) 'platform': value,
      if (instance.deviceId case final value?) 'deviceId': value,
      if (instance.hardware case final value?) 'hardware': value,
      if (instance.deviceName case final value?) 'deviceName': value,
      if (instance.deviceManufacturer case final value?)
        'deviceManufacturer': value,
      if (instance.deviceModel case final value?) 'deviceModel': value,
      if (instance.operatingSystem case final value?) 'operatingSystem': value,
      if (instance.sdk case final value?) 'sdk': value,
      if (instance.release case final value?) 'release': value,
      'deviceData': instance.deviceData,
    };

BatteryState _$BatteryStateFromJson(Map<String, dynamic> json) => BatteryState(
      (json['batteryLevel'] as num?)?.toInt(),
      json['batteryStatus'] as String?,
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$BatteryStateToJson(BatteryState instance) =>
    <String, dynamic>{
      if (instance.$type case final value?) '__type': value,
      if (instance.batteryLevel case final value?) 'batteryLevel': value,
      if (instance.batteryStatus case final value?) 'batteryStatus': value,
    };

FreeMemory _$FreeMemoryFromJson(Map<String, dynamic> json) => FreeMemory(
      (json['freePhysicalMemory'] as num?)?.toInt(),
      (json['freeVirtualMemory'] as num?)?.toInt(),
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$FreeMemoryToJson(FreeMemory instance) =>
    <String, dynamic>{
      if (instance.$type case final value?) '__type': value,
      if (instance.freePhysicalMemory case final value?)
        'freePhysicalMemory': value,
      if (instance.freeVirtualMemory case final value?)
        'freeVirtualMemory': value,
    };

ScreenEvent _$ScreenEventFromJson(Map<String, dynamic> json) => ScreenEvent(
      json['screenEvent'] as String?,
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$ScreenEventToJson(ScreenEvent instance) =>
    <String, dynamic>{
      if (instance.$type case final value?) '__type': value,
      if (instance.screenEvent case final value?) 'screenEvent': value,
    };

Timezone _$TimezoneFromJson(Map<String, dynamic> json) => Timezone(
      json['timezone'] as String,
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$TimezoneToJson(Timezone instance) => <String, dynamic>{
      if (instance.$type case final value?) '__type': value,
      'timezone': instance.timezone,
    };
