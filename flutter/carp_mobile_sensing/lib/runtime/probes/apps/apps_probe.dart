/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
import 'dart:async';
import 'package:carp_mobile_sensing/domain/datum/apps_datum.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:device_apps/device_apps.dart';

/// A polling probe collecting a list of installed applications on this device.
class AppsProbe extends PollingProbe {
  AppsProbe(PollingProbeMeasure _measure) : super(_measure);

  @override
  Future<Datum> getDatum() async {
    List<Application> apps = await DeviceApps.getInstalledApplications();
    AppsDatum _ad = new AppsDatum();
    _ad.installedApps = _getAppNames(apps);
    return _ad;
  }

  List<String> _getAppNames(List<Application> apps) {
    List<String> names = new List();
    apps.forEach((a) {
      names.add(a.appName);
    });
    return names;
  }
}
