/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_core_client;

/// Collects [Data] for a single device.
abstract class DeviceDataCollector {
  /// The registration for this device.
  DeviceRegistration deviceRegistration;

  /// The set of data types defining which data can be collected on this device.
  Set<String> get supportedDataTypes;

  /// Get a unique id for this device.
  String get id;

  /// The type of this device
  String get type;

  /// Determines whether a connection can be made at this point in time to the device.
  bool canConnect();

  DeviceDataCollector([this.deviceRegistration]);
}

/// Supports creating and holding a registry of [DeviceDataCollector] instances
/// for devices.
abstract class DeviceDataCollectorFactory {
  /// Returns the [DeviceDataCollector] of the given [deviceType].
  DeviceDataCollector getDeviceDataCollector(String deviceType);

  /// Returns true if this factory supports a device of the given [deviceType].
  /// Note that even though a certain type of device is supported, its device
  /// [DeviceDataCollector] is not loaded until [createDeviceDataCollector] is called.
  bool supportsDeviceDataCollector(String deviceType);

  /// Returns true if this factory contain a device manager of the given [deviceType].
  bool hasDeviceDataCollector(String deviceType);

  /// Create and register a [DeviceDataCollector] for a [deviceType].
  Future<DeviceDataCollector> createDeviceDataCollector(String deviceType);

  // Remove the device of [deviceType] from this registry.
  void unregisterDeviceDataCollector(String deviceType);
}
