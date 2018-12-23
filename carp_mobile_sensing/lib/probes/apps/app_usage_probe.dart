part of apps;

/// A probe collecting app usage information about installed apps on the device
class AppUsageProbe extends PollingProbe {
  AppUsage appUsage;
  int frequency, duration;

  Stream<Datum> get stream => null;

  AppUsageProbe(PeriodicMeasure measure) : super(measure);

  @override
  void initialize() {
    frequency = (measure as PeriodicMeasure).frequency;
    duration = (measure as PeriodicMeasure).duration;
    super.initialize();
  }

  @override
  Future start() async {
    super.start();
    Duration _pause = new Duration(milliseconds: frequency);
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
    appUsage = null;
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
    appUsage = new AppUsage();
    DateTime end = DateTime.now();
    DateTime start = DateTime.fromMillisecondsSinceEpoch(end.millisecondsSinceEpoch - duration);

    Map<dynamic, dynamic> usage = await appUsage.getUsage(start, end);

    return AppUsageDatum(measure: measure)..usage = Map<String, double>.from(usage);
  }
}
