/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of context;

/// This is the base class for this context sampling package.
///
/// To use this package, register it in the [carp_mobile_sensing] package using
///
/// ```
///   SamplingPackageRegistry().register(ContextSamplingPackage());
/// ```
class ContextSamplingPackage extends SmartphoneSamplingPackage {
  static const String ACTIVITY = "${NameSpace.CARP}.activity";
  static const String LOCATION = "${NameSpace.CARP}.location";
  static const String GEOLOCATION = "${NameSpace.CARP}.geolocation";
  static const String GEOFENCE = "${NameSpace.CARP}.geofence";
  static const String MOBILITY = "${NameSpace.CARP}.mobility";
  static const String AIR_QUALITY = "${NameSpace.CARP}.air_quality";
  static const String WEATHER = "${NameSpace.CARP}.weather";

  @override
  List<String> get dataTypes => [
        ACTIVITY,
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
  DeviceManager _deviceManager = LocationServiceManager();

  @override
  List<String> get dataTypes => [
        ContextSamplingPackage.LOCATION,
        ContextSamplingPackage.GEOLOCATION,
        ContextSamplingPackage.GEOFENCE,
        ContextSamplingPackage.MOBILITY,
      ];

  @override
  Probe? create(String type) {
    switch (type) {
      case ContextSamplingPackage.LOCATION:
        return LocationProbe();
      case ContextSamplingPackage.GEOLOCATION:
        return GeoLocationProbe();
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
  DeviceManager _deviceManager = AirQualityServiceManager();

  @override
  List<String> get dataTypes => [
        ContextSamplingPackage.AIR_QUALITY,
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
  DeviceManager _deviceManager = WeatherServiceManager();

  @override
  List<String> get dataTypes => [
        ContextSamplingPackage.AIR_QUALITY,
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



// /// This is the base class for this context sampling package.
// ///
// /// To use this package, register it in the [carp_mobile_sensing] package using
// ///
// /// ```
// ///   SamplingPackageRegistry.register(ContextSamplingPackage());
// /// ```
// class ContextSamplingPackage extends SmartphoneSamplingPackage {
//   static const String LOCATION = "${NameSpace.CARP}.location";
//   static const String GEOLOCATION = "${NameSpace.CARP}.geolocation";
//   static const String ACTIVITY = "${NameSpace.CARP}.activity";
//   static const String WEATHER = "${NameSpace.CARP}.weather";
//   static const String AIR_QUALITY = "${NameSpace.CARP}.air_quality";
//   static const String GEOFENCE = "${NameSpace.CARP}.geofence";
//   static const String MOBILITY = "${NameSpace.CARP}.mobility";

//   List<String> get dataTypes => [
//         LOCATION,
//         GEOLOCATION,
//         ACTIVITY,
//         WEATHER,
//         AIR_QUALITY,
//         GEOFENCE,
//         MOBILITY,
//       ];

//   Probe? create(String type) {
//     switch (type) {
//       case LOCATION:
//         return LocationProbe();
//       case GEOLOCATION:
//         return GeoLocationProbe();
//       case ACTIVITY:
//         return ActivityProbe();
//       case WEATHER:
//         return WeatherProbe();
//       case AIR_QUALITY:
//         return AirQualityProbe();
//       case GEOFENCE:
//         return GeofenceProbe();
//       case MOBILITY:
//         return MobilityProbe();
//       default:
//         return null;
//     }
//   }

//   void onRegister() {
//     // first register all configurations to be de/serializable
//     FromJsonFactory().register(AirQualityService(apiKey: ''));
//     FromJsonFactory().register(
//       GeofenceSamplingConfiguration(
//           center: GeoPosition(1.1, 1.1), dwell: const Duration(), radius: 1.0),
//     );
//     FromJsonFactory().register(LocationService());
//     FromJsonFactory().register(WeatherService(apiKey: ''));
//     FromJsonFactory().register(AirQualityService(apiKey: ''));
//     FromJsonFactory().register(GeoPosition(1.1, 1.1));

//     // registering the transformers from CARP to OMH for geolocation and physical activity
//     // we assume that there is an OMH schema registered already...
//     TransformerSchemaRegistry()
//         .lookup(NameSpace.OMH)!
//         .add(LOCATION, OMHGeopositionDataPoint.transformer);
//     TransformerSchemaRegistry()
//         .lookup(NameSpace.OMH)!
//         .add(ACTIVITY, OMHPhysicalActivityDataPoint.transformer);
//   }

//   List<Permission> get permissions =>
//       [Permission.locationAlways, Permission.activityRecognition];

//   @override
//   String get deviceType => ESenseDevice.DEVICE_TYPE;

//   @override
//   DeviceManager get deviceManager => _deviceManager;

//   SamplingSchema get samplingSchema => SamplingSchema()
//     ..addConfiguration(
//         MOBILITY,
//         MobilitySamplingConfiguration(
//             placeRadius: 50,
//             stopRadius: 5,
//             usePriorContexts: true,
//             stopDuration: Duration(seconds: 30)));
// }
