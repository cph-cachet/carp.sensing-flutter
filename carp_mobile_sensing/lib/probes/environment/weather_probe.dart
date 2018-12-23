part of environment;

class WeatherProbe extends PollingProbe {
  WeatherStation _ws;
  String _apiKey;
  int _frequency;

  Stream<Datum> get stream => null;

  /// Initialize an [WeatherProbe] taking a [PeriodicMeasure] as configuration.
  WeatherProbe(WeatherMeasure measure) : super(measure);

  @override
  void initialize() {
    _apiKey = (measure as WeatherMeasure).apiKey;
    _frequency = (measure as WeatherMeasure).frequency;
    _ws = new WeatherStation(_apiKey);
    super.initialize();
  }

  @override
  Future start() async {
    super.start();
    Duration _pause = new Duration(milliseconds: _frequency);
    Timer.periodic(_pause, (Timer timer) {
      // Create a recurrent timer that wait (pause) and then resume the sampling.
      Timer.periodic(_pause, (Timer timer) {
        this.resume();
        // Create a timer that stops the sampling after the specified duration.
      });
    });
  }

  @override
  void stop() {
    _ws = null;
  }

  @override
  void resume() {}

  @override
  void pause() async {
    Datum _datum = await getDatum();
    if (_datum != null) this.notifyAllListeners(_datum);
  }

  @override
  Future<Datum> getDatum() async {
    Weather w = await _ws.currentWeather();
    WeatherDatum datum = new WeatherDatum(measure: measure)
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

    return datum;
  }
}
