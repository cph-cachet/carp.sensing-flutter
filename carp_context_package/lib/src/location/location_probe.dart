/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of context;

LocationManager locationManager = LocationManager.instance;

/// Collects location information from the underlying OS's location API.
/// Is a [DatumProbe] that collects a [LocationDatum] once when used.
///
/// Note that in order for location tracking to work with this probe, the
/// phone must be online on the internet, since online Google APIs are used.
class LocationProbe extends DatumProbe {
  Future<Datum> getDatum() async => locationManager
      .getCurrentLocation()
      .then((dto) => LocationDatum.fromLocationDto(dto));
}

/// Collects geolocation information from the underlying OS's location API.
/// Is a [StreamProbe] that generates a [LocationDatum] every time location is changed.
/// Takes a [LocationMeasure] as configuration.
///
/// Note that in order for location tracking to work with this probe, the
/// phone must be online on the internet, since Google APIs are used.
class GeoLocationProbe extends StreamProbe {
  LocationSettings locationSettings;

  Future<void> onInitialize(Measure measure) async {
    assert(measure is LocationMeasure);
    super.onInitialize(measure);

    locationManager.distanceFilter = (measure as LocationMeasure).distance;
    locationManager.interval =
        (measure as LocationMeasure).frequency.inSeconds;
    locationManager.notificationTitle = 'CARP Location Probe';
    locationManager.notificationMsg = 'CARP is tracking your location';

    await locationManager.start();
  }

  Stream<LocationDatum> get stream {
    return locationManager.dtoStream
        .map((dto) => LocationDatum.fromLocationDto(dto));
  }
}
