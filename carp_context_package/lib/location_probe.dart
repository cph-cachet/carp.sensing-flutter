/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of context;

/// The general location provider service.
location.Location _locationService = location.Location();

/// Collects location information from the underlying OS's location API.
/// Is a [StreamProbe] that generates a [LocationDatum] every time location is changed.
///
/// Note that in order for location tracking to work with this probe, the
/// phone must be online on the internet, since Google APIs are used.
class LocationProbe extends StreamProbe {
  void onInitialize(Measure measure) async {
    super.onInitialize(measure);
    await _getPermission();
  }

  Stream<LocationDatum> get stream => _locationService
      .onLocationChanged()
      .asBroadcastStream()
      .map((location) => LocationDatum.fromLocationData(location));

  Future<bool> _getPermission() async {
    bool permission = false;
    bool enabled = await _locationService.serviceEnabled();
    if (enabled) {
      permission = await _locationService.hasPermission();
      if (!permission) permission = await _locationService.requestPermission();
    }

    return permission;
  }
}
