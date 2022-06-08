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
        return (Platform.isAndroid) ? LightProbe() : null;
      default:
        return null;
    }
  }

  void onRegister() {}

  List<Permission> get permissions => [];

  SamplingSchema get samplingSchema => SamplingSchema()
    ..addConfiguration(
        PERIODIC_ACCELEROMETER,
        PeriodicSamplingConfiguration(
          interval: const Duration(seconds: 5),
          duration: const Duration(seconds: 1),
        ))
    ..addConfiguration(
        PERIODIC_GYROSCOPE,
        PeriodicSamplingConfiguration(
          interval: const Duration(seconds: 5),
          duration: const Duration(seconds: 1),
        ))
    ..addConfiguration(
        LIGHT,
        PeriodicSamplingConfiguration(
          interval: const Duration(minutes: 5),
          duration: const Duration(seconds: 10),
        ));
}
