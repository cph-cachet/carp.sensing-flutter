/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of context;

/// Holds activity information.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class ActivityDatum extends Datum {
  // static Map<ar.ActivityType, ActivityType> _activityTypeMap = {
  //   ar.ActivityType.IN_VEHICLE: ActivityType.IN_VEHICLE,
  //   ar.ActivityType.ON_BICYCLE: ActivityType.ON_BICYCLE,
  //   ar.ActivityType.RUNNING: ActivityType.RUNNING,
  //   ar.ActivityType.STILL: ActivityType.STILL,
  //   ar.ActivityType.UNKNOWN: ActivityType.UNKNOWN,
  //   ar.ActivityType.WALKING: ActivityType.WALKING,
  // };

  // static Map<ar.ActivityConfidence, int> _confidenceLevelMap = {
  //   ar.ActivityConfidence.HIGH: 100,
  //   ar.ActivityConfidence.MEDIUM: 70,
  //   ar.ActivityConfidence.LOW: 40,
  // };

  DataFormat get format =>
      DataFormat.fromString(ContextSamplingPackage.ACTIVITY);

  ActivityDatum(this.type, this.confidence) : super();

  ActivityDatum.fromMap(Map<dynamic, dynamic> map)
      : confidence = map['confidence'],
        type = map['type'],
        super();

  factory ActivityDatum.fromActivityEvent(ActivityEvent activityEvent) =>
      ActivityDatum(
        activityEvent.type,
        activityEvent.confidence,
      );

  // factory ActivityDatum.fromActivity(ar.Activity activity) => ActivityDatum(
  //       _activityTypeMap[activity.type] ?? ActivityType.UNKNOWN,
  //       _confidenceLevelMap[activity.confidence] ?? 0,
  //     );

  factory ActivityDatum.fromJson(Map<String, dynamic> json) =>
      _$ActivityDatumFromJson(json);

  Map<String, dynamic> toJson() => _$ActivityDatumToJson(this);

  /// Confidence in activity recognition.
  int confidence;

  /// Type of activity recognized.
  ///
  /// Possible types of activities are:
  /// * IN_VEHICLE - The device is in a vehicle, such as a car.
  /// * ON_BICYCLE - The device is on a bicycle.
  /// * ON_FOOT - The device is on a user who is walking or running.
  /// * WALKING - The device is on a user who is walking.
  /// * RUNNING - The device is on a user who is running.
  /// * STILL - The device is still (not moving).
  ///
  /// The types above are adopted from the Android activity recognition API.
  /// On iOS the following mapping takes place:
  ///
  /// * stationary => STILL
  /// * walking => WALKING
  /// * running => RUNNING
  /// * automotive => IN_VEHICLE
  /// * cycling => ON_BICYCLE
  ///
  /// Note that the [ActivityProbe] discard some AR events, which include:
  ///  * [ActivityType.UNKNOWN]
  ///  * [ActivityType.TILTING]
  ///  * Activities with a low confidence level (<50%)
  ActivityType type;

  /// Activity [type] as a string.
  String get typeString => type.toString().split(".").last;

  String toString() =>
      super.toString() + ', type: $typeString, confidence: $confidence';
}
