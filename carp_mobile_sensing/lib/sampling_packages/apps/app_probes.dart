/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of apps;

/// A probe collecting a list of installed applications on this device.
///
/// Note that this probe only works on Android. On iOS, an empty list is returned.
class AppsProbe extends DatumProbe {
  AppsProbe() : super();

  Stream<Datum> get stream => null;

  // check if the DeviceApps plugin is available (only available on Android)
  Future<void> onInitialize(Measure measure) async {
    print('onInitialize in $this');
    super.onInitialize(measure);
    if (!Platform.isAndroid) throw SensingException("Error initializing AppsProbe -- only available on Android.");
  }

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
///
/// Note that this probe only works on Android. On iOS, an exception is thrown and the probe is stopped.
class AppUsageProbe extends DatumProbe {
  AppUsage appUsage = new AppUsage();

  AppUsageProbe() : super();

  Future<void> onInitialize(Measure measure) async {
    super.onInitialize(measure);
    assert(measure is AppUsageMeasure, 'An AppUsageMeasure must be provided to use the AppUsageProbe.');
    // check if AppUsage is available (only available on Android)
    if (!Platform.isAndroid) throw SensingException("Error initializing AppUsageProbe -- only avaiulable on Android.");
    //await appUsage.fetchUsage(DateTime.now().subtract(Duration(days: 1)), DateTime.now());
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
