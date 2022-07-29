part of sensors;

class SensorSamplingPackage extends SmartphoneSamplingPackage {
  /// Measure type for continous collection of accelorometer data (x,y,z).
  ///
  /// Event-based measure.
  /// No sampling configuration needed.
  static const String ACCELEROMETER = 'dk.cachet.carp.accelerometer';

  /// Measure type for continous collection of gyroscope data (x,y,z).
  ///
  /// Event-based measure.
  /// No sampling configuration needed.
  static const String GYROSCOPE = 'dk.cachet.carp.gyroscope';

  /// Measure type for periodic collection of accelorometer data (x,y,z).
  ///
  /// Periodic measure.
  /// Use [PeriodicSamplingConfiguration] for configuration.
  static const String PERIODIC_ACCELEROMETER =
      'dk.cachet.carp.periodic_accelerometer';

  /// Measure type for periodic collection of gyroscope data (x,y,z).
  ///
  /// Periodic measure.
  /// Use [PeriodicSamplingConfiguration] for configuration.
  static const String PERIODIC_GYROSCOPE = 'dk.cachet.carp.periodic_gyroscope';

  /// Measure type for collection of step count from the phones pedometer sensor.
  ///
  /// Event-based measure.
  /// No sampling configuration needed.
  static const String PEDOMETER = 'dk.cachet.carp.pedometer';

  /// Measure type for collection of ambient light from the phones light sensor.
  ///
  /// Periodic measure.
  /// Use [PeriodicSamplingConfiguration] for configuration.
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
