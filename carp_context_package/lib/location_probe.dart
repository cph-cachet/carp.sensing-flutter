/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of context;

Location _locationService;

/// The general location provider service.
Location get locationService {
  if (_locationService == null) _locationService = Location();
  return _locationService;
}

/// Collects location information from the underlying OS's location API.
/// Is a [PeriodicDatumProbe] that collects a [LocationDatum] on a regular basis
/// as specified in a [LocationMeasure].
///
/// Note that in order for location tracking to work with this probe, the
/// phone must be online on the internet, since online Google APIs are used.
class LocationProbe extends PeriodicDatumProbe {
  Future<void> onInitialize(Measure measure) async {
    assert(measure is LocationMeasure);
    super.onInitialize(measure);
  }

  Future<bool> _setSettings() async => await locationService.changeSettings(
      accuracy: (measure as LocationMeasure).accuracy ?? LocationAccuracy.BALANCED);

  Future<Datum> getDatum() async =>
      locationService.getLocation().then((location) => LocationDatum.fromLocationData(location));
}

/// Collects location information from the underlying OS's location API.
/// Is a [StreamProbe] that generates a [LocationDatum] every time location is changed.
///
/// Note that in order for location tracking to work with this probe, the
/// phone must be online on the internet, since Google APIs are used.
class DeprecatedLocationProbe extends StreamProbe {
  Future<void> onInitialize(Measure measure) async {
    super.onInitialize(measure);
    await _getPermission();
    await _setSettings();
  }

  Stream<LocationDatum> get stream => locationService
      .onLocationChanged()
      .asBroadcastStream()
      .map((location) => LocationDatum.fromLocationData(location));

  Future<bool> _getPermission() async {
    bool permission = false;
    bool enabled = await locationService.serviceEnabled();
    if (enabled) {
      permission = await locationService.hasPermission();
      if (!permission) permission = await locationService.requestPermission();
    }

    return permission;
  }

  Future<bool> _setSettings() async =>
      await locationService.changeSettings(accuracy: LocationAccuracy.BALANCED, interval: 5000);
}
