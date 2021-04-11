/*
 * Copyright 2019 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of movisens;

/// The Movisens sampling package
class MovisensSamplingPackage implements SamplingPackage {
  static const String MOVISENS = "${NameSpace.CARP}.movisens";

  static const String MOVISENS_NAMESPACE = "${NameSpace.CARP}.movisens";
  static const String MET_LEVEL = "$MOVISENS_NAMESPACE.met_level";
  static const String MET = "$MOVISENS_NAMESPACE.met";
  static const String HR = "$MOVISENS_NAMESPACE.hr";
  static const String HRV = "$MOVISENS_NAMESPACE.hrv";
  static const String IS_HRV_VALID = "$MOVISENS_NAMESPACE.is_hrv_valid";
  static const String BODY_POSITION = "$MOVISENS_NAMESPACE.body_position";
  static const String STEP_COUNT = "$MOVISENS_NAMESPACE.step_count";
  static const String MOVEMENT_ACCELERATION =
      "$MOVISENS_NAMESPACE.movement_acceleration";
  static const String TAP_MARKER = "$MOVISENS_NAMESPACE.tap_marker";
  static const String BATTERY_LEVEL = "$MOVISENS_NAMESPACE.battery_level";
  static const String CONNECTION_STATUS =
      "$MOVISENS_NAMESPACE.connection_status";

  void onRegister() {
    FromJsonFactory().register(MovisensMeasure());
    FromJsonFactory().register(MovisensDevice());

    // registering the transformers from CARP to OMH for heart rate and step count.
    // we assume that there is an OMH schema registered already...
    TransformerSchemaRegistry().lookup(NameSpace.OMH).add(
          HR,
          OMHHeartRateDatum.transformer,
        );
    TransformerSchemaRegistry().lookup(NameSpace.OMH).add(
          STEP_COUNT,
          OMHStepCountDatum.transformer,
        );
  }

  String get deviceType => MovisensDevice.DEVICE_TYPE;
  DeviceManager get deviceManager => MovisensDeviceManager();

  List<Permission> get permissions => []; // no special permissions needed

  /// Create a [MovisensProbe].
  Probe create(String type) =>
      (type == MOVISENS_NAMESPACE) ? MovisensProbe() : null;

  List<String> get dataTypes => [MOVISENS_NAMESPACE];

  /// This debug schema contains a [MovisensMeasure] for a 25 year old male,
  /// height 175 cm, weight 75 kg, for a Movisens device with address
  /// '88:6B:0F:CD:E7:F2' located on the person's chest.
  ///
  /// This is a device (and person) used for debugging at CACHET.
  SamplingSchema get debug => SamplingSchema()
    ..type = SamplingSchemaType.common
    ..name = 'Common (default) app sampling schema'
    ..powerAware = false
    ..measures.addEntries([
      MapEntry(
          MOVISENS_NAMESPACE,
          MovisensMeasure(
            // Test data for a male 25 year old user.
            type: MOVISENS_NAMESPACE,
            measureDescription: {
              'en': MeasureDescription(
                name: 'Movisens ECG device',
                description:
                    "Collects heart rythm data from the Movisens EcgMove4 sensor",
              )
            },
            address: '88:6B:0F:CD:E7:F2',
            sensorLocation: SensorLocation.chest,
            gender: Gender.male,
            deviceName: 'Sensor 02655',
            height: 175,
            weight: 75,
            age: 25,
          )),
    ]);

  // All other sampling schemas return null since we cannot provide default
  // schemas for Movisens devices. They are custom to the person wearing it.
  SamplingSchema get light => null;
  SamplingSchema get minimum => null;
  SamplingSchema get normal => null;
  SamplingSchema get common => null;
}
