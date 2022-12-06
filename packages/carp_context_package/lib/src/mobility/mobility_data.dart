part of carp_context_package;

/// A [Data] that holds mobility features information.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class MobilityData extends Data {
  static const dataType = ContextSamplingPackage.MOBILITY;

  /// The time this data was collected.
  DateTime? timestamp;

  /// The day of this mobility features.
  DateTime? date;

  /// Number of places visited on [date].
  int? numberOfPlaces;

  /// Location Variance on [date].
  double? locationVariance;

  /// Location entropy on [date].
  ///  * High entropy: Time is spent evenly among all places
  ///  * Low  entropy: Time is mainly spent at a few of the places
  double? entropy;

  /// Normalized entropy on [date]. A scalar between 0 and 1
  double? normalizedEntropy;

  /// Home Stay on [date]. A scalar between 0 and 1.
  double? homeStay;

  /// Distance travelled on [date], in meters.
  double? distanceTravelled;

  MobilityData() : super();

  factory MobilityData.fromMobilityContext(MobilityContext context) =>
      MobilityData()
        ..date = context.date
        ..timestamp = context.timestamp
        ..numberOfPlaces = context.numberOfSignificantPlaces
        ..locationVariance = context.locationVariance
        ..entropy = context.entropy
        ..normalizedEntropy = context.normalizedEntropy
        ..homeStay = context.homeStay
        ..distanceTravelled = context.distanceTravelled;

  factory MobilityData.fromJson(Map<String, dynamic> json) =>
      _$MobilityDataFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$MobilityDataToJson(this);

  @override
  String toString() =>
      '${super.toString()}, number of places: $numberOfPlaces, location variance: $locationVariance, entropy: $entropy, normalized entropy: $normalizedEntropy, home stay: $homeStay, distance travelled: $distanceTravelled';
}
