/*
 * Copyright 2019 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of movisens;

/// The Movisens sampling package
class MovisensSamplingPackage extends SmartphoneSamplingPackage {
  static const String MOVISENS_DEVICE_TYPE = 'esense';

  static const String MOVISENS = "${NameSpace.CARP}.movisens";
  static const String MET_LEVEL = "$MOVISENS.met_level";
  static const String MET = "$MOVISENS.met";
  static const String HR = "$MOVISENS.hr";
  static const String HRV = "$MOVISENS.hrv";
  static const String IS_HRV_VALID = "$MOVISENS.is_hrv_valid";
  static const String BODY_POSITION = "$MOVISENS.body_position";
  static const String STEP_COUNT = "$MOVISENS.step_count";
  static const String MOVEMENT_ACCELERATION = "$MOVISENS.movement_acceleration";
  static const String TAP_MARKER = "$MOVISENS.tap_marker";
  static const String BATTERY_LEVEL = "$MOVISENS.battery_level";
  static const String CONNECTION_STATUS = "$MOVISENS.connection_status";

  void onRegister() {
    FromJsonFactory().register(MovisensMeasure());

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

  List<Permission> get permissions => []; // no special permissions needed

  /// Create a [MovisensProbe].
  Probe create(String type) => (type == MOVISENS) ? MovisensProbe() : null;

  List<String> get dataTypes => [MOVISENS];

  /// This common / default schema contains a [MovisensMeasure] for
  /// a 25 year old male, height 175 cm, weight 75 kg, for a Movisens
  /// device with address '88:6B:0F:CD:E7:F2' located on the person's
  /// chest.
  SamplingSchema get common => SamplingSchema()
    ..type = SamplingSchemaType.common
    ..name = 'Common (default) app sampling schema'
    ..powerAware = false
    ..measures.addEntries([
      MapEntry(
          MOVISENS,
          MovisensMeasure(
            // Test data for a male 25 year old user.
            type: MOVISENS,
            name: 'Movisens ECG device',
            address: '88:6B:0F:CD:E7:F2',
            sensorLocation: SensorLocation.chest,
            gender: Gender.male,
            deviceName: 'Sensor 02655',
            height: 175,
            weight: 75,
            age: 25,
          )),
    ]);

  SamplingSchema get light => common;
  SamplingSchema get minimum => common;
  SamplingSchema get normal => common;
  SamplingSchema get debug => common;
}
