/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of context;

/// The general location provider service.
location.Location locationService = location.Location();

/// Collects location information from the underlying OS's location API.
/// Is a [StreamProbe] that generates a [LocationDatum] every time location is changed.
///
/// Note that in order for location tracking to work with this probe, the
/// phone must be online on the internet, since Google APIs are used.
class LocationProbe extends StreamProbe {
  Future<bool> getPermission() async {
    bool permission = false;
    bool enabled = await locationService.serviceEnabled();
    print("Location service available: $enabled");
    if (enabled) {
      permission = await locationService.hasPermission();
      if (!permission) permission = await locationService.requestPermission();
    }
    print("Location permission: $permission");

    return permission;
  }

  void onInitialize(Measure measure) async {
    super.onInitialize(measure);
    await getPermission();
  }

  Stream<LocationDatum> get stream => locationService
      .onLocationChanged()
      .asBroadcastStream()
      .map((location) => LocationDatum.fromLocationData(location));
}
