part of context;

/// Specify the configuration on how to measure mobility features
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class MobilityMeasure extends Measure {
  /// Should prior computed context be used?
  bool usePriorContexts;

  // The radius of a stop.
  double stopRadius;

  // The radius for registring a place.
  double placeRadius;

  /// The duration of a stop (minimum).
  Duration stopDuration;

  MobilityMeasure(MeasureType type,
      {name,
      enabled,
      this.usePriorContexts,
      this.stopRadius,
      this.placeRadius,
      this.stopDuration})
      : super(type, name: name, enabled: enabled);

  static Function get fromJsonFunction => _$MobilityMeasureFromJson;

  factory MobilityMeasure.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory.fromJson(
          json[Serializable.CLASS_IDENTIFIER].toString(), json);

  Map<String, dynamic> toJson() => _$MobilityMeasureToJson(this);

  String toString() =>
      super.toString() +
      ',usePriorContext: $usePriorContexts,'
          'stopRadius: $stopRadius,'
          'placeRadius: $placeRadius,'
          'stopDuration: $stopDuration';
}
