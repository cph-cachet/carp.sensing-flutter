part of device;

class DeviceSamplingPackage extends SmartphoneSamplingPackage {
  /// Measure type for collection of basic device information like device name,
  /// model, manufacturer, operating system, and hardware profile.
  ///  * One-time measure.
  ///  * Uses the [Smartphone] master device for data collection.
  ///  * No sampling configuration needed.
  static const String DEVICE = 'dk.cachet.carp.device';

  /// Measure type for collection of free physical and virtual memory.
  ///  * Interval-based measure.
  ///  * Uses the [Smartphone] master device for data collection.
  ///  * Use [IntervalSamplingConfiguration] for configuration.
  static const String MEMORY = 'dk.cachet.carp.memory';

  /// Measure type for collection of battery level and charging status.
  ///  * Event-based measure.
  ///  * Uses the [Smartphone] master device for data collection.
  ///  * No sampling configuration needed.
  static const String BATTERY = 'dk.cachet.carp.battery';

  /// Measure type for collection of screen events (on/off/unlocked).
  ///  * Event-based measure.
  ///  * Uses the [Smartphone] master device for data collection.
  ///  * No sampling configuration needed.
  static const String SCREEN = 'dk.cachet.carp.screen';

  @override
  List<String> get dataTypes => [
        DEVICE,
        MEMORY,
        BATTERY,
        SCREEN,
      ];

  @override
  Probe? create(String type) {
    switch (type) {
      case DEVICE:
        return DeviceProbe();
      case MEMORY:
        return MemoryProbe();
      case BATTERY:
        return BatteryProbe();
      case SCREEN:
        return (Platform.isAndroid) ? ScreenProbe() : null;
      default:
        return null;
    }
  }

  @override
  void onRegister() {} // does nothing for this device sampling package

  @override
  List<Permission> get permissions => [];

  @override
  SamplingSchema get samplingSchema => SamplingSchema()
    ..addConfiguration(MEMORY,
        IntervalSamplingConfiguration(interval: const Duration(minutes: 1)));
}
