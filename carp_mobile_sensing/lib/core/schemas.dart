/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of core;

/// Signature of a data transformer.
typedef DatumTransformer = Datum Function(Datum);

/// Signature of a data stream transformer.
typedef DatumStreamTransformer = Stream<Datum> Function(Stream<Datum>);

String _encode(Object object) => const JsonEncoder.withIndent(' ').convert(object);

class PrivacySchema {
  Map<String, DatumTransformer> transformers = Map();

  PrivacySchema() : super();

  factory PrivacySchema.none() => PrivacySchema();
  factory PrivacySchema.full() => PrivacySchema();

  addProtector(String type, DatumTransformer protector) => transformers[type] = protector;

  /// Returns a privacy protected version of [data].
  ///
  /// If a transformer for this data type exists, the data is transformed.
  /// Otherwise, the same data is returned unchanged.
  Datum protect(Datum data) {
    Function transformer = transformers[data.format.name];
    return (transformer != null) ? transformer(data) : data;
  }
}

/// Specify how sampling should be done. Used to make default configuration of [Measure]s.
class SamplingSchema {
  /// The sampling schema type according to [SamplingSchemaType].
  String type;

  /// A printer-friendly name of this [SamplingSchema].
  String name;

  /// A map of default [Measure]s for this sampling schema.
  ///
  /// These default measures can be manually populated by
  /// adding [Measure]s to this map.
  Map<String, Measure> measures = Map<String, Measure>();

  /// Returns a list of [Measure]s from this [SamplingSchema] for
  /// a list of [MeasureType]s as specified in [types].
  ///
  /// This method is a convenient way to get a list of pre-configured
  /// measures of the correct type with default settings.
  /// For example using
  ///
  ///       SamplingSchema.common().getMeasureList([DataType.LOCATION, DataType.ACTIVITY, DataType.WEATHER]);
  ///
  /// would return a list with a [Measure] for location and activity, a [WeatherMeasure] for weather,
  /// each with default configurations from the [SamplingSchema.common()] schema.
  ///
  /// If [namepace] is specified, then the returned measures' [MeasureType] belong to this namespace.
  /// Otherwise, the [NameSpace.UNKNOWN] is applied.
  List<Measure> getMeasureList(List<String> types, {String namepace}) {
    List<Measure> _list = List<Measure>();

    types.forEach((type) {
      if (measures.containsKey(type)) {
        // using json encoding/decoding to clone the measure object
        final _json = _encode(measures[type]);
        final Measure _clone = Measure.fromJson(json.decode(_json) as Map<String, dynamic>);
        _clone.type.namepace = namepace ?? NameSpace.UNKNOWN;
        _list.add(_clone);
      }
    });

    return _list;
  }

  /// Is this sampling schema power-aware, i.e. adapting its sampling strategy to
  /// the battery power status.
  bool powerAware = false;

  SamplingSchema({this.type, this.name, this.powerAware}) : super();

  /// A default `common` sampling schema.
  ///
  /// This schema contains measure configurations based on best-effort experience
  /// and is intended for sampling on a daily basis with recharging
  /// at least once pr. day. This scheme is power-aware.
  ///
  /// These default settings are described in this [table](https://github.com/cph-cachet/carp.sensing-flutter/wiki/Schemas#samplingschemacommon).
  factory SamplingSchema.common() {
    return SamplingSchema(type: SamplingSchemaType.LIGHT, name: 'Common (default) sampling', powerAware: true)
      ..measures.addEntries([
        MapEntry(
            DataType.ACCELEROMETER,
            PeriodicMeasure(MeasureType(NameSpace.UNKNOWN, DataType.ACCELEROMETER),
                enabled: false, frequency: 1000, duration: 10)),
        MapEntry(
            DataType.GYROSCOPE,
            PeriodicMeasure(MeasureType(NameSpace.UNKNOWN, DataType.GYROSCOPE),
                enabled: false, frequency: 1000, duration: 10)),
        MapEntry(
            DataType.PEDOMETER,
            PeriodicMeasure(MeasureType(NameSpace.UNKNOWN, DataType.PEDOMETER),
                enabled: true, frequency: 60 * 60 * 1000)),
        MapEntry(
            DataType.LIGHT,
            PeriodicMeasure(MeasureType(NameSpace.UNKNOWN, DataType.LIGHT),
                enabled: false, frequency: 60 * 1000, duration: 1000)),
        MapEntry(DataType.BATTERY, Measure(MeasureType(NameSpace.UNKNOWN, DataType.BATTERY), enabled: true)),
        MapEntry(DataType.SCREEN, Measure(MeasureType(NameSpace.UNKNOWN, DataType.SCREEN), enabled: true)),
        MapEntry(DataType.MEMORY,
            PeriodicMeasure(MeasureType(NameSpace.UNKNOWN, DataType.MEMORY), enabled: false, frequency: 10 * 1000)),
        MapEntry(DataType.LOCATION, Measure(MeasureType(NameSpace.UNKNOWN, DataType.LOCATION), enabled: true)),
        MapEntry(DataType.CONNECTIVITY, Measure(MeasureType(NameSpace.UNKNOWN, DataType.CONNECTIVITY), enabled: true)),
        MapEntry(
            DataType.BLUETOOTH,
            PeriodicMeasure(MeasureType(NameSpace.UNKNOWN, DataType.BLUETOOTH),
                enabled: false, frequency: 60 * 60 * 1000, duration: 2 * 1000)),
        MapEntry(
            DataType.APPS,
            PeriodicMeasure(MeasureType(NameSpace.UNKNOWN, DataType.APPS),
                enabled: true, frequency: 24 * 60 * 60 * 1000)),
        MapEntry(
            DataType.APP_USAGE,
            PeriodicMeasure(MeasureType(NameSpace.UNKNOWN, DataType.APP_USAGE),
                enabled: true, frequency: 60 * 60 * 1000, duration: 60 * 60 * 1000)),
        MapEntry(
            DataType.AUDIO,
            PeriodicMeasure(MeasureType(NameSpace.UNKNOWN, DataType.AUDIO),
                enabled: false, frequency: 60 * 1000, duration: 2 * 1000)),
        MapEntry(
            DataType.NOISE,
            PeriodicMeasure(MeasureType(NameSpace.UNKNOWN, DataType.NOISE),
                enabled: true, frequency: 60 * 1000, duration: 2 * 1000)),
        MapEntry(DataType.ACTIVITY, Measure(MeasureType(NameSpace.UNKNOWN, DataType.ACTIVITY), enabled: true)),
        MapEntry(DataType.PHONE_LOG,
            PhoneLogMeasure(MeasureType(NameSpace.UNKNOWN, DataType.PHONE_LOG), enabled: false, days: 30)),
        MapEntry(DataType.TEXT_MESSAGE_LOG,
            Measure(MeasureType(NameSpace.UNKNOWN, DataType.TEXT_MESSAGE_LOG), enabled: false)),
        MapEntry(DataType.TEXT_MESSAGE, Measure(MeasureType(NameSpace.UNKNOWN, DataType.TEXT_MESSAGE), enabled: true)),
        MapEntry(
            DataType.WEATHER,
            WeatherMeasure(MeasureType(NameSpace.UNKNOWN, DataType.WEATHER),
                enabled: false, frequency: 2 * 60 * 60 * 1000))
      ]);
  }

  /// A sampling schema that does not adapt any [Measure]s.
  ///
  /// This schema is an empty schema and therefore don't change anything when
  /// used to adapt a [Study] and its [Measure]s in the [adapt] method.
  factory SamplingSchema.normal({bool powerAware}) =>
      SamplingSchema(type: SamplingSchemaType.NORMAL, name: 'Default sampling', powerAware: powerAware);

  /// A default light sampling schema.
  ///
  /// This schema is intended for sampling on a daily basis with recharging
  /// at least once pr. day. This scheme is not power-aware.
  factory SamplingSchema.light() {
    return SamplingSchema(type: SamplingSchemaType.LIGHT, name: 'Default Light sampling', powerAware: true)
      ..measures.addEntries([
        MapEntry(DataType.LOCATION,
            Measure(MeasureType(NameSpace.UNKNOWN, DataType.LOCATION), enabled: false)) // disable location sensing
      ]);
  }

  factory SamplingSchema.minimum() =>
      SamplingSchema(type: SamplingSchemaType.MINIMUM, name: 'Default Minimum sampling', powerAware: true)
        ..measures.addEntries([
          MapEntry(DataType.LOCATION,
              Measure(MeasureType(NameSpace.UNKNOWN, DataType.LOCATION), enabled: false)), // disable location sensing
          MapEntry(DataType.MEMORY,
              Measure(MeasureType(NameSpace.UNKNOWN, DataType.MEMORY), enabled: false)) // disable memory sensing
        ]);

  /// A non-sampling sampling schema.
  ///
  /// This schema disables all sampling by disabling all probes.
  /// This schema is power-aware and sampling will be restored to the original
  /// level, once the device is recharged above the [SamplingSchema.LIGHT_SAMPLING_LEVEL]
  /// level.
  factory SamplingSchema.none() {
    SamplingSchema schema =
        SamplingSchema(type: SamplingSchemaType.NONE, name: 'Default No sampling', powerAware: true);
    DataType.all.forEach((key) {
      schema.measures[key] = Measure(MeasureType(NameSpace.UNKNOWN, key), enabled: false);
    });

    return schema;
  }

  /// Adapts all [Measure]s in a [Study] to this [SamplingSchema].
  ///
  /// The following parameters are adapted
  ///   * [enabled] - a measure can be enabled / disabled based on this schema
  ///   * [frequency] - the sampling frequency can be adjusted based on this schema
  ///   * [duration] - the sampling duration can be adjusted based on this schema
  void adapt(Study study, {bool restore = true}) {
    study.tasks.forEach((task) {
      task.measures.forEach((measure) {
        // first restore each measure in the study+tasks to its previous value
        if (restore) measure.restore();
        if (measures.containsKey(measure.type.name)) {
          // if an adapted measure exists in this schema, adapt to this
          measure.adapt(measures[measure.type.name]);
        }
        // notify listeners that the measure has changed due to restoration and/or adaptation
        measure.hasChanged();
      });
    });
  }
}

/// A enumeration of known sampling schemas types.
class SamplingSchemaType {
  static const String NORMAL = "NORMAL";
  static const String LIGHT = "LIGHT";
  static const String MINIMUM = "MINIMUM";
  static const String NONE = "NONE";
}
