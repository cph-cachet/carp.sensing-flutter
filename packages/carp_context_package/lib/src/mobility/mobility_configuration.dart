part of context;

/// Specify the configuration on how to measure mobility features.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class MobilitySamplingConfiguration extends PersistentSamplingConfiguration {
  /// Should prior computed context be used?
  bool usePriorContexts;

  /// The radius of a stop.
  double stopRadius;

  /// The radius for registring a place.
  double placeRadius;

  /// The duration of a stop (minimum).
  late Duration stopDuration;

  MobilitySamplingConfiguration({
    this.usePriorContexts = true,
    this.stopRadius = 25,
    this.placeRadius = 50,
    Duration? stopDuration,
  }) : super() {
    this.stopDuration = stopDuration ?? const Duration(seconds: 30);
  }

  @override
  Function get fromJsonFunction => _$MobilitySamplingConfigurationFromJson;

  @override
  Map<String, dynamic> toJson() => _$MobilitySamplingConfigurationToJson(this);

  factory MobilitySamplingConfiguration.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as MobilitySamplingConfiguration;
}
