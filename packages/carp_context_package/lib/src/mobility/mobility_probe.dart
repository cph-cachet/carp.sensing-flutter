part of context;

/// Collects mobility features using the [MobilityFeatures] API.
class MobilityProbe extends StreamProbe {
  @override
  void onInitialize(Measure measure) {
    super.onInitialize(measure);
    MobilityMeasure m = measure as MobilityMeasure;

    // configuration
    MobilityFeatures().stopRadius = m.stopRadius;
    MobilityFeatures().placeRadius = m.placeRadius;
    MobilityFeatures().stopDuration = m.stopDuration;
  }

  @override
  Future<void> onResume() async {
    await LocationManager().configure(measure as LocationConfiguration);

    // start the location data stream from the LocationManager
    Stream<LocationSample> locationStream = LocationManager()
        .onLocationChanged
        .map((loc) => LocationSample(
            GeoLocation(loc.latitude!, loc.longitude!), DateTime.now()));

    // feed the location data stream to the MobilityFeatures singleton
    // which in turn produce [MobilityContext]s
    await MobilityFeatures().startListening(locationStream);

    super.onResume();
  }

  @override
  Future<void> onPause() async {
    await MobilityFeatures().stopListening();
    super.onPause();
  }

  /// The stream of mobility features as they are generated.
  @override
  Stream<Datum> get stream => MobilityFeatures()
      .contextStream
      .map((context) => MobilityDatum.fromMobilityContext(context));
}
