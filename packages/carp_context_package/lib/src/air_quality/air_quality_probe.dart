part of context;

/// Collects local air quality information using the [AirQuality] plugin.
class AirQualityProbe extends DatumProbe {
  late AirQuality _waqi;

  void onInitialize(Measure measure) {
    super.onInitialize(measure);
    _waqi = AirQuality((measure as AirQualityMeasure).apiKey);
  }

  Future<void> onResume() async {
    await LocationManager().configure();
    super.onResume();
  }

  /// Returns the [AirQualityDatum] based on the location of the phone.
  Future<Datum> getDatum() async {
    try {
      final loc = await LocationManager().getLastKnownLocation();
      final airQuality =
          await _waqi.feedFromGeoLocation(loc.latitude!, loc.longitude!);

      return AirQualityDatum.fromAirQualityData(airQuality);
    } catch (err) {
      warning('$runtimeType - Error getting air quality - $err');
      return ErrorDatum('AirQuality Probe Exception: $err');
    }
  }
}
