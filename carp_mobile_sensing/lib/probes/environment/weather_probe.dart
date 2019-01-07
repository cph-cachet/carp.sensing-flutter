part of environment;

/// Collects the weather on a regular basis using the [WeatherStation] API.
class WeatherProbe extends PeriodicDatumProbe {
  WeatherStation weather;
  String apiKey;

  WeatherProbe({String name}) : super(name: name);

  @override
  void initialize(Measure measure) {
    assert(measure is WeatherMeasure, 'A WeatherProbe must be intialized with a WeatherMeasure');
    super.initialize(measure);
    apiKey = (measure as WeatherMeasure).apiKey;
  }

  @override
  Future<Datum> getDatum() async {
    Weather w = await weather.currentWeather();
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
  }
}
