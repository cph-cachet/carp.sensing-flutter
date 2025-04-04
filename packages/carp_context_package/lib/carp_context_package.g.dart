// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'carp_context_package.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Activity _$ActivityFromJson(Map<String, dynamic> json) => Activity(
      type: $enumDecode(_$ActivityTypeEnumMap, json['type']),
      confidence: (json['confidence'] as num).toInt(),
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$ActivityToJson(Activity instance) => <String, dynamic>{
      if (instance.$type case final value?) '__type': value,
      'confidence': instance.confidence,
      'type': _$ActivityTypeEnumMap[instance.type]!,
    };

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
      satellites: (json['satellites'] as num?)?.toInt(),
      provider: json['provider'] as String?,
    )
      ..$type = json['__type'] as String?
      ..sensorSpecificData = json['sensorSpecificData'] == null
          ? null
          : Data.fromJson(json['sensorSpecificData'] as Map<String, dynamic>);

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
      if (instance.$type case final value?) '__type': value,
      if (instance.sensorSpecificData?.toJson() case final value?)
        'sensorSpecificData': value,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      if (instance.altitude case final value?) 'altitude': value,
      if (instance.accuracy case final value?) 'accuracy': value,
      if (instance.verticalAccuracy case final value?)
        'verticalAccuracy': value,
      if (instance.speed case final value?) 'speed': value,
      if (instance.speedAccuracy case final value?) 'speedAccuracy': value,
      if (instance.heading case final value?) 'heading': value,
      if (instance.headingAccuracy case final value?) 'headingAccuracy': value,
      if (instance.time?.toIso8601String() case final value?) 'time': value,
      if (instance.isMock case final value?) 'isMock': value,
      if (instance.elapsedRealtimeNanos case final value?)
        'elapsedRealtimeNanos': value,
      if (instance.elapsedRealtimeUncertaintyNanos case final value?)
        'elapsedRealtimeUncertaintyNanos': value,
      if (instance.satellites case final value?) 'satellites': value,
      if (instance.provider case final value?) 'provider': value,
    };

LocationSamplingConfiguration _$LocationSamplingConfigurationFromJson(
        Map<String, dynamic> json) =>
    LocationSamplingConfiguration(
      once: json['once'] as bool? ?? false,
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$LocationSamplingConfigurationToJson(
        LocationSamplingConfiguration instance) =>
    <String, dynamic>{
      if (instance.$type case final value?) '__type': value,
      'once': instance.once,
    };

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

Map<String, dynamic> _$WeatherToJson(Weather instance) => <String, dynamic>{
      if (instance.$type case final value?) '__type': value,
      if (instance.country case final value?) 'country': value,
      if (instance.areaName case final value?) 'areaName': value,
      if (instance.weatherMain case final value?) 'weatherMain': value,
      if (instance.weatherDescription case final value?)
        'weatherDescription': value,
      if (instance.date?.toIso8601String() case final value?) 'date': value,
      if (instance.sunrise?.toIso8601String() case final value?)
        'sunrise': value,
      if (instance.sunset?.toIso8601String() case final value?) 'sunset': value,
      if (instance.latitude case final value?) 'latitude': value,
      if (instance.longitude case final value?) 'longitude': value,
      if (instance.pressure case final value?) 'pressure': value,
      if (instance.windSpeed case final value?) 'windSpeed': value,
      if (instance.windDegree case final value?) 'windDegree': value,
      if (instance.humidity case final value?) 'humidity': value,
      if (instance.cloudiness case final value?) 'cloudiness': value,
      if (instance.rainLastHour case final value?) 'rainLastHour': value,
      if (instance.rainLast3Hours case final value?) 'rainLast3Hours': value,
      if (instance.snowLastHour case final value?) 'snowLastHour': value,
      if (instance.snowLast3Hours case final value?) 'snowLast3Hours': value,
      if (instance.temperature case final value?) 'temperature': value,
      if (instance.tempMin case final value?) 'tempMin': value,
      if (instance.tempMax case final value?) 'tempMax': value,
    };

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

Map<String, dynamic> _$WeatherServiceToJson(WeatherService instance) =>
    <String, dynamic>{
      if (instance.$type case final value?) '__type': value,
      'roleName': instance.roleName,
      if (instance.isOptional case final value?) 'isOptional': value,
      if (instance.defaultSamplingConfiguration
              ?.map((k, e) => MapEntry(k, e.toJson()))
          case final value?)
        'defaultSamplingConfiguration': value,
      'apiKey': instance.apiKey,
    };

OMHContextDataPoint _$OMHContextDataPointFromJson(Map<String, dynamic> json) =>
    OMHContextDataPoint(
      DataPoint.fromJson(json['datapoint'] as Map<String, dynamic>),
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$OMHContextDataPointToJson(
        OMHContextDataPoint instance) =>
    <String, dynamic>{
      if (instance.$type case final value?) '__type': value,
      'datapoint': instance.datapoint.toJson(),
    };

GeoPosition _$GeoPositionFromJson(Map<String, dynamic> json) => GeoPosition(
      (json['latitude'] as num).toDouble(),
      (json['longitude'] as num).toDouble(),
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$GeoPositionToJson(GeoPosition instance) =>
    <String, dynamic>{
      if (instance.$type case final value?) '__type': value,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };

GeofenceSamplingConfiguration _$GeofenceSamplingConfigurationFromJson(
        Map<String, dynamic> json) =>
    GeofenceSamplingConfiguration(
      center: GeoPosition.fromJson(json['center'] as Map<String, dynamic>),
      radius: (json['radius'] as num).toDouble(),
      dwell: Duration(microseconds: (json['dwell'] as num).toInt()),
      name: json['name'] as String,
    )
      ..$type = json['__type'] as String?
      ..lastTime = json['lastTime'] == null
          ? null
          : DateTime.parse(json['lastTime'] as String);

Map<String, dynamic> _$GeofenceSamplingConfigurationToJson(
        GeofenceSamplingConfiguration instance) =>
    <String, dynamic>{
      if (instance.$type case final value?) '__type': value,
      if (instance.lastTime?.toIso8601String() case final value?)
        'lastTime': value,
      'center': instance.center.toJson(),
      'radius': instance.radius,
      'dwell': instance.dwell.inMicroseconds,
      'name': instance.name,
    };

Geofence _$GeofenceFromJson(Map<String, dynamic> json) => Geofence(
      type: $enumDecode(_$GeofenceTypeEnumMap, json['type']),
      name: json['name'] as String,
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$GeofenceToJson(Geofence instance) => <String, dynamic>{
      if (instance.$type case final value?) '__type': value,
      'name': instance.name,
      'type': _$GeofenceTypeEnumMap[instance.type]!,
    };

const _$GeofenceTypeEnumMap = {
  GeofenceType.ENTER: 'ENTER',
  GeofenceType.EXIT: 'EXIT',
  GeofenceType.DWELL: 'DWELL',
};

AirQuality _$AirQualityFromJson(Map<String, dynamic> json) => AirQuality(
      airQualityIndex: (json['airQualityIndex'] as num).toInt(),
      source: json['source'] as String?,
      place: json['place'] as String?,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      airQualityLevel: $enumDecodeNullable(
          _$AirQualityLevelEnumMap, json['airQualityLevel']),
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$AirQualityToJson(AirQuality instance) =>
    <String, dynamic>{
      if (instance.$type case final value?) '__type': value,
      'airQualityIndex': instance.airQualityIndex,
      if (instance.source case final value?) 'source': value,
      if (instance.place case final value?) 'place': value,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      if (_$AirQualityLevelEnumMap[instance.airQualityLevel] case final value?)
        'airQualityLevel': value,
    };

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

Map<String, dynamic> _$AirQualityServiceToJson(AirQualityService instance) =>
    <String, dynamic>{
      if (instance.$type case final value?) '__type': value,
      'roleName': instance.roleName,
      if (instance.isOptional case final value?) 'isOptional': value,
      if (instance.defaultSamplingConfiguration
              ?.map((k, e) => MapEntry(k, e.toJson()))
          case final value?)
        'defaultSamplingConfiguration': value,
      'apiKey': instance.apiKey,
    };

Mobility _$MobilityFromJson(Map<String, dynamic> json) => Mobility(
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      numberOfStops: (json['numberOfStops'] as num?)?.toInt(),
      numberOfMoves: (json['numberOfMoves'] as num?)?.toInt(),
      numberOfPlaces: (json['numberOfPlaces'] as num?)?.toInt(),
      locationVariance: (json['locationVariance'] as num?)?.toDouble(),
      entropy: (json['entropy'] as num?)?.toDouble(),
      normalizedEntropy: (json['normalizedEntropy'] as num?)?.toDouble(),
      homeStay: (json['homeStay'] as num?)?.toDouble(),
      distanceTraveled: (json['distanceTraveled'] as num?)?.toDouble(),
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$MobilityToJson(Mobility instance) => <String, dynamic>{
      if (instance.$type case final value?) '__type': value,
      if (instance.timestamp?.toIso8601String() case final value?)
        'timestamp': value,
      if (instance.date?.toIso8601String() case final value?) 'date': value,
      if (instance.numberOfStops case final value?) 'numberOfStops': value,
      if (instance.numberOfMoves case final value?) 'numberOfMoves': value,
      if (instance.numberOfPlaces case final value?) 'numberOfPlaces': value,
      if (instance.locationVariance case final value?)
        'locationVariance': value,
      if (instance.entropy case final value?) 'entropy': value,
      if (instance.normalizedEntropy case final value?)
        'normalizedEntropy': value,
      if (instance.homeStay case final value?) 'homeStay': value,
      if (instance.distanceTraveled case final value?)
        'distanceTraveled': value,
    };

MobilitySamplingConfiguration _$MobilitySamplingConfigurationFromJson(
        Map<String, dynamic> json) =>
    MobilitySamplingConfiguration(
      usePriorContexts: json['usePriorContexts'] as bool? ?? true,
      stopRadius: (json['stopRadius'] as num?)?.toDouble() ?? 25,
      placeRadius: (json['placeRadius'] as num?)?.toDouble() ?? 50,
      stopDuration: json['stopDuration'] == null
          ? null
          : Duration(microseconds: (json['stopDuration'] as num).toInt()),
    )
      ..$type = json['__type'] as String?
      ..lastTime = json['lastTime'] == null
          ? null
          : DateTime.parse(json['lastTime'] as String);

Map<String, dynamic> _$MobilitySamplingConfigurationToJson(
        MobilitySamplingConfiguration instance) =>
    <String, dynamic>{
      if (instance.$type case final value?) '__type': value,
      if (instance.lastTime?.toIso8601String() case final value?)
        'lastTime': value,
      'usePriorContexts': instance.usePriorContexts,
      'stopRadius': instance.stopRadius,
      'placeRadius': instance.placeRadius,
      'stopDuration': instance.stopDuration.inMicroseconds,
    };

LocationService _$LocationServiceFromJson(Map<String, dynamic> json) =>
    LocationService(
      roleName: json['roleName'] as String?,
      accuracy:
          $enumDecodeNullable(_$GeolocationAccuracyEnumMap, json['accuracy']) ??
              GeolocationAccuracy.balanced,
      distance: (json['distance'] as num?)?.toDouble() ?? 10,
      interval: json['interval'] == null
          ? const Duration(minutes: 1)
          : Duration(microseconds: (json['interval'] as num).toInt()),
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

Map<String, dynamic> _$LocationServiceToJson(LocationService instance) =>
    <String, dynamic>{
      if (instance.$type case final value?) '__type': value,
      'roleName': instance.roleName,
      if (instance.isOptional case final value?) 'isOptional': value,
      if (instance.defaultSamplingConfiguration
              ?.map((k, e) => MapEntry(k, e.toJson()))
          case final value?)
        'defaultSamplingConfiguration': value,
      'accuracy': _$GeolocationAccuracyEnumMap[instance.accuracy]!,
      'distance': instance.distance,
      'interval': instance.interval.inMicroseconds,
      if (instance.notificationTitle case final value?)
        'notificationTitle': value,
      if (instance.notificationMessage case final value?)
        'notificationMessage': value,
      if (instance.notificationDescription case final value?)
        'notificationDescription': value,
      if (instance.notificationIconName case final value?)
        'notificationIconName': value,
      'notificationOnTapBringToFront': instance.notificationOnTapBringToFront,
    };

const _$GeolocationAccuracyEnumMap = {
  GeolocationAccuracy.powerSave: 'powerSave',
  GeolocationAccuracy.low: 'low',
  GeolocationAccuracy.balanced: 'balanced',
  GeolocationAccuracy.high: 'high',
  GeolocationAccuracy.navigation: 'navigation',
  GeolocationAccuracy.reduced: 'reduced',
};
