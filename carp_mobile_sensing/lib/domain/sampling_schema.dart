/*
 * Copyright 2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of domain;

String _encode(Object? object) =>
    const JsonEncoder.withIndent(' ').convert(object);

/// Specifies a set of [SamplingConfiguration]s for a set of [Measure] types.
class SamplingSchema {
  final Map<String, SamplingConfiguration> _configurations = {};

  /// A set of default [SamplingConfiguration]s for the measure [types] for
  /// this sampling schema.
  Map<String, SamplingConfiguration> get configurations => _configurations;

  /// The list of measure types supported by this sampling schema.
  List<String> get types => _configurations.keys.toList();

  SamplingSchema() : super();

  /// Add a sampling configuration to this schema.
  void addConfiguration(String type, SamplingConfiguration configuration) =>
      _configurations[type] = configuration;

  /// Remove a sampling configuration from this schema.
  void removeConfiguration(String type) => _configurations.remove(type);

  /// Adds all sampling configurations from another [schema] to this schema.
  /// If a configuration in [schema] is already in this schema, its value is overwritten.
  void addSamplingSchema(SamplingSchema schema) =>
      configurations.addAll(schema.configurations);

  /// Returns a list of copies of [SamplingConfiguration]s from this schema for
  /// a list of [types].
  List<SamplingConfiguration> getConfigurations({required List<String> types}) {
    List<SamplingConfiguration> configurationList = [];

    // since we're using json serialization below, make sure that the json
    // functions have been registred
    CarpMobileSensing();

    for (var type in types) {
      if (configurations.containsKey(type)) {
        // using json encoding/decoding to clone the measure object
        final configurationAsJson = _encode(configurations[type]);
        final SamplingConfiguration configurationClone =
            SamplingConfiguration.fromJson(
                json.decode(configurationAsJson) as Map<String, dynamic>);
        configurationList.add(configurationClone);
      }
    }

    return configurationList;
  }

  // /// A sampling schema that does not adapt any [Measure]s.
  // ///
  // /// This schema is used in the power-aware adaptation of sampling. See [PowerAwarenessState].
  // /// [SamplingSchema.normal] is an empty schema and therefore don't change anything when
  // /// used to adapt a [StudyProtocol] and its [Measure]s in the [adapt] method.
  // factory SamplingSchema.normal({bool powerAware = false}) => SamplingSchema(
  //     type: SamplingSchemaType.normal,
  //     name: 'Default sampling',
  //     powerAware: powerAware);

  // /// Adapts all [Measure]s in a [MasterDeviceDeployment] to this [SamplingSchema].
  // ///
  // /// The following parameters are adapted
  // ///   * [enabled] - a measure can be enabled / disabled based on this schema
  // ///   * [interval] - the sampling frequency can be adjusted based on this schema
  // ///   * [duration] - the sampling duration can be adjusted based on this schema
  // void adapt(MasterDeviceDeployment deployment, {bool restore = true}) {
  //   deployment.tasks.forEach((task) {
  //     task.measures.forEach((measure) {
  //       if (measure is CAMSMeasure) {
  //         // first restore each measure in the study+tasks to its previous value
  //         if (restore) measure.restore();
  //         if (measures.containsKey(measure.type)) {
  //           // if an adapted measure exists in this schema, adapt to it
  //           measure.adapt(measures[measure.type]!);
  //         }
  //         // notify listeners that the measure has changed due to restoration
  //         // and/or adaptation
  //         measure.hasChanged();
  //       }
  //     });
  //   });
  // }
}

// /// A enumeration of known sampling schemas types.
// enum SamplingSchemaType {
//   maximum,
//   common,
//   normal,
//   light,
//   minimum,
//   none,
//   debug,
// }
