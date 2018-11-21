part of apps;

class AppUsageProbe extends PollingProbe {
  AppUsage _appUsage;
  int _frequency, _duration;

  /// Initialize an [AppUsageProbe] taking a [SensorMeasure] as configuration.
  AppUsageProbe(AppUsageMeasure _measure)
      : assert(_measure != null),
        super(_measure);

  @override
  void initialize() {
    _frequency = (measure as AppUsageMeasure).frequency;
    _duration = (measure as AppUsageMeasure).duration;
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
    _appUsage = null;
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
    _appUsage = new AppUsage();
    DateTime end = DateTime.now();
    DateTime start = DateTime.fromMillisecondsSinceEpoch(
        end.millisecondsSinceEpoch - _duration);

    print('Start date: $start');
    print('End date: $end');
    Map<dynamic, dynamic> usage = await _appUsage.getUsage(start, end);

    AppUsageDatum datum = new AppUsageDatum();
    datum.usage = Map<String, double>.from(usage);

    print(usage);
    return datum;
  }
}
