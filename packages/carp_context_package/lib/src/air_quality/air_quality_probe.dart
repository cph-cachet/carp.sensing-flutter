part of context;

/// Collects local air quality information using the [AirQuality] plugin.
class AirQualityProbe extends DatumProbe {
  AirQuality _waqi;

  Future<void> onInitialize(Measure measure) async {
    super.onInitialize(measure);
    assert((measure as AirQualityMeasure).apiKey != null, 'In order to use the WAQI API, an API key must be provided.');
    _waqi = AirQuality((measure as AirQualityMeasure).apiKey);
  }

  /// Returns the [AirQualityDatum] based on the location of the phone.
  Future<Datum> getDatum() async {
    try {
      //LocationDto location = await locationManager.getCurrentLocation();
      //geolocator.Position location = await geolocator.getCurrentPosition();
      location.LocationData loc = await locationProvider.getLocation();

      if (loc != null) {
        AirQualityData q = await _waqi.feedFromGeoLocation(loc.latitude, loc.longitude);

        if (q != null)
          return AirQualityDatum.fromAirQualityData(q);
        else
          return ErrorDatum('AirQuality plugin returned null.');
      } else {
        return ErrorDatum('Could not get current location in AirQualityProbe.');
      }
    } catch (err) {
      return ErrorDatum('AirQuality Probe Exception: $err');
    }
  }
}
