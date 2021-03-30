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
    ..type = _$enumDecodeNullable(_$ActivityTypeEnumMap, json['type']);
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
  writeNotNull('type', _$ActivityTypeEnumMap[instance.type]);
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

const _$ActivityTypeEnumMap = {
  ActivityType.IN_VEHICLE: 'IN_VEHICLE',
  ActivityType.ON_BICYCLE: 'ON_BICYCLE',
  ActivityType.ON_FOOT: 'ON_FOOT',
  ActivityType.RUNNING: 'RUNNING',
  ActivityType.STILL: 'STILL',
  ActivityType.TILTING: 'TILTING',
  ActivityType.UNKNOWN: 'UNKNOWN',
  ActivityType.WALKING: 'WALKING',
  ActivityType.INVALID: 'INVALID',
};

LocationDatum _$LocationDatumFromJson(Map<String, dynamic> json) {
  return LocationDatum()
    ..id = json['id'] as String
    ..timestamp = json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String)
    ..time =
        json['time'] == null ? null : DateTime.parse(json['time'] as String)
    ..latitude = json['latitude']
    ..longitude = json['longitude']
    ..altitude = json['altitude']
    ..accuracy = json['accuracy']
    ..speed = json['speed']
    ..speedAccuracy = json['speed_accuracy']
    ..heading = json['heading'];
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
    type: json['type'] as String,
    measureDescription:
        (json['measure_description'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(
          k,
          e == null
              ? null
              : MeasureDescription.fromJson(e as Map<String, dynamic>)),
    ),
    enabled: json['enabled'] as bool,
    frequency: json['frequency'] == null
        ? null
        : Duration(microseconds: json['frequency'] as int),
    duration: json['duration'] == null
        ? null
        : Duration(microseconds: json['duration'] as int),
    accuracy:
        _$enumDecodeNullable(_$GeolocationAccuracyEnumMap, json['accuracy']),
    distance: (json['distance'] as num)?.toDouble(),
    notificationTitle: json['notification_title'] as String,
    notificationMsg: json['notification_msg'] as String,
  )
    ..$type = json[r'$type'] as String
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

  writeNotNull(r'$type', instance.$type);
  writeNotNull('type', instance.type);
  writeNotNull('measure_description', instance.measureDescription);
  writeNotNull('enabled', instance.enabled);
  writeNotNull('configuration', instance.configuration);
  writeNotNull('frequency', instance.frequency?.inMicroseconds);
  writeNotNull('duration', instance.duration?.inMicroseconds);
  writeNotNull('accuracy', _$GeolocationAccuracyEnumMap[instance.accuracy]);
  writeNotNull('distance', instance.distance);
  writeNotNull('notification_title', instance.notificationTitle);
  writeNotNull('notification_msg', instance.notificationMsg);
  return val;
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
    ..latitude = json['latitude']
    ..longitude = json['longitude']
    ..pressure = json['pressure']
    ..windSpeed = json['wind_speed']
    ..windDegree = json['wind_degree']
    ..humidity = json['humidity']
    ..cloudiness = json['cloudiness']
    ..rainLastHour = json['rain_last_hour']
    ..rainLast3Hours = json['rain_last3_hours']
    ..snowLastHour = json['snow_last_hour']
    ..snowLast3Hours = json['snow_last3_hours']
    ..temperature = json['temperature']
    ..tempMin = json['temp_min']
    ..tempMax = json['temp_max'];
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
    type: json['type'] as String,
    measureDescription:
        (json['measure_description'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(
          k,
          e == null
              ? null
              : MeasureDescription.fromJson(e as Map<String, dynamic>)),
    ),
    enabled: json['enabled'],
    apiKey: json['api_key'] as String,
  )
    ..$type = json[r'$type'] as String
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

  writeNotNull(r'$type', instance.$type);
  writeNotNull('type', instance.type);
  writeNotNull('measure_description', instance.measureDescription);
  writeNotNull('enabled', instance.enabled);
  writeNotNull('configuration', instance.configuration);
  writeNotNull('api_key', instance.apiKey);
  return val;
}

GeoPosition _$GeoPositionFromJson(Map<String, dynamic> json) {
  return GeoPosition(
    (json['latitude'] as num)?.toDouble(),
    (json['longitude'] as num)?.toDouble(),
  )..$type = json[r'$type'] as String;
}

Map<String, dynamic> _$GeoPositionToJson(GeoPosition instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  writeNotNull('latitude', instance.latitude);
  writeNotNull('longitude', instance.longitude);
  return val;
}

GeofenceMeasure _$GeofenceMeasureFromJson(Map<String, dynamic> json) {
  return GeofenceMeasure(
    type: json['type'] as String,
    enabled: json['enabled'],
    center: json['center'] == null
        ? null
        : GeoPosition.fromJson(json['center'] as Map<String, dynamic>),
    radius: (json['radius'] as num)?.toDouble(),
  )
    ..$type = json[r'$type'] as String
    ..measureDescription =
        (json['measure_description'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(
          k,
          e == null
              ? null
              : MeasureDescription.fromJson(e as Map<String, dynamic>)),
    )
    ..configuration = (json['configuration'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as String),
    )
    ..dwell = json['dwell'] == null
        ? null
        : Duration(microseconds: json['dwell'] as int);
}

Map<String, dynamic> _$GeofenceMeasureToJson(GeofenceMeasure instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  writeNotNull('type', instance.type);
  writeNotNull('measure_description', instance.measureDescription);
  writeNotNull('enabled', instance.enabled);
  writeNotNull('configuration', instance.configuration);
  writeNotNull('center', instance.center);
  writeNotNull('radius', instance.radius);
  writeNotNull('dwell', instance.dwell?.inMicroseconds);
  return val;
}

GeofenceDatum _$GeofenceDatumFromJson(Map<String, dynamic> json) {
  return GeofenceDatum(
    type: _$enumDecodeNullable(_$GeofenceTypeEnumMap, json['type']),
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
  writeNotNull('type', _$GeofenceTypeEnumMap[instance.type]);
  return val;
}

const _$GeofenceTypeEnumMap = {
  GeofenceType.ENTER: 'ENTER',
  GeofenceType.EXIT: 'EXIT',
  GeofenceType.DWELL: 'DWELL',
};

AirQualityDatum _$AirQualityDatumFromJson(Map<String, dynamic> json) {
  return AirQualityDatum()
    ..id = json['id'] as String
    ..timestamp = json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String)
    ..airQualityIndex = json['air_quality_index'] as int
    ..source = json['source'] as String
    ..place = json['place'] as String
    ..latitude = json['latitude']
    ..longitude = json['longitude']
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
    type: json['type'] as String,
    measureDescription:
        (json['measure_description'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(
          k,
          e == null
              ? null
              : MeasureDescription.fromJson(e as Map<String, dynamic>)),
    ),
    enabled: json['enabled'],
    apiKey: json['api_key'] as String,
  )
    ..$type = json[r'$type'] as String
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

  writeNotNull(r'$type', instance.$type);
  writeNotNull('type', instance.type);
  writeNotNull('measure_description', instance.measureDescription);
  writeNotNull('enabled', instance.enabled);
  writeNotNull('configuration', instance.configuration);
  writeNotNull('api_key', instance.apiKey);
  return val;
}

MobilityDatum _$MobilityDatumFromJson(Map<String, dynamic> json) {
  return MobilityDatum()
    ..id = json['id'] as String
    ..date =
        json['date'] == null ? null : DateTime.parse(json['date'] as String)
    ..timestamp = json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String)
    ..numberOfPlaces = json['number_of_places'] as int
    ..locationVariance = (json['location_variance'] as num)?.toDouble()
    ..entropy = (json['entropy'] as num)?.toDouble()
    ..normalizedEntropy = (json['normalized_entropy'] as num)?.toDouble()
    ..homeStay = (json['home_stay'] as num)?.toDouble()
    ..distanceTravelled = (json['distance_travelled'] as num)?.toDouble();
}

Map<String, dynamic> _$MobilityDatumToJson(MobilityDatum instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('date', instance.date?.toIso8601String());
  writeNotNull('timestamp', instance.timestamp?.toIso8601String());
  writeNotNull('number_of_places', instance.numberOfPlaces);
  writeNotNull('location_variance', instance.locationVariance);
  writeNotNull('entropy', instance.entropy);
  writeNotNull('normalized_entropy', instance.normalizedEntropy);
  writeNotNull('home_stay', instance.homeStay);
  writeNotNull('distance_travelled', instance.distanceTravelled);
  return val;
}

MobilityMeasure _$MobilityMeasureFromJson(Map<String, dynamic> json) {
  return MobilityMeasure(
    type: json['type'] as String,
    measureDescription:
        (json['measure_description'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(
          k,
          e == null
              ? null
              : MeasureDescription.fromJson(e as Map<String, dynamic>)),
    ),
    enabled: json['enabled'],
    usePriorContexts: json['use_prior_contexts'] as bool,
    stopRadius: (json['stop_radius'] as num)?.toDouble(),
    placeRadius: (json['place_radius'] as num)?.toDouble(),
    stopDuration: json['stop_duration'] == null
        ? null
        : Duration(microseconds: json['stop_duration'] as int),
  )
    ..$type = json[r'$type'] as String
    ..configuration = (json['configuration'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as String),
    );
}

Map<String, dynamic> _$MobilityMeasureToJson(MobilityMeasure instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  writeNotNull('type', instance.type);
  writeNotNull('measure_description', instance.measureDescription);
  writeNotNull('enabled', instance.enabled);
  writeNotNull('configuration', instance.configuration);
  writeNotNull('use_prior_contexts', instance.usePriorContexts);
  writeNotNull('stop_radius', instance.stopRadius);
  writeNotNull('place_radius', instance.placeRadius);
  writeNotNull('stop_duration', instance.stopDuration?.inMicroseconds);
  return val;
}
