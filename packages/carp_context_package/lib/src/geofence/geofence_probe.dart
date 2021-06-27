part of context;

/// Listen on location movements and reports a [GeofenceDatum] to the [stream]
/// when a geofence event happens. This probe can handle only one [GeofenceMeasure].
/// If you need multiple geofences, add a [GeofenceMeasure] for each to your [Study]
/// for example using the [Trigger] model.
class GeofenceProbe extends StreamProbe {
  late Geofence fence;
  StreamController<GeofenceDatum> geoFenceStreamController =
      StreamController.broadcast();

  void onInitialize(Measure measure) {
    assert(measure is GeofenceMeasure);
    super.onInitialize(measure);
    fence = Geofence.fromMeasure(measure as GeofenceMeasure);
    // listen in on the location service
    LocationManager()
        .locationStream
        .map((location) => GeoPosition.fromLocationDto(location))
        .listen((location) {
      // when a location event is fired, check if the new location creates a new [GeofenceDatum] event.
      // if so -- add it to the main stream.
      GeofenceDatum? datum = fence.moved(location);
      if (datum != null) geoFenceStreamController.add(datum);
    });
  }

  /// Set up option for geofence location tracking - accuracy
  /// is set to `low` and distance filter is 10 meters.
  double get distanceFilter => 10;

  Stream<GeofenceDatum> get stream => geoFenceStreamController.stream;
}

/// The possible states of a geofence.
enum GeofenceState { inside, outside, unknown }

/// A class representing a circular geofence with a center,
/// a radius (in meters) and a name.
class Geofence {
  /// The last known state of this geofence.
  GeofenceState state = GeofenceState.unknown;

  /// The last time an event was detected in this geofence.
  DateTime lastEvent = DateTime.now();

  /// The center of the geofence as a GPS location.
  GeoPosition center;

  /// The radius of the geofence in meters.
  double radius;

  /// The dwell time of this geofence. If an object is located inside this
  /// geofence for more that [dwell], the [moved] function will return this.
  Duration dwell;

  /// The name of this geofence.
  String? name;

  /// Specify a geofence.
  Geofence({
    required this.center,
    required this.radius,
    required this.dwell,
    this.name,
  }) : super();

  /// Create a [Geofence] based on a [GeofenceMeasure].
  // Geofence.fromMeasure(GeofenceMeasure measure) {
  //   this.center = measure.center;
  //   this.radius = measure.radius;
  //   this.dwell = measure.dwell;
  //   this.name = measure.name;
  // }

  factory Geofence.fromMeasure(GeofenceMeasure measure) => Geofence(
        center: measure.center,
        radius: measure.radius,
        dwell: measure.dwell,
        name: measure.name,
      );

  GeofenceDatum? moved(GeoPosition location) {
    GeofenceDatum? datum;
    if (center.distanceTo(location) < radius) {
      // we're inside the geofence
      switch (state) {
        case GeofenceState.unknown:
        case GeofenceState.outside:
          // if we came from outside the fence, we have now entered
          state = GeofenceState.inside;
          lastEvent = DateTime.now();
          datum = GeofenceDatum(type: GeofenceType.ENTER, name: name);
          break;
        case GeofenceState.inside:
          // if we were already inside, check if dwelling takes place
          if (lastEvent.add(dwell).isBefore(DateTime.now())) {
            // we have been dwelling in this geofence
            state = GeofenceState.inside;
            lastEvent = DateTime.now();
            datum = GeofenceDatum(type: GeofenceType.DWELL, name: name);
          }
          break;
      }
    } else {
      // we're outside the geofence - check if we have left
      if (state != GeofenceState.outside) {
        // we have just left the geofence
        state = GeofenceState.outside;
        lastEvent = DateTime.now();
        datum = GeofenceDatum(type: GeofenceType.EXIT, name: name);
      }
    }

    return datum;
  }

  String toString() =>
      'Geofence - center: $center, radius: $radius, dwell: $dwell, name: $name, state: $state';
}
