part of context;

/// Collects local air quality information using the [AirQuality] API.
class AirQualityProbe extends DatumProbe {
  AirQuality _waqi;

  Future<void> onInitialize(Measure measure) async {
    super.onInitialize(measure);
    assert((measure as AirQualityMeasure).apiKey != null, 'In order to use the WAQI API, an API key must be provided.');
    _waqi = AirQuality((measure as AirQualityMeasure).apiKey);
  }

  /// Returns the [AirQualityDatum] for this location based on the IP address of the phone.
  Future<Datum> getDatum() async {
    try {
      //LocationData loc = await locationService.getLocation();
      //AirQualityData data = await _waqi.feedFromGeoLocation(loc.latitude.toString(), loc.longitude.toString());
      //AirQualityData data = await _waqi.feedFromIP();
      //return AirQualityDatum.fromAirQualityData(data);

      return _waqi.feedFromIP().then((data) => AirQualityDatum.fromAirQualityData(data));
    } catch (err) {
      return ErrorDatum('AirQualityProbe Exception: $err');
    }
  }
}
