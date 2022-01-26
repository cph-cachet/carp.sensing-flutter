/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of runtime;

/// A [DeviceController] handles runtime managenent of all devices connected to
/// this phone, including the phone itsel.
class DeviceController implements DeviceDataCollectorFactory {
  static final DeviceController _instance = DeviceController._();
  final Map<String, DeviceManager> _devices = {};

  /// Get the singleton [DeviceController].
  factory DeviceController() => _instance;
  DeviceController._() {
    // always register this phone in the device registry
    // registerDevice(Smartphone.DEVICE_TYPE);
  }

  @override
  Map<String, DeviceManager> get devices => _devices;

  @override
  bool supportsDevice(String type) {
    for (var package in SamplingPackageRegistry().packages) {
      if (package.deviceType == type) return true;
    }
    return false;
  }

  @override
  DeviceManager? getDevice(String deviceType) => _devices[deviceType];

  @override
  bool hasDevice(String deviceType) => _devices.containsKey(deviceType);

  @override
  Future<DeviceManager?> createDevice(String deviceType) async {
    // early out if already registrered
    if (_devices.containsKey(deviceType)) return _devices[deviceType]!;

    info('Creating device manager for device type: $deviceType');

    // look for a device manager of this type in the sampling packages
    DeviceManager? manager;
    for (var package in SamplingPackageRegistry().packages) {
      if (package.deviceType == deviceType) manager = package.deviceManager;
    }

    if (manager == null) {
      warning('No device manager found for device: $deviceType');
    } else {
      registerDevice(deviceType, manager);
    }

    return manager;
  }

  // /// A convinient method for creating and registring all devices which are
  // /// available in each [SamplingPackage] that has been registred in the
  // /// [SamplingPackageRegistry].
  // void registerAllAvailableDevices() {
  //   for (var package in SamplingPackageRegistry().packages) {
  //     registerDevice(package.deviceType, package.deviceManager);
  //   }
  // }

  @override
  void registerDevice(String deviceType, DeviceDataCollector manager) {
    manager.type = deviceType;
    _devices[deviceType] = manager as DeviceManager;
  }

  @override
  void unregisterDevice(String deviceType) => _devices.remove(deviceType);

  @override
  void initializeDevices(MasterDeviceDeployment masterDeviceDeployment) =>
      masterDeviceDeployment.connectedDevices
          .forEach((descriptor) => initializeDevice(descriptor));

  @override
  void initializeDevice(DeviceDescriptor descriptor) =>
      _devices[descriptor.type]?.initialize(descriptor);

  String devicesToString() =>
      _devices.keys.map((key) => key.split('.').last).toString();

  @override
  String toString() => '$runtimeType [${_devices.length}]';
}

// TODO - should be/extend an [Executor] and handle the triggered task associated with this device.... and its probes....

/// A [DeviceManager] handles a device on runtime.
abstract class DeviceManager extends DeviceDataCollector {
  final StreamController<DeviceStatus> _eventController =
      StreamController.broadcast();
  final Set<String> _supportedDataTypes = {};

  DeviceManager([
    String? type,
    DeviceRegistration? deviceRegistration,
    DeviceDescriptor? deviceDescriptor,
  ]) : super(
          type,
          deviceRegistration,
          deviceDescriptor,
        );

  @override
  Set<String> get supportedDataTypes => _supportedDataTypes;

  /// The stream of status events for this device.
  Stream<DeviceStatus> get statusEvents => _eventController.stream;

  DeviceStatus _status = DeviceStatus.unknown;

  /// The runtime status of this device.
  DeviceStatus get status => _status;

  /// Has this device manager been initialized
  bool get isInitialized => status.index >= DeviceStatus.initialized.index;

  /// Change the runtime status of this device.
  set status(DeviceStatus newStatus) {
    _status = newStatus;
    _eventController.add(newStatus);
  }

  /// The runtime battery level of this device.
  int? get batteryLevel;

  /// Initialize the device data collector by specifying its device [descriptor].
  void initialize(DeviceDescriptor descriptor) {
    info('Initializing device manager, type: $type, descriptor.: $descriptor');
    deviceDescriptor = descriptor;
    onInitialize(descriptor);
    status = DeviceStatus.initialized;
  }

  /// Callback on [initialize].
  ///
  /// Is often overriden in sub-classes. Note, however, that it must not be
  /// doing a lot of work on startup.
  void onInitialize(DeviceDescriptor descriptor);

  /// Ask this [DeviceManager] to connect to the device.
  ///
  /// Returns true if successful, false if not.
  Future<bool> connect() async {
    bool _success = false;
    assert(isInitialized,
        '$runtimeType has not been initialized - cannot connect to it.');

    info(
        '$runtimeType - Trying to connect to device of type: $type and id: $id');
    _success = await onConnect();
    status = (_success) ? DeviceStatus.connected : DeviceStatus.error;
    info('$runtimeType - Connection status: $status');

    return _success;
  }

  /// Callback on [connect].
  ///
  /// Is often overriden in sub-classes. Note, however, that it must not be
  /// doing a lot of work on startup.
  Future<bool> onConnect();

  /// Ask this [DeviceManager] to disconnect from the device.
  ///
  /// Returns true if successful, false if not.
  Future<bool> disconnect() async {
    bool _success = false;
    if (status != DeviceStatus.connected) {
      warning(
          '$runtimeType is not connected, so nothing to disconnect from....');
      return true;
    }

    info(
        '$runtimeType - Trying to disconnect to device of type: $type and id: $id');
    _success = await onDisconnect();
    status = (_success) ? DeviceStatus.disconnected : DeviceStatus.error;
    info('Connection status: $status');

    return _success;
  }

  /// Callback on [disconnect].
  ///
  /// Is often overriden in sub-classes. Note, however, that it must not be
  /// doing a lot of work on startup.
  Future<bool> onDisconnect();
}

/// A device manager for a smartphone.
class SmartphoneDeviceManager extends DeviceManager {
  int? _batteryLevel = 0;

  @override
  String get id => DeviceInfo().deviceID!;

  @override
  void onInitialize(DeviceDescriptor descriptor) {
    super.initialize(descriptor);

    // listen to the battery
    BatteryProbe()
      ..data.listen((dataPoint) =>
          _batteryLevel = (dataPoint.data as BatteryDatum).batteryLevel)
      ..initialize(Measure(type: DeviceSamplingPackage.BATTERY))
      ..resume();

    status = DeviceStatus.connected;

    // find the supported datatypes
    for (var package in SamplingPackageRegistry().packages) {
      if (package is SmartphoneSamplingPackage) {
        _supportedDataTypes.addAll(package.dataTypes);
      }
    }
  }

  @override
  int? get batteryLevel => _batteryLevel;

  @override
  bool canConnect() => true; // can always connect to the phone

  @override
  Future<bool> onConnect() async => true; // always connected to the phone

  @override
  Future<bool> onDisconnect() async => true; // always connected to the phone
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

  /// The device has been initialized.
  initialized,

  /// The device is paired with this phone.
  /// Mainly used for [BTLEDeviceManager].
  paired,

  /// The device is connected.
  connected,

  /// The device is sampling measures.
  sampling,

  /// The device is disconnected.
  disconnected,
}
