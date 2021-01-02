/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of carp_apps_package;

/// A probe collecting a list of installed applications on this device.
///
/// Note that this probe only works on Android. On iOS, an empty list is
/// returned.
class AppsProbe extends DatumProbe {
  AppsProbe() : super();

  Stream<Datum> get stream => null;

  void onInitialize(Measure measure) {
    super.onInitialize(measure);

    // check if the DeviceApps plugin is available (only available on Android)
    if (!Platform.isAndroid)
      throw SensingException(
          "Error initializing AppsProbe -- only available on Android.");
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

/// A probe collecting app usage information on apps that are installed on
/// the device.
///
/// Note that this probe only works on Android. On iOS, an exception is thrown
/// and the probe is stopped.
class AppUsageProbe extends DatumProbe {
  MarkedMeasure markedMeasure;

  AppUsageProbe() : super();

  void onInitialize(Measure measure) {
    super.onInitialize(measure);
    assert(measure is MarkedMeasure,
        'An MarkedMeasure must be provided to use the AppUsageProbe.');
    markedMeasure = (measure as MarkedMeasure);

    // check if AppUsage is available (only available on Android)
    if (!Platform.isAndroid)
      throw SensingException(
          "Error initializing AppUsageProbe -- only available on Android.");
  }

  Future<Datum> getDatum() async {
    // get the last mark - if null, go back as specified in history
    DateTime start = markedMeasure.lastTime ??
        DateTime.now().subtract(markedMeasure.history);
    DateTime end = DateTime.now();

    debug(
        'Collecting app usage - start: ${start.toUtc()}, end: ${end.toUtc()}');
    List<AppUsageInfo> infos = await AppUsage.getAppUsage(start, end);

    Map<String, int> usage = {};
    infos.forEach((e) {
      usage[e.appName] = e.usage.inSeconds;
    });

    // save the time this was collected - issue #150
    markedMeasure.lastTime = DateTime.now();

    return AppUsageDatum()
      ..start = start.toUtc()
      ..end = end.toUtc()
      ..usage = usage;
  }
}
