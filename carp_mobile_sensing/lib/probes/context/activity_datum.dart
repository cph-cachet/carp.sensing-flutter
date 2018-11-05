/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of activity;

/// Holds activity information.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class ActivityDatum extends CARPDatum {
  static CARPDataFormat CARP_DATA_FORMAT = new CARPDataFormat(
      NameSpace.CARP_NAMESPACE, ProbeRegistry.ACTIVITY_MEASURE);

  ActivityDatum() : super();

  ActivityDatum.fromMap(Map<dynamic, dynamic> map)
      : confidence = map['confidence'],
        type = map['type'];

  ActivityDatum.fromActivity(Activity act) {
    this.confidence = act.confidence;
    this.type = act.type;
  }

  factory ActivityDatum.fromJson(Map<String, dynamic> json) =>
      _$ActivityDatumFromJson(json);
  Map<String, dynamic> toJson() => _$ActivityDatumToJson(this);

  /// Confidence in activity recognition.
  int confidence;

  /// Type of activity recognized.
  ///
  /// On Android these are:
  /// * IN_VEHICLE - The device is in a vehicle, such as a car.
  /// * ON_BICYCLE - The device is on a bicycle.
  /// * ON_FOOT - The device is on a user who is walking or running.
  /// * RUNNING - The device is on a user who is running.
  /// * STILL - The device is still (not moving).
  /// * TILTING - The device angle relative to gravity changed significantly.
  /// * UNKNOWN - Unable to detect the current activity.
  /// * WALKING - The device is on a user who is walking.
  ///
  /// On iOS:
  /// * stationary
  /// * walking
  /// * running
  /// * automotive
  /// * cycling
  /// * unknown
  String type;

  CARPDataFormat getCARPDataFormat() => CARP_DATA_FORMAT;

  String toString() => "activity : {type: $type, confidence: $confidence}";
}
