/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_core_domain;

/// Describes any type of electronic device, such as a smartphone, wearable
/// device, a sensor, or internet service (e.g. FitBit API) that collects data
/// which can be part of a [StudyProtocol] configuration and which collects measures
/// via probes.
class DeviceDescriptor {
  DeviceDescriptor({
    this.deviceType,
    this.name,
    this.roleName,
    this.isMasterDevice = false,
    this.collectingMeasureTypes,
  }) : super();

  /// The unique device type. For example `phone`.
  String deviceType;

  /// A printer-fiendly name of this device.
  String name;

  /// Is this the master device?
  bool isMasterDevice;

  /// The role name of this device in a specific [StudyProtocol].
  /// For example, 'Patient's phone'
  String roleName;

  /// The list of measures that this device is collecting as part of a
  /// [StudyProtocol].
  List<DataType> collectingMeasureTypes = [];

  String toString() =>
      '$runtimeType - deviceType: $deviceType, name: $name, isMasterDevice: $isMasterDevice, roleName: $roleName';
}

/// A device which aggregates, synchronizes, and optionally uploads incoming
/// data received from one or more connected devices (potentially just itself).
class MasterDeviceDescriptor extends DeviceDescriptor {
  MasterDeviceDescriptor({
    String deviceType,
    String name,
    String roleName,
    List<DataType> collectingMeasureTypes,
  }) : super(
          deviceType: deviceType,
          name: name,
          roleName: roleName,
          isMasterDevice: true,
          collectingMeasureTypes: collectingMeasureTypes,
        );
}

/// An internet-connected phone with built-in sensors.
/// Typically this phone for a [StudyProtocol] running on this phone.
class Smartphone extends MasterDeviceDescriptor {
  /// The type of a smartphone master device.
  static const String SMARTPHONE_DEVICE_TYPE = 'smarthone';

  Smartphone({
    String name,
    String roleName,
    List<DataType> collectingMeasureTypes,
  }) : super(
          deviceType: SMARTPHONE_DEVICE_TYPE,
          name: name,
          roleName: roleName,
          collectingMeasureTypes: collectingMeasureTypes,
        );
}
