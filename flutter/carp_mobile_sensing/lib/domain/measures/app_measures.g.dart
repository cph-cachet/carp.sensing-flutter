// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_measures.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppMeasure _$AppMeasureFromJson(Map<String, dynamic> json) {
  return AppMeasure(json['measure_type'] as String, name: json['name'])
    ..$ = json[r'$'] as String
    ..enabled = json['enabled'] as bool
    ..configuration = (json['configuration'] as Map<String, dynamic>)
        ?.map((k, e) => MapEntry(k, e as String));
}

Map<String, dynamic> _$AppMeasureToJson(AppMeasure instance) {
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
