part of carp_context_package;

/// Collects mobility features using the [MobilityFeatures] API.
class MobilityProbe extends StreamProbe {
  @override
  bool onInitialize() {
    MobilitySamplingConfiguration conf =
        samplingConfiguration as MobilitySamplingConfiguration;

    MobilityFeatures().stopRadius = conf.stopRadius;
    MobilityFeatures().placeRadius = conf.placeRadius;
    MobilityFeatures().stopDuration = conf.stopDuration;

    return true;
  }

  @override
  Future<bool> onResume() async {
    // start the location data stream from the LocationManager
    Stream<LocationSample> locationStream = LocationManager()
        .onLocationChanged
        .map((loc) => LocationSample(
            GeoLocation(loc.latitude!, loc.longitude!), DateTime.now()));

    // feed the location data stream to the MobilityFeatures singleton
    // which in turn produce [MobilityContext]s
    await MobilityFeatures().startListening(locationStream);

    return super.onResume();
  }

  @override
  Future<bool> onPause() async {
    await MobilityFeatures().stopListening();
    return super.onPause();
  }

  /// The stream of mobility features as they are generated.
  @override
  Stream<Datum> get stream => MobilityFeatures()
      .contextStream
      .map((context) => MobilityDatum.fromMobilityContext(context));
}
