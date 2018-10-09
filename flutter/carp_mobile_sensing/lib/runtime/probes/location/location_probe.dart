/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
import 'dart:async';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:carp_mobile_sensing/domain/datum/location_datum.dart';
import 'package:location/location.dart';

/**
 * A [LocationProbe] is able to get location information.
 * It is a [ListeningProbe] that generates a [LocationDatum] everytime location is changed.
 */
class LocationProbe extends StreamSubscriptionListeningProbe {
  Location _location;

  LocationProbe(LocationMeasure measure) : super(measure);

  @override
  void initialize() {
    super.initialize();
    _location = new Location();
  }

  @override
  Future start() async {
    super.start();

    // starting the subscription to the location service - triggered every time the location changes.
    try {
      subscription =
          _location.onLocationChanged().listen(onData, onError: onError, onDone: onDone, cancelOnError: true);
    } catch (error) {
      onError(error);
    }
  }

  void onData(dynamic event) async {
    assert(event is Map<String, double>);
    Map<String, double> location = event;

    LocationDatum ld = new LocationDatum();
    ld.latitude = location["latitude"];
    ld.longitude = location["longitude"];
    ld.accuracy = location["accuracy"];
    ld.altitude = location["altitude"];
    ld.speed = location["speed"];
    ld.speedAccuracy = location["speed_accuracy"];

    this.notifyAllListeners(ld);
  }
}
