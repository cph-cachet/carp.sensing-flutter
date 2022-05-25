/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of runtime;

/// A [DeviceController] handles runtime managenent of all devices and services
/// connected to this phone, including the phone itself.
class DeviceController implements DeviceDataCollectorFactory {
  static final DeviceController _instance = DeviceController._();
  final Map<String, DeviceManager> _devices = {};

  /// Get the singleton [DeviceController].
  factory DeviceController() => _instance;
  DeviceController._();

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

  /// A convinient method for creating and registring all devices which are
  /// available in each [SamplingPackage] that has been registred in the
  /// [SamplingPackageRegistry].
  void registerAllAvailableDevices() {
    for (var package in SamplingPackageRegistry().packages) {
      registerDevice(package.deviceType, package.deviceManager);
    }
  }

  @override
  void registerDevice(String deviceType, DeviceDataCollector manager) {
    manager.type = deviceType;
    _devices[deviceType] = manager as DeviceManager;
  }

  @override
  void unregisterDevice(String deviceType) => _devices.remove(deviceType);

  @override
  void initializeDevices(MasterDeviceDeployment masterDeviceDeployment) {
    // first initialize the master device (i.e. this phone)
    initializeDevice(masterDeviceDeployment.deviceDescriptor);
    // and then initialize all the connected devices (if any)
    masterDeviceDeployment.connectedDevices
        .forEach((descriptor) => initializeDevice(descriptor));
  }

  @override
  void initializeDevice(DeviceDescriptor descriptor) {
    if (hasDevice(descriptor.type)) {
      _devices[descriptor.type]?.initialize(descriptor);
    } else {
      warning(
          "A device of type '${descriptor.type}' is not available on this device.");
    }
  }

  /// A string representation of all [devices].
  String devicesToString() =>
      _devices.keys.map((key) => key.split('.').last).toString();

  @override
  String toString() => '$runtimeType [${_devices.length}]';
}
