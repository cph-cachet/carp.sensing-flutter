part of mobile_sensing_app;

class DevicesModel {
  List<DeviceModel> _devices = [];
  List<DeviceModel> get devices => _devices;
}

class DeviceModel {
  DeviceManager deviceManager;
  String get type => deviceManager.descriptor.deviceType;
  DeviceStatus get state => deviceManager.status;
  Stream<DeviceStatus> get deviceEvents => deviceManager.deviceEvents;

  ///A printer-friendly name for this device.
  String get name => deviceManager.descriptor.name;

  ///A printer-friendly description of this device.
  String get description => deviceTypeDescription[type];

  /// The battery level of this device.
  int get batteryLevel => deviceManager.batteryLevel;

  /// The icon for this type of device.
  Icon get icon => deviceTypeIcon[type];

  /// The icon for the runtime state of this device.
  Icon get stateIcon => deviceStateIcon[state];

  DeviceModel(this.deviceManager)
      : assert(deviceManager != null,
            'A DeviceModel must be initialized with a real Device.'),
        super();

  static Map<String, String> get deviceTypeDescription => {
        SmartphoneSamplingPackage.DEVICE_TYPE_SMARTPHONE: 'This phone',
      };

  static Map<String, Icon> get deviceTypeIcon => {
        SmartphoneSamplingPackage.DEVICE_TYPE_SMARTPHONE:
            Icon(Icons.phone_android, size: 50, color: CACHET.GREY_4),
      };

  static Map<DeviceStatus, Icon> get deviceStateIcon => {
        DeviceStatus.unknown: Icon(Icons.error_outline, color: CACHET.RED),
        DeviceStatus.error: Icon(Icons.error_outline, color: CACHET.RED),
        DeviceStatus.disconnected: Icon(Icons.close, color: CACHET.YELLOW),
        DeviceStatus.connected: Icon(Icons.check, color: CACHET.GREEN),
        DeviceStatus.sampling: Icon(Icons.save_alt, color: CACHET.ORANGE),
      };
}
