part of device;

class DeviceSamplingPackage extends SmartphoneSamplingPackage {
  static const String DEVICE = 'dk.cachet.carp.device';
  static const String MEMORY = 'dk.cachet.carp.memory';
  static const String BATTERY = 'dk.cachet.carp.battery';
  static const String SCREEN = 'dk.cachet.carp.screen';

  List<String> get dataTypes => [
        DEVICE,
        MEMORY,
        BATTERY,
        SCREEN,
      ];

  Probe? create(String type) {
    switch (type) {
      case DEVICE:
        return DeviceProbe();
      case MEMORY:
        return MemoryProbe();
      case BATTERY:
        return BatteryProbe();
      case SCREEN:
        return ScreenProbe();
      default:
        return null;
    }
  }

  void onRegister() {} // does nothing for this device sampling package

  List<Permission> get permissions => [];

  SamplingSchema get samplingSchema => SamplingSchema()
    ..addConfiguration(
        MEMORY,
        PeriodicSamplingConfiguration(
          interval: const Duration(minutes: 1),
          duration: const Duration(seconds: 1),
        ));
}
