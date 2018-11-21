part of environment;

class WeatherProbe extends PollingProbe {
  Weather _weather;
  String _apiKey;
  int _frequency;

  /// Initialize an [WeatherProbe] taking a [ProbeMeasure] as configuration.
  WeatherProbe(PollingProbeMeasure _measure)
      : assert(_measure != null),
        super(_measure);

  @override
  void initialize() {
    _apiKey = (measure as WeatherMeasure).apiKey;
    _frequency = (measure as WeatherMeasure).frequency;
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
    _weather = null;
  }

  @override
  void resume() {

  }

  @override
  void pause() async {
    Datum _datum = await getDatum();
    if (_datum != null) this.notifyAllListeners(_datum);
  }

  @override
  Future<Datum> getDatum() async {
    WeatherDatum datum = new WeatherDatum();
    _weather = new Weather(_apiKey);
    datum.weather = await _weather.getCurrentWeather();
    return datum;
  }
}
