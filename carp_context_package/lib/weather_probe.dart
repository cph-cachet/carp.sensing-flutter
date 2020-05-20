part of context;

/// Collects local weather information using the [WeatherStation] API.
class WeatherProbe extends DatumProbe {
  WeatherStation _weather;

  Future<void> onInitialize(Measure measure) async {
    super.onInitialize(measure);
    assert(
        (measure as WeatherMeasure).apiKey != null, 'In order to use the Weather API, and API key must be provided.');
    _weather = WeatherStation((measure as WeatherMeasure).apiKey);
  }

  /// Returns the [WeatherDatum] for this location.
  Future<Datum> getDatum() async {
    try {
      Position here = await geolocator.getCurrentPosition();

      Weather w = await _weather.currentWeather(here.latitude, here.longitude);

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
      else
        return ErrorDatum('WeatherStation plugin retuned null: ${_weather.toString()}');
    } catch (err) {
      return ErrorDatum('WeatherProbe Exception: $err');
    }
  }
}
