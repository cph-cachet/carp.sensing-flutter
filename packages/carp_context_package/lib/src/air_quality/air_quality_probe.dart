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
      var loc = await LocationManager().getLastKnownLocation();
      AirQualityData q =
          await _waqi.feedFromGeoLocation(loc.latitude!, loc.longitude!);
      return AirQualityDatum.fromAirQualityData(q);
    } catch (err) {
      return ErrorDatum('AirQuality Probe Exception: $err');
    }
  }
}
