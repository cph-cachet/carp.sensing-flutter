part of sensors;

class SensorSamplingPackage extends SmartphoneSamplingPackage {
  /// Ambient light from the phones light sensor.
  static const String AMBIENT_LIGHT_TYPE_NAME =
      '${CarpDataTypes.CARP_NAMESPACE}.ambientlight';

  @override
  List<DataTypeMetaData> get dataTypes => [
        CarpDataTypes.types[CarpDataTypes.ACCELERATION_TYPE_NAME]!,
        CarpDataTypes.types[CarpDataTypes.ROTATION_TYPE_NAME]!,
        CarpDataTypes.types[CarpDataTypes.STEP_COUNT_TYPE_NAME]!,
        DataTypeMetaData(
          type: AMBIENT_LIGHT_TYPE_NAME,
          displayName: "Ambient light",
          timeType: DataTimeType.TIME_SPAN,
        ),
      ];

  @override
  Probe? create(String type) {
    switch (type) {
      case CarpDataTypes.ACCELERATION_TYPE_NAME:
        return AccelerometerProbe();
      case CarpDataTypes.ROTATION_TYPE_NAME:
        return GyroscopeProbe();
      case CarpDataTypes.STEP_COUNT_TYPE_NAME:
        return PedometerProbe();
      case AMBIENT_LIGHT_TYPE_NAME:
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
  ///  * [AMBIENT_LIGHT_TYPE_NAME] - every 5 minutes sampling for 10 second
  @override
  SamplingSchema get samplingSchema => SamplingSchema()
    ..addConfiguration(
        AMBIENT_LIGHT_TYPE_NAME,
        PeriodicSamplingConfiguration(
          interval: const Duration(minutes: 5),
          duration: const Duration(seconds: 10),
        ));
}
