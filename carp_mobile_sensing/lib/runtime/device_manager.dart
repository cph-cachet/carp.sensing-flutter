/*
 * Copyright 2021-2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of runtime;

// TODO - should be/extend an [Executor] and handle the triggered task associated with this device.... and its probes....

/// A [DeviceManager] handles a hardware device or online service on runtime.
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

  /// Change the runtime status of this device.
  set status(DeviceStatus newStatus) {
    debug('$runtimeType - setting device status: $status');
    _status = newStatus;
    _eventController.add(newStatus);
  }

  /// Has this device manager been initialized?
  bool get isInitialized => status.index >= DeviceStatus.initialized.index;

  /// Has this device manager been connected?
  bool get isConnected => status == DeviceStatus.connected;

  /// Initialize the device manager by specifying its device [descriptor].
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

    return _success;
  }

  /// Callback on [disconnect].
  ///
  /// Is often overriden in sub-classes. Note, however, that it must not be
  /// doing a lot of work on startup.
  Future<bool> onDisconnect();
}

/// A [DeviceManager] for an online service.
abstract class OnlineServiceManager extends DeviceManager {}

/// A [DeviceManager] for a hardware device.
abstract class HardwareDeviceManager extends DeviceManager {
  /// The runtime battery level of this device.
  int? get batteryLevel;
}

/// A device manager for a smartphone.
class SmartphoneDeviceManager extends HardwareDeviceManager {
  int? _batteryLevel = 0;

  @override
  String get id => DeviceInfo().deviceID!;

  @override
  void onInitialize(DeviceDescriptor descriptor) {
    // listen to the battery
    BatteryProbe()
      ..data.listen((dataPoint) =>
          _batteryLevel = (dataPoint.data as BatteryDatum).batteryLevel)
      ..initialize(Measure(type: DeviceSamplingPackage.BATTERY))
      ..resume();

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

abstract class BTLEDeviceManager extends HardwareDeviceManager {
  /// The Bluetooth address of this BTLE device in the form
  /// `00:04:79:00:0F:4D`.
  String get btleAddress;
}

/// Different status for a [DeviceManager].
enum DeviceStatus {
  /// The state of the device is unknown.
  unknown,

  /// The device is in an errorous state.
  error,

  /// The device has been initialized.
  initialized,

  /// The device is paired with this phone.
  /// Mainly used for a [BTLEDeviceManager].
  paired,

  /// The device is connected and ready to be used.
  connected,

  /// The device is disconnected.
  disconnected,
}
