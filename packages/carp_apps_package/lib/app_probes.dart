/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of carp_apps_package;

/// A probe collecting a list of installed applications on this device.
///
/// Note that this probe only works on Android.
/// On iOS, an exception is thrown and the probe is stopped.
class AppsProbe extends DatumProbe {
  AppsProbe() : super();

  @override
  Future<Datum> getDatum() async {
    List<Application> apps = await DeviceApps.getInstalledApplications();
    return AppsDatum()..installedApps = _getAppNames(apps);
  }

  List<String> _getAppNames(List<Application> apps) {
    List<String> names = [];
    for (var app in apps) {
      names.add(app.appName);
    }
    return names;
  }
}

/// A probe collecting app usage information on apps that are installed on
/// the device.
///
/// Note that this probe only works on Android.
/// On iOS, an exception is thrown and the probe is stopped.
class AppUsageProbe extends DatumProbe {
  AppUsageProbe() : super();

  @override
  HistoricSamplingConfiguration get samplingConfiguration =>
      super.samplingConfiguration as HistoricSamplingConfiguration;

  @override
  Future<Datum> getDatum() async {
    // get the last mark - if null, go back as specified in history

    DateTime start = samplingConfiguration.lastTime ??
        DateTime.now().subtract(samplingConfiguration.past);
    DateTime end = DateTime.now();

    debug(
        'Collecting app usage - start: ${start.toUtc()}, end: ${end.toUtc()}');
    List<AppUsageInfo> infos = await AppUsage.getAppUsage(start, end);


    // Create maps for several sets of information
    Map<String, int> usage = {};
    Map<String, DateTime> startRange = {};
    Map<String, DateTime> stopRange = {};
    Map<String, DateTime> lastUseForeground = {};

    // use full package name
    for (AppUsageInfo inf in infos) {
      usage[inf.packageName] = inf.usage.inSeconds;
      startRange[inf.packageName] = inf.startDate;
      stopRange[inf.packageName] = inf.endDate;
      lastUseForeground[inf.packageName] = inf.lastForeground;
    }

    AppUsageDatum toReturn=(AppUsageDatum(start.toUtc(), end.toUtc())..usage = usage);
    toReturn.stopRange=stopRange;
    toReturn.startRange=startRange;
    toReturn.lastUseForeground=lastUseForeground;
    return toReturn;
  }


}
