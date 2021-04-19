/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of runtime;

/// A [DeviceController] handles runtime managenent of all devices used in a
/// study deployment.
class DeviceController implements DeviceDataCollectorFactory {
  static final DeviceController _instance = DeviceController._();
  final Map<String, DeviceManager> _devices = {};

  /// Get the singleton [DeviceController].
  factory DeviceController() => _instance;
  DeviceController._();

  @override
  bool supportsDeviceDataCollector(String type) {
    for (var package in SamplingPackageRegistry().packages)
      if (package.deviceType == type) return true;

    return false;
  }

  @override
  DeviceDataCollector getDeviceDataCollector(String deviceType) =>
      _devices[deviceType];

  @override
  bool hasDeviceDataCollector(String deviceType) =>
      _devices.containsKey(deviceType);

  @override
  Future<DeviceManager> createDeviceDataCollector(String deviceType) async {
    info('Creating device manager for device type: $deviceType');

    // early out if already registrered
    if (_devices.containsKey(deviceType)) return _devices[deviceType];

    // look for a device manager of this type in the sampling packages
    DeviceManager manager;
    for (var package in SamplingPackageRegistry().packages)
      if (package.deviceType == deviceType) manager = package.deviceManager;

    if (manager == null) {
      warning('No device manager found for device: $deviceType');
    } else {
      await manager.initialize(deviceType);
      _devices[deviceType] = manager;
    }
    return manager;
  }

  @override
  void unregisterDeviceDataCollector(String deviceType) =>
      _devices.remove(deviceType);

  String devicesToString() =>
      _devices.keys.map((key) => key.split('.').last).toString();
}

/// A [DeviceManager] handles a device on runtime.
// TODO - should be/extend an [Executor] and handle the triggered task associated with this device.... and its probes....
abstract class DeviceManager extends DeviceDataCollector {
  String _type;
  final StreamController<DeviceStatus> _eventController =
      StreamController.broadcast();
  Set<String> _supportedDataTypes = {};

  DeviceManager([DeviceRegistration deviceRegistration])
      : super(deviceRegistration);

  @override
  Set<String> get supportedDataTypes => _supportedDataTypes;

  /// The stream of status events for this device.
  Stream<DeviceStatus> get deviceEvents => _eventController.stream;

  /// The type of this device
  String get type => _type;

  DeviceStatus _status = DeviceStatus.unknown;

  /// The runtime status of this device.
  DeviceStatus get status => _status;

  /// Change the runtime status of this device.
  set status(DeviceStatus newStatus) {
    _status = newStatus;
    _eventController.add(newStatus);
  }

  /// The runtime battery level of this device.
  int get batteryLevel;

  /// Initialize the device manager by specifying its [type].
  Future initialize(String type) async {
    info('Initializing device manager, type: $type');
    _type = type;
  }

  /// Ask this [DeviceManager] to connect to the device.
  Future connect();

  /// Ask this [DeviceManager] to disconnect from the device.
  Future disconnect();
}

class SmartphoneDeviceManager extends DeviceManager {
  String get id => DeviceInfo().deviceID;

  Future initialize(String type) async {
    await super.initialize(type);

    // listen to the battery
    BatteryProbe()
      ..data.listen((dataPoint) =>
          _batteryLevel = (dataPoint.data as BatteryDatum).batteryLevel)
      ..initialize(Measure(type: DeviceSamplingPackage.BATTERY))
      ..resume();

    status = DeviceStatus.connected;

    // find the supported datatypes
    for (var package in SamplingPackageRegistry().packages) {
      if (package is SmartphoneSamplingPackage)
        _supportedDataTypes.addAll(package.dataTypes);
    }
  }

  int _batteryLevel = 0;
  int get batteryLevel => _batteryLevel;

  bool canConnect() => true; // can always connect to the phone
  Future connect() => null; // always connected to the phone
  Future disconnect() => null; // cannot disconnect from the phone
}

abstract class BTLEDeviceManager extends DeviceManager {
  /// The Bluetooth address of this BTLE device in the form
  /// `00:04:79:00:0F:4D`.
  String get btleAddress;
}

/// Different status for a device.
enum DeviceStatus {
  /// The state of the device is unknown.
  unknown,

  /// The device is in an errorous state.
  error,

  /// The device is disconnected.
  disconnected,

  /// The device is paired with this phone.
  /// Mainly used for [BTLEDeviceManager].
  paired,

  /// The device is connected.
  connected,

  /// The device is sampling measures.
  sampling,
}
