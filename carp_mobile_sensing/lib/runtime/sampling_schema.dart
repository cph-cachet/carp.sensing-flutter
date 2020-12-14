/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of runtime;

String _encode(Object object) =>
    const JsonEncoder.withIndent(' ').convert(object);

/// Specify how sampling should be done. Used to make default configuration of
/// [Measure]s.
///
/// A new [SamplingSchema] can be created for specific purposes. For example,
/// the following schema is made for outdoor activity tracking.
///
///     SamplingSchema activitySchema = SamplingSchema(name: 'Outdoor Activity Sampling Schema', powerAware: true)
///       ..measures.addEntries([
///         MapEntry(DataType.PEDOMETER,
///           PeriodicMeasure(MeasureType(NameSpace.CARP, DataType.PEDOMETER), enabled: true, frequency: 60 * 60 * 1000)),
///         MapEntry(DataType.SCREEN, Measure(MeasureType(NameSpace.CARP, DataType.SCREEN), enabled: true)),
///         MapEntry(DataType.LOCATION, Measure(MeasureType(NameSpace.CARP, DataType.LOCATION), enabled: true)),
///         MapEntry(DataType.NOISE,
///           PeriodicMeasure(MeasureType(NameSpace.CARP, DataType.NOISE),
///             enabled: true, frequency: 60 * 1000, duration: 2 * 1000)),
///         MapEntry(DataType.ACTIVITY, Measure(MeasureType(NameSpace.CARP, DataType.ACTIVITY), enabled: true)),
///         MapEntry(DataType.WEATHER,
///           WeatherMeasure(MeasureType(NameSpace.CARP, DataType.WEATHER), enabled: true, frequency: 2 * 60 * 60 * 1000))
///       ]);
///
/// There is also a set of factory methods than provide different default
/// sampling schemas, including:
///
/// * [`common`]() - a default, most common configuration of all known measures
/// * [`maximum`]() - using the `common` default configuration of all probes, but enabling all measures
/// * [`light`]() - a light configuration, enabling low-frequent sampling but with good coverage
/// * [`minimum`]() - a minimum set of measures, with a minimum sampling rate
/// * [`none`]() - no sampling at all (used to pause all sampling)
///
/// See the [documentation](https://github.com/cph-cachet/carp.sensing-flutter/wiki/Schemas) for further details.
///
class SamplingSchema {
  /// The sampling schema type according to [SamplingSchemaType].
  String type;

  /// A printer-friendly name of this [SamplingSchema].
  String name;

  /// A description of this [SamplingSchema].
  String description;

  /// A map of default [Measure]s for this sampling schema.
  ///
  /// These default measures can be manually populated by
  /// adding [Measure]s to this map.
  Map<String, Measure> measures = {};

  /// Adds all measures from [schema] to this sampling schema.
  ///
  /// If a measure in [schema] is already in this schema, its value is overwritten.
  void addSamplingSchema(SamplingSchema schema) {
    if (schema != null) measures.addAll(schema.measures);
  }

  /// Returns a list of [Measure]s from this [SamplingSchema] for
  /// a list of [MeasureType]s as specified in [types].
  ///
  /// This method is a convenient way to get a list of pre-configured
  /// measures of the correct type with default settings.
  /// For example using
  ///
  ///       SamplingSchema.common().getMeasureList(
  ///         namespace: NameSpace.CARP,
  ///         types: [
  ///           ConnectivitySamplingPackage.BLUETOOTH,
  ///           ConnectivitySamplingPackage.CONNECTIVITY,
  ///           SensorSamplingPackage.ACCELEROMETER,
  ///           SensorSamplingPackage.GYROSCOPE,
  ///           AppsSamplingPackage.APPS,
  ///         ]);
  ///
  /// would return a list with a [Measure] for bluetooth, connectivity, etc.,
  /// each with default configurations from the [SamplingSchema.common()] schema.
  ///
  /// If [namespace] is specified, then the returned measures' [MeasureType]
  /// belong to this namespace.
  /// Otherwise, the [NameSpace.UNKNOWN] is applied.
  List<Measure> getMeasureList(
      {String namespace = NameSpace.UNKNOWN, @required List<String> types}) {
    List<Measure> _list = [];

    types.forEach((type) {
      if (measures.containsKey(type)) {
        // using json encoding/decoding to clone the measure object
        final _json = _encode(measures[type]);
        final Measure _clone =
            Measure.fromJson(json.decode(_json) as Map<String, dynamic>);
        _clone.type.namespace = namespace ?? NameSpace.UNKNOWN;
        _list.add(_clone);
      }
    });

    return _list;
  }

  /// Is this sampling schema power-aware, i.e. adapting its sampling strategy
  /// to the battery power status. See [PowerAwarenessState].
  bool powerAware = false;

  SamplingSchema({this.type, this.name, this.powerAware}) : super();

  /// A schema that does maximum sampling.
  ///
  /// Takes its settings from the [SamplingSchema.common()] schema, but
  /// enables all measures.
  factory SamplingSchema.maximum({String namespace}) =>
      SamplingSchema.common(namespace: namespace)
        ..type = SamplingSchemaType.MAXIMUM
        ..name = 'Default ALL sampling'
        ..powerAware = true
        ..measures.values.forEach((measure) => measure.enabled = true);

  /// A default `common` sampling schema.
  ///
  /// This schema contains measure configurations based on best-effort
  /// experience and is intended for sampling on a daily basis with recharging
  /// at least once pr. day. This scheme is power-aware.
  ///
  /// These default settings are described in this [table](https://github.com/cph-cachet/carp.sensing-flutter/wiki/Schemas#samplingschemacommon).
  factory SamplingSchema.common({String namespace = NameSpace.UNKNOWN}) {
    SamplingSchema schema = SamplingSchema()
      ..type = SamplingSchemaType.COMMON
      ..name = 'Common (default) sampling'
      ..powerAware = true;

    // join sampling schemas from each registered sampling package.
    SamplingPackageRegistry()
        .packages
        .forEach((package) => schema.addSamplingSchema(package.common));
    //schema.measures.values.forEach((measure) => print('measure : $measure'));
    schema.measures.values
        .forEach((measure) => measure.type.namespace = namespace);

    return schema;
  }

  /// A sampling schema that does not adapt any [Measure]s.
  ///
  /// This schema is used in the power-aware adaptation of sampling. See [PowerAwarenessState].
  /// [SamplingSchema.normal] is an empty schema and therefore don't change anything when
  /// used to adapt a [Study] and its [Measure]s in the [adapt] method.
  factory SamplingSchema.normal({String namespace, bool powerAware}) =>
      SamplingSchema(
          type: SamplingSchemaType.NORMAL,
          name: 'Default sampling',
          powerAware: powerAware);

  /// A default light sampling schema.
  ///
  /// This schema is used in the power-aware adaptation of sampling.
  /// See [PowerAwarenessState].
  /// This schema is intended for sampling on a daily basis with recharging
  /// at least once pr. day. This scheme is power-aware.
  ///
  /// See this [table](https://github.com/cph-cachet/carp.sensing-flutter/wiki/Schemas#samplingschemalight) for an overview.
  factory SamplingSchema.light({String namespace}) {
    SamplingSchema schema = SamplingSchema()
      ..type = SamplingSchemaType.LIGHT
      ..name = 'Light sampling'
      ..powerAware = true;

    // join sampling schemas from each registered sampling package.
    SamplingPackageRegistry()
        .packages
        .forEach((package) => schema.addSamplingSchema(package.light));
    schema.measures.values
        .forEach((measure) => measure.type.namespace = namespace);

    return schema;
  }

  /// A default minimum sampling schema.
  ///
  /// This schema is used in the power-aware adaptation of sampling.
  /// See [PowerAwarenessState].
  factory SamplingSchema.minimum({String namespace}) {
    SamplingSchema schema = SamplingSchema()
      ..type = SamplingSchemaType.MINIMUM
      ..name = 'Minimum sampling'
      ..powerAware = true;

    // join sampling schemas from each registered sampling package.
    SamplingPackageRegistry()
        .packages
        .forEach((package) => schema.addSamplingSchema(package.minimum));
    schema.measures.values
        .forEach((measure) => measure.type.namespace = namespace);

    return schema;
  }

  /// A non-sampling sampling schema.
  ///
  /// This schema is used in the power-aware adaptation of sampling.
  /// See [PowerAwarenessState].
  /// This schema pauses all sampling by disabling all probes.
  /// Sampling will be restored to the minimum level, once the device is
  /// recharged above the [PowerAwarenessState.MINIMUM_SAMPLING_LEVEL] level.
  factory SamplingSchema.none({String namespace = NameSpace.CARP}) {
    SamplingSchema schema = SamplingSchema(
        type: SamplingSchemaType.NONE, name: 'No sampling', powerAware: true);
    DataType.all.forEach((key) => schema.measures[key] =
        Measure(MeasureType(namespace, key), enabled: false));

    return schema;
  }

  /// A sampling schema for debugging purposes.
  /// Collects and combines the [SamplingPackage.debug] [SamplingSchema]s
  /// for each package.
  factory SamplingSchema.debug({String namespace = NameSpace.CARP}) {
    SamplingSchema schema = SamplingSchema()
      ..type = SamplingSchemaType.DEBUG
      ..name = 'Debugging sampling'
      ..powerAware = false;

    // join sampling schemas from each registered sampling package.
    SamplingPackageRegistry()
        .packages
        .forEach((package) => schema.addSamplingSchema(package.debug));
    schema.measures.values
        .forEach((measure) => measure.type.namespace = namespace);

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
          // if an adapted measure exists in this schema, adapt to it
          measure.adapt(measures[measure.type.name]);
        }
        // notify listeners that the measure has changed due to restoration
        // and/or adaptation
        measure.hasChanged();
      });
    });
  }
}

/// A enumeration of known sampling schemas types.
class SamplingSchemaType {
  static const String MAXIMUM = 'MAXIMUM';
  static const String COMMON = 'COMMON';
  static const String NORMAL = 'NORMAL';
  static const String LIGHT = 'LIGHT';
  static const String MINIMUM = 'MINIMUM';
  static const String NONE = 'NONE';
  static const String DEBUG = 'DEBUG';
}
