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

class SamplingSchema {
  /// The default [NameSpace] for sampling schemas.
  //static const String DEFAULT_NAMESPACE = NameSpace.CARP;

  //Study study;

  /// A printer-friendly name of this [SamplingSchema].
  String name;

  /// The [NameSpace] to be used for this [SamplingSchema].
  //String namespace;

  /// A map of default [Measure] for this sampling schema.
  ///
  /// These default measures can be manually populated by
  /// adding [Measure]s to this map.
  Map<String, Measure> measures = Map<String, Measure>();

  /// Is this sampling schema power-aware, i.e. adapting its sampling strategy to
  /// the battery power status.
  bool powerAware = false;

  SamplingSchema({this.name, this.powerAware}) : super();

  /// A default light sampling schema.
  ///
  /// This schema is intended for sampling on a daily basis with recharging
  /// at least once pr. day. This scheme is not power-aware.
  ///
  /// Settings:
  ///  - accelerometer
  ///  - gyroscope
  ///  - pedometer
  ///  - light
  ///  - hardware (battery, memory)
  ///  - connectivity
  ///  - location
  ///  - app usage
  ///  - phone usage
  ///  - text messaging
  ///  - screen activity
  ///  - activity recognition
  ///  - environment (weather)
  factory SamplingSchema.light() {
    //namespace ??= DEFAULT_NAMESPACE;
    return SamplingSchema(name: 'Light sampling', powerAware: true)
      ..measures.addEntries([MapEntry('a', Measure(MeasureType(NameSpace.UNKNOWN, 'a')))]);
  }

  factory SamplingSchema.maximum() => SamplingSchema();

  factory SamplingSchema.minimum() => SamplingSchema();

  /// A non-sampling sampling schema.
  ///
  /// This schema disables all sampling by disabling all probes.
  /// This schema is power-aware and sampling will be restored to the original
  /// level, once the device is recharged above the [SamplingSchema.LIGHT_SAMPLING_LEVEL]
  /// level.
  factory SamplingSchema.none() {
    SamplingSchema schema = SamplingSchema(powerAware: true);
    DataType.all.forEach((key) {
      schema.measures[key] = Measure(MeasureType(NameSpace.UNKNOWN, key), enabled: false);
    });

    return schema;
  }

  /// Adapts the [Measure]s in a [Study] to this [SamplingSchema].
  ///
  /// The following parameters are adapted
  ///   * [enabled] - a measure can be enabled / disabled based on this schema
  ///   * [frequency] - the sampling frequency can be adjusted based on this schema
  ///   * [duration] - the sampling duration can be adjusted based on this schema
  void adapt(Study study) {
    //this.study = study;
    study.tasks.forEach((task) {
      task.measures.forEach((measure) {
        if (measures.containsKey(measure.type.name)) {
          Measure default_measure = measures[measure.type.name];
          // adapting to the default measure settings
          measure.enabled = default_measure.enabled;
          if ((measure is PeriodicMeasure) && (default_measure is PeriodicMeasure)) {
            measure.frequency = default_measure.frequency;
            measure.duration = default_measure.duration;
          }
        }
      });
    });
  }
}
