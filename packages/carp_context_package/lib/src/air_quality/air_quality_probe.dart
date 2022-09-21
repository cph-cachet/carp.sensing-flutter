part of carp_context_package;

/// Collects local air quality information using the [AirQuality] plugin.
class AirQualityProbe extends DatumProbe {
  @override
  AirQualityServiceManager get deviceManager =>
      super.deviceManager as AirQualityServiceManager;

  @override
  bool onInitialize() {
    LocationManager().configure().then((_) => super.onInitialize());
    return true;
  }

  /// Returns the [AirQualityDatum] based on the location of the phone.
  // ignore: annotate_overrides
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
    warning(
        '$runtimeType - no service available. Did you remember to add the AirQualityService to the study protocol?');
    return ErrorDatum('$runtimeType - no service available.');
  }
}
