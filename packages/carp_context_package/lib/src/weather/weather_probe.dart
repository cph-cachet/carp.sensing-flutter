part of context;

/// Collects local weather information using the [WeatherFactory] API.
class WeatherProbe extends DatumProbe {
  late WeatherFactory _wf;

  void onInitialize(Measure measure) {
    super.onInitialize(measure);
    WeatherMeasure wm = measure as WeatherMeasure;
    _wf = WeatherFactory(wm.apiKey);
  }

  Future<void> onResume() async {
    await LocationManager().configure();
    super.onResume();
  }

  /// Returns the [WeatherDatum] for this location.
  Future<Datum> getDatum() async {
    try {
      var loc = await LocationManager().getLastKnownLocation();

      Weather w = await _wf.currentWeatherByLocation(
        loc.latitude!,
        loc.longitude!,
      );

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
        ..temperature = w.temperature!.celsius
        ..tempMin = w.tempMin!.celsius
        ..tempMax = w.tempMax!.celsius;
    } catch (err) {
      return ErrorDatum('WeatherProbe Exception: $err');
    }
  }
}
