part of mobile_sensing_app;

/// A view model for a [DeviceManager].
class DeviceViewModel {
  DeviceManager deviceManager;
  String? get type => deviceManager.type;
  DeviceStatus get status => deviceManager.status;
  Stream<DeviceStatus> get deviceEvents => deviceManager.statusEvents;

  /// The device id.
  String get id => deviceManager.id;

  /// A printer-friendly name for this device.
  String? get name => deviceTypeName[type!];

  /// A printer-friendly description of this device.
  String get description => '${deviceTypeDescription[type!]} - $statusString'
      '${(deviceManager is HardwareDeviceManager && batteryLevel != null) ? '\n$batteryLevel% battery remaining.' : ''}';

  String get statusString => status.name;

  /// The battery level of this device, if known.
  int? get batteryLevel => deviceManager is HardwareDeviceManager
      ? (deviceManager as HardwareDeviceManager).batteryLevel
      : null;

  /// The icon for this type of device.
  Icon? get icon => deviceTypeIcon[type!];

  /// The icon for the runtime state of this device.
  Icon? get stateIcon => deviceStateIcon[status];

  DeviceViewModel(this.deviceManager) : super();

  static Map<String, String> get deviceTypeName => {
        Smartphone.DEVICE_TYPE: 'Phone',
        ESenseDevice.DEVICE_TYPE: 'eSense',
        PolarDevice.DEVICE_TYPE: 'Polar',
        LocationService.DEVICE_TYPE: 'Location',
        AirQualityService.DEVICE_TYPE: 'Air Quality',
        WeatherService.DEVICE_TYPE: 'Weather',
        HealthService.DEVICE_TYPE: 'Health',
        MovisensDevice.DEVICE_TYPE: 'Movisens',
      };

  static Map<String, String> get deviceTypeDescription => {
        Smartphone.DEVICE_TYPE: 'This phone',
        ESenseDevice.DEVICE_TYPE: 'eSense Ear Plug',
        PolarDevice.DEVICE_TYPE: 'Polar HR Monitor',
        LocationService.DEVICE_TYPE: 'Location Service',
        AirQualityService.DEVICE_TYPE: 'World Air Quality Service',
        WeatherService.DEVICE_TYPE: 'Open Weather Service',
        HealthService.DEVICE_TYPE: 'Health data stored on the phone',
        MovisensDevice.DEVICE_TYPE: 'Movisens Sensor',
      };

  static Map<String, Icon> get deviceTypeIcon => {
        Smartphone.DEVICE_TYPE:
            Icon(Icons.phone_android, size: 50, color: CachetColors.GREY_4),
        ESenseDevice.DEVICE_TYPE:
            Icon(Icons.headset, size: 50, color: CachetColors.BLUE),
        PolarDevice.DEVICE_TYPE: Icon(Icons.monitor_heart,
            size: 50, color: CachetColors.LIGHT_GREEN),
        LocationService.DEVICE_TYPE:
            Icon(Icons.location_on, size: 50, color: CachetColors.GREEN),
        AirQualityService.DEVICE_TYPE:
            Icon(Icons.air, size: 50, color: CachetColors.LIGHT_GREEN),
        WeatherService.DEVICE_TYPE:
            Icon(Icons.cloud, size: 50, color: CachetColors.DARK_BLUE),
        HealthService.DEVICE_TYPE:
            Icon(Icons.heart_broken, size: 50, color: CachetColors.RED),
        MovisensDevice.DEVICE_TYPE:
            Icon(Icons.watch, size: 50, color: CachetColors.CYAN),
      };

  static Map<DeviceStatus, Icon> get deviceStateIcon => {
        DeviceStatus.unknown:
            Icon(Icons.error_outline, color: CachetColors.RED),
        DeviceStatus.error: Icon(Icons.error_outline, color: CachetColors.RED),
        DeviceStatus.disconnected:
            Icon(Icons.close, color: CachetColors.YELLOW),
        DeviceStatus.connected: Icon(Icons.check, color: CachetColors.GREEN),
        DeviceStatus.paired:
            Icon(Icons.bluetooth_connected, color: CachetColors.DARK_BLUE),
      };
}
