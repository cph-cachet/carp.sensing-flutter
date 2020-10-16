part of sensors;

class SensorSamplingPackage implements SamplingPackage {
  static const String ACCELEROMETER = 'accelerometer';
  static const String GYROSCOPE = 'gyroscope';
  static const String PEDOMETER = 'pedometer';
  static const String LIGHT = 'light';

  List<String> get dataTypes => [
        ACCELEROMETER,
        GYROSCOPE,
        PEDOMETER,
        LIGHT,
      ];

  Probe create(String type) {
    switch (type) {
      case ACCELEROMETER:
        //  return AccelerometerProbe();
        return BufferingAccelerometerProbe();
      case GYROSCOPE:
        //return GyroscopeProbe();
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
          PeriodicMeasure(MeasureType(NameSpace.CARP, ACCELEROMETER),
              name: 'Accelerometer',
              enabled: false,
              frequency: const Duration(milliseconds: 100),
              duration: const Duration(milliseconds: 1))),
      MapEntry(
          GYROSCOPE,
          PeriodicMeasure(MeasureType(NameSpace.CARP, GYROSCOPE),
              name: 'Gyroscope',
              enabled: false,
              frequency: const Duration(milliseconds: 100),
              duration: const Duration(milliseconds: 1))),
      MapEntry(
          PEDOMETER, Measure(MeasureType(NameSpace.CARP, PEDOMETER), name: 'Pedometer (Step Count)', enabled: true)),
      MapEntry(
          LIGHT,
          PeriodicMeasure(MeasureType(NameSpace.CARP, LIGHT),
              name: 'Ambient Light',
              enabled: true,
              frequency: const Duration(minutes: 1),
              duration: const Duration(seconds: 1))),
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
    ..type = SamplingSchemaType.COMMON
    ..name = 'Common (default) sensor sampling schema'
    ..powerAware = false
    ..measures.addEntries([
      MapEntry(
          ACCELEROMETER,
          PeriodicMeasure(MeasureType(NameSpace.CARP, ACCELEROMETER),
              name: 'Accelerometer',
              enabled: true,
              frequency: const Duration(milliseconds: 1000),
              duration: const Duration(milliseconds: 10))),
      MapEntry(
          GYROSCOPE,
          PeriodicMeasure(MeasureType(NameSpace.CARP, GYROSCOPE),
              name: 'Gyroscope',
              enabled: true,
              frequency: const Duration(milliseconds: 1000),
              duration: const Duration(milliseconds: 10))),
      MapEntry(
          PEDOMETER, Measure(MeasureType(NameSpace.CARP, PEDOMETER), name: 'Pedometer (Step Count)', enabled: true)),
      MapEntry(
          LIGHT,
          PeriodicMeasure(MeasureType(NameSpace.CARP, LIGHT),
              name: 'Ambient Light',
              enabled: true,
              frequency: const Duration(seconds: 10),
              duration: const Duration(seconds: 2))),
    ]);
}
