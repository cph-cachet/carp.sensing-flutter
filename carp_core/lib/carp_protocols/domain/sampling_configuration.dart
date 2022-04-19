/*
 * Copyright 2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of carp_core_protocols;

/// Contains configuration on how to sample a data stream of a given type.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class SamplingConfiguration extends Serializable {
  SamplingConfiguration() : super();
  Function get fromJsonFunction => _$SamplingConfigurationFromJson;
  factory SamplingConfiguration.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as SamplingConfiguration;
  Map<String, dynamic> toJson() => _$SamplingConfigurationToJson(this);
  String get jsonType =>
      'dk.cachet.carp.protocols.domain.sampling.SamplingConfiguration';
}

/// Specifies the sampling scheme for a data [type], including possible options,
/// defaults, and constraints.
abstract class DataTypeSamplingScheme {
  /// The data type this sampling scheme relates to.
  String type;

  // TODO - note that this is called "default" in carp-core-kotlin.
  // But "default" is a reserved word in Dart. May cause serialization problems.....

  /// The default configuration to use when no other configuration is specified.
  SamplingConfiguration defaultSamplingConfiguration;

  DataTypeSamplingScheme(this.type, this.defaultSamplingConfiguration)
      : super();
}
