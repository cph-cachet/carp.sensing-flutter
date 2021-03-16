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

  Probe create(String type) {
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
    FromJsonFactory().register(LocationMeasure(type: null));
    FromJsonFactory().register(WeatherMeasure(type: null));
    FromJsonFactory().register(GeofenceMeasure(type: null));
    FromJsonFactory().register(AirQualityMeasure(type: null));
    FromJsonFactory().register(GeoPosition(0, 0));
    FromJsonFactory().register(MobilityMeasure(type: null));

    // registering the transformers from CARP to OMH for geolocation and physical activity.
    // we assume that there is an OMH schema registered already...
    TransformerSchemaRegistry()
        .lookup(NameSpace.OMH)
        .add(LOCATION, OMHGeopositionDatum.transformer);
    TransformerSchemaRegistry()
        .lookup(NameSpace.OMH)
        .add(ACTIVITY, OMHPhysicalActivityDatum.transformer);
  }

  List<Permission> get permissions => [
        Permission.locationAlways,
        Permission.sensors,
        Permission.activityRecognition
      ];

  SamplingSchema get common => SamplingSchema()
    ..type = SamplingSchemaType.COMMON
    ..name = 'Common (default) context sampling schema'
    ..powerAware = true
    ..measures.addEntries([
      MapEntry(
        LOCATION,
        Measure(
            type: MeasureType(NameSpace.CARP, LOCATION),
            name: 'Location',
            enabled: true),
      ),
      MapEntry(
          GEOLOCATION,
          LocationMeasure(
            type: MeasureType(NameSpace.CARP, GEOLOCATION),
            name: 'Geo-location',
            enabled: true,
            frequency: Duration(seconds: 30),
            accuracy: GeolocationAccuracy.low,
            distance: 3,
          )),
      MapEntry(
        ACTIVITY,
        Measure(
            type: MeasureType(NameSpace.CARP, ACTIVITY),
            name: 'Activity Recognition',
            enabled: true),
      ),
      MapEntry(
          WEATHER,
          WeatherMeasure(
              type: MeasureType(NameSpace.CARP, WEATHER),
              name: 'Local Weather',
              enabled: true,
              apiKey: '12b6e28582eb9298577c734a31ba9f4f')),
      MapEntry(
          AIR_QUALITY,
          AirQualityMeasure(
              type: MeasureType(NameSpace.CARP, AIR_QUALITY),
              name: 'Local Air Quality',
              enabled: true,
              apiKey: '9e538456b2b85c92647d8b65090e29f957638c77')),
      MapEntry(
          GEOFENCE,
          GeofenceMeasure(
              type: MeasureType(NameSpace.CARP, GEOFENCE),
              enabled: true,
              center: GeoPosition(55.7943601, 12.4461956),
              radius: 500,
              name: 'Geofence (Virum)')),
      MapEntry(
          MOBILITY,
          MobilityMeasure(
              type: MeasureType(NameSpace.CARP, MOBILITY),
              name: 'Mobility Features',
              enabled: true,
              placeRadius: 50,
              stopRadius: 25,
              usePriorContexts: true,
              stopDuration: Duration(minutes: 3))),
    ]);

  SamplingSchema get light => common
    ..type = SamplingSchemaType.LIGHT
    ..name = 'Light context sampling'
    ..measures[WEATHER].enabled = false;

  SamplingSchema get minimum => light
    ..type = SamplingSchemaType.MINIMUM
    ..name = 'Minimum context sampling'
    ..measures[ACTIVITY].enabled = false
    ..measures[GEOFENCE].enabled = false;

  SamplingSchema get normal => common;

  SamplingSchema get debug => common
    ..type = SamplingSchemaType.DEBUG
    ..name = 'Debugging context sampling schema'
    ..powerAware = false
    ..measures[GEOLOCATION] = LocationMeasure(
      type: MeasureType(NameSpace.CARP, GEOLOCATION),
      name: 'Geo-location',
      enabled: true,
      frequency: Duration(seconds: 3),
      accuracy: GeolocationAccuracy.best,
      distance: 0,
    )
    ..measures[WEATHER] = WeatherMeasure(
      type: MeasureType(NameSpace.CARP, WEATHER),
      name: 'Local Weather',
      apiKey: '12b6e28582eb9298577c734a31ba9f4f',
    );
}
