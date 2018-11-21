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
