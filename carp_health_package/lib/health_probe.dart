part of health_lib;

class HealthProbe extends StreamProbe {
  StreamController<HealthDatum> _ctrl = StreamController<HealthDatum>.broadcast();

  String type;

  Stream<HealthDatum> get stream => _ctrl.stream;
  List<HealthDataPoint> healthData = List<HealthDataPoint>();

  List<HealthDataType> dataTypes;
  Duration duration;

  HealthProbe(this.type);

  /// Make Health plugin call and fetch data points
  Future<void> _getHealthData(DateTime start, DateTime end) async {
    List<HealthDataPoint> healthData = List<HealthDataPoint>();

    for (HealthDataType type in dataTypes) {
      try {
        List<HealthDataPoint> data = await Health.getHealthDataFromType(start, end, type);
        healthData.addAll(data);
      } catch (exception) {
        _ctrl.addError(exception);
      }
    }

    // convert [HealthDataPoint] to Datums and add them to the stream.
    for (HealthDataPoint h in healthData) _ctrl.add(HealthDatum.fromHealthDataPoint(h));
  }

  Future<void> onResume() async {
    super.onResume();
    _getHealthData(DateTime.now().subtract(duration), DateTime.now());
  }

  Future<void> onInitialize(Measure measure) async {
    super.onInitialize(measure);
    assert(measure is HealthMeasure);
    duration = (measure as HealthMeasure).duration;
    dataTypes = (measure as HealthMeasure).healthDataTypes;

    // try to get permissions to accessing health data
    bool permission = await Health.requestAuthorization();

    print(' >>> $this.onInitialize - permission : $permission');
  }
}

//class HealthProbe extends DatumProbe {
//  List<HealthDataType> dataTypes;
//  Duration duration;
//
//  /// Make Health plugin call and fetch data points
//  Future<Datum> getDatum() async {
//    print(' >>> duration : $duration');
//
//    DateTime end = DateTime.now();
//    DateTime start = end.subtract(duration);
//
//    print('HealthProbe _makeApiCall()');
//    List<HealthDataPoint> healthData = [];
//
//    for (HealthDataType type in dataTypes) {
//      // calls to 'Health.getHealthDataFromType' must be wrapped in a try catch block.
//      try {
//        healthData = await Health.getHealthDataFromType(start, end, type);
//
//        // convert [HealthDataPoint] to Datums and add them to the stream.
//        //HealthDatum.fromHealthDataPointList(healthData);
//      } catch (exception) {
//        print(exception.toString());
//      }
//    }
//    return HealthDatum.fromHealthDataPointList(healthData);
//  }
//
//  @override
//  Future<void> onInitialize(Measure measure) async {
//    print(' >> onInitialize in $this');
//    super.onInitialize(measure);
//    assert(measure is HealthMeasure);
//    duration = (measure as HealthMeasure).duration;
//    dataTypes = (measure as HealthMeasure).healthDataTypes;
//  }
//
//  Future<void> onStart() async {
//    print('HealthProbe onStart()');
//  }
//}
