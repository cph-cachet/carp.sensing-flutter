// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sensors.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AmbientLight _$AmbientLightFromJson(Map<String, dynamic> json) => AmbientLight(
      meanLux: json['meanLux'] as num?,
      stdLux: json['stdLux'] as num?,
      minLux: json['minLux'] as num?,
      maxLux: json['maxLux'] as num?,
    )
      ..$type = json['__type'] as String?
      ..sensorSpecificData = json['sensorSpecificData'] == null
          ? null
          : Data.fromJson(json['sensorSpecificData'] as Map<String, dynamic>);

Map<String, dynamic> _$AmbientLightToJson(AmbientLight instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  writeNotNull('sensorSpecificData', instance.sensorSpecificData);
  writeNotNull('meanLux', instance.meanLux);
  writeNotNull('stdLux', instance.stdLux);
  writeNotNull('minLux', instance.minLux);
  writeNotNull('maxLux', instance.maxLux);
  return val;
}

AverageAccelerometer _$AverageAccelerometerFromJson(
        Map<String, dynamic> json) =>
    AverageAccelerometer(
      xm: (json['xm'] as num?)?.toDouble(),
      ym: (json['ym'] as num?)?.toDouble(),
      zm: (json['zm'] as num?)?.toDouble(),
      xms: (json['xms'] as num?)?.toDouble(),
      yms: (json['yms'] as num?)?.toDouble(),
      zms: (json['zms'] as num?)?.toDouble(),
      n: json['n'] as int?,
    )
      ..$type = json['__type'] as String?
      ..sensorSpecificData = json['sensorSpecificData'] == null
          ? null
          : Data.fromJson(json['sensorSpecificData'] as Map<String, dynamic>);

Map<String, dynamic> _$AverageAccelerometerToJson(
    AverageAccelerometer instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  writeNotNull('sensorSpecificData', instance.sensorSpecificData);
  writeNotNull('xm', instance.xm);
  writeNotNull('ym', instance.ym);
  writeNotNull('zm', instance.zm);
  writeNotNull('xms', instance.xms);
  writeNotNull('yms', instance.yms);
  writeNotNull('zms', instance.zms);
  writeNotNull('n', instance.n);
  return val;
}
