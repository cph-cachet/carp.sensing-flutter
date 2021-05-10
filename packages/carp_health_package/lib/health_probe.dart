part of health_package;

class HealthProbe extends StreamProbe {
  StreamController<HealthDatum> _ctrl = StreamController.broadcast();

  Stream<HealthDatum> get stream => _ctrl.stream;
  HealthMeasure healthMeasure;

  HealthProbe() : super();

  void onInitialize(Measure measure) {
    super.onInitialize(measure);
    assert(measure is HealthMeasure,
        'A HealthMeasure must be provided to use the HealthProbe.');
    healthMeasure = (measure as HealthMeasure);

    // Request access to the health data type before starting sampling
    _healthFactory.requestAuthorization([healthMeasure.healthDataType]);
  }

  Future onResume() async {
    super.onResume();

    debug('Collecting health data - Measure : $healthMeasure');

    DateTime start = healthMeasure.lastTime ??
        DateTime.now().subtract(healthMeasure.history);
    DateTime end = DateTime.now();
    HealthDataType healthDataType = healthMeasure.healthDataType;
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
