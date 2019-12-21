/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of context;

Geolocator _geolocator;

/// The general geo-location provider service.
Geolocator get geolocator {
  if (_geolocator == null) _geolocator = Geolocator();
  return _geolocator;
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

  Future<Datum> getDatum() async =>
      geolocator.getCurrentPosition().then((position) => LocationDatum.fromPositionData(position));
}

/// Collects geolocation information from the underlying OS's location API.
/// Is a [StreamProbe] that generates a [LocationDatum] every time location is changed.
///
/// Note that in order for location tracking to work with this probe, the
/// phone must be online on the internet, since Google APIs are used.
class GeoLocationProbe extends StreamProbe {
  LocationOptions locationOptions;

  Future<void> onInitialize(Measure measure) async {
    assert(measure is LocationMeasure);
    super.onInitialize(measure);

    locationOptions = LocationOptions(
      accuracy: (measure as LocationMeasure).locationAccuracy,
      timeInterval: (measure as LocationMeasure).frequency,
      distanceFilter: (measure as LocationMeasure).distance,
    );
  }

  Stream<LocationDatum> get stream => geolocator
      .getPositionStream(locationOptions)
      .asBroadcastStream()
      .map((position) => LocationDatum.fromPositionData(position));
}
