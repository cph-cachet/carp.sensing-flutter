part of context;

/// A [Datum] that holds mobility features information.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class MobilityDatum extends Datum {
  DataFormat get format =>
      DataFormat.fromString(ContextSamplingPackage.MOBILITY);

  /// The day of this mobility features.
  DateTime date;

  /// The timestamp at which the features were computed.
  DateTime timestamp;

  /// Number of places visited on [date].
  int numberOfPlaces;

  /// Location Variance on [date].
  double locationVariance;

  /// Location entropy
  ///  * High entropy: Time is spent evenly among all places
  ///  * Low  entropy: Time is mainly spent at a few of the places
  double entropy;

  /// Normalized entropy. A scalar between 0 and 1
  double normalizedEntropy;

  /// Home Stay today. A scalar between 0 and 1, i.e. from 0% to 100%
  double homeStay;

  /// Distance travelled today, in meters.
  double distanceTravelled;

  MobilityDatum() : super();

  factory MobilityDatum.fromJson(Map<String, dynamic> json) =>
      _$MobilityDatumFromJson(json);

  Map<String, dynamic> toJson() => _$MobilityDatumToJson(this);

  String toString() =>
      super.toString() +
      ',number of places: $numberOfPlaces\n' +
      'location variance: $locationVariance\n' +
      'entropy: $entropy\n' +
      'normalized entropy: $normalizedEntropy\n' +
      'home stay: $homeStay\n' +
      'distance travelled: $distanceTravelled\n';
}
