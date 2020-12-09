part of sensors;

class SensorSamplingPackage implements SamplingPackage {
  static const String ACCELEROMETER = 'accelerometer';
  static const String GYROSCOPE = 'gyroscope';
  static const String PERIODIC_ACCELEROMETER = 'periodic_accelerometer';
  static const String PERIODIC_GYROSCOPE = 'periodic_gyroscope';
  static const String PEDOMETER = 'pedometer';
  static const String LIGHT = 'light';

  List<String> get dataTypes => [
        ACCELEROMETER,
        GYROSCOPE,
        PERIODIC_ACCELEROMETER,
        PERIODIC_GYROSCOPE,
        PEDOMETER,
        LIGHT,
      ];

  Probe create(String type) {
    switch (type) {
      case ACCELEROMETER:
        return AccelerometerProbe();
      case GYROSCOPE:
        return GyroscopeProbe();
      case PERIODIC_ACCELEROMETER:
        return BufferingAccelerometerProbe();
      case PERIODIC_GYROSCOPE:
        return BufferingGyroscopeProbe();
      case PEDOMETER:
        return PedometerProbe();
      case LIGHT:
        return LightProbe();
      default:
        return null;
    }
  }

  void onRegister() {} // does nothing for this sensor package

  List<Permission> get permissions => [Permission.sensors];

  SamplingSchema get common => SamplingSchema()
    ..type = SamplingSchemaType.COMMON
    ..name = 'Common (default) sensor sampling schema'
    ..powerAware = true
    ..measures.addEntries([
      MapEntry(
          ACCELEROMETER,
          Measure(
            MeasureType(NameSpace.CARP, ACCELEROMETER),
            name: 'Accelerometer',
            enabled: false,
          )),
      MapEntry(
          GYROSCOPE,
          Measure(
            MeasureType(NameSpace.CARP, GYROSCOPE),
            name: 'Gyroscope',
            enabled: false,
          )),
      MapEntry(
          PERIODIC_ACCELEROMETER,
          PeriodicMeasure(
            MeasureType(NameSpace.CARP, PERIODIC_ACCELEROMETER),
            name: 'Accelerometer',
            enabled: false,
            frequency: const Duration(seconds: 5),
            duration: const Duration(seconds: 1),
          )),
      MapEntry(
          PERIODIC_GYROSCOPE,
          PeriodicMeasure(
            MeasureType(NameSpace.CARP, PERIODIC_GYROSCOPE),
            name: 'Gyroscope',
            enabled: false,
            frequency: const Duration(seconds: 5),
            duration: const Duration(seconds: 1),
          )),
      MapEntry(
          PEDOMETER,
          Measure(MeasureType(NameSpace.CARP, PEDOMETER),
              name: 'Pedometer (Step Count)', enabled: true)),
      MapEntry(
          LIGHT,
          PeriodicMeasure(
            MeasureType(NameSpace.CARP, LIGHT),
            name: 'Ambient Light',
            enabled: true,
            frequency: const Duration(minutes: 1),
            duration: const Duration(seconds: 1),
          )),
    ]);

  SamplingSchema get light => common
    ..type = SamplingSchemaType.LIGHT
    ..name = 'Light sensor sampling'
    ..measures[LIGHT].enabled = false;

  SamplingSchema get minimum => common
    ..type = SamplingSchemaType.LIGHT
    ..name = 'Light sensor sampling'
    ..measures[PEDOMETER].enabled = false;

  SamplingSchema get normal => common;

  SamplingSchema get debug => SamplingSchema()
    ..type = SamplingSchemaType.DEBUG
    ..name = 'Common (default) sensor sampling schema'
    ..powerAware = false
    ..measures.addEntries([
      MapEntry(
          ACCELEROMETER,
          Measure(MeasureType(NameSpace.CARP, ACCELEROMETER),
              name: 'Accelerometer')),
      MapEntry(GYROSCOPE,
          Measure(MeasureType(NameSpace.CARP, GYROSCOPE), name: 'Gyroscope')),
      MapEntry(
          PERIODIC_ACCELEROMETER,
          PeriodicMeasure(
            MeasureType(NameSpace.CARP, PERIODIC_ACCELEROMETER),
            name: 'Accelerometer',
            frequency: const Duration(seconds: 5),
            duration: const Duration(seconds: 1),
          )),
      MapEntry(
          PERIODIC_GYROSCOPE,
          PeriodicMeasure(
            MeasureType(NameSpace.CARP, PERIODIC_GYROSCOPE),
            name: 'Gyroscope',
            frequency: const Duration(seconds: 5),
            duration: const Duration(seconds: 1),
          )),
      MapEntry(
          PEDOMETER,
          Measure(MeasureType(NameSpace.CARP, PEDOMETER),
              name: 'Pedometer (Step Count)')),
      MapEntry(
          LIGHT,
          PeriodicMeasure(
            MeasureType(NameSpace.CARP, LIGHT),
            name: 'Ambient Light',
            frequency: const Duration(seconds: 10),
            duration: const Duration(seconds: 2),
          )),
    ]);
}
