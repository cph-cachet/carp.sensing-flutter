// GENERATED CODE - DO NOT MODIFY BY HAND

part of environment;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherDatum _$WeatherDatumFromJson(Map<String, dynamic> json) {
  return WeatherDatum()
    ..c__ = json['c__'] as String
    ..id = json['id'] as String
    ..timestamp = json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String)
    ..deviceInfo = json['device_info'] == null
        ? null
        : DeviceInfo.fromJson(json['device_info'] as Map<String, dynamic>)
    ..weather = json['weather'] as Map<String, dynamic>;
}

Map<String, dynamic> _$WeatherDatumToJson(WeatherDatum instance) {
  var val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('c__', instance.c__);
  writeNotNull('id', instance.id);
  writeNotNull('timestamp', instance.timestamp?.toIso8601String());
  writeNotNull('device_info', instance.deviceInfo);
  writeNotNull('weather', instance.weather);
  return val;
}

WeatherMeasure _$WeatherMeasureFromJson(Map<String, dynamic> json) {
  return WeatherMeasure(json['measure_type'],
      apiKey: json['api_key'] as String,
      name: json['name'],
      frequency: json['frequency'],
      duration: json['duration'])
    ..c__ = json['c__'] as String
    ..enabled = json['enabled'] as bool
    ..configuration = (json['configuration'] as Map<String, dynamic>)
        ?.map((k, e) => MapEntry(k, e as String));
}

Map<String, dynamic> _$WeatherMeasureToJson(WeatherMeasure instance) {
  var val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('c__', instance.c__);
  writeNotNull('measure_type', instance.measureType);
  writeNotNull('name', instance.name);
  writeNotNull('enabled', instance.enabled);
  writeNotNull('configuration', instance.configuration);
  writeNotNull('frequency', instance.frequency);
  writeNotNull('duration', instance.duration);
  writeNotNull('api_key', instance.apiKey);
  return val;
}
