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

  Probe? create(String type) {
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
        type: ACCELEROMETER,
        name: 'Accelerometer',
        description:
            'Collects movement data based on the onboard phone accelerometer sensor.',
        enabled: false,
      ),
      CAMSMeasure(
        type: GYROSCOPE,
        name: 'Gyroscope',
        description:
            'Collects movement data based on the onboard phone gyroscope sensor.',
        enabled: false,
      ),
      PeriodicMeasure(
        type: PERIODIC_ACCELEROMETER,
        name: 'Accelerometer',
        description:
            'Collects movement data based on the onboard phone accelerometer sensor.',
        enabled: false,
        frequency: const Duration(seconds: 5),
        duration: const Duration(seconds: 1),
      ),
      PeriodicMeasure(
        type: PERIODIC_GYROSCOPE,
        name: 'Gyroscope',
        description:
            'Collects movement data based on the onboard phone gyroscope sensor.',
        enabled: false,
        frequency: const Duration(seconds: 5),
        duration: const Duration(seconds: 1),
      ),
      CAMSMeasure(
        type: PEDOMETER,
        name: 'Pedometer (Step Count)',
        description: 'Collects step events from the onboard phone step sensor.',
      ),
      PeriodicMeasure(
        type: LIGHT,
        name: 'Ambient Light',
        description:
            'Collects ambient light from the light sensor on the phone.',
        frequency: const Duration(minutes: 1),
        duration: const Duration(seconds: 1),
      ),
    ]);

  SamplingSchema get light {
    SamplingSchema light = common
      ..type = SamplingSchemaType.light
      ..name = 'Light sensor sampling';
    (light.measures[DataType.fromString(LIGHT) as String] as CAMSMeasure).enabled = false;
    return light;
  }

  SamplingSchema get minimum {
    SamplingSchema minimum = common
      ..type = SamplingSchemaType.light
      ..name = 'Light sensor sampling';
    (minimum.measures[DataType.fromString(PEDOMETER) as String] as CAMSMeasure).enabled =
        false;
    return minimum;
  }

  SamplingSchema get normal => common;
  SamplingSchema get debug => common;
}
