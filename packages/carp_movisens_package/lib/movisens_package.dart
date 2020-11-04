/*
 * Copyright 2019 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of movisens;

/// The Movisens sampling package
class MovisensSamplingPackage implements SamplingPackage {
  static const String MOVISENS = "movisens";
  static const String MET_LEVEL = "met_level";
  static const String MET = "met";
  static const String HR = "hr";
  static const String HRV = "hrv";
  static const String IS_HRV_VALID = "is_hrv_valid";
  static const String BODY_POSITION = "body_position";
  static const String STEP_COUNT = "step_count";
  static const String MOVEMENT_ACCELERATION = "movement_acceleration";
  static const String TAP_MARKER = "tap_marker";
  static const String BATTERY_LEVEL = "battery_level";
  static const String CONNECTION_STATUS = "connection_status";

  void onRegister() {
    FromJsonFactory.registerFromJsonFunction("MovisensMeasure", MovisensMeasure.fromJsonFunction);

    // registering the transformers from CARP to OMH for heart rate and step count.
    // we assume that there is an OMH schema registered already...
    TransformerSchemaRegistry().lookup(NameSpace.OMH).add(
          '${MovisensSamplingPackage.MOVISENS}.${MovisensSamplingPackage.HR}',
          OMHHeartRateDatum.transformer,
        );
    TransformerSchemaRegistry().lookup(NameSpace.OMH).add(
          '${MovisensSamplingPackage.MOVISENS}.${MovisensSamplingPackage.STEP_COUNT}',
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
    ..type = SamplingSchemaType.COMMON
    ..name = 'Common (default) app sampling schema'
    ..powerAware = false
    ..measures.addEntries([
      MapEntry(
          MOVISENS,
          MovisensMeasure(
            // Test data for a male 25 year old user.
            MeasureType(NameSpace.CARP, MOVISENS),
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
