part of context;

/// Specify the configuration on how to compute Mobility Features
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class MobilityMeasure extends Measure {
  /// Parameters for the mobility feature computation
  bool usePriorContexts;
  double stopRadius, placeRadius;
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
