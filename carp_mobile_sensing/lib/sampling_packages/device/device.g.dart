// GENERATED CODE - DO NOT MODIFY BY HAND

part of device;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceInformation _$DeviceInformationFromJson(Map<String, dynamic> json) =>
    DeviceInformation(
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

Map<String, dynamic> _$DeviceInformationToJson(DeviceInformation instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  writeNotNull('platform', instance.platform);
  writeNotNull('deviceId', instance.deviceId);
  writeNotNull('hardware', instance.hardware);
  writeNotNull('deviceName', instance.deviceName);
  writeNotNull('deviceManufacturer', instance.deviceManufacturer);
  writeNotNull('deviceModel', instance.deviceModel);
  writeNotNull('operatingSystem', instance.operatingSystem);
  writeNotNull('sdk', instance.sdk);
  writeNotNull('release', instance.release);
  return val;
}

BatteryState _$BatteryStateFromJson(Map<String, dynamic> json) => BatteryState(
      json['batteryLevel'] as int?,
      json['batteryStatus'] as String?,
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$BatteryStateToJson(BatteryState instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  writeNotNull('batteryLevel', instance.batteryLevel);
  writeNotNull('batteryStatus', instance.batteryStatus);
  return val;
}

FreeMemory _$FreeMemoryFromJson(Map<String, dynamic> json) => FreeMemory(
      json['freePhysicalMemory'] as int?,
      json['freeVirtualMemory'] as int?,
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$FreeMemoryToJson(FreeMemory instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  writeNotNull('freePhysicalMemory', instance.freePhysicalMemory);
  writeNotNull('freeVirtualMemory', instance.freeVirtualMemory);
  return val;
}

ScreenEvent _$ScreenEventFromJson(Map<String, dynamic> json) => ScreenEvent(
      json['screenEvent'] as String?,
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$ScreenEventToJson(ScreenEvent instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  writeNotNull('screenEvent', instance.screenEvent);
  return val;
}

Timezone _$TimezoneFromJson(Map<String, dynamic> json) => Timezone(
      json['timezone'] as String,
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$TimezoneToJson(Timezone instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['timezone'] = instance.timezone;
  return val;
}
