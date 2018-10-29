// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_measure.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AudioMeasure _$AudioMeasureFromJson(Map<String, dynamic> json) {
  return AudioMeasure(json['measure_type'])
    ..$ = json[r'$'] as String
    ..name = json['name'] as String
    ..enabled = json['enabled'] as bool
    ..configuration = (json['configuration'] as Map<String, dynamic>)
        ?.map((k, e) => MapEntry(k, e as String))
    ..frequency = json['frequency'] as int
    ..duration = json['duration'] as int;
}

Map<String, dynamic> _$AudioMeasureToJson(AudioMeasure instance) {
  var val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$', instance.$);
  writeNotNull('measure_type', instance.measureType);
  writeNotNull('name', instance.name);
  writeNotNull('enabled', instance.enabled);
  writeNotNull('configuration', instance.configuration);
  writeNotNull('frequency', instance.frequency);
  writeNotNull('duration', instance.duration);
  return val;
}
