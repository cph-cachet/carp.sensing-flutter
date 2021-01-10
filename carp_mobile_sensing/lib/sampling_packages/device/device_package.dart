part of device;

class DeviceSamplingPackage implements SamplingPackage {
  static const String DEVICE = 'device';
  static const String MEMORY = 'memory';
  static const String BATTERY = 'battery';
  static const String SCREEN = 'screen';

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

  String get deviceType => DeviceDescriptor.DEVICE_TYPE_SMARTPHONE;

  DeviceRegistration get deviceRegistration;

  void onRegister() {} // does nothing for this device sampling package

  List<Permission> get permissions => [];

  SamplingSchema get common => SamplingSchema()
    ..type = SamplingSchemaType.COMMON
    ..name = 'Common (default) device sampling schema'
    ..powerAware = true
    ..measures.addEntries([
      MapEntry(
          DEVICE,
          Measure(
              type: MeasureType(NameSpace.CARP, DEVICE),
              name: 'Basic Device Info',
              enabled: true)),
      MapEntry(
          MEMORY,
          PeriodicMeasure(
              type: MeasureType(NameSpace.CARP, MEMORY),
              name: 'Memory Usage',
              enabled: true,
              frequency: const Duration(minutes: 1))),
      MapEntry(
          BATTERY,
          Measure(
              type: MeasureType(NameSpace.CARP, BATTERY),
              name: 'Battery',
              enabled: true)),
      MapEntry(
          SCREEN,
          Measure(
              type: MeasureType(NameSpace.CARP, SCREEN),
              name: 'Screen Activity (lock/on/off)',
              enabled: true)),
    ]);

  SamplingSchema get light => common
    ..type = SamplingSchemaType.LIGHT
    ..name = 'Light sensor sampling'
    ..measures[MEMORY].enabled = false;

  SamplingSchema get minimum => light;

  SamplingSchema get normal => common;

  SamplingSchema get debug => common
    ..type = SamplingSchemaType.DEBUG
    ..powerAware = false
    ..name = 'Debug device sampling';
}
