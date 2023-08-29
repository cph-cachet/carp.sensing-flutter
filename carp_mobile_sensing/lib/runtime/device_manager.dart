// ignore_for_file: unnecessary_getters_setters

/*
 * Copyright 2021-2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of runtime;

/// A [DeviceManager] handles a hardware device or online service on runtime.
abstract class DeviceManager<TDeviceConfiguration extends DeviceConfiguration>
    extends DeviceDataCollector<TDeviceConfiguration> {
  final StreamController<DeviceStatus> _eventController =
      StreamController.broadcast();

  bool _hasPermissions = false;
  Timer? _heartbeatTimer;
  DeviceStatus _status = DeviceStatus.unknown;

  /// The set of task control executors that use this device manager.
  final Set<TaskControlExecutor> executors = {};

  /// The list of permissions that this device need in order to run.
  ///
  /// See [Permission](https://pub.dev/documentation/permission_handler/latest/permission_handler/Permission/values-constant.html)
  /// for a list of possible permissions.
  ///
  /// For Android permission in the Manifest.xml file, see
  /// [Manifest.permission]https://developer.android.com/reference/kotlin/android/Manifest.permission)
  List<Permission> get permissions;

  DeviceManager(
    super.type, [
    super.configuration,
  ]);

  @override
  Set<String> get supportedDataTypes => configuration?.supportedDataTypes ?? {};

  /// The name of the [type] without the namespace.
  String get typeName => type.split('.').last;

  /// The runtime status of this device.
  DeviceStatus get status => _status;

  /// Change the runtime status of this device.
  set status(DeviceStatus newStatus) {
    debug('$runtimeType - setting device status: $newStatus');
    _status = newStatus;
    _eventController.add(_status);
  }

  /// The stream of status events for this device.
  Stream<DeviceStatus> get statusEvents => _eventController.stream;

  /// Has this device manager been initialized?
  bool get isInitialized => status.index >= DeviceStatus.initialized.index;

  /// Is this device manager connected to the real device?
  bool get isConnected => status == DeviceStatus.connected;

  /// Initialize the device manager by specifying its [configuration].
  @nonVirtual
  void initialize(TDeviceConfiguration configuration) {
    info(
        'Initializing device manager, type: $typeName, configuration: $configuration');
    super.configuration = configuration;
    onInitialize(configuration);

    status = DeviceStatus.initialized;
  }

  /// Callback on [initialize].
  ///
  /// Is to be overridden in sub-classes. Note, however, that it must not be
  /// doing a lot of work on startup.
  void onInitialize(TDeviceConfiguration configuration);

  /// Start heartbeat monitoring for this device for the deployment controlled
  /// by [controller].
  void startHeartbeatMonitoring(SmartphoneDeploymentController controller) {
    if (!isInitialized) {
      warning(
          '$runtimeType - Trying to start heartbeat monitoring before device is initialized. '
          'Please initialize device first.');
      return;
    }
    debug(
        '$runtimeType - Setting up heartbeat monitoring for device: $configuration');
    _heartbeatTimer = Timer.periodic(
        const Duration(minutes: DeviceController.HEARTBEAT_PERIOD),
        (_) => (isConnected)
            ? controller.executor.addMeasurement(Measurement.fromData(Heartbeat(
                period: DeviceController.HEARTBEAT_PERIOD,
                deviceType: configuration!.type,
                deviceRoleName: configuration!.roleName)))
            : null);
  }

  /// Stop heartbeat monitoring for this device.
  void stopHeartbeatMonitoring() => _heartbeatTimer?.cancel();

  /// Does this device manager have the [permissions] to run?
  @nonVirtual
  Future<bool> hasPermissions() async {
    if (!_hasPermissions) {
      info(
          '$runtimeType - Checking permissions for device of type: $typeName and id: $id');
      _hasPermissions = true;
      for (var permission in permissions) {
        bool isGranted = await permission.isGranted;
        debug('$runtimeType - Permission of $permission: $isGranted');
        _hasPermissions = isGranted && _hasPermissions;
      }
      debug('$runtimeType - Permission of all permissions: $_hasPermissions');
    }
    return _hasPermissions;
  }

  /// Request all [permissions] for this device manager.
  @nonVirtual
  Future<void> requestPermissions() async {
    info(
        '$runtimeType - Requesting permissions for device of type: $typeName and id: $id');
    for (var permission in permissions) {
      await permission.request();
    }

    await onRequestPermissions();
  }

  /// Callback on [requestPermissions].
  ///
  /// Is to be overridden in sub-classes for device-specific permission handling.
  Future<void> onRequestPermissions();

  /// Ask this [DeviceManager] to start connecting to the device.
  ///
  /// Returns the [DeviceStatus] of the device.
  @nonVirtual
  Future<DeviceStatus> connect() async {
    if (!isInitialized) {
      warning('$runtimeType has not been initialized - cannot connect to it.');
      return status;
    }

    if (!(await hasPermissions())) {
      warning('$runtimeType has not the permissions required to connect. '
          'Call requestPermissions() before calling connect.');
      return status;
    }

    info(
        '$runtimeType - Trying to connect to device of type: $typeName and id: $id');

    try {
      status = await onConnect();
    } catch (error) {
      warning(
          '$runtimeType - cannot connect to device $configuration - error: $error');
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
    info('$runtimeType - Restarting sampling...');

    for (var executor in executors) {
      executor.restart();
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
        '$runtimeType - Trying to disconnect to device of type: $typeName and id: $id');
    success = await onDisconnect();
    status = (success) ? DeviceStatus.disconnected : DeviceStatus.error;

    return success;
  }

  /// Callback on [disconnect].
  ///
  /// Is to be overridden in sub-classes.
  Future<bool> onDisconnect();

  @override
  String toString() =>
      '$runtimeType - type: $typeName, id: $id, status: $status';
}

/// A [DeviceManager] for an online service, like a weather service.
abstract class OnlineServiceManager<TDeviceConfiguration extends OnlineService>
    extends DeviceManager<TDeviceConfiguration> {
  OnlineServiceManager(
    super.type, [
    super.configuration,
  ]);
}

/// A [DeviceManager] for a hardware device.
///
/// The main assumption for a hardware device is that it has a battery and
/// this hardware device manager allow for getting the battery level and
/// listen to battery events.
abstract class HardwareDeviceManager<
        TDeviceConfiguration extends DeviceConfiguration>
    extends DeviceManager<TDeviceConfiguration> {
  /// The runtime battery level of this hardware device.
  /// Returns null if unknown.
  int? get batteryLevel;

  /// The stream of battery level events.
  Stream<int> get batteryEvents => const Stream.empty();

  HardwareDeviceManager(
    super.type, [
    super.configuration,
  ]);
}

/// A device manager for a smartphone.
class SmartphoneDeviceManager extends HardwareDeviceManager<Smartphone> {
  int _batteryLevel = 0;
  Battery battery = Battery();
  final Set<String> _supportedDataTypes = {};

  @override
  List<Permission> get permissions => [];

  @override
  Set<String> get supportedDataTypes => _supportedDataTypes;

  @override
  String get id => DeviceInfo().deviceID!;

  @override
  String? get displayName => DeviceInfo().toString();

  SmartphoneDeviceManager([
    Smartphone? configuration,
  ]) : super(Smartphone.DEVICE_TYPE, configuration);

  @override
  void onInitialize(Smartphone configuration) {
    // listen to the battery
    battery.onBatteryStateChanged
        .listen((state) async => _batteryLevel = await battery.batteryLevel);

    // find the supported data types
    for (var package in SamplingPackageRegistry().packages) {
      if (package is SmartphoneSamplingPackage) {
        _supportedDataTypes.addAll(package.dataTypes.map((type) => type.type));
      }
    }
  }

  @override
  int get batteryLevel => _batteryLevel;

  @override
  Stream<int> get batteryEvents =>
      battery.onBatteryStateChanged.map((_) => _batteryLevel);

  @override
  Future<bool> canConnect() async => true; // can always connect to the phone

  @override
  Future<void> onRequestPermissions() async {}

  @override
  Future<DeviceStatus> onConnect() async => DeviceStatus.connected;

  @override
  Future<bool> onDisconnect() async => true;
}

/// A device manager for a connectable Bluetooth device.
abstract class BTLEDeviceManager<
        TDeviceConfiguration extends DeviceConfiguration>
    extends HardwareDeviceManager<TDeviceConfiguration> {
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
  List<Permission> get permissions => [
        // Permission.bluetooth,
        Permission.bluetoothConnect,
        Permission.bluetoothScan,
      ];

  BTLEDeviceManager(
    super.type, [
    super.configuration,
  ]);

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

  /// The device is in an error state.
  error,

  /// The device manager has been initialized, but not yet connected.
  initialized,

  /// The device is paired with this phone.
  /// This status is mainly used in Bluetooth devices (via a [BTLEDeviceManager]).
  paired,

  /// The phone is trying to connect to the device.
  connecting,

  /// The device is connected to the phone and ready to be used.
  connected,

  /// The device is disconnected from the phone.
  disconnected,
}
