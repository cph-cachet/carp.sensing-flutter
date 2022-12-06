part of device;

class DeviceSamplingPackage extends SmartphoneSamplingPackage {
  /// Measure type for collection of basic device information like device name,
  /// model, manufacturer, operating system, and hardware profile.
  ///  * One-time measure.
  ///  * Uses the [Smartphone] primary device for data collection.
  ///  * No sampling configuration needed.
  static const String DEVICE_INFORMATION =
      '${CarpDataTypes.CARP_NAMESPACE}.device';

  /// Measure type for collection of free physical and virtual memory.
  ///  * Interval-based measure.
  ///  * Uses the [Smartphone] primary device for data collection.
  ///  * Use [IntervalSamplingConfiguration] for configuration.
  static const String FREE_MEMORY = '${CarpDataTypes.CARP_NAMESPACE}.memory';

  /// Measure type for collection of battery level and charging status.
  ///  * Event-based measure.
  ///  * Uses the [Smartphone] primary device for data collection.
  ///  * No sampling configuration needed.
  static const String BATTERY_STATE = '${CarpDataTypes.CARP_NAMESPACE}.state';

  /// Measure type for collection of screen events (on/off/unlocked).
  ///  * Event-based measure.
  ///  * Uses the [Smartphone] primary device for data collection.
  ///  * No sampling configuration needed.
  static const String SCREEN_EVENT = '${CarpDataTypes.CARP_NAMESPACE}.screen';

  @override
  List<DataTypeMetaData> get dataTypes => [
        DataTypeMetaData(
          type: DEVICE_INFORMATION,
          displayName: "Device Information",
          timeType: DataTimeType.POINT,
        ),
        DataTypeMetaData(
          type: FREE_MEMORY,
          displayName: "Free Memory",
          timeType: DataTimeType.POINT,
        ),
        DataTypeMetaData(
          type: BATTERY_STATE,
          displayName: "Battery State",
          timeType: DataTimeType.POINT,
        ),
        DataTypeMetaData(
          type: SCREEN_EVENT,
          displayName: "Screen Events",
          timeType: DataTimeType.POINT,
        ),
      ];

  @override
  Probe? create(String type) {
    switch (type) {
      case DEVICE_INFORMATION:
        return DeviceProbe();
      case FREE_MEMORY:
        return MemoryProbe();
      case BATTERY_STATE:
        return BatteryProbe();
      case SCREEN_EVENT:
        return (Platform.isAndroid) ? ScreenProbe() : null;
      default:
        return null;
    }
  }

  @override
  void onRegister() {
    FromJsonFactory().register(DeviceInformation());
    FromJsonFactory().register(BatteryState());
    FromJsonFactory().register(FreeMemory());
    FromJsonFactory().register(ScreenEvent());
  }

  @override
  List<Permission> get permissions => [];

  /// Default samplings schema for:
  ///  * [FREE_MEMORY] - once pr. minute.
  @override
  SamplingSchema get samplingSchema => SamplingSchema()
    ..addConfiguration(FREE_MEMORY,
        IntervalSamplingConfiguration(interval: const Duration(minutes: 1)));
}
