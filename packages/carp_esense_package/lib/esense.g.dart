// GENERATED CODE - DO NOT MODIFY BY HAND

part of esense;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ESenseButton _$ESenseButtonFromJson(Map<String, dynamic> json) => ESenseButton(
      deviceName: json['device_name'] as String,
      pressed: json['pressed'] as bool,
    )
      ..$type = json['__type'] as String?
      ..timestamp = DateTime.parse(json['timestamp'] as String);

Map<String, dynamic> _$ESenseButtonToJson(ESenseButton instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['timestamp'] = instance.timestamp.toIso8601String();
  val['device_name'] = instance.deviceName;
  val['pressed'] = instance.pressed;
  return val;
}

ESenseSensor _$ESenseSensorFromJson(Map<String, dynamic> json) => ESenseSensor(
      deviceName: json['device_name'] as String,
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
      packetIndex: json['packet_index'] as int?,
      accel: (json['accel'] as List<dynamic>?)?.map((e) => e as int).toList(),
      gyro: (json['gyro'] as List<dynamic>?)?.map((e) => e as int).toList(),
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$ESenseSensorToJson(ESenseSensor instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['timestamp'] = instance.timestamp.toIso8601String();
  val['device_name'] = instance.deviceName;
  writeNotNull('packet_index', instance.packetIndex);
  writeNotNull('accel', instance.accel);
  writeNotNull('gyro', instance.gyro);
  return val;
}

ESenseDevice _$ESenseDeviceFromJson(Map<String, dynamic> json) => ESenseDevice(
      roleName: json['roleName'] as String? ?? ESenseDevice.DEFAULT_ROLENAME,
      deviceName: json['deviceName'] as String?,
      samplingRate: json['samplingRate'] as int?,
    )
      ..$type = json['__type'] as String?
      ..isOptional = json['isOptional'] as bool?
      ..supportedDataTypes = (json['supportedDataTypes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList()
      ..defaultSamplingConfiguration =
          (json['defaultSamplingConfiguration'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(
            k, SamplingConfiguration.fromJson(e as Map<String, dynamic>)),
      );

Map<String, dynamic> _$ESenseDeviceToJson(ESenseDevice instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['roleName'] = instance.roleName;
  writeNotNull('isOptional', instance.isOptional);
  writeNotNull('supportedDataTypes', instance.supportedDataTypes);
  writeNotNull(
      'defaultSamplingConfiguration', instance.defaultSamplingConfiguration);
  writeNotNull('deviceName', instance.deviceName);
  writeNotNull('samplingRate', instance.samplingRate);
  return val;
}
