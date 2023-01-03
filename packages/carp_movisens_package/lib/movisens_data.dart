/*
 * Copyright 2019-2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of carp_movisens_package;

/// An abstract  for all Movisens data events.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class MovisensData extends Data {
  static const String STEPS = "${MovisensSamplingPackage.ACTIVITY}.steps";
  static const String BODY_POSITION =
      "${MovisensSamplingPackage.ACTIVITY}.body_position";
  static const String INCLINATION =
      "${MovisensSamplingPackage.ACTIVITY}.inclination";
  static const String MOVEMENT_ACCELERATION =
      "${MovisensSamplingPackage.ACTIVITY}.movement_acceleration";
  static const String MET = "${MovisensSamplingPackage.ACTIVITY}.met";
  static const String MET_LEVEL =
      "${MovisensSamplingPackage.ACTIVITY}.met_level";

  static const String HR_MEAN = "${MovisensSamplingPackage.HR}.hr_mean";
  static const String HRV = "${MovisensSamplingPackage.HR}.hrv";
  static const String IS_HRV_VALID =
      "${MovisensSamplingPackage.HR}.is_hrv_valid";

  /// The timestamp of the Movisens event.
  ///
  /// Note that on Movisens devices, the stream of data sent through Bluetooth
  /// is not transmitted instantaneously after it has been measured on the device.
  /// See the documentation on [Timestamps](https://pub.dev/packages/movisens_flutter#timestamps) for more information.
  late DateTime timestamp;

  /// The ID of the device which emitted this event.
  /// Uses a MAC address format on Android. Uses a UUID format on iOS.
  String deviceId;

  /// The type of BTLE characteristic which emitted this event.
  movisens.MovisensBluetoothCharacteristics type;

  MovisensData({
    required this.deviceId,
    required this.type,
    DateTime? timestamp,
  }) : super() {
    this.timestamp = timestamp ?? DateTime.now();
  }

  factory MovisensData.fromMovisensEvent(movisens.MovisensEvent event) =>
      MovisensData(
          deviceId: event.deviceId, type: event.type, timestamp: event.time);

  // factory MovisensData.fromMap(
  //   Map<String, dynamic> map, [
  //   String? deviceName,
  // ]) {
  //   MovisensData  = MovisensData();

  //   if (map.containsKey("MetLevel")) {
  //      = MovisensMETLevel.fromMap(map["MetLevel"].toString());
  //   }
  //   if (map.containsKey("Met")) {
  //      = MovisensMET.fromMap(map["Met"].toString());
  //   }
  //   if (map.containsKey("HR")) {
  //      = MovisensHR.fromMap(map["HR"].toString());
  //   }
  //   if (map.containsKey("HRV")) {
  //      = MovisensHRV.fromMap(map["HRV"].toString());
  //   }
  //   if (map.containsKey("IsHrvValid")) {
  //      = MovisensIsHrvValid.fromMap(map["IsHrvValid"].toString());
  //   }
  //   if (map.containsKey("BodyPosition")) {
  //      = MovisensBodyPosition.fromMap(map["BodyPosition"].toString());
  //   }
  //   if (map.containsKey("StepCount")) {
  //      = MovisensStepCount.fromMap(map["StepCount"].toString());
  //   }
  //   if (map.containsKey("MovementAcceleration")) {
  //      = MovisensMovementAcceleration.fromMap(
  //         map["MovementAcceleration"].toString());
  //   }
  //   if (map.containsKey("TapMarker")) {
  //      = MovisensTapMarker.fromMap(map["TapMarker"].toString());
  //   }
  //   if (map.containsKey("BatteryLevel")) {
  //      = MovisensBatteryLevel.fromMap(map["BatteryLevel"].toString());
  //   }
  //   if (map.containsKey("ConnectionStatus")) {
  //      = MovisensConnectionStatus.fromMap(
  //         map["ConnectionStatus"].toString());
  //   }

  //   .movisensTimestamp =
  //       _movisensTimestampToUTC(map['timestamp'].toString());
  //   .deviceId = deviceName;

  //   return ;
  // }

  /// Make a Movisens timestamp into UTC format
  static String _movisensTimestampToUTC(String timestamp) {
    List<String> splittedTimestamp = timestamp.split(" ");
    return "${splittedTimestamp[0]}T${splittedTimestamp[1]}.000Z";
  }

  factory MovisensData.fromJson(Map<String, dynamic> json) =>
      _$MovisensDataFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$MovisensDataToJson(this);
}

/// Step counts as measured by the Movisens device.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class MovisensStepCount extends MovisensData {
  static const dataType = MovisensData.STEPS;

  /// Number of steps taken by the user in last interval
  int steps;

  MovisensStepCount({
    required super.deviceId,
    required super.type,
    super.timestamp,
    required this.steps,
  });

  @override
  factory MovisensStepCount.fromMovisensEvent(movisens.StepsEvent event) =>
      MovisensStepCount(
        deviceId: event.deviceId,
        type: event.type,
        timestamp: event.time,
        steps: event.steps,
      );

  factory MovisensStepCount.fromJson(Map<String, dynamic> json) =>
      _$MovisensStepCountFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$MovisensStepCountToJson(this);
}

/// The body position of the person wearing the device.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class MovisensBodyPosition extends MovisensData {
  static const dataType = MovisensData.BODY_POSITION;

  String bodyPosition;

  MovisensBodyPosition({
    required super.deviceId,
    required super.type,
    super.timestamp,
    required this.bodyPosition,
  });

  @override
  factory MovisensBodyPosition.fromMovisensEvent(
          movisens.BodyPositionEvent event) =>
      MovisensBodyPosition(
        deviceId: event.deviceId,
        type: event.type,
        timestamp: event.time,
        bodyPosition: event.bodyPosition.name,
      );

  factory MovisensBodyPosition.fromJson(Map<String, dynamic> json) =>
      _$MovisensBodyPositionFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$MovisensBodyPositionToJson(this);
}

/// The inclination of the body axes at the sensor location against the x, y
/// and z axises.
///
/// Calculates the mean inclinations of the three body axes from the
/// acceleration signal and displays the value for each inclination in degrees.
/// The values range from 0° to 180°.
///
/// Read more in the [Movisens Documentation](https://docs.movisens.com/Algorithms/physical_activity/#inclination-inclinsationdown-inclinationforward-inclinationright).
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class MovisensInclination extends MovisensData {
  static const dataType = MovisensData.INCLINATION;

  /// Inclination of the sensor in degrees on the (x,y,z) axis
  int x, y, z;

  MovisensInclination({
    required super.deviceId,
    required super.type,
    super.timestamp,
    required this.x,
    required this.y,
    required this.z,
  });

  @override
  factory MovisensInclination.fromMovisensEvent(
          movisens.InclinationEvent event) =>
      MovisensInclination(
        deviceId: event.deviceId,
        type: event.type,
        timestamp: event.time,
        x: event.x,
        y: event.y,
        z: event.z,
      );

  factory MovisensInclination.fromJson(Map<String, dynamic> json) =>
      _$MovisensInclinationFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$MovisensInclinationToJson(this);
}

/// Movisens movement (accelerometer) reading.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class MovisensMovementAcceleration extends MovisensData {
  static const dataType = MovisensData.MOVEMENT_ACCELERATION;

  /// A measurement of physical activity metric that outputs values that have a
  /// very good correlation to the intensity of bodily movements.
  /// Measure in g (multiples of earth gravity (1g = 9,81 m/s2).)
  double movementAcceleration;

  MovisensMovementAcceleration({
    required super.deviceId,
    required super.type,
    super.timestamp,
    required this.movementAcceleration,
  });

  @override
  factory MovisensMovementAcceleration.fromMovisensEvent(
          movisens.MovementAccelerationEvent event) =>
      MovisensMovementAcceleration(
        deviceId: event.deviceId,
        type: event.type,
        timestamp: event.time,
        movementAcceleration: event.movementAcceleration,
      );

  factory MovisensMovementAcceleration.fromJson(Map<String, dynamic> json) =>
      _$MovisensMovementAccelerationFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$MovisensMovementAccelerationToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class MovisensMET extends MovisensData {
  static const dataType = MovisensData.MET;

  /// Measure of Metabolic Equivalent of Task (MET), indicates the energy expenditure.
  /// It is defined as the ratio of metabolic rate during a specific physical
  /// task to a reference metabolic rate.
  int met;

  MovisensMET({
    required super.deviceId,
    required super.type,
    super.timestamp,
    required this.met,
  });

  @override
  factory MovisensMET.fromMovisensEvent(movisens.MetEvent event) => MovisensMET(
        deviceId: event.deviceId,
        type: event.type,
        timestamp: event.time,
        met: event.met,
      );

  factory MovisensMET.fromJson(Map<String, dynamic> json) =>
      _$MovisensMETFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$MovisensMETToJson(this);
}

/// Movisens Metabolic (MET) level.
///
/// Number of seconds the user is in one of the following MET levels:
///   * sedentary
///   * light
///   * moderate
///   * vigorous
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class MovisensMETLevel extends MovisensData {
  static const dataType = MovisensData.MET_LEVEL;

  int sedentary, light, moderate, vigorous;

  MovisensMETLevel({
    required super.deviceId,
    required super.type,
    super.timestamp,
    required this.sedentary,
    required this.light,
    required this.moderate,
    required this.vigorous,
  });

  @override
  factory MovisensMETLevel.fromMovisensEvent(movisens.MetLevelEvent event) =>
      MovisensMETLevel(
        deviceId: event.deviceId,
        type: event.type,
        timestamp: event.time,
        sedentary: event.sedentary,
        light: event.light,
        moderate: event.moderate,
        vigorous: event.vigorous,
      );

  factory MovisensMETLevel.fromJson(Map<String, dynamic> json) =>
      _$MovisensMETLevelFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$MovisensMETLevelToJson(this);
}

/// Heart Rate (HR) in beats pr. minute (BPM).
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class MovisensHR extends MovisensData {
  static const dataType = MovisensData.HR_MEAN;

  /// Heart Rate (HR) mean of the previous 60 seconds, i.e., beats pr. minute (BPM).
  int hr;

  MovisensHR({
    required super.deviceId,
    required super.type,
    super.timestamp,
    required this.hr,
  });

  @override
  factory MovisensHR.fromMovisensEvent(movisens.HrMeanEvent event) =>
      MovisensHR(
        deviceId: event.deviceId,
        type: event.type,
        timestamp: event.time,
        hr: event.hrMean,
      );

  factory MovisensHR.fromJson(Map<String, dynamic> json) =>
      _$MovisensHRFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$MovisensHRToJson(this);
}

/// Heart rate variability (HRV).
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class MovisensHRV extends MovisensData {
  static const dataType = MovisensData.HR_MEAN;

  /// The Root Mean Square of Successive Differences (RMSSD) of heart beat intervals.
  ///
  /// This parameter is the mean value of the HRV parameter RMSSD per output interval.
  /// RMSSD is the root mean square of successive differences of beat intervals.
  /// The unit is milliseconds.
  int hrv;

  MovisensHRV({
    required super.deviceId,
    required super.type,
    super.timestamp,
    required this.hrv,
  });

  @override
  factory MovisensHRV.fromMovisensEvent(movisens.RmssdEvent event) =>
      MovisensHRV(
        deviceId: event.deviceId,
        type: event.type,
        timestamp: event.time,
        hrv: event.rmssd,
      );

  factory MovisensHRV.fromJson(Map<String, dynamic> json) =>
      _$MovisensHRVFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$MovisensHRVToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class MovisensIsHrvValid extends MovisensData {
  static const dataType = MovisensData.HR_MEAN;

  /// Are the current HRV measurements valid?
  bool isHrvValid;

  MovisensIsHrvValid({
    required super.deviceId,
    required super.type,
    super.timestamp,
    required this.isHrvValid,
  });

  @override
  factory MovisensIsHrvValid.fromMovisensEvent(
          movisens.HrvIsValidEvent event) =>
      MovisensIsHrvValid(
        deviceId: event.deviceId,
        type: event.type,
        timestamp: event.time,
        isHrvValid: event.hrvIsValid,
      );

  factory MovisensIsHrvValid.fromJson(Map<String, dynamic> json) =>
      _$MovisensIsHrvValidFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$MovisensIsHrvValidToJson(this);
}

/// Representing a tap marker event from a user tap on the Movisens device.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class MovisensTapMarker extends MovisensData {
  static const dataType = MovisensSamplingPackage.TAP_MARKER;

  /// The tap marker value.
  int tapMarker;

  MovisensTapMarker({
    required super.deviceId,
    required super.type,
    super.timestamp,
    required this.tapMarker,
  });

  @override
  factory MovisensTapMarker.fromMovisensEvent(movisens.TapMarkerEvent event) =>
      MovisensTapMarker(
        deviceId: event.deviceId,
        type: event.type,
        timestamp: event.time,
        tapMarker: event.tapMarkerValue,
      );

  factory MovisensTapMarker.fromJson(Map<String, dynamic> json) =>
      _$MovisensTapMarkerFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$MovisensTapMarkerToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class MovisensEDA extends MovisensData {
  static const dataType = MovisensSamplingPackage.EDA;

  /// The Mean Skin Conductance Level (SCL) value in micro Siemens.
  double edaSclMean;

  MovisensEDA({
    required super.deviceId,
    required super.type,
    super.timestamp,
    required this.edaSclMean,
  });

  @override
  factory MovisensEDA.fromMovisensEvent(movisens.EdaSclMeanEvent event) =>
      MovisensEDA(
        deviceId: event.deviceId,
        type: event.type,
        timestamp: event.time,
        edaSclMean: event.edaSclMean,
      );

  factory MovisensEDA.fromJson(Map<String, dynamic> json) =>
      _$MovisensEDAFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$MovisensEDAToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class MovisensSkinTemperature extends MovisensData {
  static const dataType = MovisensSamplingPackage.SKIN_TEMPERATURE;

  /// Temperature of the skin in degree Celsius.
  double skinTemperature;

  MovisensSkinTemperature({
    required super.deviceId,
    required super.type,
    super.timestamp,
    required this.skinTemperature,
  });

  @override
  factory MovisensSkinTemperature.fromMovisensEvent(
          movisens.SkinTemperatureEvent event) =>
      MovisensSkinTemperature(
        deviceId: event.deviceId,
        type: event.type,
        timestamp: event.time,
        skinTemperature: event.skinTemperature,
      );

  factory MovisensSkinTemperature.fromJson(Map<String, dynamic> json) =>
      _$MovisensSkinTemperatureFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$MovisensSkinTemperatureToJson(this);
}
