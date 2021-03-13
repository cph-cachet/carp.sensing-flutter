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

  List<Permission> get permissions => [];

  SamplingSchema get common => SamplingSchema()
    ..type = SamplingSchemaType.common
    ..name = 'Common (default) device sampling schema'
    ..powerAware = true
    ..addMeasures([
      CAMSMeasure(
        type: DEVICE,
        name: 'Basic Device Info',
      ),
      PeriodicMeasure(
          type: MEMORY,
          name: 'Memory Usage',
          frequency: const Duration(minutes: 1)),
      CAMSMeasure(
        type: BATTERY,
        name: 'Battery',
      ),
      CAMSMeasure(
        type: SCREEN,
        name: 'Screen Activity (lock/on/off)',
      ),
    ]);

  SamplingSchema get light {
    SamplingSchema light = common
      ..type = SamplingSchemaType.light
      ..name = 'Light sensor sampling';
    (light.measures[DataType.fromString(MEMORY)] as CAMSMeasure).enabled =
        false;
    return light;
  }

  SamplingSchema get minimum => light..type = SamplingSchemaType.minimum;

  SamplingSchema get normal => common..type = SamplingSchemaType.normal;

  SamplingSchema get debug => common
    ..type = SamplingSchemaType.debug
    ..powerAware = false
    ..name = 'Debug device sampling';
}
