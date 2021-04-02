// GENERATED CODE - DO NOT MODIFY BY HAND

part of esense;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ESenseMeasure _$ESenseMeasureFromJson(Map<String, dynamic> json) {
  return ESenseMeasure(
    type: json['type'] as String,
    measureDescription:
        (json['measure_description'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(
          k,
          e == null
              ? null
              : MeasureDescription.fromJson(e as Map<String, dynamic>)),
    ),
    enabled: json['enabled'],
    deviceName: json['device_name'] as String,
    samplingRate: json['sampling_rate'] as int,
  )
    ..$type = json[r'$type'] as String
    ..configuration = (json['configuration'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as String),
    );
}

Map<String, dynamic> _$ESenseMeasureToJson(ESenseMeasure instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  writeNotNull('type', instance.type);
  writeNotNull('measure_description', instance.measureDescription);
  writeNotNull('enabled', instance.enabled);
  writeNotNull('configuration', instance.configuration);
  writeNotNull('device_name', instance.deviceName);
  writeNotNull('sampling_rate', instance.samplingRate);
  return val;
}

ESenseButtonDatum _$ESenseButtonDatumFromJson(Map<String, dynamic> json) {
  return ESenseButtonDatum(
    deviceName: json['device_name'] as String,
    pressed: json['pressed'] as bool,
  )
    ..id = json['id'] as String
    ..timestamp = json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String);
}

Map<String, dynamic> _$ESenseButtonDatumToJson(ESenseButtonDatum instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('timestamp', instance.timestamp?.toIso8601String());
  writeNotNull('device_name', instance.deviceName);
  writeNotNull('pressed', instance.pressed);
  return val;
}

ESenseSensorDatum _$ESenseSensorDatumFromJson(Map<String, dynamic> json) {
  return ESenseSensorDatum(
    deviceName: json['device_name'] as String,
    timestamp: json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String),
    packetIndex: json['packet_index'] as int,
    accel: (json['accel'] as List)?.map((e) => e as int)?.toList(),
    gyro: (json['gyro'] as List)?.map((e) => e as int)?.toList(),
  )..id = json['id'] as String;
}

Map<String, dynamic> _$ESenseSensorDatumToJson(ESenseSensorDatum instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('timestamp', instance.timestamp?.toIso8601String());
  writeNotNull('device_name', instance.deviceName);
  writeNotNull('packet_index', instance.packetIndex);
  writeNotNull('accel', instance.accel);
  writeNotNull('gyro', instance.gyro);
  return val;
}

ESenseDevice _$ESenseDeviceFromJson(Map<String, dynamic> json) {
  return ESenseDevice(
    roleName: json['roleName'] as String,
    supportedDataTypes:
        (json['supportedDataTypes'] as List)?.map((e) => e as String)?.toList(),
  )
    ..$type = json[r'$type'] as String
    ..isMasterDevice = json['isMasterDevice'] as bool
    ..samplingConfiguration =
        (json['samplingConfiguration'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(
          k,
          e == null
              ? null
              : SamplingConfiguration.fromJson(e as Map<String, dynamic>)),
    );
}

Map<String, dynamic> _$ESenseDeviceToJson(ESenseDevice instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  writeNotNull('isMasterDevice', instance.isMasterDevice);
  writeNotNull('roleName', instance.roleName);
  writeNotNull('supportedDataTypes', instance.supportedDataTypes);
  writeNotNull('samplingConfiguration', instance.samplingConfiguration);
  return val;
}
