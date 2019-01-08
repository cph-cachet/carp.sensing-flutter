part of apps;

/// A probe collecting app usage information about installed apps on the device
class AppUsageProbe extends PeriodicDatumProbe {
  AppUsage appUsage = new AppUsage();

  AppUsageProbe(PeriodicMeasure measure) : super(measure);

  Future<Datum> getDatum() async {
    DateTime end = DateTime.now();
    DateTime start = DateTime.fromMillisecondsSinceEpoch(end.millisecondsSinceEpoch - duration.inMilliseconds);

    Map<dynamic, dynamic> usage = await appUsage.getUsage(start, end);
    return AppUsageDatum()
      ..start = start.toUtc()
      ..end = end.toUtc()
      ..usage = Map<String, double>.from(usage);
  }
}
