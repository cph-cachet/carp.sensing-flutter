part of carp_context_package;

/// Collects local weather information using the [WeatherFactory] API.
class WeatherProbe extends DatumProbe {
  @override
  WeatherServiceManager get deviceManager =>
      super.deviceManager as WeatherServiceManager;

  @override
  void onInitialize() =>
      LocationManager().configure().then((_) => super.onInitialize());

  /// Returns the [WeatherDatum] for this location.
  @override
  Future<Datum> getDatum() async {
    if (deviceManager.service != null) {
      try {
        final loc = await LocationManager().getLastKnownLocation();
        final Weather weather =
            await deviceManager.service!.currentWeatherByLocation(
          loc.latitude!,
          loc.longitude!,
        );

        return WeatherDatum.fromWeatherData(weather);
      } catch (error) {
        warning('$runtimeType - Error getting weather - $error');
        return ErrorDatum('$runtimeType Exception: $error');
      }
    }
    warning(
        '$runtimeType - no service available. Did you remember to add the WeatherService to the study protocol?');
    return ErrorDatum('$runtimeType - no service available.');
  }
}
