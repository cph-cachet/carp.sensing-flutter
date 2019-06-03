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
  static const String GEOFENCE = "geofence";

  List<String> get dataTypes => [LOCATION, ACTIVITY, WEATHER, GEOFENCE];

  Probe create(String type) {
    switch (type) {
      case LOCATION:
        return LocationProbe();
      case ACTIVITY:
        return ActivityProbe();
      case WEATHER:
        return WeatherProbe();
      case GEOFENCE:
        return GeofenceProbe();
      default:
        return null;
    }
  }

  void onRegister() {
    FromJsonFactory.registerFromJsonFunction("WeatherMeasure", WeatherMeasure.fromJsonFunction);
    FromJsonFactory.registerFromJsonFunction("GeofenceMeasure", GeofenceMeasure.fromJsonFunction);
    FromJsonFactory.registerFromJsonFunction("Location", Location.fromJsonFunction);

    // registering the transformers from CARP to OMH for geolocation and physical activity.
    // we assume that there is an OMH schema registered already...
    TransformerSchemaRegistry.lookup(NameSpace.OMH).add(LOCATION, OMHGeopositionDatum.transformer);
    TransformerSchemaRegistry.lookup(NameSpace.OMH).add(ACTIVITY, OMHPhysicalActivityDatum.transformer);
  }

  SamplingSchema get common => SamplingSchema()
    ..type = SamplingSchemaType.COMMON
    ..name = 'Common (default) context sampling schema'
    ..powerAware = true
    ..measures.addEntries([
      MapEntry(
          DataType.LOCATION, Measure(MeasureType(NameSpace.CARP, DataType.LOCATION), name: 'Location', enabled: true)),
      MapEntry(DataType.ACTIVITY,
          Measure(MeasureType(NameSpace.CARP, DataType.ACTIVITY), name: 'Activity Recognition', enabled: true)),
      MapEntry(
          DataType.WEATHER,
          WeatherMeasure(MeasureType(NameSpace.CARP, DataType.WEATHER),
              // collect local weather once pr. hour
              name: 'Local Weather',
              enabled: true,
              //frequency: 60 * 60 * 1000
              frequency: 60 * 1000,
              apiKey: '12b6e28582eb9298577c734a31ba9f4f')),
      MapEntry(
          DataType.GEOFENCE,
          GeofenceMeasure(MeasureType(NameSpace.CARP, DataType.GEOFENCE),
              enabled: true, center: Location(55.786025, 12.524159), radius: 500, name: 'DTU')),
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
}
