/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of context;

/// Holds activity information.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class ActivityDatum extends CARPDatum {
  static const DataFormat CARP_DATA_FORMAT = DataFormat(NameSpace.CARP, ContextSamplingPackage.ACTIVITY);
  DataFormat get format => CARP_DATA_FORMAT;

  ActivityDatum() : super();

  ActivityDatum.fromMap(Map<dynamic, dynamic> map)
      : confidence = map['confidence'],
        type = map['type'],
        super();

  factory ActivityDatum.fromActivity(Activity activity) {
    ActivityDatum activityDatum = ActivityDatum();
    activityDatum.confidence = activity.confidence;
    if (Platform.isIOS) {
      // map iOS activity types
      switch (activity.type) {
        case 'stationary':
          activityDatum.type = 'STILL';
          break;
        case 'walking':
          activityDatum.type = 'WALKING';
          break;
        case 'running':
          activityDatum.type = 'RUNNING';
          break;
        case 'automotive':
          activityDatum.type = 'IN_VEHICLE';
          break;
        case 'cycling':
          activityDatum.type = 'ON_BICYCLE';
          break;
        case 'unknown':
          activityDatum.type = 'UNKNOWN';
          break;
        default:
          activityDatum.type = 'UNKNOWN';
          break;
      }
    } else
      // use the Android types directly
      activityDatum.type = activity.type;

    return activityDatum;
  }

  factory ActivityDatum.fromJson(Map<String, dynamic> json) => _$ActivityDatumFromJson(json);
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
  /// * TILTING - The device angle relative to gravity changed significantly.
  /// * UNKNOWN - Unable to detect the current activity.
  ///
  /// The types above are adopted from the Android activity recognition API.
  /// On iOS the following mapping takes place:
  ///
  /// * stationary => STILL
  /// * walking => WALKING
  /// * running => RUNNING
  /// * automotive => IN_VEHICLE
  /// * cycling => ON_BICYCLE
  /// * unknown => UNKNOWN
  String type;

  String toString() => super.toString() + ', type: $type, confidence: $confidence';
}
