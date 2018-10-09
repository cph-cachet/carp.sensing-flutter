// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connectivity_measures.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConnectivityMeasure _$ConnectivityMeasureFromJson(Map<String, dynamic> json) {
  return ConnectivityMeasure(json['measure_type'] as String, name: json['name'])
    ..$ = json[r'$'] as String
    ..enabled = json['enabled'] as bool
    ..configuration = (json['configuration'] as Map<String, dynamic>)
        ?.map((k, e) => MapEntry(k, e as String));
}

Map<String, dynamic> _$ConnectivityMeasureToJson(ConnectivityMeasure instance) {
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

BluetoothMeasure _$BluetoothMeasureFromJson(Map<String, dynamic> json) {
  return BluetoothMeasure(json['measure_type'] as String,
      name: json['name'],
      frequency: json['frequency'],
      duration: json['duration'])
    ..$ = json[r'$'] as String
    ..enabled = json['enabled'] as bool
    ..configuration = (json['configuration'] as Map<String, dynamic>)
        ?.map((k, e) => MapEntry(k, e as String));
}

Map<String, dynamic> _$BluetoothMeasureToJson(BluetoothMeasure instance) {
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
