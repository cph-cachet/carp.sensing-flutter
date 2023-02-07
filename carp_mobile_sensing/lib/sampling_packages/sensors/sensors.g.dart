// GENERATED CODE - DO NOT MODIFY BY HAND

part of sensors;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AmbientLight _$AmbientLightFromJson(Map<String, dynamic> json) => AmbientLight(
      meanLux: json['meanLux'] as num?,
      stdLux: json['stdLux'] as num?,
      minLux: json['minLux'] as num?,
      maxLux: json['maxLux'] as num?,
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$AmbientLightToJson(AmbientLight instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  writeNotNull('meanLux', instance.meanLux);
  writeNotNull('stdLux', instance.stdLux);
  writeNotNull('minLux', instance.minLux);
  writeNotNull('maxLux', instance.maxLux);
  return val;
}
