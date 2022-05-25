/*
 * Copyright 2018-2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of context;

/// Collects location information from the underlying OS's location API.
/// Is a [DatumProbe] that collects one [LocationDatum] at a time.
class LocationProbe extends DatumProbe {
  @override
  LocationServiceManager get deviceManager =>
      super.deviceManager as LocationServiceManager;

  @override
  Future<Datum> getDatum() async => deviceManager.manager
      .getLocation()
      .then((location) => LocationDatum.fromLocation(location));
}

/// Collects geolocation information from the underlying OS's location API.
/// Is a [StreamProbe] that generates a [LocationDatum] every time location is changed.
class GeoLocationProbe extends StreamProbe {
  @override
  LocationServiceManager get deviceManager =>
      super.deviceManager as LocationServiceManager;

  @override
  Stream<LocationDatum> get stream => deviceManager.manager.onLocationChanged
      .map((location) => LocationDatum.fromLocation(location));
}
