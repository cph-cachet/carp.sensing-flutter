part of health_package;

/// A probe collecting health data from Apple Health or Google Fit.
///
/// Configuration of this probe is based on a [HealthSamplingConfiguration] which
/// again is a [HistoricSamplingConfiguration].
/// This means that when started, it will try to collect data back to the last
/// time data was collected.
/// Hence, this probe is suited for configuration using some trigger that
/// collects data on a regular basis. This could be a [PeriodicTrigger] or it
/// could be configured as an [AppTask] asking the user to collect the data
/// on a regular basis.
class HealthProbe extends StreamProbe {
  final StreamController<Measurement> _ctrl = StreamController.broadcast();

  @override
  Stream<Measurement> get stream => _ctrl.stream;

  @override
  HealthSamplingConfiguration get samplingConfiguration =>
      super.samplingConfiguration as HealthSamplingConfiguration;

  @override
  bool onInitialize() {
    // Request access to the health data type before starting sampling
    _healthFactory.requestAuthorization(samplingConfiguration.healthDataTypes);
    return true;
  }

  @override
  Future<bool> onStart() async {
    super.onStart();

    debug(
        '$runtimeType - Collecting health data, configuration : $samplingConfiguration');

    DateTime start = samplingConfiguration.lastTime ??
        DateTime.now().subtract(samplingConfiguration.past);
    DateTime end = DateTime.now();
    List<HealthDataType> healthDataTypes =
        samplingConfiguration.healthDataTypes;
    List<HealthDataPoint> data = [];

    debug(
        '$runtimeType - Collecting health data, type: $healthDataTypes, start: ${start.toUtc()}, end: ${end.toUtc()}');
    try {
      data = await _healthFactory.getHealthDataFromTypes(
        start,
        end,
        healthDataTypes,
      );
      debug(
          '$runtimeType - Retrieved ${data.length} health data points of type. $healthDataTypes');

      // Convert HealthDataPoint to measurements and add them to the stream.
      for (var data in data) {
        _ctrl.add(Measurement(
            sensorStartTime: data.dateFrom.microsecondsSinceEpoch,
            sensorEndTime: data.dateTo.microsecondsSinceEpoch,
            data: HealthData.fromHealthDataPoint(data)));
      }
    } catch (exception) {
      _ctrl.addError(exception);
      return false;
    }
    return true;
  }
}
