part of sensors;

class SensorSamplingPackage extends SmartphoneSamplingPackage {
  /// Measure type for continuos collection of accelerometer data (x,y,z).
  /// This includes gravity.
  ///
  /// * Event-based measure.
  /// * Uses the [Smartphone] master device for data collection.
  /// * No sampling configuration needed.
  static const String ACCELEROMETER = 'dk.cachet.carp.accelerometer';

  /// Measure type for continuos collection of user accelerometer data (x,y,z).
  /// This excludes gravity.
  ///
  /// * Event-based measure.
  /// * Uses the [Smartphone] master device for data collection.
  /// * No sampling configuration needed.
  static const String USER_ACCELEROMETER = 'dk.cachet.carp.user_accelerometer';

  /// Measure type for continuos collection of gyroscope data (x,y,z).
  ///  * Event-based measure.
  ///  * Uses the [Smartphone] master device for data collection.
  ///  * No sampling configuration needed.
  static const String GYROSCOPE = 'dk.cachet.carp.gyroscope';

  /// Measure type for continuos collection of magnetometer data (x,y,z).
  ///  * Event-based measure.
  ///  * Uses the [Smartphone] master device for data collection.
  ///  * No sampling configuration needed.
  static const String MAGNETOMETER = 'dk.cachet.carp.magnetometer';

  /// Measure type for periodic collection of accelerometer data (x,y,z).
  ///  * Periodic measure.
  ///  * Uses the [Smartphone] master device for data collection.
  ///  * Use [PeriodicSamplingConfiguration] for configuration.
  static const String PERIODIC_ACCELEROMETER =
      'dk.cachet.carp.periodic_accelerometer';

  /// Measure type for periodic collection of user accelerometer data (x,y,z).
  ///  * Periodic measure.
  ///  * Uses the [Smartphone] master device for data collection.
  ///  * Use [PeriodicSamplingConfiguration] for configuration.
  static const String PERIODIC_USER_ACCELEROMETER =
      'dk.cachet.carp.periodic_user_accelerometer';

  /// Measure type for periodic collection of gyroscope data (x,y,z).
  ///  * Periodic measure.
  ///  * Uses the [Smartphone] master device for data collection.
  ///  * Use [PeriodicSamplingConfiguration] for configuration.
  static const String PERIODIC_GYROSCOPE = 'dk.cachet.carp.periodic_gyroscope';

  /// Measure type for periodic collection of magnetometer data (x,y,z).
  ///  * Periodic measure.
  ///  * Uses the [Smartphone] master device for data collection.
  ///  * Use [PeriodicSamplingConfiguration] for configuration.
  static const String PERIODIC_MAGNETOMETER =
      'dk.cachet.carp.periodic_magnetometer';

  /// Measure type for collection of step count from the phones pedometer sensor.
  ///  * Event-based measure.
  ///  * Uses the [Smartphone] master device for data collection.
  ///  * No sampling configuration needed.
  static const String PEDOMETER = 'dk.cachet.carp.pedometer';

  /// Measure type for collection of ambient light from the phones light sensor.
  ///  * Periodic measure.
  ///  * Uses the [Smartphone] master device for data collection.
  ///  * Use [PeriodicSamplingConfiguration] for configuration.
  static const String LIGHT = 'dk.cachet.carp.light';

  @override
  List<String> get dataTypes => [
        ACCELEROMETER,
        USER_ACCELEROMETER,
        GYROSCOPE,
        PERIODIC_ACCELEROMETER,
        PERIODIC_USER_ACCELEROMETER,
        PERIODIC_GYROSCOPE,
        PEDOMETER,
        LIGHT,
      ];

  @override
  Probe? create(String type) {
    switch (type) {
      case ACCELEROMETER:
        return AccelerometerProbe();
      case USER_ACCELEROMETER:
        return UserAccelerometerProbe();
      case GYROSCOPE:
        return GyroscopeProbe();
      case PERIODIC_ACCELEROMETER:
        return BufferingAccelerometerProbe();
      case PERIODIC_USER_ACCELEROMETER:
        return BufferingUserAccelerometerProbe();
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

  /// Default samplings schema for:
  ///  * [PERIODIC_ACCELEROMETER] - every 5 seconds sampling for 1 second
  ///  * [PERIODIC_USER_ACCELEROMETER] - every 5 seconds sampling for 1 second
  ///  * [PERIODIC_GYROSCOPE] - every 5 seconds sampling for 1 second
  ///  * [LIGHT] - every 5 minutes sampling for 10 second
  @override
  SamplingSchema get samplingSchema => SamplingSchema()
    ..addConfiguration(
        PERIODIC_ACCELEROMETER,
        PeriodicSamplingConfiguration(
          interval: const Duration(seconds: 5),
          duration: const Duration(seconds: 1),
        ))
    ..addConfiguration(
        PERIODIC_USER_ACCELEROMETER,
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
