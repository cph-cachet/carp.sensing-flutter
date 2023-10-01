part of device;

class DeviceSamplingPackage extends SmartphoneSamplingPackage {
  /// Measure type for collection of basic device information like device name,
  /// model, manufacturer, operating system, and hardware profile.
  ///  * One-time measure.
  ///  * Uses the [Smartphone] primary device for data collection.
  ///  * No sampling configuration needed.
  static const String DEVICE_INFORMATION =
      '${CarpDataTypes.CARP_NAMESPACE}.deviceinformation';

  /// Measure type for collection of free physical and virtual memory.
  ///  * Interval-based measure.
  ///  * Uses the [Smartphone] primary device for data collection.
  ///  * Use [IntervalSamplingConfiguration] for configuration.
  static const String FREE_MEMORY =
      '${CarpDataTypes.CARP_NAMESPACE}.freememory';

  /// Measure type for collection of battery level and charging status.
  ///  * Event-based measure.
  ///  * Uses the [Smartphone] primary device for data collection.
  ///  * No sampling configuration needed.
  static const String BATTERY_STATE =
      '${CarpDataTypes.CARP_NAMESPACE}.batterystate';

  /// Measure type for collection of screen events (on/off/unlocked).
  ///  * Event-based measure.
  ///  * Uses the [Smartphone] primary device for data collection.
  ///  * No sampling configuration needed.
  static const String SCREEN_EVENT =
      '${CarpDataTypes.CARP_NAMESPACE}.screenevent';

  /// Measure type for collection of the time zone of the device.
  /// See [List of tz database time zones](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)
  /// for an overview of timezones.
  ///  * One-time measure.
  ///  * Uses the [Smartphone] master device for data collection.
  ///  * No sampling configuration needed.
  static const String TIMEZONE = '${CarpDataTypes.CARP_NAMESPACE}.timezone';

  @override
  DataTypeSamplingSchemeMap get samplingSchemes =>
      DataTypeSamplingSchemeMap.from([
        DataTypeSamplingScheme(DataTypeMetaData(
          type: DEVICE_INFORMATION,
          displayName: "Device Information",
          timeType: DataTimeType.POINT,
        )),
        DataTypeSamplingScheme(
            DataTypeMetaData(
              type: FREE_MEMORY,
              displayName: "Free Memory",
              timeType: DataTimeType.POINT,
            ),
            IntervalSamplingConfiguration(
              interval: const Duration(minutes: 1),
            )),
        DataTypeSamplingScheme(DataTypeMetaData(
          type: BATTERY_STATE,
          displayName: "Battery State",
          timeType: DataTimeType.POINT,
        )),
        DataTypeSamplingScheme(DataTypeMetaData(
          type: SCREEN_EVENT,
          displayName: "Screen Events",
          timeType: DataTimeType.POINT,
        )),
        DataTypeSamplingScheme(DataTypeMetaData(
          type: TIMEZONE,
          displayName: "Device Timezone",
          timeType: DataTimeType.POINT,
        )),
      ]);

  @override
  Probe? create(String type) {
    switch (type) {
      case DEVICE_INFORMATION:
        return DeviceProbe();
      case FREE_MEMORY:
        return MemoryProbe();
      case BATTERY_STATE:
        return BatteryProbe();
      case TIMEZONE:
        return TimezoneProbe();
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
    FromJsonFactory().register(Timezone(''));
  }
}
