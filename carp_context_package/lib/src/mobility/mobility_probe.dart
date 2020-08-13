part of context;

/// Collects local weather information using the [WeatherStation] API.
class MobilityProbe extends DatumProbe {
  MobilityFactory _mobilityFactory;

  Future<void> onInitialize(Measure measure) async {
    super.onInitialize(measure);
    MobilityMeasure mm = measure as MobilityMeasure;
    _mobilityFactory = MobilityFactory.instance;
    _mobilityFactory.stopRadius = (mm.stopRadius ?? 25);
    _mobilityFactory.placeRadius = (mm.placeRadius ?? 50);
    _mobilityFactory.stopDuration = (mm.stopDuration ?? Duration(minutes: 3));
    _mobilityFactory.usePriorContexts = (mm.usePriorContexts ?? true);

    Stream<LocationSample> stream =
        locationManager.dtoStream.map((e) =>
        LocationSample(GeoLocation(e.latitude, e.longitude), DateTime.now()));
    _mobilityFactory.startListening(stream);
  }

  /// Returns the [WeatherDatum] for this location.
  Future<Datum> getDatum() async {
    try {
      MobilityContext context =
          await _mobilityFactory.computeFeatures(date: DateTime.now());

      if (context != null)
        return MobilityDatum()
          ..numberOfPlaces = context.numberOfPlaces
          ..homeStay = context.homeStay
          ..distanceTravelled = context.distanceTravelled
          ..entropy = context.entropy
          ..normalizedEntropy = context.normalizedEntropy
          ..locationVariance = context.locationVariance
          ..routineIndex = context.routineIndex;
      else
        return ErrorDatum('Mobility Feaures retuned null');
    } catch (err) {
      return ErrorDatum('MobilityProbe Exception: $err');
    }
  }
}
