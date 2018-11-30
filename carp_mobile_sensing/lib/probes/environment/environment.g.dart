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
    ..country = json['country'] as String
    ..areaName = json['area_name'] as String
    ..weatherMain = json['weather_main'] as String
    ..weatherDescription = json['weather_description'] as String
    ..date =
        json['date'] == null ? null : DateTime.parse(json['date'] as String)
    ..sunrise = json['sunrise'] == null
        ? null
        : DateTime.parse(json['sunrise'] as String)
    ..sunset =
        json['sunset'] == null ? null : DateTime.parse(json['sunset'] as String)
    ..latitude = (json['latitude'] as num)?.toDouble()
    ..longitude = (json['longitude'] as num)?.toDouble()
    ..pressure = (json['pressure'] as num)?.toDouble()
    ..windSpeed = (json['wind_speed'] as num)?.toDouble()
    ..windDegree = (json['wind_degree'] as num)?.toDouble()
    ..humidity = (json['humidity'] as num)?.toDouble()
    ..cloudiness = (json['cloudiness'] as num)?.toDouble()
    ..rainLastHour = (json['rain_last_hour'] as num)?.toDouble()
    ..rainLast3Hours = (json['rain_last3_hours'] as num)?.toDouble()
    ..snowLastHour = (json['snow_last_hour'] as num)?.toDouble()
    ..snowLast3Hours = (json['snow_last3_hours'] as num)?.toDouble()
    ..temperature = (json['temperature'] as num)?.toDouble()
    ..tempMin = (json['temp_min'] as num)?.toDouble()
    ..tempMax = (json['temp_max'] as num)?.toDouble();
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
  writeNotNull('country', instance.country);
  writeNotNull('area_name', instance.areaName);
  writeNotNull('weather_main', instance.weatherMain);
  writeNotNull('weather_description', instance.weatherDescription);
  writeNotNull('date', instance.date?.toIso8601String());
  writeNotNull('sunrise', instance.sunrise?.toIso8601String());
  writeNotNull('sunset', instance.sunset?.toIso8601String());
  writeNotNull('latitude', instance.latitude);
  writeNotNull('longitude', instance.longitude);
  writeNotNull('pressure', instance.pressure);
  writeNotNull('wind_speed', instance.windSpeed);
  writeNotNull('wind_degree', instance.windDegree);
  writeNotNull('humidity', instance.humidity);
  writeNotNull('cloudiness', instance.cloudiness);
  writeNotNull('rain_last_hour', instance.rainLastHour);
  writeNotNull('rain_last3_hours', instance.rainLast3Hours);
  writeNotNull('snow_last_hour', instance.snowLastHour);
  writeNotNull('snow_last3_hours', instance.snowLast3Hours);
  writeNotNull('temperature', instance.temperature);
  writeNotNull('temp_min', instance.tempMin);
  writeNotNull('temp_max', instance.tempMax);
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
