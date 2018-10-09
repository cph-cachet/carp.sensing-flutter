// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sensor_datum.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccelerometerDatum _$AccelerometerDatumFromJson(Map<String, dynamic> json) {
  return AccelerometerDatum(
      x: (json['x'] as num)?.toDouble(),
      y: (json['y'] as num)?.toDouble(),
      z: (json['z'] as num)?.toDouble())
    ..$ = json[r'$'] as String
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

  writeNotNull(r'$', instance.$);
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
    ..$ = json[r'$'] as String
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

  writeNotNull(r'$', instance.$);
  writeNotNull('id', instance.id);
  writeNotNull('timestamp', instance.timestamp?.toIso8601String());
  writeNotNull('device_info', instance.deviceInfo);
  writeNotNull('x', instance.x);
  writeNotNull('y', instance.y);
  writeNotNull('z', instance.z);
  return val;
}

LightDatum _$LightDatumFromJson(Map<String, dynamic> json) {
  return LightDatum(lux: json['lux'] as int)
    ..$ = json[r'$'] as String
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

  writeNotNull(r'$', instance.$);
  writeNotNull('id', instance.id);
  writeNotNull('timestamp', instance.timestamp?.toIso8601String());
  writeNotNull('device_info', instance.deviceInfo);
  writeNotNull('lux', instance.lux);
  return val;
}
