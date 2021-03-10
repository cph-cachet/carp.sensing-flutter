part of sensors;

class SensorSamplingPackage extends SmartphoneSamplingPackage {
  static const String ACCELEROMETER = 'dk.cachet.carp.accelerometer';
  static const String GYROSCOPE = 'dk.cachet.carp.gyroscope';
  static const String PERIODIC_ACCELEROMETER =
      'dk.cachet.carp.periodic_accelerometer';
  static const String PERIODIC_GYROSCOPE = 'dk.cachet.carp.periodic_gyroscope';
  static const String PEDOMETER = 'dk.cachet.carp.pedometer';
  static const String LIGHT = 'dk.cachet.carp.light';

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
    ..type = SamplingSchemaType.common
    ..name = 'Common (default) sensor sampling schema'
    ..powerAware = true
    ..addMeasures([
      CAMSMeasure(
        type: DataType.fromString(ACCELEROMETER),
        name: 'Accelerometer',
        enabled: false,
      ),
      CAMSMeasure(
        type: DataType.fromString(GYROSCOPE),
        name: 'Gyroscope',
        enabled: false,
      ),
      PeriodicMeasure(
        type: DataType.fromString(PERIODIC_ACCELEROMETER),
        name: 'Accelerometer',
        enabled: false,
        frequency: const Duration(seconds: 5),
        duration: const Duration(seconds: 1),
      ),
      PeriodicMeasure(
        type: DataType.fromString(PERIODIC_GYROSCOPE),
        name: 'Gyroscope',
        enabled: false,
        frequency: const Duration(seconds: 5),
        duration: const Duration(seconds: 1),
      ),
      CAMSMeasure(
        type: DataType.fromString(PEDOMETER),
        name: 'Pedometer (Step Count)',
      ),
      PeriodicMeasure(
        type: DataType.fromString(LIGHT),
        name: 'Ambient Light',
        frequency: const Duration(minutes: 1),
        duration: const Duration(seconds: 1),
      ),
    ]);

  SamplingSchema get light {
    SamplingSchema light = common
      ..type = SamplingSchemaType.light
      ..name = 'Light sensor sampling';
    (light.measures[DataType.fromString(LIGHT)] as CAMSMeasure).enabled = false;
    return light;
  }

  SamplingSchema get minimum {
    SamplingSchema minimum = common
      ..type = SamplingSchemaType.light
      ..name = 'Light sensor sampling';
    (minimum.measures[DataType.fromString(PEDOMETER)] as CAMSMeasure).enabled =
        false;
    return minimum;
  }

  SamplingSchema get normal => common;

  SamplingSchema get debug => SamplingSchema()
    ..type = SamplingSchemaType.debug
    ..name = 'Debugging sensor sampling schema'
    ..powerAware = false
    ..addMeasures([
      CAMSMeasure(
          type: DataType.fromString(ACCELEROMETER), name: 'Accelerometer'),
      CAMSMeasure(type: DataType(NameSpace.CARP, GYROSCOPE), name: 'Gyroscope'),
      PeriodicMeasure(
        type: DataType.fromString(PERIODIC_ACCELEROMETER),
        name: 'Accelerometer',
        frequency: const Duration(seconds: 5),
        duration: const Duration(seconds: 1),
      ),
      PeriodicMeasure(
        type: DataType.fromString(PERIODIC_GYROSCOPE),
        name: 'Gyroscope',
        frequency: const Duration(seconds: 5),
        duration: const Duration(seconds: 1),
      ),
      CAMSMeasure(
          type: DataType.fromString(PEDOMETER), name: 'Pedometer (Step Count)'),
      PeriodicMeasure(
        type: DataType.fromString(LIGHT),
        name: 'Ambient Light',
        frequency: const Duration(seconds: 10),
        duration: const Duration(seconds: 2),
      ),
    ]);
}
