/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of esense;

/// This is the base class for this eSense sampling package.
///
/// To use this package, register it in the [carp_mobile_sensing] package using
///
/// ```
///   SamplingPackageRegistry.register(ESenseSamplingPackage());
/// ```
class ESenseSamplingPackage implements SamplingPackage {
  static const String ESENSE_NAMESPACE = "${NameSpace.CARP}.esense";
  static const String ESENSE_BUTTON = "$ESENSE_NAMESPACE.button";
  static const String ESENSE_SENSOR = "$ESENSE_NAMESPACE.sensor";

  DeviceManager _deviceManager = ESenseDeviceManager();

  @override
  List<String> get dataTypes => [ESENSE_BUTTON, ESENSE_SENSOR];

  @override
  Probe? create(String type) {
    switch (type) {
      case ESENSE_BUTTON:
        return ESenseButtonProbe();
      case ESENSE_SENSOR:
        return ESenseSensorProbe();
      default:
        return null;
    }
  }

  @override
  void onRegister() {
    FromJsonFactory().register(ESenseDevice());
  }

  @override
  List<Permission> get permissions => [
        Permission.location,
        Permission.microphone,
      ];

  @override
  String get deviceType => ESenseDevice.DEVICE_TYPE;

  @override
  DeviceManager get deviceManager => _deviceManager;

  @override
  SamplingSchema get samplingSchema => SamplingSchema();
}
