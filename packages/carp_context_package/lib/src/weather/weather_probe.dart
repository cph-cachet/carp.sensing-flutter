part of carp_context_package;

/// Collects local weather information using the [WeatherServiceManager].
class WeatherProbe extends MeasurementProbe {
  @override
  WeatherServiceManager get deviceManager =>
      super.deviceManager as WeatherServiceManager;

  @override
  bool onInitialize() {
    LocationManager().configure().then((_) => super.onInitialize());
    return true;
  }

  /// Returns the [Weather] for this location wrapped as a [Measurement].
  @override
  Future<Measurement> getMeasurement() async {
    if (deviceManager.service != null) {
      try {
        final loc = await LocationManager().getLocation();
        final w = await deviceManager.service!.currentWeatherByLocation(
          loc.latitude,
          loc.longitude,
        );

        return Measurement.fromData(Weather.fromWeatherData(w));
      } catch (error) {
        warning('$runtimeType - Error getting weather - $error');
        return Measurement.fromData(
            Error(message: '$runtimeType Exception: $error'));
      }
    }
    warning(
        '$runtimeType - no service available. Did you remember to add the WeatherService to the study protocol?');
    return Measurement.fromData(
        Error(message: '$runtimeType - no service available.'));
  }
}
