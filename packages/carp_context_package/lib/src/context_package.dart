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
///   SamplingPackageRegistry.register(ContextSamplingPackage());
/// ```
class ContextSamplingPackage extends SmartphoneSamplingPackage {
  static const String LOCATION = "${NameSpace.CARP}.location";
  static const String GEOLOCATION = "${NameSpace.CARP}.geolocation";
  static const String ACTIVITY = "${NameSpace.CARP}.activity";
  static const String WEATHER = "${NameSpace.CARP}.weather";
  static const String AIR_QUALITY = "${NameSpace.CARP}.air_quality";
  static const String GEOFENCE = "${NameSpace.CARP}.geofence";
  static const String MOBILITY = "${NameSpace.CARP}.mobility";

  List<String> get dataTypes => [
        LOCATION,
        GEOLOCATION,
        ACTIVITY,
        WEATHER,
        AIR_QUALITY,
        GEOFENCE,
        MOBILITY,
      ];

  Probe? create(String type) {
    switch (type) {
      case LOCATION:
        return LocationProbe();
      case GEOLOCATION:
        return GeoLocationProbe();
      case ACTIVITY:
        return ActivityProbe();
      case WEATHER:
        return WeatherProbe();
      case AIR_QUALITY:
        return AirQualityProbe();
      case GEOFENCE:
        return GeofenceProbe();
      case MOBILITY:
        return MobilityProbe();
      default:
        return null;
    }
  }

  void onRegister() {
    // first register all configurations to be de/serializable
    FromJsonFactory().register(AirQualityService(apiKey: ''));
    FromJsonFactory().register(
      GeofenceSamplingConfiguration(
          center: GeoPosition(1.1, 1.1), dwell: const Duration(), radius: 1.0),
    );
    FromJsonFactory().register(WeatherService(apiKey: ''));
    FromJsonFactory().register(GeoPosition(1.1, 1.1));

    // registering the transformers from CARP to OMH for geolocation and physical activity
    // we assume that there is an OMH schema registered already...
    TransformerSchemaRegistry()
        .lookup(NameSpace.OMH)!
        .add(LOCATION, OMHGeopositionDataPoint.transformer);
    TransformerSchemaRegistry()
        .lookup(NameSpace.OMH)!
        .add(ACTIVITY, OMHPhysicalActivityDataPoint.transformer);
  }

  List<Permission> get permissions =>
      [Permission.locationAlways, Permission.activityRecognition];

  SamplingSchema get samplingSchema => SamplingSchema()
    ..addConfiguration(
        MOBILITY,
        MobilitySamplingConfiguration(
            placeRadius: 50,
            stopRadius: 5,
            usePriorContexts: true,
            stopDuration: Duration(seconds: 30)));
}
