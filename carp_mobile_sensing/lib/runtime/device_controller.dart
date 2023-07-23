/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of runtime;

/// A [DeviceController] handles runtime management of all devices and services
/// connected to this phone, including the phone itself.
class DeviceController implements DeviceDataCollectorFactory {
  static final DeviceController _instance = DeviceController._();
  final Map<String, DeviceManager> _devices = {};

  /// The period of sending [Heartbeat] measurements, in minutes.
  static const int HEARTBEAT_PERIOD = 5;

  /// Get the singleton [DeviceController].
  factory DeviceController() => _instance;
  DeviceController._();

  @override
  Map<String, DeviceManager> get devices => _devices;

  /// Get the list of connected devices defined in the study deployment.
  List<DeviceManager> get connectedDevices =>
      _devices.values.where((manager) => manager.isInitialized).toList();

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
    // early out if already registered
    if (_devices.containsKey(deviceType)) return _devices[deviceType]!;

    info('$runtimeType - Creating device manager for device type: $deviceType');

    // look for a device manager of this type in the sampling packages
    DeviceManager? manager;
    for (var package in SamplingPackageRegistry().packages) {
      if (package.deviceType == deviceType) manager = package.deviceManager;
    }

    if (manager == null) {
      warning('$runtimeType - No device manager found for device: $deviceType');
    } else {
      registerDevice(deviceType, manager);
    }

    return manager;
  }

  /// A convenient method for creating and registering all devices which are
  /// available in each [SamplingPackage] that has been registered in the
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
  void initializeDevices(PrimaryDeviceDeployment primaryDeviceDeployment) {
    //  first initialize the primary device (i.e. this phone)
    initializeDevice(primaryDeviceDeployment.deviceConfiguration);
    // and then initialize all the connected devices (if any)
    for (var configuration in primaryDeviceDeployment.connectedDevices) {
      initializeDevice(configuration);
    }
  }

  @override
  void initializeDevice(DeviceConfiguration configuration) {
    if (hasDevice(configuration.type)) {
      _devices[configuration.type]?.initialize(configuration);
    } else {
      warning(
          "A device of type '${configuration.type}' is not available on this device. "
          "This may be because this device is not available on this operating system. "
          "Or it may be because the sampling package containing this device has not been registered in the SamplingPackageRegistry.");
    }
  }

  /// Start heartbeat monitoring for all devices, incl. the phone, for the
  /// deployment controlled by [controller].
  void startHeartbeatMonitoring(SmartphoneDeploymentController controller) {
    for (var device in devices.values) {
      device.startHeartbeatMonitoring(controller);
    }
  }

  /// A convenient method for connecting all connectable devices available
  /// in each [SamplingPackage] that has been registered in the
  /// [SamplingPackageRegistry].
  Future<void> connectAllConnectableDevices() async {
    for (var package in SamplingPackageRegistry().packages) {
      if (getDevice(package.deviceType) != null &&
          getDevice(package.deviceType)!.isInitialized) {
        if (await package.deviceManager.canConnect()) {
          await getDevice(package.deviceType)?.connect();
        }
      }
    }
  }

  /// A convenient method for disconnecting all connected devices.
  Future<void> disconnectAllConnectedDevices() async {
    for (var device in connectedDevices) {
      device.disconnect();
    }
  }

  /// A string representation of all [devices].
  String devicesToString() =>
      _devices.keys.map((key) => key.split('.').last).toString();

  @override
  String toString() => '$runtimeType [${_devices.length}]';
}
