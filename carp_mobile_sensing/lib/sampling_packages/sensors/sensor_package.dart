part of sensors;

class SensorSamplingPackage extends SmartphoneSamplingPackage {
  /// Rate of change in velocity, including gravity, along perpendicular x, y,
  /// and z axes in the device's coordinate system.
  ///  * Event-based measure.
  ///  * Uses the [Smartphone] device for data collection.
  ///  * No sampling configuration needed.
  static const String ACCELERATION = CarpDataTypes.ACCELERATION_TYPE_NAME;

  /// Rate of change in velocity, excluding gravity, along perpendicular x, y,
  /// and z axes in the device's coordinate system.
  ///  * Event-based measure.
  ///  * Uses the [Smartphone] device for data collection.
  ///  * No sampling configuration needed.
  static const String NON_GRAVITATIONAL_ACCELERATION =
      CarpDataTypes.NON_GRAVITATIONAL_ACCELERATION_TYPE_NAME;

  /// Rotation of the device in x,y,z (typically measured by a gyroscope).
  ///  * Event-based measure.
  ///  * Uses the [Smartphone] device for data collection.
  ///  * No sampling configuration needed.
  static const String ROTATION = CarpDataTypes.ROTATION_TYPE_NAME;

  /// Magnetic field around the device in x,y,z (typically measured by a magnetometer).
  ///  * Event-based measure.
  ///  * Uses the [Smartphone] device for data collection.
  ///  * No sampling configuration needed.
  static const String MAGNETIC_FIELD = CarpDataTypes.MAGNETIC_FIELD_TYPE_NAME;

  /// Ambient light from the phones light sensor.
  ///  * Event-based measure.
  ///  * Uses the [Smartphone] device for data collection.
  ///  * Uses a [PeriodicSamplingConfiguration] for configuration.
  static const String AMBIENT_LIGHT =
      '${CarpDataTypes.CARP_NAMESPACE}.ambientlight';

  /// The number of steps taken in a specified time interval.
  ///  * Event-based measure.
  ///  * Uses the [Smartphone] device for data collection.
  ///  * No sampling configuration needed.
  static const String STEP_COUNT = CarpDataTypes.STEP_COUNT_TYPE_NAME;

  @override
  DataTypeSamplingSchemeMap get samplingSchemes =>
      DataTypeSamplingSchemeMap.from([
        DataTypeSamplingScheme(
            CarpDataTypes().types[CarpDataTypes.ACCELERATION_TYPE_NAME]!),
        DataTypeSamplingScheme(CarpDataTypes()
            .types[CarpDataTypes.NON_GRAVITATIONAL_ACCELERATION_TYPE_NAME]!),
        DataTypeSamplingScheme(
            CarpDataTypes().types[CarpDataTypes.ROTATION_TYPE_NAME]!),
        DataTypeSamplingScheme(
            CarpDataTypes().types[CarpDataTypes.STEP_COUNT_TYPE_NAME]!),
        DataTypeSamplingScheme(
            CarpDataTypes().types[CarpDataTypes.MAGNETIC_FIELD_TYPE_NAME]!),
        DataTypeSamplingScheme(
            DataTypeMetaData(
              type: AMBIENT_LIGHT,
              displayName: "Ambient Light",
              timeType: DataTimeType.TIME_SPAN,
            ),
            PeriodicSamplingConfiguration(
              interval: const Duration(minutes: 5),
              duration: const Duration(seconds: 10),
            )),
      ]);

  @override
  Probe? create(String type) {
    switch (type) {
      case ACCELERATION:
        return AccelerometerProbe();
      case NON_GRAVITATIONAL_ACCELERATION:
        return UserAccelerometerProbe();
      case MAGNETIC_FIELD:
        return MagnetometerProbe();
      case ROTATION:
        return GyroscopeProbe();
      case STEP_COUNT:
        return PedometerProbe();
      case AMBIENT_LIGHT:
        return (Platform.isAndroid) ? LightProbe() : null;
      default:
        return null;
    }
  }

  @override
  void onRegister() {
    FromJsonFactory().register(AmbientLight());
  }

  @override
  List<Permission> get permissions => [];
}
