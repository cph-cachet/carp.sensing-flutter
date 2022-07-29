part of sensors;

class SensorSamplingPackage extends SmartphoneSamplingPackage {
  /// Measure type for collection of accelorometer data (x,y,z).
  ///
  /// Event-based measure.
  static const String ACCELEROMETER = 'dk.cachet.carp.accelerometer';

  /// Measure type for collection of
  ///
  /// Event-based measure.
  static const String GYROSCOPE = 'dk.cachet.carp.gyroscope';

  /// Measure type for collection of
  ///
  /// Event-based measure.
  static const String PERIODIC_ACCELEROMETER =
      'dk.cachet.carp.periodic_accelerometer';

  /// Measure type for collection of
  ///
  /// Event-based measure.
  static const String PERIODIC_GYROSCOPE = 'dk.cachet.carp.periodic_gyroscope';

  /// Measure type for collection of
  ///
  /// Event-based measure.
  static const String PEDOMETER = 'dk.cachet.carp.pedometer';

  /// Measure type for collection of
  ///
  /// Event-based measure.
  static const String LIGHT = 'dk.cachet.carp.light';

  @override
  List<String> get dataTypes => [
        ACCELEROMETER,
        GYROSCOPE,
        PERIODIC_ACCELEROMETER,
        PERIODIC_GYROSCOPE,
        PEDOMETER,
        LIGHT,
      ];

  @override
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

  @override
  void onRegister() {}

  @override
  List<Permission> get permissions => [];

  @override
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
