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
class ContextSamplingPackage implements SamplingPackage {
  static const String LOCATION = "location";
  static const String ACTIVITY = "activity";
  static const String WEATHER = "weather";
  static const String AIR_QUALITY = "air_quality";
  static const String GEOFENCE = "geofence";

  List<String> get dataTypes => [
        LOCATION,
        ACTIVITY,
        WEATHER,
        AIR_QUALITY,
        GEOFENCE,
      ];

  Probe create(String type) {
    switch (type) {
      case LOCATION:
        return LocationProbe();
      case ACTIVITY:
        return ActivityProbe();
      case WEATHER:
        return WeatherProbe();
      case AIR_QUALITY:
        return AirQualityProbe();
      case GEOFENCE:
        return GeofenceProbe();
      default:
        return null;
    }
  }

  void onRegister() {
    FromJsonFactory.registerFromJsonFunction("LocationMeasure", LocationMeasure.fromJsonFunction);
    FromJsonFactory.registerFromJsonFunction("WeatherMeasure", WeatherMeasure.fromJsonFunction);
    FromJsonFactory.registerFromJsonFunction("GeofenceMeasure", GeofenceMeasure.fromJsonFunction);
    FromJsonFactory.registerFromJsonFunction("GeoPosition", GeoPosition.fromJsonFunction);

    // registering the transformers from CARP to OMH for geolocation and physical activity.
    // we assume that there is an OMH schema registered already...
    TransformerSchemaRegistry.lookup(NameSpace.OMH).add(LOCATION, OMHGeopositionDatum.transformer);
    TransformerSchemaRegistry.lookup(NameSpace.OMH).add(ACTIVITY, OMHPhysicalActivityDatum.transformer);
  }

  List<PermissionGroup> get permissions => [PermissionGroup.location, PermissionGroup.sensors];

  SamplingSchema get common => SamplingSchema()
    ..type = SamplingSchemaType.COMMON
    ..name = 'Common (default) context sampling schema'
    ..powerAware = true
    ..measures.addEntries([
      MapEntry(
          LOCATION,
          LocationMeasure(MeasureType(NameSpace.CARP, LOCATION),
              name: 'Location', enabled: true, frequency: 10 * 1000, accuracy: LocationAccuracy.BALANCED)),
      MapEntry(ACTIVITY, Measure(MeasureType(NameSpace.CARP, ACTIVITY), name: 'Activity Recognition', enabled: true)),
      MapEntry(
          WEATHER,
          WeatherMeasure(MeasureType(NameSpace.CARP, WEATHER),
              name: 'Local Weather', enabled: true, apiKey: '12b6e28582eb9298577c734a31ba9f4f')),
      MapEntry(
          GEOFENCE,
          GeofenceMeasure(MeasureType(NameSpace.CARP, GEOFENCE),
              enabled: true, center: GeoPosition(55.7943601, 12.4461956), radius: 500, name: 'Geofence (Virum)')),
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
    ..measures[WEATHER] = WeatherMeasure(MeasureType(NameSpace.CARP, WEATHER),
        name: 'Local Weather', apiKey: '12b6e28582eb9298577c734a31ba9f4f');
}
