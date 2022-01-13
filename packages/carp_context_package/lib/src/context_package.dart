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
  static const String LOCATION = "dk.cachet.carp.location";
  static const String GEOLOCATION = "dk.cachet.carp.geolocation";
  static const String ACTIVITY = "dk.cachet.carp.activity";
  static const String WEATHER = "dk.cachet.carp.weather";
  static const String AIR_QUALITY = "dk.cachet.carp.air_quality";
  static const String GEOFENCE = "dk.cachet.carp.geofence";
  static const String MOBILITY = "dk.cachet.carp.mobility";

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
    // first register all measure to be de/serializable
    dataTypes.forEach(
        (measure) => FromJsonFactory().register(common.measures[measure]!));
    // register the GeoPosition class used in the GeofenceMeasure
    FromJsonFactory().register(GeoPosition(1.1, 1.1));

    // registering the transformers from CARP to OMH for geolocation and physical activity.
    // we assume that there is an OMH schema registered already...
    TransformerSchemaRegistry()
        .lookup(NameSpace.OMH)!
        .add(LOCATION, OMHGeopositionDatum.transformer);
    TransformerSchemaRegistry()
        .lookup(NameSpace.OMH)!
        .add(ACTIVITY, OMHPhysicalActivityDatum.transformer);
  }

  List<Permission> get permissions => [
        Permission.locationAlways,
        Permission.sensors,
        Permission.activityRecognition
      ];

  SamplingSchema get common => SamplingSchema(
      type: SamplingSchemaType.common,
      name: 'Common (default) context sampling schema',
      powerAware: true)
    ..measures.addEntries([
      MapEntry(
        LOCATION,
        LocationMeasure(
          type: LOCATION,
          name: 'Location',
          description:
              "Ont-time collection of location from the phone's GPS sensor",
        ),
      ),
      MapEntry(
          GEOLOCATION,
          LocationMeasure(
            type: GEOLOCATION,
            name: 'Geo-location',
            description:
                "Continously collection of location from the phone's GPS sensor",
            accuracy: GeolocationAccuracy.low,
            interval: const Duration(minutes: 5),
            distance: 10,
          )),
      MapEntry(
        ACTIVITY,
        CAMSMeasure(
          type: ACTIVITY,
          name: 'Activity Recognition',
          description:
              "Collects activity type from the phone's activity recognition module",
        ),
      ),
      MapEntry(
          WEATHER,
          WeatherMeasure(
              type: WEATHER,
              name: 'Weather',
              description:
                  "Collects local weather from the WeatherAPI web service",
              // TODO - remove this
              apiKey: '12b6e28582eb9298577c734a31ba9f4f')),
      MapEntry(
          AIR_QUALITY,
          AirQualityMeasure(
              type: AIR_QUALITY,
              name: 'Air Quality',
              description:
                  "Collects local air quality from the OpenWeatherMap (OWM) web service",
              // TODO - remove this
              apiKey: '9e538456b2b85c92647d8b65090e29f957638c77')),
      MapEntry(
          GEOFENCE,
          GeofenceMeasure(
              type: GEOFENCE,
              center: GeoPosition(55.7943601, 12.4461956),
              radius: 500,
              dwell: Duration(minutes: 30),
              name: 'Geofence',
              description:
                  "Collects geofence events when then phone enters, leaves, or dwell in a geographic area",
              label: 'Geofence (Virum)')),
      MapEntry(
          MOBILITY,
          MobilityMeasure(
              type: MOBILITY,
              name: 'Mobility Features',
              description:
                  "Extracts mobility features based on location tracking",
              placeRadius: 50,
              stopRadius: 5,
              usePriorContexts: true,
              stopDuration: Duration(seconds: 30))),
    ]);

  SamplingSchema get light {
    SamplingSchema light = common
      ..type = SamplingSchemaType.light
      ..name = 'Light context sampling';
    (light.measures[WEATHER] as WeatherMeasure).enabled = false;
    return light;
  }

  SamplingSchema get minimum {
    SamplingSchema minimum = light
      ..type = SamplingSchemaType.minimum
      ..name = 'Minimum context sampling';
    (minimum.measures[ACTIVITY] as CAMSMeasure).enabled = false;
    (minimum.measures[GEOFENCE] as GeofenceMeasure).enabled = false;
    return minimum;
  }

  SamplingSchema get normal => common;

  SamplingSchema get debug {
    SamplingSchema debug = common
      ..type = SamplingSchemaType.debug
      ..name = 'Debugging context sampling schema'
      ..powerAware = false;
    (debug.measures[GEOLOCATION] as LocationMeasure)
      ..interval = const Duration(seconds: 10)
      ..distance = 0
      ..accuracy = GeolocationAccuracy.navigation;

    return debug;
  }
}
