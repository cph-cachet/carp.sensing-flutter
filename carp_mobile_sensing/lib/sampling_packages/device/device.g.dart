// GENERATED CODE - DO NOT MODIFY BY HAND

part of device;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceInformation _$DeviceInformationFromJson(Map<String, dynamic> json) =>
    DeviceInformation(
      json['platform'] as String?,
      json['deviceId'] as String?,
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
      json['battery_level'] as int?,
      json['battery_status'] as String?,
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$BatteryStateToJson(BatteryState instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  writeNotNull('battery_level', instance.batteryLevel);
  writeNotNull('battery_status', instance.batteryStatus);
  return val;
}

FreeMemory _$FreeMemoryFromJson(Map<String, dynamic> json) => FreeMemory(
      json['free_physical_memory'] as int?,
      json['free_virtual_memory'] as int?,
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$FreeMemoryToJson(FreeMemory instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  writeNotNull('free_physical_memory', instance.freePhysicalMemory);
  writeNotNull('free_virtual_memory', instance.freeVirtualMemory);
  return val;
}

ScreenEvent _$ScreenEventFromJson(Map<String, dynamic> json) => ScreenEvent(
      json['screen_event'] as String?,
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$ScreenEventToJson(ScreenEvent instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  writeNotNull('screen_event', instance.screenEvent);
  return val;
}
