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
  final val = <String, dynamic>{};

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
    ..time =
        json['time'] == null ? null : DateTime.parse(json['time'] as String)
    ..latitude = (json['latitude'] as num)?.toDouble()
    ..longitude = (json['longitude'] as num)?.toDouble()
    ..altitude = (json['altitude'] as num)?.toDouble()
    ..accuracy = (json['accuracy'] as num)?.toDouble()
    ..speed = (json['speed'] as num)?.toDouble()
    ..speedAccuracy = (json['speed_accuracy'] as num)?.toDouble()
    ..heading = (json['heading'] as num)?.toDouble();
}

Map<String, dynamic> _$LocationDatumToJson(LocationDatum instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('timestamp', instance.timestamp?.toIso8601String());
  writeNotNull('time', instance.time?.toIso8601String());
  writeNotNull('latitude', instance.latitude);
  writeNotNull('longitude', instance.longitude);
  writeNotNull('altitude', instance.altitude);
  writeNotNull('accuracy', instance.accuracy);
  writeNotNull('speed', instance.speed);
  writeNotNull('speed_accuracy', instance.speedAccuracy);
  writeNotNull('heading', instance.heading);
  return val;
}

LocationMeasure _$LocationMeasureFromJson(Map<String, dynamic> json) {
  return LocationMeasure(
    json['type'] == null
        ? null
        : MeasureType.fromJson(json['type'] as Map<String, dynamic>),
    name: json['name'],
    enabled: json['enabled'],
    frequency: json['frequency'],
    duration: json['duration'],
    accuracy:
        _$enumDecodeNullable(_$GeolocationAccuracyEnumMap, json['accuracy']),
    distance: json['distance'] as int,
  )
    ..c__ = json['c__'] as String
    ..configuration = (json['configuration'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as String),
    );
}

Map<String, dynamic> _$LocationMeasureToJson(LocationMeasure instance) {
  final val = <String, dynamic>{};

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
  writeNotNull('accuracy', _$GeolocationAccuracyEnumMap[instance.accuracy]);
  writeNotNull('distance', instance.distance);
  return val;
}

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$GeolocationAccuracyEnumMap = {
  GeolocationAccuracy.lowest: 'lowest',
  GeolocationAccuracy.low: 'low',
  GeolocationAccuracy.medium: 'medium',
  GeolocationAccuracy.high: 'high',
  GeolocationAccuracy.best: 'best',
  GeolocationAccuracy.bestForNavigation: 'bestForNavigation',
};

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
  final val = <String, dynamic>{};

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
    apiKey: json['api_key'] as String,
  )
    ..c__ = json['c__'] as String
    ..configuration = (json['configuration'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as String),
    );
}

Map<String, dynamic> _$WeatherMeasureToJson(WeatherMeasure instance) {
  final val = <String, dynamic>{};

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
  writeNotNull('api_key', instance.apiKey);
  return val;
}

GeoPosition _$GeoPositionFromJson(Map<String, dynamic> json) {
  return GeoPosition(
    (json['latitude'] as num)?.toDouble(),
    (json['longitude'] as num)?.toDouble(),
  )..c__ = json['c__'] as String;
}

Map<String, dynamic> _$GeoPositionToJson(GeoPosition instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('c__', instance.c__);
  writeNotNull('latitude', instance.latitude);
  writeNotNull('longitude', instance.longitude);
  return val;
}

GeofenceMeasure _$GeofenceMeasureFromJson(Map<String, dynamic> json) {
  return GeofenceMeasure(
    json['type'] == null
        ? null
        : MeasureType.fromJson(json['type'] as Map<String, dynamic>),
    enabled: json['enabled'],
    center: json['center'] == null
        ? null
        : GeoPosition.fromJson(json['center'] as Map<String, dynamic>),
    radius: (json['radius'] as num)?.toDouble(),
    name: json['name'] as String,
  )
    ..c__ = json['c__'] as String
    ..configuration = (json['configuration'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as String),
    )
    ..dwell = json['dwell'] as int;
}

Map<String, dynamic> _$GeofenceMeasureToJson(GeofenceMeasure instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('c__', instance.c__);
  writeNotNull('type', instance.type);
  writeNotNull('enabled', instance.enabled);
  writeNotNull('configuration', instance.configuration);
  writeNotNull('center', instance.center);
  writeNotNull('radius', instance.radius);
  writeNotNull('dwell', instance.dwell);
  writeNotNull('name', instance.name);
  return val;
}

GeofenceDatum _$GeofenceDatumFromJson(Map<String, dynamic> json) {
  return GeofenceDatum(
    type: json['type'] as String,
    name: json['name'] as String,
  )
    ..id = json['id'] as String
    ..timestamp = json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String);
}

Map<String, dynamic> _$GeofenceDatumToJson(GeofenceDatum instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('timestamp', instance.timestamp?.toIso8601String());
  writeNotNull('name', instance.name);
  writeNotNull('type', instance.type);
  return val;
}

AirQualityDatum _$AirQualityDatumFromJson(Map<String, dynamic> json) {
  return AirQualityDatum()
    ..id = json['id'] as String
    ..timestamp = json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String)
    ..airQualityIndex = json['air_quality_index'] as int
    ..source = json['source'] as String
    ..place = json['place'] as String
    ..latitude = (json['latitude'] as num)?.toDouble()
    ..longitude = (json['longitude'] as num)?.toDouble()
    ..airQualityLevel = _$enumDecodeNullable(
        _$AirQualityLevelEnumMap, json['air_quality_level']);
}

Map<String, dynamic> _$AirQualityDatumToJson(AirQualityDatum instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('timestamp', instance.timestamp?.toIso8601String());
  writeNotNull('air_quality_index', instance.airQualityIndex);
  writeNotNull('source', instance.source);
  writeNotNull('place', instance.place);
  writeNotNull('latitude', instance.latitude);
  writeNotNull('longitude', instance.longitude);
  writeNotNull(
      'air_quality_level', _$AirQualityLevelEnumMap[instance.airQualityLevel]);
  return val;
}

const _$AirQualityLevelEnumMap = {
  AirQualityLevel.UNKNOWN: 'UNKNOWN',
  AirQualityLevel.GOOD: 'GOOD',
  AirQualityLevel.MODERATE: 'MODERATE',
  AirQualityLevel.UNHEALTHY_FOR_SENSITIVE_GROUPS:
      'UNHEALTHY_FOR_SENSITIVE_GROUPS',
  AirQualityLevel.UNHEALTHY: 'UNHEALTHY',
  AirQualityLevel.VERY_UNHEALTHY: 'VERY_UNHEALTHY',
  AirQualityLevel.HAZARDOUS: 'HAZARDOUS',
};

AirQualityMeasure _$AirQualityMeasureFromJson(Map<String, dynamic> json) {
  return AirQualityMeasure(
    json['type'] == null
        ? null
        : MeasureType.fromJson(json['type'] as Map<String, dynamic>),
    name: json['name'],
    enabled: json['enabled'],
    apiKey: json['api_key'] as String,
  )
    ..c__ = json['c__'] as String
    ..configuration = (json['configuration'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as String),
    );
}

Map<String, dynamic> _$AirQualityMeasureToJson(AirQualityMeasure instance) {
  final val = <String, dynamic>{};

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
  writeNotNull('api_key', instance.apiKey);
  return val;
}
