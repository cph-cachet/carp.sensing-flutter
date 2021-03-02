// GENERATED CODE - DO NOT MODIFY BY HAND

part of sensors;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccelerometerDatum _$AccelerometerDatumFromJson(Map<String, dynamic> json) {
  return AccelerometerDatum(
    x: (json['x'] as num)?.toDouble(),
    y: (json['y'] as num)?.toDouble(),
    z: (json['z'] as num)?.toDouble(),
  )
    ..id = json['id'] as String
    ..timestamp = json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String)
    ..format = json['format'] == null
        ? null
        : DataType.fromJson(json['format'] as Map<String, dynamic>);
}

Map<String, dynamic> _$AccelerometerDatumToJson(AccelerometerDatum instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('timestamp', instance.timestamp?.toIso8601String());
  writeNotNull('format', instance.format);
  writeNotNull('x', instance.x);
  writeNotNull('y', instance.y);
  writeNotNull('z', instance.z);
  return val;
}

GyroscopeDatum _$GyroscopeDatumFromJson(Map<String, dynamic> json) {
  return GyroscopeDatum(
    x: (json['x'] as num)?.toDouble(),
    y: (json['y'] as num)?.toDouble(),
    z: (json['z'] as num)?.toDouble(),
  )
    ..id = json['id'] as String
    ..timestamp = json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String)
    ..format = json['format'] == null
        ? null
        : DataType.fromJson(json['format'] as Map<String, dynamic>);
}

Map<String, dynamic> _$GyroscopeDatumToJson(GyroscopeDatum instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('timestamp', instance.timestamp?.toIso8601String());
  val['format'] = instance.format;
  val['x'] = instance.x;
  val['y'] = instance.y;
  val['z'] = instance.z;
  return val;
}

LightDatum _$LightDatumFromJson(Map<String, dynamic> json) {
  return LightDatum(
    meanLux: json['mean_lux'] as num,
    stdLux: json['std_lux'] as num,
    minLux: json['min_lux'] as num,
    maxLux: json['max_lux'] as num,
  )
    ..id = json['id'] as String
    ..timestamp = json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String)
    ..format = json['format'] == null
        ? null
        : DataType.fromJson(json['format'] as Map<String, dynamic>);
}

Map<String, dynamic> _$LightDatumToJson(LightDatum instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('timestamp', instance.timestamp?.toIso8601String());
  writeNotNull('format', instance.format);
  writeNotNull('mean_lux', instance.meanLux);
  writeNotNull('std_lux', instance.stdLux);
  writeNotNull('min_lux', instance.minLux);
  writeNotNull('max_lux', instance.maxLux);
  return val;
}

PedometerDatum _$PedometerDatumFromJson(Map<String, dynamic> json) {
  return PedometerDatum(
    json['step_count'] as int,
  )
    ..id = json['id'] as String
    ..timestamp = json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String)
    ..format = json['format'] == null
        ? null
        : DataType.fromJson(json['format'] as Map<String, dynamic>);
}

Map<String, dynamic> _$PedometerDatumToJson(PedometerDatum instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('timestamp', instance.timestamp?.toIso8601String());
  writeNotNull('format', instance.format);
  writeNotNull('step_count', instance.stepCount);
  return val;
}
