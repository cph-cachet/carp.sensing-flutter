// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'carp_context_package.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Activity _$ActivityFromJson(Map<String, dynamic> json) => Activity(
      type: $enumDecode(_$ActivityTypeEnumMap, json['type']),
      confidence: json['confidence'] as int,
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$ActivityToJson(Activity instance) {
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

Location _$LocationFromJson(Map<String, dynamic> json) => Location(
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0,
      altitude: (json['altitude'] as num?)?.toDouble(),
      accuracy: (json['accuracy'] as num?)?.toDouble(),
      verticalAccuracy: (json['verticalAccuracy'] as num?)?.toDouble(),
      heading: (json['heading'] as num?)?.toDouble(),
      headingAccuracy: (json['headingAccuracy'] as num?)?.toDouble(),
      speed: (json['speed'] as num?)?.toDouble(),
      speedAccuracy: (json['speedAccuracy'] as num?)?.toDouble(),
      time:
          json['time'] == null ? null : DateTime.parse(json['time'] as String),
      isMock: json['isMock'] as bool?,
      elapsedRealtimeNanos: (json['elapsedRealtimeNanos'] as num?)?.toDouble(),
      elapsedRealtimeUncertaintyNanos:
          (json['elapsedRealtimeUncertaintyNanos'] as num?)?.toDouble(),
      satellites: json['satellites'] as int?,
      provider: json['provider'] as String?,
    )
      ..$type = json['__type'] as String?
      ..sensorSpecificData = json['sensorSpecificData'] == null
          ? null
          : Data.fromJson(json['sensorSpecificData'] as Map<String, dynamic>);

Map<String, dynamic> _$LocationToJson(Location instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  writeNotNull('sensorSpecificData', instance.sensorSpecificData);
  val['latitude'] = instance.latitude;
  val['longitude'] = instance.longitude;
  writeNotNull('altitude', instance.altitude);
  writeNotNull('accuracy', instance.accuracy);
  writeNotNull('verticalAccuracy', instance.verticalAccuracy);
  writeNotNull('speed', instance.speed);
  writeNotNull('speedAccuracy', instance.speedAccuracy);
  writeNotNull('heading', instance.heading);
  writeNotNull('headingAccuracy', instance.headingAccuracy);
  writeNotNull('time', instance.time?.toIso8601String());
  writeNotNull('isMock', instance.isMock);
  writeNotNull('elapsedRealtimeNanos', instance.elapsedRealtimeNanos);
  writeNotNull('elapsedRealtimeUncertaintyNanos',
      instance.elapsedRealtimeUncertaintyNanos);
  writeNotNull('satellites', instance.satellites);
  writeNotNull('provider', instance.provider);
  return val;
}

Weather _$WeatherFromJson(Map<String, dynamic> json) => Weather()
  ..$type = json['__type'] as String?
  ..country = json['country'] as String?
  ..areaName = json['areaName'] as String?
  ..weatherMain = json['weatherMain'] as String?
  ..weatherDescription = json['weatherDescription'] as String?
  ..date = json['date'] == null ? null : DateTime.parse(json['date'] as String)
  ..sunrise =
      json['sunrise'] == null ? null : DateTime.parse(json['sunrise'] as String)
  ..sunset =
      json['sunset'] == null ? null : DateTime.parse(json['sunset'] as String)
  ..latitude = (json['latitude'] as num?)?.toDouble()
  ..longitude = (json['longitude'] as num?)?.toDouble()
  ..pressure = (json['pressure'] as num?)?.toDouble()
  ..windSpeed = (json['windSpeed'] as num?)?.toDouble()
  ..windDegree = (json['windDegree'] as num?)?.toDouble()
  ..humidity = (json['humidity'] as num?)?.toDouble()
  ..cloudiness = (json['cloudiness'] as num?)?.toDouble()
  ..rainLastHour = (json['rainLastHour'] as num?)?.toDouble()
  ..rainLast3Hours = (json['rainLast3Hours'] as num?)?.toDouble()
  ..snowLastHour = (json['snowLastHour'] as num?)?.toDouble()
  ..snowLast3Hours = (json['snowLast3Hours'] as num?)?.toDouble()
  ..temperature = (json['temperature'] as num?)?.toDouble()
  ..tempMin = (json['tempMin'] as num?)?.toDouble()
  ..tempMax = (json['tempMax'] as num?)?.toDouble();

Map<String, dynamic> _$WeatherToJson(Weather instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  writeNotNull('country', instance.country);
  writeNotNull('areaName', instance.areaName);
  writeNotNull('weatherMain', instance.weatherMain);
  writeNotNull('weatherDescription', instance.weatherDescription);
  writeNotNull('date', instance.date?.toIso8601String());
  writeNotNull('sunrise', instance.sunrise?.toIso8601String());
  writeNotNull('sunset', instance.sunset?.toIso8601String());
  writeNotNull('latitude', instance.latitude);
  writeNotNull('longitude', instance.longitude);
  writeNotNull('pressure', instance.pressure);
  writeNotNull('windSpeed', instance.windSpeed);
  writeNotNull('windDegree', instance.windDegree);
  writeNotNull('humidity', instance.humidity);
  writeNotNull('cloudiness', instance.cloudiness);
  writeNotNull('rainLastHour', instance.rainLastHour);
  writeNotNull('rainLast3Hours', instance.rainLast3Hours);
  writeNotNull('snowLastHour', instance.snowLastHour);
  writeNotNull('snowLast3Hours', instance.snowLast3Hours);
  writeNotNull('temperature', instance.temperature);
  writeNotNull('tempMin', instance.tempMin);
  writeNotNull('tempMax', instance.tempMax);
  return val;
}

WeatherService _$WeatherServiceFromJson(Map<String, dynamic> json) =>
    WeatherService(
      roleName: json['roleName'] as String?,
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
  writeNotNull(
      'defaultSamplingConfiguration', instance.defaultSamplingConfiguration);
  val['apiKey'] = instance.apiKey;
  return val;
}

OMHContextDataPoint _$OMHContextDataPointFromJson(Map<String, dynamic> json) =>
    OMHContextDataPoint(
      DataPoint.fromJson(json['datapoint'] as Map<String, dynamic>),
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$OMHContextDataPointToJson(OMHContextDataPoint instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['datapoint'] = instance.datapoint;
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
      name: json['name'] as String,
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
  val['name'] = instance.name;
  return val;
}

Geofence _$GeofenceFromJson(Map<String, dynamic> json) => Geofence(
      type: $enumDecode(_$GeofenceTypeEnumMap, json['type']),
      name: json['name'] as String,
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$GeofenceToJson(Geofence instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['name'] = instance.name;
  val['type'] = _$GeofenceTypeEnumMap[instance.type]!;
  return val;
}

const _$GeofenceTypeEnumMap = {
  GeofenceType.ENTER: 'ENTER',
  GeofenceType.EXIT: 'EXIT',
  GeofenceType.DWELL: 'DWELL',
};

AirQuality _$AirQualityFromJson(Map<String, dynamic> json) => AirQuality(
      airQualityIndex: json['airQualityIndex'] as int,
      source: json['source'] as String?,
      place: json['place'] as String?,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      airQualityLevel: $enumDecodeNullable(
          _$AirQualityLevelEnumMap, json['airQualityLevel']),
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$AirQualityToJson(AirQuality instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['airQualityIndex'] = instance.airQualityIndex;
  writeNotNull('source', instance.source);
  writeNotNull('place', instance.place);
  val['latitude'] = instance.latitude;
  val['longitude'] = instance.longitude;
  writeNotNull(
      'airQualityLevel', _$AirQualityLevelEnumMap[instance.airQualityLevel]);
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
  writeNotNull(
      'defaultSamplingConfiguration', instance.defaultSamplingConfiguration);
  val['apiKey'] = instance.apiKey;
  return val;
}

Mobility _$MobilityFromJson(Map<String, dynamic> json) => Mobility(
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      numberOfPlaces: json['numberOfPlaces'] as int?,
      locationVariance: (json['locationVariance'] as num?)?.toDouble(),
      entropy: (json['entropy'] as num?)?.toDouble(),
      normalizedEntropy: (json['normalizedEntropy'] as num?)?.toDouble(),
      homeStay: (json['homeStay'] as num?)?.toDouble(),
      distanceTraveled: (json['distanceTraveled'] as num?)?.toDouble(),
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$MobilityToJson(Mobility instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  writeNotNull('timestamp', instance.timestamp?.toIso8601String());
  writeNotNull('date', instance.date?.toIso8601String());
  writeNotNull('numberOfPlaces', instance.numberOfPlaces);
  writeNotNull('locationVariance', instance.locationVariance);
  writeNotNull('entropy', instance.entropy);
  writeNotNull('normalizedEntropy', instance.normalizedEntropy);
  writeNotNull('homeStay', instance.homeStay);
  writeNotNull('distanceTraveled', instance.distanceTraveled);
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
      accuracy:
          $enumDecodeNullable(_$GeolocationAccuracyEnumMap, json['accuracy']) ??
              GeolocationAccuracy.balanced,
      distance: (json['distance'] as num?)?.toDouble() ?? 10,
      interval: json['interval'] == null
          ? const Duration(minutes: 1)
          : Duration(microseconds: json['interval'] as int),
      notificationTitle: json['notificationTitle'] as String?,
      notificationMessage: json['notificationMessage'] as String?,
      notificationDescription: json['notificationDescription'] as String?,
      notificationIconName: json['notificationIconName'] as String?,
      notificationOnTapBringToFront:
          json['notificationOnTapBringToFront'] as bool? ?? false,
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
  writeNotNull(
      'defaultSamplingConfiguration', instance.defaultSamplingConfiguration);
  val['accuracy'] = _$GeolocationAccuracyEnumMap[instance.accuracy]!;
  val['distance'] = instance.distance;
  val['interval'] = instance.interval.inMicroseconds;
  writeNotNull('notificationTitle', instance.notificationTitle);
  writeNotNull('notificationMessage', instance.notificationMessage);
  writeNotNull('notificationDescription', instance.notificationDescription);
  writeNotNull('notificationIconName', instance.notificationIconName);
  val['notificationOnTapBringToFront'] = instance.notificationOnTapBringToFront;
  return val;
}

const _$GeolocationAccuracyEnumMap = {
  GeolocationAccuracy.powerSave: 'powerSave',
  GeolocationAccuracy.low: 'low',
  GeolocationAccuracy.balanced: 'balanced',
  GeolocationAccuracy.high: 'high',
  GeolocationAccuracy.navigation: 'navigation',
};
