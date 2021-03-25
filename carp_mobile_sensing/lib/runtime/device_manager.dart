/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of runtime;

/// A [DeviceRegistry] handles runtime managenent of all devices used in a
/// study configuration.
class DeviceRegistry {
  static final DeviceRegistry _instance = DeviceRegistry._();
  final Map<String, DeviceManager> _devices = {};

  /// Get the singleton [DeviceRegistry].
  factory DeviceRegistry() => _instance;
  DeviceRegistry._();

  /// The list of devices running on this phone as part of a study.
  /// Mapped to their device type.
  /// Note that this model entails that only one device of the same
  /// type can be connected to a Device Manager (i.e., phone).
  Map<String, DeviceManager> get devices => _devices;

  // Create and add the device of [type] to the registry.
  Future registerDevice(String type) async {
    debug('Creating device manager for device type: $type');
    DeviceManager manager = await create(type);
    if (manager == null) {
      warning('No device manager found for device: $type');
    } else {
      info('Initializing device manager: $manager');
      await manager.initialize(type);
      devices[type] = manager;
    }
  }

  // Remove the device of [type] from the registry.
  void unregisterDevice(String type) => _devices.remove(type);

  /// Create the device manager based on the device's [type].
  ///
  /// This methods search the [SamplingPackageRegistry] for a [DeviceManager]
  /// which has a device manager of the specified [type].
  Future<DeviceManager> create(String type) async {
    DeviceManager _deviceManager;

    SamplingPackageRegistry().packages.forEach((package) {
      // match the role name with the device type in a package
      if (package.deviceType == type) {
        _deviceManager = package.deviceManager;
      }
    });

    return _deviceManager;
  }
}

/// A [DeviceManager] handles a device on runtime.
abstract class DeviceManager {
  String _type;
  final StreamController<DeviceStatus> _eventController =
      StreamController.broadcast();

  /// The stream of status events for this device.
  Stream<DeviceStatus> get deviceEvents => _eventController.stream;

  /// The type of device
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
      ..data.listen(
          (datum) => _batteryLevel = (datum as BatteryDatum).batteryLevel)
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
