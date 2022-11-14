// GENERATED CODE - DO NOT MODIFY BY HAND

part of sensors;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccelerometerDatum _$AccelerometerDatumFromJson(Map<String, dynamic> json) =>
    AccelerometerDatum(
      x: (json['x'] as num?)?.toDouble(),
      y: (json['y'] as num?)?.toDouble(),
      z: (json['z'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$AccelerometerDatumToJson(AccelerometerDatum instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('x', instance.x);
  writeNotNull('y', instance.y);
  writeNotNull('z', instance.z);
  return val;
}

GyroscopeDatum _$GyroscopeDatumFromJson(Map<String, dynamic> json) =>
    GyroscopeDatum(
      x: (json['x'] as num?)?.toDouble(),
      y: (json['y'] as num?)?.toDouble(),
      z: (json['z'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$GyroscopeDatumToJson(GyroscopeDatum instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('x', instance.x);
  writeNotNull('y', instance.y);
  writeNotNull('z', instance.z);
  return val;
}

MagnetometerDatum _$MagnetometerDatumFromJson(Map<String, dynamic> json) =>
    MagnetometerDatum(
      x: (json['x'] as num?)?.toDouble(),
      y: (json['y'] as num?)?.toDouble(),
      z: (json['z'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$MagnetometerDatumToJson(MagnetometerDatum instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('x', instance.x);
  writeNotNull('y', instance.y);
  writeNotNull('z', instance.z);
  return val;
}

LightDatum _$LightDatumFromJson(Map<String, dynamic> json) => LightDatum(
      meanLux: json['mean_lux'] as num?,
      stdLux: json['std_lux'] as num?,
      minLux: json['min_lux'] as num?,
      maxLux: json['max_lux'] as num?,
    );

Map<String, dynamic> _$LightDatumToJson(LightDatum instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('mean_lux', instance.meanLux);
  writeNotNull('std_lux', instance.stdLux);
  writeNotNull('min_lux', instance.minLux);
  writeNotNull('max_lux', instance.maxLux);
  return val;
}

PedometerDatum _$PedometerDatumFromJson(Map<String, dynamic> json) =>
    PedometerDatum(
      json['step_count'] as int?,
    );

Map<String, dynamic> _$PedometerDatumToJson(PedometerDatum instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('step_count', instance.stepCount);
  return val;
}
