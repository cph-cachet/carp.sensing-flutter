/*
 * Copyright 2018-2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_context_package;

/// Collects location information from the underlying OS's location API.
/// Is a [MeasurementProbe] that collects one [Location] at a time.
class CurrentLocationProbe extends MeasurementProbe {
  @override
  LocationServiceManager get deviceManager =>
      super.deviceManager as LocationServiceManager;

  @override
  Future<Measurement> getMeasurement() async {
    try {
      final location = await deviceManager.manager.getLocation();
      return Measurement.fromData(location);
    } catch (error) {
      warning('$runtimeType - Error location - $error');
      return Measurement.fromData(
          Error(message: '$runtimeType Exception: $error'));
    }
  }
}

/// Collects location information from the underlying OS's location API.
/// Is a [StreamProbe] that generates a [Location] data point every time
/// location is changed.
class LocationProbe extends StreamProbe {
  @override
  LocationServiceManager get deviceManager =>
      super.deviceManager as LocationServiceManager;

  @override
  Stream<Measurement> get stream => deviceManager.manager.onLocationChanged
      .map((location) => Measurement.fromData(location));
}
