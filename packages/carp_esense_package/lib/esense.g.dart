// GENERATED CODE - DO NOT MODIFY BY HAND

part of esense;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ESenseMeasure _$ESenseMeasureFromJson(Map<String, dynamic> json) =>
    ESenseMeasure(
      type: json['type'] as String,
      name: json['name'] as String?,
      description: json['description'] as String?,
      enabled: json['enabled'] ?? true,
      deviceName: json['deviceName'] as String,
      samplingRate: json['samplingRate'] as int? ?? 10,
    )
      ..$type = json[r'$type'] as String?
      ..configuration = Map<String, String>.from(json['configuration'] as Map);

Map<String, dynamic> _$ESenseMeasureToJson(ESenseMeasure instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  val['type'] = instance.type;
  writeNotNull('name', instance.name);
  writeNotNull('description', instance.description);
  val['enabled'] = instance.enabled;
  val['configuration'] = instance.configuration;
  val['deviceName'] = instance.deviceName;
  val['samplingRate'] = instance.samplingRate;
  return val;
}

ESenseButtonDatum _$ESenseButtonDatumFromJson(Map<String, dynamic> json) =>
    ESenseButtonDatum(
      deviceName: json['device_name'] as String,
      pressed: json['pressed'] as bool,
    )
      ..id = json['id'] as String?
      ..timestamp = json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String);

Map<String, dynamic> _$ESenseButtonDatumToJson(ESenseButtonDatum instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('timestamp', instance.timestamp?.toIso8601String());
  val['device_name'] = instance.deviceName;
  val['pressed'] = instance.pressed;
  return val;
}

ESenseSensorDatum _$ESenseSensorDatumFromJson(Map<String, dynamic> json) =>
    ESenseSensorDatum(
      deviceName: json['device_name'] as String,
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
      packetIndex: json['packet_index'] as int?,
      accel: (json['accel'] as List<dynamic>?)?.map((e) => e as int).toList(),
      gyro: (json['gyro'] as List<dynamic>?)?.map((e) => e as int).toList(),
    )..id = json['id'] as String?;

Map<String, dynamic> _$ESenseSensorDatumToJson(ESenseSensorDatum instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('timestamp', instance.timestamp?.toIso8601String());
  val['device_name'] = instance.deviceName;
  writeNotNull('packet_index', instance.packetIndex);
  writeNotNull('accel', instance.accel);
  writeNotNull('gyro', instance.gyro);
  return val;
}

ESenseDevice _$ESenseDeviceFromJson(Map<String, dynamic> json) => ESenseDevice(
      roleName: json['roleName'] as String?,
      supportedDataTypes: (json['supportedDataTypes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    )
      ..$type = json[r'$type'] as String?
      ..isMasterDevice = json['isMasterDevice'] as bool?
      ..samplingConfiguration =
          (json['samplingConfiguration'] as Map<String, dynamic>).map(
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

  writeNotNull(r'$type', instance.$type);
  writeNotNull('isMasterDevice', instance.isMasterDevice);
  val['roleName'] = instance.roleName;
  writeNotNull('supportedDataTypes', instance.supportedDataTypes);
  val['samplingConfiguration'] = instance.samplingConfiguration;
  return val;
}
