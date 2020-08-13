part of context;

/// A [Datum] that holds mobility features information collected through
/// Mobility Features package
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class MobilityDatum extends CARPDatum {
  static const DataFormat CARP_DATA_FORMAT =
      DataFormat(NameSpace.CARP, ContextSamplingPackage.MOBILITY);

  DataFormat get format => CARP_DATA_FORMAT;

  DateTime date, timestamp;
  int numberOfPlaces;
  double locationVariance,
      entropy,
      normalizedEntropy,
      homeStay,
      distanceTravelled,
      routineIndex;

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
      'distance travelled: $distanceTravelled\n' +
      'routine index: $routineIndex';
}
