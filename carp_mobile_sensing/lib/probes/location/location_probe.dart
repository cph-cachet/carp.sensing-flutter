/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of location;

/// Collects location information from the underlying OS's location API.
/// Is a [ListeningProbe] that generates a [LocationDatum] every time location is changed.
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
      subscription = _location.onLocationChanged().listen(onData,
          onError: onError, onDone: onDone, cancelOnError: true);
    } catch (error) {
      onError(error);
    }
  }

  void onData(dynamic event) async {
    assert(event is Map<String, double>);
    this.notifyAllListeners(LocationDatum.fromMap(event));
  }
}
