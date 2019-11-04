part of device;

class DeviceSamplingPackage implements SamplingPackage {
  static const String DEVICE = "device";
  static const String MEMORY = "memory";
  static const String BATTERY = "battery";
  static const String SCREEN = "screen";

  List<String> get dataTypes => [
        DEVICE,
        MEMORY,
        BATTERY,
        SCREEN,
      ];

  Probe create(String type) {
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

  List<PermissionGroup> get permissions => [PermissionGroup.phone];

  SamplingSchema get common => SamplingSchema()
    ..type = SamplingSchemaType.COMMON
    ..name = 'Common (default) device sampling schema'
    ..powerAware = true
    ..measures.addEntries([
      MapEntry(DEVICE, Measure(MeasureType(NameSpace.CARP, DEVICE), name: 'Basic Device Info', enabled: true)),
      MapEntry(
          MEMORY,
          PeriodicMeasure(MeasureType(NameSpace.CARP, MEMORY),
              name: 'Memory Usage', enabled: true, frequency: 60 * 1000)),
      MapEntry(BATTERY, Measure(MeasureType(NameSpace.CARP, BATTERY), name: 'Battery', enabled: true)),
      MapEntry(
          SCREEN, Measure(MeasureType(NameSpace.CARP, SCREEN), name: 'Screen Activity (lock/on/off)', enabled: true)),
    ]);

  SamplingSchema get light => common
    ..type = SamplingSchemaType.LIGHT
    ..name = 'Light sensor sampling'
    ..measures[MEMORY].enabled = false;

  SamplingSchema get minimum => light;

  SamplingSchema get normal => common;

  SamplingSchema get debug => common
    ..type = SamplingSchemaType.DEBUG
    ..name = 'Debug device sampling';
}
