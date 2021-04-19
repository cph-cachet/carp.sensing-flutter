/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_core_client;

/// Provides access to the status of a device which is connected to a master device.
abstract class ConnectedDeviceManager {
  DeviceRegistration deviceRegistration;
  DeviceDataCollector dataCollector;

  ConnectedDeviceManager({this.deviceRegistration, this.dataCollector});

  /// Determines whether a connection can be made at this point in time to the device.
  bool canConnect() => dataCollector.canConnect();
}

/// Describes the status of a [device] in a study runtime.
enum DeviceRegistrationStatus {
  Unregistered,
  Registered,
}
