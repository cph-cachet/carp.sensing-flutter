/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_core_client;

// This class is called [DeviceDataCollector] in carp_core - !"#€"#%

/// Collects [Data] for a single device.
abstract class DeviceDataCollector {
  String? _type;

  /// The type of this device
  String? get type => _type;

  /// The registration for this device.
  DeviceRegistration? deviceRegistration;

  /// The set of data types defining which data can be collected on this device.
  Set<String> get supportedDataTypes;

  /// Get a unique id for this device.
  String get id;

  /// Determines whether a connection can be made at this point in time to the device.
  bool canConnect();

  DeviceDataCollector([this.deviceRegistration]);

  /// Initialize the device data collector by specifying its [type].
  ///
  /// Is often overriden in sub-classes. Note, however, that it must not be
  /// doing a lot of work on startup.
  @mustCallSuper
  void initialize(String type) {
    _type = type;
  }
}

// This class is called [DeviceDataCollectorFactory] in carp_core - "#€!"#
//
/// Supports creating and holding a registry of [DeviceDataCollector]s for devices.
abstract class DeviceRegistry {
  /// The devices available in this [DeviceRegistry] mapped to their device type.
  Map<String, DeviceDataCollector> get devices;

  /// Returns the [DeviceDataCollector] of the given [deviceType].
  DeviceDataCollector getDevice(String deviceType);

  /// Returns true if this factory supports a device of the given [deviceType].
  /// Note that even though a certain type of device is supported, its device
  /// [DeviceDataCollector] is not loaded until [registerDevice] is called.
  bool supportsDevice(String deviceType);

  /// Returns true if this factory contain a device manager of the given [deviceType].
  bool hasDevice(String deviceType);

  /// Register and initialize a [DeviceDataCollector] for a [deviceType].
  void registerDevice(String deviceType, DeviceDataCollector collector);

  /// Create and register a [DeviceDataCollector] based on a [deviceType].
  Future<DeviceDataCollector> createDevice(String deviceType);

  // Remove the device of [deviceType] from this registry.
  void unregisterDevice(String deviceType);
}
