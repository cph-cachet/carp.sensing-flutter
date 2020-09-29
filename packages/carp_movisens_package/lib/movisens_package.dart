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
    TransformerSchemaRegistry.instance.lookup(NameSpace.OMH)
        .add('${MovisensSamplingPackage.MOVISENS}.${MovisensSamplingPackage.HR}', OMHHeartRateDatum.transformer);
    TransformerSchemaRegistry.instance.lookup(NameSpace.OMH).add(
        '${MovisensSamplingPackage.MOVISENS}.${MovisensSamplingPackage.STEP_COUNT}', OMHStepCountDatum.transformer);
  }

  List<Permission> get permissions => []; // no special permissions needed

  Probe create(String type) => (type == MOVISENS) ? MovisensProbe() : null;

  List<String> get dataTypes => [MOVISENS];

  // TODO: implement common
  SamplingSchema get common => null;

  // TODO: implement light
  SamplingSchema get light => null;

  // TODO: implement minimum
  SamplingSchema get minimum => null;

  // TODO: implement normal
  SamplingSchema get normal => null;

  // TODO: implement debug
  SamplingSchema get debug => null;
}
