part of device;

class DeviceSamplingPackage extends SmartphoneSamplingPackage {
  /// Measure type for collection of basic device information like device name,
  /// model, manufacturer, operating system, and hardware profile.
  ///  * One-time measure.
  ///  * Uses the [Smartphone] master device for data collection.
  ///  * No sampling configuration needed.
  static const String DEVICE_INFORMATION_TYPE_NAME =
      '${CarpDataTypes.CARP_NAMESPACE}.deviceinformation';

  /// Measure type for collection of free physical and virtual memory.
  ///  * Interval-based measure.
  ///  * Uses the [Smartphone] master device for data collection.
  ///  * Use [IntervalSamplingConfiguration] for configuration.
  static const String FREE_MEMORY_TYPE_NAME =
      '${CarpDataTypes.CARP_NAMESPACE}.freememory';

  /// Measure type for collection of battery level and charging status.
  ///  * Event-based measure.
  ///  * Uses the [Smartphone] master device for data collection.
  ///  * No sampling configuration needed.
  static const String BATTERY_STATE_TYPE_NAME =
      '${CarpDataTypes.CARP_NAMESPACE}.batterystate';

  /// Measure type for collection of screen events (on/off/unlocked).
  ///  * Event-based measure.
  ///  * Uses the [Smartphone] master device for data collection.
  ///  * No sampling configuration needed.
  static const String SCREEN_EVENT_TYPE_NAME =
      '${CarpDataTypes.CARP_NAMESPACE}.screenevent';

  @override
  List<String> get dataTypes => [
        DEVICE_INFORMATION_TYPE_NAME,
        FREE_MEMORY_TYPE_NAME,
        BATTERY_STATE_TYPE_NAME,
        SCREEN_EVENT_TYPE_NAME,
      ];

  @override
  Probe? create(String type) {
    switch (type) {
      case DEVICE_INFORMATION_TYPE_NAME:
        return DeviceProbe();
      case FREE_MEMORY_TYPE_NAME:
        return MemoryProbe();
      case BATTERY_STATE_TYPE_NAME:
        return BatteryProbe();
      case SCREEN_EVENT_TYPE_NAME:
        return (Platform.isAndroid) ? ScreenProbe() : null;
      default:
        return null;
    }
  }

  @override
  void onRegister() {} // does nothing for this device sampling package

  @override
  List<Permission> get permissions => [];

  /// Default samplings schema for:
  ///  * [FREE_MEMORY_TYPE_NAME] - once pr. minute.
  @override
  SamplingSchema get samplingSchema => SamplingSchema()
    ..addConfiguration(FREE_MEMORY_TYPE_NAME,
        IntervalSamplingConfiguration(interval: const Duration(minutes: 1)));
}
