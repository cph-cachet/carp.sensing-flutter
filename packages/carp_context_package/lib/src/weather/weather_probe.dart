part of context;

/// Collects local weather information using the [WeatherStation] API.
class WeatherProbe extends DatumProbe {
  WeatherFactory _wf;

  void onInitialize(Measure measure) {
    super.onInitialize(measure);
    WeatherMeasure wm = measure as WeatherMeasure;
    assert(wm.apiKey != null, 'In order to use the Weather API, an API key must be provided.');
    _wf = WeatherFactory(wm.apiKey);
  }

  /// Returns the [WeatherDatum] for this location.
  Future<Datum> getDatum() async {
    try {
      Position loc = await getLastKnownPosition();

      if (loc != null) {
        Weather w = await _wf.currentWeatherByLocation(loc?.latitude, loc?.longitude);

        if (w != null)
          return WeatherDatum()
            ..country = w.country
            ..areaName = w.areaName
            ..weatherMain = w.weatherMain
            ..weatherDescription = w.weatherDescription
            ..date = w.date
            ..sunrise = w.sunrise
            ..sunset = w.sunset
            ..latitude = w.latitude
            ..longitude = w.longitude
            ..pressure = w.pressure
            ..windSpeed = w.windSpeed
            ..windDegree = w.windDegree
            ..humidity = w.humidity
            ..cloudiness = w.cloudiness
            ..rainLastHour = w.rainLastHour
            ..rainLast3Hours = w.rainLast3Hours
            ..snowLastHour = w.snowLastHour
            ..snowLast3Hours = w.snowLast3Hours
            ..temperature = w.temperature.celsius
            ..tempMin = w.tempMin.celsius
            ..tempMax = w.tempMax.celsius;
        else {
          return ErrorDatum('WeatherStation plugin returned null.');
        }
      } else {
        return ErrorDatum('Could not get current location in WeatherProbe.');
      }
    } catch (err) {
      return ErrorDatum('WeatherProbe Exception: $err');
    }
  }
}
