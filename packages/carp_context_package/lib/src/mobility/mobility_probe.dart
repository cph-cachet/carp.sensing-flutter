part of context;

/// Collects mobility features using the [MobilityFactory] API.
class MobilityProbe extends StreamProbe {
  void onInitialize(Measure measure) {
    super.onInitialize(measure);
    MobilityMeasure m = measure as MobilityMeasure;

    // configuration
    MobilityFeatures().stopRadius = m.stopRadius;
    MobilityFeatures().placeRadius = m.placeRadius;
    MobilityFeatures().stopDuration = m.stopDuration;

    // start the location data stream from the LocationManager
    Stream<LocationSample> stream = LocationManager().locationStream.map((e) =>
        LocationSample(GeoLocation(e.latitude, e.longitude), DateTime.now()));

    // feed the location data stream to the MobilityFeatures singleton
    // which in turn produce [MobilityContext]s
    MobilityFeatures().startListening(stream);
  }

  /// The stream of mobility features as they are generated.
  Stream<Datum> get stream => MobilityFeatures()
      .contextStream
      .map((context) => MobilityDatum.fromMobilityContext(context));
}
