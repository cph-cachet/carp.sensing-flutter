part of health_package;

class HealthProbe extends StreamProbe {
  StreamController<HealthDatum> _ctrl = StreamController.broadcast();

  Stream<HealthDatum> get stream => _ctrl.stream;

  @override
  HealthSamplingConfiguration get samplingConfiguration =>
      super.samplingConfiguration as HealthSamplingConfiguration;

  HealthProbe() : super();

  void onInitialize() {
    // Request access to the health data type before starting sampling
    _healthFactory.requestAuthorization([samplingConfiguration.healthDataType]);
  }

  Future onResume() async {
    super.onResume();

    debug('Collecting health data - configuration : $samplingConfiguration');

    DateTime start = samplingConfiguration.lastTime ??
        DateTime.now().subtract(samplingConfiguration.past);
    DateTime end = DateTime.now();
    HealthDataType? healthDataType = samplingConfiguration.healthDataType;
    List<HealthDataPoint> data = [];

    debug(
        'Collecting health data - type: $healthDataType, start: ${start.toUtc()}, end: ${end.toUtc()}');
    try {
      data = await _healthFactory
          .getHealthDataFromTypes(start, end, [healthDataType]);
      debug(
          'Retrieved ${data.length} health data points of type. $healthDataType');

      // convert [HealthDataPoint] to Datums and add them to the stream.
      data.forEach((data) => _ctrl.add(HealthDatum.fromHealthDataPoint(data)));
    } catch (exception) {
      _ctrl.addError(exception);
    }
  }
}
