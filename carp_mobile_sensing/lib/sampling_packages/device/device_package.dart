part of device;

class DeviceSamplingPackage extends SmartphoneSamplingPackage {
  static const String DEVICE = 'dk.cachet.carp.device';
  static const String MEMORY = 'dk.cachet.carp.memory';
  static const String BATTERY = 'dk.cachet.carp.battery';
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
