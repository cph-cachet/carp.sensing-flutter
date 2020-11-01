part of context;

/// Collects local weather information using the [WeatherStation] API.
class MobilityProbe extends StreamProbe {
  /// Init the [MobilityFactory] singleton
  MobilityFactory _mobilityFactory = MobilityFactory.instance;

  void onInitialize(Measure measure) {
    super.onInitialize(measure);
    MobilityMeasure m = measure as MobilityMeasure;

    /// Extract parameters from the [MobilityMeasure]
    _mobilityFactory.stopRadius = (m.stopRadius ?? 25);
    _mobilityFactory.placeRadius = (m.placeRadius ?? 50);
    _mobilityFactory.stopDuration = (m.stopDuration ?? Duration(minutes: 3));

    /// Start the Location Data stream from the LocationManager
    Stream<LocationSample> stream =
        locationManager.dtoStream.map((e) => LocationSample(GeoLocation(e.latitude, e.longitude), DateTime.now()));

    /// Feed the Location Data Stream to the [MobilityFactory] singleton
    /// The [MobilityFactory] will in turn produce [MobilityContext]s
    _mobilityFactory.startListening(stream);
  }

  /// Get the [MobilityContext] stream from the [MobilityFactory] singleton
  Stream<Datum> get stream => _mobilityFactory.contextStream.map(_convertToDatum);

  /// Converts a [MobilityContext] to a [MobilityDatum]
  MobilityDatum _convertToDatum(MobilityContext context) => MobilityDatum()
    ..numberOfPlaces = context.numberOfSignificantPlaces
    ..homeStay = context.homeStay
    ..distanceTravelled = context.distanceTravelled
    ..entropy = context.entropy
    ..normalizedEntropy = context.normalizedEntropy
    ..locationVariance = context.locationVariance;
}
