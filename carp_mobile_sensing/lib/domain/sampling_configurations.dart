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

  @override
  Map<String, dynamic> toJson() =>
      _$PersistentSamplingConfigurationToJson(this);
  @override
  Function get fromJsonFunction => _$PersistentSamplingConfigurationFromJson;
  factory PersistentSamplingConfiguration.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as PersistentSamplingConfiguration;
}

/// A sampling configuration which allows configuring the time back in the [past]
/// and into the [future] to collect data.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class HistoricSamplingConfiguration extends PersistentSamplingConfiguration {
  static const int DEFAULT_NUMBER_OF_DAYS = 1;

  /// The time duration back in time to collect data.
  late Duration past;

  /// The time duration ahead in time to collect data.
  late Duration future;

  HistoricSamplingConfiguration({Duration? past, Duration? future}) : super() {
    this.past = past ?? const Duration(days: DEFAULT_NUMBER_OF_DAYS);
    this.future = future ?? const Duration(days: DEFAULT_NUMBER_OF_DAYS);
  }

  @override
  Function get fromJsonFunction => _$HistoricSamplingConfigurationFromJson;
  @override
  Map<String, dynamic> toJson() => _$HistoricSamplingConfigurationToJson(this);
  factory HistoricSamplingConfiguration.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as HistoricSamplingConfiguration;
}

/// A sampling configuration which allows configuring the time [interval] in
/// between subsequent measurements.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class IntervalSamplingConfiguration extends PersistentSamplingConfiguration {
  /// Sampling interval (i.e., delay between sampling).
  Duration interval;

  IntervalSamplingConfiguration({required this.interval}) : super();

  @override
  Function get fromJsonFunction => _$IntervalSamplingConfigurationFromJson;
  @override
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
    required super.interval,
    required this.duration,
  });

  @override
  Map<String, dynamic> toJson() => _$PeriodicSamplingConfigurationToJson(this);
  @override
  Function get fromJsonFunction => _$PeriodicSamplingConfigurationFromJson;
  factory PeriodicSamplingConfiguration.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as PeriodicSamplingConfiguration;
}
