part of '../../carp_context_package.dart';

/// A sampling configuration for location sampling.
/// This configuration allows for specifying if the location should be sampled only once.
///
/// Usage:
///
/// ```dart
/// Measure(type: ContextSamplingPackage.LOCATION)
///   ..overrideSamplingConfiguration = LocationSamplingConfiguration(once: true),
/// ```
///
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class LocationSamplingConfiguration extends SamplingConfiguration {
  /// Should the location be sampled only once?
  bool once = false;

  LocationSamplingConfiguration({this.once = false}) : super();

  @override
  Map<String, dynamic> toJson() => _$LocationSamplingConfigurationToJson(this);
  @override
  Function get fromJsonFunction => _$LocationSamplingConfigurationFromJson;
  factory LocationSamplingConfiguration.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson<LocationSamplingConfiguration>(json);
}
