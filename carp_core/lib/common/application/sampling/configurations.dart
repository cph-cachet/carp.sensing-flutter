/*
 * Copyright 2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of carp_core_common;

/// Contains configuration on how to sample a data stream of a given type.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class SamplingConfiguration extends Serializable {
  SamplingConfiguration() : super();

  @override
  Function get fromJsonFunction => _$SamplingConfigurationFromJson;
  factory SamplingConfiguration.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as SamplingConfiguration;
  @override
  Map<String, dynamic> toJson() => _$SamplingConfigurationToJson(this);

  @override
  String get jsonType =>
      'dk.cachet.carp.common.application.sampling.$runtimeType';
}

/// A sampling configuration which does not provide any configuration options.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class NoOptionsSamplingConfiguration extends SamplingConfiguration {
  NoOptionsSamplingConfiguration() : super();

  @override
  Function get fromJsonFunction => _$NoOptionsSamplingConfigurationFromJson;
  factory NoOptionsSamplingConfiguration.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as NoOptionsSamplingConfiguration;
  @override
  Map<String, dynamic> toJson() => _$NoOptionsSamplingConfigurationToJson(this);
}

/// A sampling configuration which changes based on how much battery the device has left.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class BatteryAwareSamplingConfiguration extends SamplingConfiguration {
  /// The sampling configuration to use when there is plenty of battery left.
  SamplingConfiguration normal;

  /// The sampling configuration to use when the battery is low.
  SamplingConfiguration low;

  /// The sampling configuration to use when the battery is critically low.
  /// By default, sampling should be disabled at this point.
  SamplingConfiguration? critical;

  BatteryAwareSamplingConfiguration({
    required this.normal,
    required this.low,
    this.critical,
  }) : super();

  @override
  Function get fromJsonFunction => _$BatteryAwareSamplingConfigurationFromJson;
  @override
  Map<String, dynamic> toJson() =>
      _$BatteryAwareSamplingConfigurationToJson(this);
  factory BatteryAwareSamplingConfiguration.fromJson(
          Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as BatteryAwareSamplingConfiguration;
}

/// The level of detail a data stream should be sampled at, corresponding to
/// expected degrees of power consumption.
enum Granularity {
  /// Consumes a lot of power. Only use for short periods of time or when power
  /// consumption is not an issue.
  Detailed,

  /// Balanced power consumption. For battery-based devices this aims not to
  /// require more than one recharge per day.
  Balanced,

  /// Minimal impact on power consumption, but only provides a very coarse
  /// level of detail.
  Coarse
}

/// A [SamplingConfiguration] which allows specifying a desired level of [granularity],
/// corresponding to expected degrees of power consumption.
@JsonSerializable()
class GranularitySamplingConfiguration extends SamplingConfiguration {
  Granularity granularity;
  GranularitySamplingConfiguration(this.granularity);

  @override
  Function get fromJsonFunction => _$GranularitySamplingConfigurationFromJson;

  factory GranularitySamplingConfiguration.fromJson(
          Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as GranularitySamplingConfiguration;

  @override
  Map<String, dynamic> toJson() =>
      _$GranularitySamplingConfigurationToJson(this);
}
