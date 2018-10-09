// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'communication_measures.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TextMessageMeasure _$TextMessageMeasureFromJson(Map<String, dynamic> json) {
  return TextMessageMeasure(json['measure_type'] as String, name: json['name'])
    ..$ = json[r'$'] as String
    ..enabled = json['enabled'] as bool
    ..configuration = (json['configuration'] as Map<String, dynamic>)
        ?.map((k, e) => MapEntry(k, e as String));
}

Map<String, dynamic> _$TextMessageMeasureToJson(TextMessageMeasure instance) {
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
  return val;
}
