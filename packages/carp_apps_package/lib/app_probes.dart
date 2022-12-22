/*
 * Copyright 2018-2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of carp_apps_package;

/// A probe collecting a list of installed apps on this device.
///
/// Note that this probe only runs on Android.
class AppsProbe extends MeasurementProbe {
  @override
  Future<Measurement> getMeasurement() async {
    List<Application> apps = await DeviceApps.getInstalledApplications();
    return Measurement.fromData(Apps(
        apps.map((application) => App.fromApplication(application)).toList()));
  }
}

/// A probe collecting app usage information on apps that are installed on
/// the device.
///
/// Note that this probe only runs on Android.
class AppUsageProbe extends MeasurementProbe {
  AppUsageProbe() : super();

  @override
  HistoricSamplingConfiguration get samplingConfiguration =>
      super.samplingConfiguration as HistoricSamplingConfiguration;

  @override
  Future<Measurement> getMeasurement() async {
    // get the last mark - if null, go back as specified in history
    DateTime start = samplingConfiguration.lastTime ??
        DateTime.now().subtract(samplingConfiguration.past);
    DateTime end = DateTime.now();

    debug(
        'Collecting app usage - start: ${start.toUtc()}, end: ${end.toUtc()}');
    List<app_usage.AppUsageInfo> infos =
        await app_usage.AppUsage().getAppUsage(start, end);

    Map<String, int> usage = {};
    for (var inf in infos) {
      usage[inf.appName] = inf.usage.inSeconds;
    }

    return Measurement(
        sensorStartTime: start.microsecondsSinceEpoch,
        sensorEndTime: end.microsecondsSinceEpoch,
        data: AppUsage(start.toUtc(), end.toUtc(), usage));
  }
}
