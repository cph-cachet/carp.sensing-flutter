// GENERATED CODE - DO NOT MODIFY BY HAND

part of esense;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ESenseButtonDatum _$ESenseButtonDatumFromJson(Map<String, dynamic> json) =>
    ESenseButtonDatum(
      deviceName: json['device_name'] as String,
      pressed: json['pressed'] as bool,
    )
      ..id = json['id'] as String?
      ..timestamp = DateTime.parse(json['timestamp'] as String);

Map<String, dynamic> _$ESenseButtonDatumToJson(ESenseButtonDatum instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['timestamp'] = instance.timestamp.toIso8601String();
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
  writeNotNull('deviceName', instance.deviceName);
  writeNotNull('samplingRate', instance.samplingRate);
  return val;
}
