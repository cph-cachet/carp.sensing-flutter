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

  List<String> get dataTypes => [ESENSE_BUTTON, ESENSE_SENSOR];

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

  void onRegister() {
    FromJsonFactory()
        .register(ESenseMeasure(type: ESENSE_BUTTON, deviceName: 'ignored'));
    FromJsonFactory().register(ESenseDevice());
  }

  List<Permission> get permissions => [
        Permission.location,
        Permission.microphone,
      ];
  String get deviceType => ESenseDevice.DEVICE_TYPE;
  DeviceManager get deviceManager => ESenseDeviceManager();

  // Since the configuration of the eSense devices require the device name
  // it is not possible to offer any 'common' device configuration.
  // Hence, all the sampling schema getter return an empty schema.
  SamplingSchema get common => SamplingSchema(type: SamplingSchemaType.common);
  SamplingSchema get light => SamplingSchema(type: SamplingSchemaType.light);
  SamplingSchema get minimum =>
      SamplingSchema(type: SamplingSchemaType.minimum);
  SamplingSchema get normal => SamplingSchema(type: SamplingSchemaType.normal);

  // This is the debug sampling schema used by bardram
  // His eSense devices are
  //
  //        |     name    |     id
  //  ------+-------------+--------------------
  //  right | eSense-0917 |  00:04:79:00:0F:4D
  //  left  | eSense-0332 |  00:04:79:00:0D:04
  //
  // As recommended;:
  //   "it would be better to use the right earbud to record only sound samples
  //    and the left earbud to record only IMU data."
  // Hence, connect the right earbud (eSense-0917) to the phone.
  SamplingSchema get debug => SamplingSchema(
        type: SamplingSchemaType.debug,
        name: 'Debugging eSense sampling schema',
        powerAware: false,
      )..measures.addEntries([
          MapEntry(
              ESENSE_BUTTON,
              ESenseMeasure(
                  type: ESENSE_BUTTON,
                  name: 'eSense - Button',
                  description: "Collects button event from the eSense device",
                  enabled: true,
                  deviceName: 'eSense-0332')),
          MapEntry(
              ESENSE_SENSOR,
              ESenseMeasure(
                  type: ESENSE_SENSOR,
                  name: 'eSense - Sensor',
                  description:
                      "Collects movement data from the eSense inertial measurement unit (IMU) sensor",
                  enabled: true,
                  deviceName: 'eSense-0332',
                  samplingRate: 5)),
        ]);
}
