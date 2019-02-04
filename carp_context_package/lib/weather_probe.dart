part of context;

/// Collects the weather on a regular basis using the [WeatherStation] API.
class WeatherProbe extends PeriodicDatumProbe {
  WeatherStation _weather;

  WeatherProbe() : super();

  void onInitialize(Measure measure) {
    super.onInitialize(measure);
    _weather = WeatherStation((measure as WeatherMeasure).apiKey);
  }

  /// Returns the [WeatherDatum] for this location.
  Future<Datum> getDatum() async {
    try {
      Weather w = await _weather.currentWeather();
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
    } catch (err) {
      return ErrorDatum(message: 'WeatherProbe Exception: $err');
    }
  }
}
