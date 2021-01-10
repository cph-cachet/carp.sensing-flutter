/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of runtime;

/// A [DeviceManager] handles runtime managenent of all devices used in a
/// study configuration.
class DeviceManager {
  /// The list of devices running on this phone as part of a study.
  /// Mapped to their unique id.
  final Map<String, DeviceRegistration> devices = {};
  final Study _study;
  Study get study => _study;

  /// Initialize the device manager by specifying the running [Study].
  DeviceManager(this._study) {
    _study.connectedDevices
        .forEach((device) => devices.add(DeviceRegistration(device)));
  }

  /// Initialize by providing the stream of [Datum] events to handle.
  Future initialize(Stream<Datum> data) {}
}

/// A [DeviceRegistration] holds information on how a [DeviceDescriptor] has
/// been instansiated locally on runtime on the phone.
abstract class DeviceRegistration {
  final StreamController<DeviceStatus> _eventController =
      StreamController.broadcast();

  /// The stream of status events for this device.
  Stream<DeviceStatus> get deviceEvents => _eventController.stream;

  /// A unique runtime id of this device.
  String get id;

  DeviceStatus _status = DeviceStatus.unknown;

  /// The runtime status of this device.
  DeviceStatus get status => _status;

  /// Change the runtime status of this device.
  set status(DeviceStatus newStatus) {
    _status = newStatus;
    _eventController.add(newStatus);
  }

  final DeviceDescriptor _descriptor;

  /// The device description for this device as specified in the
  /// [Study] protocol.
  DeviceDescriptor get descriptor => _descriptor;

  /// The runtime battery level of this device.
  int batteryLevel = 0;

  DeviceRegistration(this._descriptor);
}

class SmartphoneDeviceRegistration extends DeviceRegistration {
  SmartphoneDeviceRegistration(DeviceDescriptor descriptor) : super(descriptor);

  String get id => throw UnimplementedError();
}

/// Different status for a device.
enum DeviceStatus {
  /// The state of the device is unknown.
  unknown,

  /// The device is in an errorous state.
  error,

  /// The device is disconnected.
  disconnected,

  /// The device is connected.
  connected,

  /// The device is sampling measures.
  sampling,
}
