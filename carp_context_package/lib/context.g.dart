// GENERATED CODE - DO NOT MODIFY BY HAND

part of context;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActivityDatum _$ActivityDatumFromJson(Map<String, dynamic> json) {
  return ActivityDatum()
    ..id = json['id'] as String
    ..timestamp = json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String)
    ..confidence = json['confidence'] as int
    ..type = json['type'] as String;
}

Map<String, dynamic> _$ActivityDatumToJson(ActivityDatum instance) {
  var val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('timestamp', instance.timestamp?.toIso8601String());
  writeNotNull('confidence', instance.confidence);
  writeNotNull('type', instance.type);
  return val;
}

LocationDatum _$LocationDatumFromJson(Map<String, dynamic> json) {
  return LocationDatum()
    ..id = json['id'] as String
    ..timestamp = json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String)
    ..latitude = (json['latitude'] as num)?.toDouble()
    ..longitude = (json['longitude'] as num)?.toDouble()
    ..altitude = (json['altitude'] as num)?.toDouble()
    ..accuracy = (json['accuracy'] as num)?.toDouble()
    ..speed = (json['speed'] as num)?.toDouble()
    ..speedAccuracy = (json['speed_accuracy'] as num)?.toDouble();
}

Map<String, dynamic> _$LocationDatumToJson(LocationDatum instance) {
  var val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('timestamp', instance.timestamp?.toIso8601String());
  writeNotNull('latitude', instance.latitude);
  writeNotNull('longitude', instance.longitude);
  writeNotNull('altitude', instance.altitude);
  writeNotNull('accuracy', instance.accuracy);
  writeNotNull('speed', instance.speed);
  writeNotNull('speed_accuracy', instance.speedAccuracy);
  return val;
}

WeatherDatum _$WeatherDatumFromJson(Map<String, dynamic> json) {
  return WeatherDatum()
    ..id = json['id'] as String
    ..timestamp = json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String)
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

  writeNotNull('id', instance.id);
  writeNotNull('timestamp', instance.timestamp?.toIso8601String());
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
  return WeatherMeasure(
      json['type'] == null
          ? null
          : MeasureType.fromJson(json['type'] as Map<String, dynamic>),
      name: json['name'],
      enabled: json['enabled'],
      frequency: json['frequency'],
      duration: json['duration'],
      apiKey: json['api_key'] as String)
    ..c__ = json['c__'] as String
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
  writeNotNull('type', instance.type);
  writeNotNull('name', instance.name);
  writeNotNull('enabled', instance.enabled);
  writeNotNull('configuration', instance.configuration);
  writeNotNull('frequency', instance.frequency);
  writeNotNull('duration', instance.duration);
  writeNotNull('api_key', instance.apiKey);
  return val;
}
