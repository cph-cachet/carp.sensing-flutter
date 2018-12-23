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
  ActivityDatum({Measure measure}) : super(measure: measure);

  ActivityDatum.fromMap({Measure measure, Map<dynamic, dynamic> map})
      : confidence = map['confidence'],
        type = map['type'],
        super(measure: measure);

  ActivityDatum.fromActivity({Measure measure, Activity activity}) : super(measure: measure) {
    this.confidence = activity.confidence;
    this.type = activity.type;
  }

  factory ActivityDatum.fromJson(Map<String, dynamic> json) => _$ActivityDatumFromJson(json);
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

  String toString() => "activity : {type: $type, confidence: $confidence}";
}
