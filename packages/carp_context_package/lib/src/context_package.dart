/*
 * Copyright 2018-2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_context_package;

/// This is the base class for this context sampling package.
///
/// To use this package, register it in the [carp_mobile_sensing] package using
///
/// ```
///   SamplingPackageRegistry().register(ContextSamplingPackage());
/// ```
class ContextSamplingPackage extends SmartphoneSamplingPackage {
  /// Measure type for continuous collection of activity events as recognized
  /// by the phone's activity recognition sub-system.
  ///  * Event-based measure.
  ///  * Uses the [Smartphone] device for data collection.
  ///  * No sampling configuration needed.
  static const String ACTIVITY = "${NameSpace.CARP}.activity";

  /// Measure type for one-time collection of current location.
  ///  * One-time measure.
  ///  * Uses the [LocationService] connected device for data collection.
  ///  * No sampling configuration needed.
  static const String CURRENT_LOCATION = "${NameSpace.CARP}.currentlocation";

  /// Measure type for continuos collection of location data.
  ///  * Event-based measure.
  ///  * Uses the [LocationService] connected device for data collection.
  ///  * No sampling configuration needed.
  static const String LOCATION = "${NameSpace.CARP}.location";

  /// Measure type for collection of geofence events (enter/exit/dwell).
  ///  * Event-based measure.
  ///  * Uses the [LocationService] connected device for data collection.
  ///  * Use [GeofenceSamplingConfiguration] for configuration.
  static const String GEOFENCE = "${NameSpace.CARP}.geofence";

  /// Measure type for continuos collection of mobility features like number of
  /// places visited, home stay percentage, and location entropy.
  ///
  ///  * Event-based measure.
  ///  * Uses the [LocationService] connected device for data collection.
  ///  * Use [MobilitySamplingConfiguration] for configuration.
  static const String MOBILITY = "${NameSpace.CARP}.mobility";

  /// Measure type for collection of air quality data from the
  /// [World's Air Quality Index (WAQI)](https://waqi.info) API.
  ///  * One-time measure.
  ///  * Uses the [AirQualityService] connected device for data collection.
  ///  * No sampling configuration needed.
  static const String AIR_QUALITY = "${NameSpace.CARP}.airquality";

  /// Measure type for collection of weather data from the
  /// [Open Weather]( https://openweathermap.org/) API.
  ///  * One-time measure.
  ///  * Uses the [WeatherService] connected device for data collection.
  ///  * No sampling configuration needed.
  static const String WEATHER = "${NameSpace.CARP}.weather";

  @override
  List<DataTypeMetaData> get dataTypes => [
        DataTypeMetaData(
          type: ACTIVITY,
          displayName: "Activity",
          timeType: DataTimeType.POINT,
        ),
      ];

  @override
  Probe? create(String type) {
    switch (type) {
      case ACTIVITY:
        return ActivityProbe();
      default:
        return null;
    }
  }

  @override
  void onRegister() {
    // first register all configurations to be de/serializable
    FromJsonFactory()
      ..register(AirQualityService(apiKey: ''))
      ..register(
        GeofenceSamplingConfiguration(
            name: '',
            center: GeoPosition(1.1, 1.1),
            dwell: const Duration(),
            radius: 1.0),
      )
      ..register(LocationService())
      ..register(WeatherService(apiKey: ''))
      ..register(AirQualityService(apiKey: ''))
      ..register(GeoPosition(1.1, 1.1));

    // registering the transformers from CARP to OMH for geolocation and physical activity
    // we assume that there is an OMH schema registered already...
    TransformerSchemaRegistry().lookup(NameSpace.OMH)!
      ..add(LOCATION, OMHGeopositionDataPoint.transformer)
      ..add(ACTIVITY, OMHPhysicalActivityDataPoint.transformer);

    // register the sub-packages
    SamplingPackageRegistry()
      ..register(LocationSamplingPackage())
      ..register(AirQualitySamplingPackage())
      ..register(WeatherSamplingPackage());
  }

  @override
  List<Permission> get permissions =>
      [Permission.locationAlways, Permission.activityRecognition];

  /// Default samplings schema for:
  ///  * [MOBILITY] - place radius on 50 meters, stop radius on 5 meters,
  ///     and stop duration at 30 seconds.
  @override
  SamplingSchema get samplingSchema => SamplingSchema()
    ..addConfiguration(
        MOBILITY,
        MobilitySamplingConfiguration(
            placeRadius: 50,
            stopRadius: 5,
            usePriorContexts: true,
            stopDuration: Duration(seconds: 30)));
}

/// The location sampling package.
class LocationSamplingPackage extends SmartphoneSamplingPackage {
  final DeviceManager _deviceManager = LocationServiceManager();

  @override
  List<DataTypeMetaData> get dataTypes => [
        DataTypeMetaData(
          type: ContextSamplingPackage.CURRENT_LOCATION,
          displayName: "Location",
          timeType: DataTimeType.POINT,
        ),
        DataTypeMetaData(
          type: ContextSamplingPackage.LOCATION,
          displayName: "Location",
          timeType: DataTimeType.POINT,
        ),
        DataTypeMetaData(
          type: ContextSamplingPackage.GEOFENCE,
          displayName: "Geofence",
          timeType: DataTimeType.POINT,
        ),
        DataTypeMetaData(
          type: ContextSamplingPackage.MOBILITY,
          displayName: "Mobility",
          timeType: DataTimeType.POINT,
        ),
      ];

  @override
  Probe? create(String type) {
    switch (type) {
      case ContextSamplingPackage.CURRENT_LOCATION:
        return CurrentLocationProbe();
      case ContextSamplingPackage.LOCATION:
        return LocationProbe();
      case ContextSamplingPackage.GEOFENCE:
        return GeofenceProbe();
      case ContextSamplingPackage.MOBILITY:
        return MobilityProbe();
      default:
        return null;
    }
  }

  @override
  void onRegister() {}

  @override
  List<Permission> get permissions => [];

  @override
  String get deviceType => LocationService.DEVICE_TYPE;

  @override
  DeviceManager get deviceManager => _deviceManager;

  @override
  SamplingSchema get samplingSchema => SamplingSchema();
}

/// The air quality sampling package.
class AirQualitySamplingPackage extends SmartphoneSamplingPackage {
  final DeviceManager _deviceManager = AirQualityServiceManager();

  @override
  List<DataTypeMetaData> get dataTypes => [
        DataTypeMetaData(
          type: ContextSamplingPackage.AIR_QUALITY,
          displayName: "Air Quality",
          timeType: DataTimeType.POINT,
        ),
      ];

  @override
  Probe? create(String type) {
    switch (type) {
      case ContextSamplingPackage.AIR_QUALITY:
        return AirQualityProbe();
      default:
        return null;
    }
  }

  @override
  void onRegister() {}

  @override
  List<Permission> get permissions => [];

  @override
  String get deviceType => AirQualityService.DEVICE_TYPE;

  @override
  DeviceManager get deviceManager => _deviceManager;

  @override
  SamplingSchema get samplingSchema => SamplingSchema();
}

/// The air quality sampling package.
class WeatherSamplingPackage extends SmartphoneSamplingPackage {
  final DeviceManager _deviceManager = WeatherServiceManager();

  @override
  List<DataTypeMetaData> get dataTypes => [
        DataTypeMetaData(
          type: ContextSamplingPackage.WEATHER,
          displayName: "Weather",
          timeType: DataTimeType.POINT,
        ),
      ];

  @override
  Probe? create(String type) {
    switch (type) {
      case ContextSamplingPackage.WEATHER:
        return WeatherProbe();
      default:
        return null;
    }
  }

  @override
  void onRegister() {}

  @override
  List<Permission> get permissions => [];

  @override
  String get deviceType => WeatherService.DEVICE_TYPE;

  @override
  DeviceManager get deviceManager => _deviceManager;

  @override
  SamplingSchema get samplingSchema => SamplingSchema();
}
