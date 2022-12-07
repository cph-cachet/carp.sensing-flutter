/*
 * Copyright 2018-2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_context_package;

/// Collects location information from the underlying OS's location API.
/// Is a [MeasurementProbe] that collects one [Location] at a time.
class LocationProbe extends MeasurementProbe {
  @override
  LocationServiceManager get deviceManager =>
      super.deviceManager as LocationServiceManager;

  @override
  Future<Measurement> getMeasurement() async =>
      deviceManager.manager.getLocation().then(
          (location) => Measurement.fromData(Location.fromLocation(location)));
}

/// Collects geolocation information from the underlying OS's location API.
/// Is a [StreamProbe] that generates a [Location] every time location is
/// changed.
class GeoLocationProbe extends StreamProbe {
  @override
  LocationServiceManager get deviceManager =>
      super.deviceManager as LocationServiceManager;

  @override
  Stream<Measurement> get stream => deviceManager.manager.onLocationChanged
      .map((location) => Measurement.fromData(Location.fromLocation(location)));
}
