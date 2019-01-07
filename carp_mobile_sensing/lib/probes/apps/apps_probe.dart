/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of apps;

/// A polling probe collecting a list of installed applications on this device.
class AppsProbe extends PeriodicDatumProbe {
  AppsProbe() : super();

  Stream<Datum> get stream => null;

  @override
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
