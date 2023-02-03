// ignore_for_file: unnecessary_getters_setters

/*
 * Copyright 2021-2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of runtime;

/// A [DeviceManager] handles a hardware device or online service on runtime.
abstract class DeviceManager<TDeviceRegistration extends DeviceRegistration,
        TDeviceConfiguration extends DeviceConfiguration>
    extends DeviceDataCollector<TDeviceRegistration, TDeviceConfiguration> {
  final StreamController<DeviceStatus> _eventController =
      StreamController.broadcast();
  final Set<String> _supportedDataTypes = {};

  /// The set of executors that use this device manager.
  final Set<Executor> executors = {};

  DeviceManager([
    super.type,
    super.deviceRegistration,
    super.deviceConfiguration,
  ]);

  @override
  Set<String> get supportedDataTypes => _supportedDataTypes;

  /// The stream of status events for this device.
  Stream<DeviceStatus> get statusEvents => _eventController.stream;

  DeviceStatus _status = DeviceStatus.unknown;

  /// The runtime status of this device.
  DeviceStatus get status => _status;

  /// Change the runtime status of this device.
  set status(DeviceStatus newStatus) {
    debug('$runtimeType - setting device status: $newStatus');
    _status = newStatus;
    _eventController.add(_status);
  }

  /// Has this device manager been initialized?
  bool get isInitialized => status.index >= DeviceStatus.initialized.index;

  /// Has this device manager been connected?
  bool get isConnected => status == DeviceStatus.connected;

  /// Initialize the device manager by specifying its device [configuration].
  @nonVirtual
  void initialize(TDeviceConfiguration configuration) {
    info(
        'Initializing device manager, type: $type, configuration: $configuration');
    deviceConfiguration = configuration;
    onInitialize(configuration);
    status = DeviceStatus.initialized;
  }

  /// Callback on [initialize].
  ///
  /// Is to be overridden in sub-classes. Note, however, that it must not be
  /// doing a lot of work on startup.
  void onInitialize(TDeviceConfiguration configuration);

  /// Ask this [DeviceManager] to start connecting to the device.
  ///
  /// Returns the [DeviceStatus] of the device.
  @nonVirtual
  Future<DeviceStatus> connect() async {
    if (!isInitialized) {
      warning('$runtimeType has not been initialized - cannot connect to it.');
      return status;
    }

    info(
        '$runtimeType - Trying to connect to device of type: $type and id: $id');

    try {
      status = await onConnect();
    } catch (error) {
      warning(
          '$runtimeType - cannot connect to device $deviceConfiguration - error: $error');
    }

    return status;
  }

  /// Callback on [connect]. Returns the [DeviceStatus] of the device.
  ///
  /// Is to be overridden in sub-classes.
  Future<DeviceStatus> onConnect();

  /// Restart sampling of the measures using this device.
  ///
  /// This entails that all measures in the study protocol using this device's
  /// type is restarted. This method is useful after the device is connected.
  @nonVirtual
  void restart() {
    info('$runtimeType - restarting sampling...');

    for (var executor in executors) {
      executor.restart();
      if (executor.state == ExecutorState.started) {
        executor.start();
      }
    }
  }

  /// Stop sampling the measures using this device.
  ///
  /// This entails that all measures in the study protocol using this device's
  /// type is stopped.
  @nonVirtual
  void stop() {
    for (var executor in executors) {
      executor.stop();
    }
  }

  /// Ask this [DeviceManager] to disconnect from the device.
  ///
  /// Returns true if successful, false if not.
  @nonVirtual
  Future<bool> disconnect() async {
    bool success = false;
    if (status != DeviceStatus.connected) {
      warning(
          '$runtimeType is not connected, so nothing to disconnect from....');
      return true;
    }

    info(
        '$runtimeType - Trying to disconnect to device of type: $type and id: $id');
    success = await onDisconnect();
    status = (success) ? DeviceStatus.disconnected : DeviceStatus.error;

    return success;
  }

  /// Callback on [disconnect].
  ///
  /// Is to be overriden in sub-classes.
  Future<bool> onDisconnect();
}

/// A [DeviceManager] for an online service, like a weather service.
abstract class OnlineServiceManager<
        TDeviceRegistration extends DeviceRegistration,
        TDeviceConfiguration extends OnlineService>
    extends DeviceManager<TDeviceRegistration, TDeviceConfiguration> {}

/// A [DeviceManager] for a hardware device.
abstract class HardwareDeviceManager<
        TDeviceRegistration extends DeviceRegistration,
        TDeviceConfiguration extends DeviceConfiguration>
    extends DeviceManager<TDeviceRegistration, TDeviceConfiguration> {
  /// The runtime battery level of this hardware device.
  /// Returns null if unknown.
  int? get batteryLevel;
}

/// A device manager for a smartphone.
class SmartphoneDeviceManager
    extends HardwareDeviceManager<DeviceRegistration, Smartphone> {
  int? _batteryLevel = 0;
  Battery battery = Battery();

  @override
  String get id => DeviceInfo().deviceID!;

  @override
  void onInitialize(Smartphone configuration) {
    // listen to the battery
    battery.onBatteryStateChanged
        .listen((state) async => _batteryLevel = await battery.batteryLevel);

    // find the supported data types
    for (var package in SamplingPackageRegistry().packages) {
      if (package is SmartphoneSamplingPackage) {
        _supportedDataTypes.addAll(package.dataTypes.map((e) => e.type));
      }
    }
  }

  @override
  int? get batteryLevel => _batteryLevel;

  @override
  Future<bool> canConnect() async => true; // can always connect to the phone

  @override
  Future<DeviceStatus> onConnect() async => DeviceStatus.connected;

  @override
  Future<bool> onDisconnect() async => true;
}

/// A device manager for a connectable bluetooth device.
abstract class BTLEDeviceManager<TDeviceRegistration extends DeviceRegistration,
        TDeviceConfiguration extends DeviceConfiguration>
    extends HardwareDeviceManager<TDeviceRegistration, TDeviceConfiguration> {
  String _btleAddress = '', _btleName = '';

  /// The Bluetooth address of this device in the form `00:04:79:00:0F:4D`.
  /// Returns empty string if unknown.
  String get btleAddress => _btleAddress;
  set btleAddress(String btleAddress) => _btleAddress = btleAddress;

  /// The Bluetooth name of this device.
  /// Returns empty string if unknown.
  String get btleName => _btleName;
  set btleName(String btleName) => _btleName = btleName;

  @override
  @mustCallSuper
  void onInitialize(TDeviceConfiguration configuration) {
    statusEvents.listen((event) {
      // when this device is (re)connected, restart sampling
      if (event == DeviceStatus.connected) {
        restart();
      }
    });
  }
}

/// Runtime status for a [DeviceManager].
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

  /// The device is trying to connect.
  connecting,

  /// The device is connected and ready to be used.
  connected,

  /// The device is disconnected.
  disconnected,
}
