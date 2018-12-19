part of environment;

class WeatherProbe extends PollingProbe {
  WeatherStation _ws;
  String _apiKey;
  int _frequency;

  /// Initialize an [WeatherProbe] taking a [PollingProbeMeasure] as configuration.
  WeatherProbe(PollingProbeMeasure _measure)
      : assert(_measure != null),
        super(_measure);

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
    WeatherDatum datum = new WeatherDatum();
    datum.country = w.country;
    datum.areaName = w.areaName;
    datum.weatherMain = w.weatherMain;
    datum.weatherDescription = w.weatherDescription;
    datum.date = w.date;
    datum.sunrise = w.sunrise;
    datum.sunset = w.sunset;
    datum.latitude = w.latitude;
    datum.longitude = w.longitude;
    datum.pressure = w.pressure;
    datum.windSpeed = w.windSpeed;
    datum.windDegree = w.windDegree;
    datum.humidity = w.humidity;
    datum.cloudiness = w.cloudiness;
    datum.rainLastHour = w.rainLastHour;
    datum.rainLast3Hours = w.rainLast3Hours;
    datum.snowLastHour = w.snowLastHour;
    datum.snowLast3Hours = w.snowLast3Hours;
    datum.temperature = w.temperature.celsius;
    datum.tempMin = w.tempMin.celsius;
    datum.tempMax = w.tempMax.celsius;
    return datum;
  }
}
