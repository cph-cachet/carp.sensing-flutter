part of context;

/// Collects local air quality information using the [AirQuality] plugin.
class AirQualityProbe extends DatumProbe {
  AirQuality _waqi;

  Future<void> onInitialize(Measure measure) async {
    super.onInitialize(measure);
    assert((measure as AirQualityMeasure).apiKey != null,
        'In order to use the WAQI API, an API key must be provided.');
    _waqi = AirQuality((measure as AirQualityMeasure).apiKey);
  }

  /// Returns the [AirQualityDatum] based on the location of the phone.
  Future<Datum> getDatum() async =>
      locationManager.getCurrentLocation().then((location) => _waqi
          .feedFromGeoLocation(location.latitude, location.longitude)
          .then((data) => AirQualityDatum.fromAirQualityData(data)));
}
