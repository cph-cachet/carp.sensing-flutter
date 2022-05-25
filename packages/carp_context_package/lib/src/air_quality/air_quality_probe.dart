part of context;

/// Collects local air quality information using the [AirQuality] plugin.
class AirQualityProbe extends DatumProbe {
  @override
  AirQualityServiceManager get deviceManager =>
      super.deviceManager as AirQualityServiceManager;

  @override
  void onInitialize() =>
      LocationManager().configure().then((_) => super.onResume());

  /// Returns the [AirQualityDatum] based on the location of the phone.
  Future<Datum> getDatum() async {
    if (deviceManager.service != null) {
      try {
        final loc = await LocationManager().getLastKnownLocation();
        final airQuality = await deviceManager.service!
            .feedFromGeoLocation(loc.latitude!, loc.longitude!);

        return AirQualityDatum.fromAirQualityData(airQuality);
      } catch (err) {
        warning('$runtimeType - Error getting air quality - $err');
        return ErrorDatum('$runtimeType Exception: $err');
      }
    }
    return ErrorDatum('$runtimeType - no service available.');
  }
}
