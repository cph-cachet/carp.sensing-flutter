part of health_package;

class HealthProbe extends StreamProbe {
  final StreamController<HealthDatum> _ctrl = StreamController.broadcast();

  @override
  Stream<HealthDatum> get stream => _ctrl.stream;

  @override
  HealthSamplingConfiguration get samplingConfiguration =>
      super.samplingConfiguration as HealthSamplingConfiguration;

  @override
  void onInitialize() {
    // Request access to the health data type before starting sampling
    _healthFactory.requestAuthorization(samplingConfiguration.healthDataTypes);
  }

  @override
  Future<void> onResume() async {
    super.onResume();

    debug('Collecting health data - configuration : $samplingConfiguration');

    DateTime start = samplingConfiguration.lastTime ??
        DateTime.now().subtract(samplingConfiguration.past);
    DateTime end = DateTime.now();
    List<HealthDataType> healthDataTypes =
        samplingConfiguration.healthDataTypes;
    List<HealthDataPoint> data = [];

    debug(
        'Collecting health data - type: $healthDataTypes, start: ${start.toUtc()}, end: ${end.toUtc()}');
    try {
      data = await _healthFactory.getHealthDataFromTypes(
        start,
        end,
        healthDataTypes,
      );
      debug(
          'Retrieved ${data.length} health data points of type. $healthDataTypes');

      // convert HealthDataPoint to Datums and add them to the stream
      for (var data in data) {
        _ctrl.add(HealthDatum.fromHealthDataPoint(data));
      }
    } catch (exception) {
      _ctrl.addError(exception);
    }
  }
}
