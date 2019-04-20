part of context;

/// Listen on location movements and reports a [GeofenceDatum] to the [stream]
/// when a geofence event happens. This probe can handle multiple [GeofenceMeasure]s.
class GeofenceProbe extends StreamProbe {
  List<Geofence> fences = List<Geofence>();
  StreamController<GeofenceDatum> geoFenceStreamController = StreamController<GeofenceDatum>.broadcast();

  void onInitialize(Measure measure) {
    assert(measure is GeofenceMeasure);
    super.onInitialize(measure);
    // add this measure to a list of geofences.
    // TODO - I'm not sure this works.... will onInitialize ever be called more than once pr. probe?
    // TODO - how can you removed it again?
    fences.add(Geofence(measure));
    // listen in on the location probe
    location.Location().onLocationChanged().map((event) => Location.fromMap(event)).listen(_onLocation);
  }

  // when a location is changed, check if this created a new [GeofenceDatum] event.
  // if so -- add it to the main stream.
  void _onLocation(Location location) {
    fences.forEach((fence) {
      GeofenceDatum datum = fence.moved(location);
      if (datum != null) geoFenceStreamController.add(datum);
    });
  }

  Stream<GeofenceDatum> get stream => geoFenceStreamController.stream;
}

enum GeofenceState { UNKNOWN, ENTER, EXIT, DWELL }

class Geofence {
  GeofenceMeasure measure;
  GeofenceState state = GeofenceState.UNKNOWN;

  Geofence(this.measure);

  GeofenceDatum moved(Location location) {
    // figure out if a new event has happened based on the new location
    return GeofenceDatum(type: state.toString(), name: measure.name);
  }
}
