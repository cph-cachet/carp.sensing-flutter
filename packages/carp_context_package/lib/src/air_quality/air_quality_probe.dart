part of context;

/// Collects local air quality information using the [AirQuality] plugin.
class AirQualityProbe extends DatumProbe {
  late AirQuality _waqi;

  void onInitialize(Measure measure) {
    super.onInitialize(measure);
    _waqi = AirQuality((measure as AirQualityMeasure).apiKey);
  }

  /// Returns the [AirQualityDatum] based on the location of the phone.
  Future<Datum> getDatum() async {
    try {
      Position loc = await getLastKnownPosition();
      AirQualityData q =
          await _waqi.feedFromGeoLocation(loc.latitude, loc.longitude);

      return AirQualityDatum.fromAirQualityData(q);
    } catch (err) {
      return ErrorDatum('AirQuality Probe Exception: $err');
    }
  }
}
