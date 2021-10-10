// /*
//  * Copyright 2018-2020 Copenhagen Center for Health Technology (CACHET) at the
//  * Technical University of Denmark (DTU).
//  * Use of this source code is governed by a MIT-style license that can be
//  * found in the LICENSE file.
//  */

// part of context;

// // The [LocationManager] runs as a background service.

// /// Get the last known position.
// /// If not known, tries to get it from the [Geolocator].
// Future<Position> getLastKnownPosition() async =>
//     await Geolocator.getLastKnownPosition() ??
//     await Geolocator.getCurrentPosition();

// void _configureLocationManager(LocationMeasure measure) {
//   LocationManager().distanceFilter = measure.distance;
//   LocationManager().interval = measure.frequency.inSeconds;
//   LocationManager().notificationTitle =
//       measure.notificationTitle ?? 'CARP Location Service';
//   LocationManager().notificationMsg = measure.notificationMsg ??
//       'The location service is running in the background';
//   LocationManager().notificationBigMsg = measure.notificationBigMsg ??
//       'Background location is on to keep the app up-to-date with your location. '
//           'This is required for main features to work properly when the app is not running.';
// }

// /// Collects location information from the underlying OS's location API.
// /// Is a [DatumProbe] that collects a [LocationDatum] once when
// /// the [getDatum] method is called.
// /// Takes a [LocationMeasure] as configuration.
// class LocationProbe extends DatumProbe {
//   void onInitialize(Measure measure) {
//     assert(measure is LocationMeasure);
//     super.onInitialize(measure);
//     _configureLocationManager(measure as LocationMeasure);
//     LocationManager().start();
//   }

//   // Future<Datum> getDatum() async => locationManager
//   //     .getCurrentLocation()
//   //     .then((dto) => LocationDatum.fromLocationDto(dto));

//   // using the Geolocator package - seems more stable over long-term sampling
//   Future<Datum> getDatum() async => Geolocator.getCurrentPosition()
//       .then((position) => LocationDatum.fromPosition(position));
// }

// /// Collects geolocation information from the underlying OS's location API.
// /// Is a [StreamProbe] that generates a [LocationDatum] every time location is changed.
// /// Takes a [LocationMeasure] as configuration.
// ///
// /// Note that in order for location tracking to work with this probe, the
// /// phone must be online on the internet, since Google APIs are used.
// class GeoLocationProbe extends StreamProbe {
//   void onInitialize(Measure measure) {
//     assert(measure is LocationMeasure);
//     super.onInitialize(measure);
//     _configureLocationManager(measure as LocationMeasure);
//     LocationManager().start();
//   }

//   Stream<LocationDatum> get stream => LocationManager()
//       .locationStream
//       .map((dto) => LocationDatum.fromLocationDto(dto));
// }
