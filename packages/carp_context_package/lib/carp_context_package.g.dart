// GENERATED CODE - DO NOT MODIFY BY HAND

part of carp_context_package;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActivityData _$ActivityDataFromJson(Map<String, dynamic> json) => ActivityData(
      $enumDecode(_$ActivityTypeEnumMap, json['type']),
      json['confidence'] as int,
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$ActivityDataToJson(ActivityData instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['confidence'] = instance.confidence;
  val['type'] = _$ActivityTypeEnumMap[instance.type]!;
  return val;
}

const _$ActivityTypeEnumMap = {
  ActivityType.IN_VEHICLE: 'IN_VEHICLE',
  ActivityType.ON_BICYCLE: 'ON_BICYCLE',
  ActivityType.RUNNING: 'RUNNING',
  ActivityType.STILL: 'STILL',
  ActivityType.WALKING: 'WALKING',
  ActivityType.UNKNOWN: 'UNKNOWN',
};

LocationData _$LocationDataFromJson(Map<String, dynamic> json) => LocationData()
  ..$type = json['__type'] as String?
  ..time = json['time'] == null ? null : DateTime.parse(json['time'] as String)
  ..latitude = (json['latitude'] as num?)?.toDouble()
  ..longitude = (json['longitude'] as num?)?.toDouble()
  ..altitude = (json['altitude'] as num?)?.toDouble()
  ..accuracy = (json['accuracy'] as num?)?.toDouble()
  ..speed = (json['speed'] as num?)?.toDouble()
  ..speedAccuracy = (json['speed_accuracy'] as num?)?.toDouble()
  ..heading = (json['heading'] as num?)?.toDouble();

Map<String, dynamic> _$LocationDataToJson(LocationData instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
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

WeatherData _$WeatherDataFromJson(Map<String, dynamic> json) => WeatherData()
  ..$type = json['__type'] as String?
  ..country = json['country'] as String?
  ..areaName = json['area_name'] as String?
  ..weatherMain = json['weather_main'] as String?
  ..weatherDescription = json['weather_description'] as String?
  ..date = json['date'] == null ? null : DateTime.parse(json['date'] as String)
  ..sunrise =
      json['sunrise'] == null ? null : DateTime.parse(json['sunrise'] as String)
  ..sunset =
      json['sunset'] == null ? null : DateTime.parse(json['sunset'] as String)
  ..latitude = (json['latitude'] as num?)?.toDouble()
  ..longitude = (json['longitude'] as num?)?.toDouble()
  ..pressure = (json['pressure'] as num?)?.toDouble()
  ..windSpeed = (json['wind_speed'] as num?)?.toDouble()
  ..windDegree = (json['wind_degree'] as num?)?.toDouble()
  ..humidity = (json['humidity'] as num?)?.toDouble()
  ..cloudiness = (json['cloudiness'] as num?)?.toDouble()
  ..rainLastHour = (json['rain_last_hour'] as num?)?.toDouble()
  ..rainLast3Hours = (json['rain_last3_hours'] as num?)?.toDouble()
  ..snowLastHour = (json['snow_last_hour'] as num?)?.toDouble()
  ..snowLast3Hours = (json['snow_last3_hours'] as num?)?.toDouble()
  ..temperature = (json['temperature'] as num?)?.toDouble()
  ..tempMin = (json['temp_min'] as num?)?.toDouble()
  ..tempMax = (json['temp_max'] as num?)?.toDouble();

Map<String, dynamic> _$WeatherDataToJson(WeatherData instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
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

WeatherService _$WeatherServiceFromJson(Map<String, dynamic> json) =>
    WeatherService(
      roleName: json['roleName'] as String?,
      supportedDataTypes: (json['supportedDataTypes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      apiKey: json['apiKey'] as String,
    )
      ..$type = json['__type'] as String?
      ..isOptional = json['isOptional'] as bool?
      ..defaultSamplingConfiguration =
          (json['defaultSamplingConfiguration'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(
            k, SamplingConfiguration.fromJson(e as Map<String, dynamic>)),
      );

Map<String, dynamic> _$WeatherServiceToJson(WeatherService instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['roleName'] = instance.roleName;
  writeNotNull('isOptional', instance.isOptional);
  writeNotNull('supportedDataTypes', instance.supportedDataTypes);
  writeNotNull(
      'defaultSamplingConfiguration', instance.defaultSamplingConfiguration);
  val['apiKey'] = instance.apiKey;
  return val;
}

GeoPosition _$GeoPositionFromJson(Map<String, dynamic> json) => GeoPosition(
      (json['latitude'] as num).toDouble(),
      (json['longitude'] as num).toDouble(),
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$GeoPositionToJson(GeoPosition instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['latitude'] = instance.latitude;
  val['longitude'] = instance.longitude;
  return val;
}

GeofenceSamplingConfiguration _$GeofenceSamplingConfigurationFromJson(
        Map<String, dynamic> json) =>
    GeofenceSamplingConfiguration(
      center: GeoPosition.fromJson(json['center'] as Map<String, dynamic>),
      radius: (json['radius'] as num).toDouble(),
      dwell: Duration(microseconds: json['dwell'] as int),
      label: json['label'] as String?,
    )
      ..$type = json['__type'] as String?
      ..lastTime = json['lastTime'] == null
          ? null
          : DateTime.parse(json['lastTime'] as String);

Map<String, dynamic> _$GeofenceSamplingConfigurationToJson(
    GeofenceSamplingConfiguration instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  writeNotNull('lastTime', instance.lastTime?.toIso8601String());
  val['center'] = instance.center;
  val['radius'] = instance.radius;
  val['dwell'] = instance.dwell.inMicroseconds;
  writeNotNull('label', instance.label);
  return val;
}

GeofenceData _$GeofenceDataFromJson(Map<String, dynamic> json) => GeofenceData(
      type: $enumDecode(_$GeofenceTypeEnumMap, json['type']),
      name: json['name'] as String?,
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$GeofenceDataToJson(GeofenceData instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  writeNotNull('name', instance.name);
  val['type'] = _$GeofenceTypeEnumMap[instance.type]!;
  return val;
}

const _$GeofenceTypeEnumMap = {
  GeofenceType.ENTER: 'ENTER',
  GeofenceType.EXIT: 'EXIT',
  GeofenceType.DWELL: 'DWELL',
};

AirQualityIndexData _$AirQualityIndexDataFromJson(Map<String, dynamic> json) =>
    AirQualityIndexData(
      json['air_quality_index'] as int,
      json['source'] as String,
      json['place'] as String,
      (json['latitude'] as num).toDouble(),
      (json['longitude'] as num).toDouble(),
      $enumDecode(_$AirQualityLevelEnumMap, json['air_quality_level']),
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$AirQualityIndexDataToJson(AirQualityIndexData instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['air_quality_index'] = instance.airQualityIndex;
  val['source'] = instance.source;
  val['place'] = instance.place;
  val['latitude'] = instance.latitude;
  val['longitude'] = instance.longitude;
  val['air_quality_level'] =
      _$AirQualityLevelEnumMap[instance.airQualityLevel]!;
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

AirQualityService _$AirQualityServiceFromJson(Map<String, dynamic> json) =>
    AirQualityService(
      roleName: json['roleName'] as String?,
      supportedDataTypes: (json['supportedDataTypes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      apiKey: json['apiKey'] as String,
    )
      ..$type = json['__type'] as String?
      ..isOptional = json['isOptional'] as bool?
      ..defaultSamplingConfiguration =
          (json['defaultSamplingConfiguration'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(
            k, SamplingConfiguration.fromJson(e as Map<String, dynamic>)),
      );

Map<String, dynamic> _$AirQualityServiceToJson(AirQualityService instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['roleName'] = instance.roleName;
  writeNotNull('isOptional', instance.isOptional);
  writeNotNull('supportedDataTypes', instance.supportedDataTypes);
  writeNotNull(
      'defaultSamplingConfiguration', instance.defaultSamplingConfiguration);
  val['apiKey'] = instance.apiKey;
  return val;
}

MobilityData _$MobilityDataFromJson(Map<String, dynamic> json) => MobilityData()
  ..$type = json['__type'] as String?
  ..timestamp = json['timestamp'] == null
      ? null
      : DateTime.parse(json['timestamp'] as String)
  ..date = json['date'] == null ? null : DateTime.parse(json['date'] as String)
  ..numberOfPlaces = json['number_of_places'] as int?
  ..locationVariance = (json['location_variance'] as num?)?.toDouble()
  ..entropy = (json['entropy'] as num?)?.toDouble()
  ..normalizedEntropy = (json['normalized_entropy'] as num?)?.toDouble()
  ..homeStay = (json['home_stay'] as num?)?.toDouble()
  ..distanceTravelled = (json['distance_travelled'] as num?)?.toDouble();

Map<String, dynamic> _$MobilityDataToJson(MobilityData instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  writeNotNull('timestamp', instance.timestamp?.toIso8601String());
  writeNotNull('date', instance.date?.toIso8601String());
  writeNotNull('number_of_places', instance.numberOfPlaces);
  writeNotNull('location_variance', instance.locationVariance);
  writeNotNull('entropy', instance.entropy);
  writeNotNull('normalized_entropy', instance.normalizedEntropy);
  writeNotNull('home_stay', instance.homeStay);
  writeNotNull('distance_travelled', instance.distanceTravelled);
  return val;
}

MobilitySamplingConfiguration _$MobilitySamplingConfigurationFromJson(
        Map<String, dynamic> json) =>
    MobilitySamplingConfiguration(
      usePriorContexts: json['usePriorContexts'] as bool? ?? true,
      stopRadius: (json['stopRadius'] as num?)?.toDouble() ?? 25,
      placeRadius: (json['placeRadius'] as num?)?.toDouble() ?? 50,
      stopDuration: json['stopDuration'] == null
          ? null
          : Duration(microseconds: json['stopDuration'] as int),
    )
      ..$type = json['__type'] as String?
      ..lastTime = json['lastTime'] == null
          ? null
          : DateTime.parse(json['lastTime'] as String);

Map<String, dynamic> _$MobilitySamplingConfigurationToJson(
    MobilitySamplingConfiguration instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  writeNotNull('lastTime', instance.lastTime?.toIso8601String());
  val['usePriorContexts'] = instance.usePriorContexts;
  val['stopRadius'] = instance.stopRadius;
  val['placeRadius'] = instance.placeRadius;
  val['stopDuration'] = instance.stopDuration.inMicroseconds;
  return val;
}

LocationService _$LocationServiceFromJson(Map<String, dynamic> json) =>
    LocationService(
      roleName: json['roleName'] as String?,
      supportedDataTypes: (json['supportedDataTypes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      accuracy:
          $enumDecodeNullable(_$GeolocationAccuracyEnumMap, json['accuracy']) ??
              GeolocationAccuracy.balanced,
      distance: (json['distance'] as num?)?.toDouble() ?? 0,
      interval: json['interval'] == null
          ? null
          : Duration(microseconds: json['interval'] as int),
      notificationTitle: json['notificationTitle'] as String?,
      notificationMessage: json['notificationMessage'] as String?,
      notificationDescription: json['notificationDescription'] as String?,
    )
      ..$type = json['__type'] as String?
      ..isOptional = json['isOptional'] as bool?
      ..defaultSamplingConfiguration =
          (json['defaultSamplingConfiguration'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(
            k, SamplingConfiguration.fromJson(e as Map<String, dynamic>)),
      );

Map<String, dynamic> _$LocationServiceToJson(LocationService instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['roleName'] = instance.roleName;
  writeNotNull('isOptional', instance.isOptional);
  writeNotNull('supportedDataTypes', instance.supportedDataTypes);
  writeNotNull(
      'defaultSamplingConfiguration', instance.defaultSamplingConfiguration);
  val['accuracy'] = _$GeolocationAccuracyEnumMap[instance.accuracy]!;
  val['distance'] = instance.distance;
  val['interval'] = instance.interval.inMicroseconds;
  writeNotNull('notificationTitle', instance.notificationTitle);
  writeNotNull('notificationMessage', instance.notificationMessage);
  writeNotNull('notificationDescription', instance.notificationDescription);
  return val;
}

const _$GeolocationAccuracyEnumMap = {
  GeolocationAccuracy.powerSave: 'powerSave',
  GeolocationAccuracy.low: 'low',
  GeolocationAccuracy.balanced: 'balanced',
  GeolocationAccuracy.high: 'high',
  GeolocationAccuracy.navigation: 'navigation',
  GeolocationAccuracy.reduced: 'reduced',
};
