// GENERATED CODE - DO NOT MODIFY BY HAND

part of sensors;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PedometerDatum _$PedometerDatumFromJson(Map<String, dynamic> json) {
  return PedometerDatum()
    ..id = json['id'] as String
    ..timestamp = json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String)
    ..deviceInfo = json['device_info'] == null
        ? null
        : DeviceInfo.fromJson(json['device_info'] as Map<String, dynamic>)
    ..startTime = json['start_time'] == null
        ? null
        : DateTime.parse(json['start_time'] as String)
    ..endTime = json['end_time'] == null
        ? null
        : DateTime.parse(json['end_time'] as String)
    ..stepCount = json['step_count'] as int;
}

Map<String, dynamic> _$PedometerDatumToJson(PedometerDatum instance) {
  var val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('timestamp', instance.timestamp?.toIso8601String());
  writeNotNull('device_info', instance.deviceInfo);
  writeNotNull('start_time', instance.startTime?.toIso8601String());
  writeNotNull('end_time', instance.endTime?.toIso8601String());
  writeNotNull('step_count', instance.stepCount);
  return val;
}

AccelerometerDatum _$AccelerometerDatumFromJson(Map<String, dynamic> json) {
  return AccelerometerDatum(
      x: (json['x'] as num)?.toDouble(),
      y: (json['y'] as num)?.toDouble(),
      z: (json['z'] as num)?.toDouble())
    ..id = json['id'] as String
    ..timestamp = json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String)
    ..deviceInfo = json['device_info'] == null
        ? null
        : DeviceInfo.fromJson(json['device_info'] as Map<String, dynamic>);
}

Map<String, dynamic> _$AccelerometerDatumToJson(AccelerometerDatum instance) {
  var val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('timestamp', instance.timestamp?.toIso8601String());
  writeNotNull('device_info', instance.deviceInfo);
  writeNotNull('x', instance.x);
  writeNotNull('y', instance.y);
  writeNotNull('z', instance.z);
  return val;
}

GyroscopeDatum _$GyroscopeDatumFromJson(Map<String, dynamic> json) {
  return GyroscopeDatum(
      x: (json['x'] as num)?.toDouble(),
      y: (json['y'] as num)?.toDouble(),
      z: (json['z'] as num)?.toDouble())
    ..id = json['id'] as String
    ..timestamp = json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String)
    ..deviceInfo = json['device_info'] == null
        ? null
        : DeviceInfo.fromJson(json['device_info'] as Map<String, dynamic>);
}

Map<String, dynamic> _$GyroscopeDatumToJson(GyroscopeDatum instance) {
  var val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('timestamp', instance.timestamp?.toIso8601String());
  writeNotNull('device_info', instance.deviceInfo);
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
      maxLux: json['max_lux'] as num)
    ..id = json['id'] as String
    ..timestamp = json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String)
    ..deviceInfo = json['device_info'] == null
        ? null
        : DeviceInfo.fromJson(json['device_info'] as Map<String, dynamic>);
}

Map<String, dynamic> _$LightDatumToJson(LightDatum instance) {
  var val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('timestamp', instance.timestamp?.toIso8601String());
  writeNotNull('device_info', instance.deviceInfo);
  writeNotNull('mean_lux', instance.meanLux);
  writeNotNull('std_lux', instance.stdLux);
  writeNotNull('min_lux', instance.minLux);
  writeNotNull('max_lux', instance.maxLux);
  return val;
}
