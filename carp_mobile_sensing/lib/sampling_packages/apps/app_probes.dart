/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of apps;

/// A probe collecting a list of installed applications on this device.
class AppsProbe extends DatumProbe {
  AppsProbe() : super();

  Stream<Datum> get stream => null;

  Future<Datum> getDatum() async {
    List<Application> apps = await DeviceApps.getInstalledApplications();
    return AppsDatum()..installedApps = _getAppNames(apps);
  }

  List<String> _getAppNames(List<Application> apps) {
    List<String> names = new List();
    apps.forEach((a) {
      names.add(a.appName);
    });
    return names;
  }
}

/// A probe collecting app usage information about installed apps on the device
class AppUsageProbe extends DatumProbe {
  AppUsage appUsage = new AppUsage();

  AppUsageProbe() : super();

  void onInitialize(Measure measure) {
    super.onInitialize(measure);
    assert(measure is AppUsageMeasure, 'An AppUsageMeasure must be provided to use the AppUsageProbe.');
  }

  Future<Datum> getDatum() async {
    DateTime end = DateTime.now();
    DateTime start =
        DateTime.fromMillisecondsSinceEpoch(end.millisecondsSinceEpoch - (measure as AppUsageMeasure).duration);

    Map<dynamic, dynamic> usage = await appUsage.fetchUsage(start, end);
    return AppUsageDatum()
      ..start = start.toUtc()
      ..end = end.toUtc()
      ..usage = Map<String, double>.from(usage);
  }
}
