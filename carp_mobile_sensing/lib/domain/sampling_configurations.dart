/*
 * Copyright 2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of domain;

/// A sampling configuration that saves the last time it was sampled.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class PersistentSamplingConfiguration extends SamplingConfiguration {
  /// The date and time of the last time this measure was collected.
  DateTime? lastTime;

  PersistentSamplingConfiguration() : super();

  Map<String, dynamic> toJson() =>
      _$PersistentSamplingConfigurationToJson(this);
  Function get fromJsonFunction => _$PersistentSamplingConfigurationFromJson;
  factory PersistentSamplingConfiguration.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as PersistentSamplingConfiguration;
}

/// A sampling configuration which allows configuring the time [interval] in
/// between subsequent measurements.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class IntervalSamplingConfiguration extends PersistentSamplingConfiguration {
  /// Sampling interval (i.e., delay between sampling).
  Duration interval;

  IntervalSamplingConfiguration({required this.interval}) : super() {}

  Function get fromJsonFunction => _$IntervalSamplingConfigurationFromJson;
  Map<String, dynamic> toJson() => _$IntervalSamplingConfigurationToJson(this);
  factory IntervalSamplingConfiguration.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as IntervalSamplingConfiguration;
}

/// A sampling configuration specifying how to collect data on a regular basis
/// for a specific period.
///
/// Data collection will be started as specified by the [interval] for a time
/// period specified as the [duration]. Useful for listening in on a
/// sensor (e.g. the accelerometer) on a regular, but limited time window.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class PeriodicSamplingConfiguration extends IntervalSamplingConfiguration {
  /// The sampling duration.
  late Duration duration;

  PeriodicSamplingConfiguration({
    required Duration interval,
    required this.duration,
  }) : super(interval: interval);

  Map<String, dynamic> toJson() => _$PeriodicSamplingConfigurationToJson(this);
  Function get fromJsonFunction => _$PeriodicSamplingConfigurationFromJson;
  factory PeriodicSamplingConfiguration.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as PeriodicSamplingConfiguration;
}

/// A sampling configuration which changes based on how much battery the device has left.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class BatteryAwareSamplingConfiguration extends SamplingConfiguration {
  /// The sampling configuration to use when there is plenty of battery left.
  SamplingConfiguration normal;

  /// The sampling configuration to use when the battery is low.
  SamplingConfiguration low;

  /// The sampling configuration to use when the battery is critically low.
  SamplingConfiguration critical;

  BatteryAwareSamplingConfiguration({
    required this.normal,
    required this.low,
    required this.critical,
  }) : super();

  Function get fromJsonFunction => _$BatteryAwareSamplingConfigurationFromJson;
  Map<String, dynamic> toJson() =>
      _$BatteryAwareSamplingConfigurationToJson(this);
  factory BatteryAwareSamplingConfiguration.fromJson(
          Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as BatteryAwareSamplingConfiguration;
}

// /// A sampling configuration which changes based on how much battery the device has left.
// @JsonSerializable(
//     fieldRename: FieldRename.none,
//     includeIfNull: false,
//     genericArgumentFactories: true)
// class BatteryAwareSamplingConfiguration<TConfig extends SamplingConfiguration>
//     extends SamplingConfiguration {
//   /// The sampling configuration to use when there is plenty of battery left.
//   TConfig normal;

//   /// The sampling configuration to use when the battery is low.
//   TConfig low;

//   /// The sampling configuration to use when the battery is critically low.
//   TConfig critical;

//   BatteryAwareSamplingConfiguration({
//     required this.normal,
//     required this.low,
//     required this.critical,
//   }) : super();

//   Function get fromJsonFunction => _$BatteryAwareSamplingConfigurationFromJson;
//   Map<String, dynamic> toJson() =>
//       _$BatteryAwareSamplingConfigurationToJson(this, toJson());
//   factory BatteryAwareSamplingConfiguration.fromJson(
//           Map<String, dynamic> json) =>
//       FromJsonFactory().fromJson(json)
//           as BatteryAwareSamplingConfiguration<TConfig>;
// }