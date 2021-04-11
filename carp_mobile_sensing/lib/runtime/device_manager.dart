/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of runtime;

/// A [DeviceController] handles runtime managenent of all devices used in a
/// study deployment.
class DeviceController {
  static final DeviceController _instance = DeviceController._();
  final Map<String, DeviceManager> _devices = {};

  /// Get the singleton [DeviceController].
  factory DeviceController() => _instance;
  DeviceController._();

  /// Returns true if this controller supports a device of the given [type].
  /// Note that even though a certain [type] of device is supported,
  /// its device mananger is not loaded until [registerDevice] is called.
  bool supportsDevice(String type) {
    for (var package in SamplingPackageRegistry().packages)
      if (package.deviceType == type) return true;

    return false;
  }

  /// Initialize this device controller based on a deployment.
  ///
  /// The [status] lists the devices needed to be deployed on this device.
  /// If a [DeploymentService] is specified, then devices which are
  /// available on this phone is registrered at this deployment service.
  ///
  /// This is a convinient method for synchronizing the devices neeeded for a
  /// deployment and the available devices on this phone.
  Future initialize(
    StudyDeploymentStatus status, [
    DeploymentService deploymentService,
  ]) async {
    // register the needed devices - listed in the deployment status

    for (var deviceStatus in status.devicesStatus) {
      String type = deviceStatus.device.type;
      String deviceRoleName = deviceStatus.device.roleName;

      // if this phone supports the device, register it
      if (supportsDevice(type)) await registerDevice(type);

      // register at the deployment manager (if available)
      if (hasDevice(type) && deploymentService != null) {
        // ask the device manager for a unique id of the device
        String deviceId = DeviceController().devices[type].id;
        DeviceRegistration registration = DeviceRegistration(deviceId);

        // register the device in the deployment service
        await deploymentService.registerDevice(
            status.studyDeploymentId, deviceRoleName, registration);
      }
    }
  }

  /// The list of devices running on this phone as part of a study.
  /// Mapped to the device type.
  /// Note that this model entails that only one device of the same
  /// type can be connected to a this phone's device registry.
  Map<String, DeviceManager> get devices => _devices;

  String devicesToString() =>
      devices.keys.map((key) => key.split('.').last).toString();

  /// Returns true if the registry contain a device manager of the given [type].
  bool hasDevice(String type) => devices.containsKey(type);

  /// Create and add the device of [type] to the registry.
  Future registerDevice(String type) async {
    info('Creating device manager for device type: $type');
    DeviceManager manager = await create(type);
    if (manager == null) {
      warning('No device manager found for device: $type');
    } else {
      await manager.initialize(type);
      _devices[type] = manager;
    }
  }

  // Remove the device of [type] from the registry.
  void unregisterDevice(String type) => _devices.remove(type);

  /// Create the device manager based on the device's [type].
  ///
  /// This methods search the [SamplingPackageRegistry] for a [DeviceManager]
  /// which has a device manager of the specified [type].
  Future<DeviceManager> create(String type) async {
    for (var package in SamplingPackageRegistry().packages)
      if (package.deviceType == type) return package.deviceManager;

    return null;
  }
}

/// A [DeviceManager] handles a device on runtime.
// TODO - should be/extend an [Executor] and handle the triggered task associated with this device.... and its probes....
abstract class DeviceManager {
  String _type;
  final StreamController<DeviceStatus> _eventController =
      StreamController.broadcast();

  /// The stream of status events for this device.
  Stream<DeviceStatus> get deviceEvents => _eventController.stream;

  /// The type of this device
  String get type => _type;

  /// A unique runtime id of this device.
  String get id;

  /// The number of measures collected by this device.
  //int get samplingSize;

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
    BatteryProbe()
      ..data.listen((dataPoint) =>
          _batteryLevel = (dataPoint.data as BatteryDatum).batteryLevel)
      ..initialize(Measure(type: DeviceSamplingPackage.BATTERY))
      ..resume();
    status = DeviceStatus.connected;
  }

  int _batteryLevel = 0;
  int get batteryLevel => _batteryLevel;

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
