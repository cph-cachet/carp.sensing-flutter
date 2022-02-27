/*
 * Copyright 2019-2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of movisens;

/// An abstract Datum for all Movisens data points.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class MovisensDatum extends Datum {
  @JsonKey(ignore: true)
  @override
  DataFormat get format =>
      DataFormat.fromString(MovisensSamplingPackage.MOVISENS);

  /// The timestamp from the Movisens device.
  String? movisensTimestamp;

  /// The device name of the Movisens device that collected this datum.
  String? movisensDeviceName;

  MovisensDatum() : super();

  factory MovisensDatum.fromMap(
    Map<String, dynamic> map, [
    String? deviceName,
  ]) {
    MovisensDatum datum = MovisensDatum();

    if (map.containsKey("MetLevel"))
      datum = MovisensMETLevelDatum.fromMap(map["MetLevel"]);
    if (map.containsKey("Met")) datum = MovisensMETDatum.fromMap(map["Met"]);
    if (map.containsKey("HR")) datum = MovisensHRDatum.fromMap(map["HR"]);
    if (map.containsKey("HRV")) datum = MovisensHRVDatum.fromMap(map["HRV"]);
    if (map.containsKey("IsHrvValid"))
      datum = MovisensIsHrvValidDatum.fromMap(map["IsHrvValid"]);
    if (map.containsKey("BodyPosition"))
      datum = MovisensBodyPositionDatum.fromMap(map["BodyPosition"]);
    if (map.containsKey("StepCount"))
      datum = MovisensStepCountDatum.fromMap(map["StepCount"]);
    if (map.containsKey("MovementAcceleration"))
      datum = MovisensMovementAccelerationDatum.fromMap(
          map["MovementAcceleration"]);
    if (map.containsKey("TapMarker"))
      datum = MovisensTapMarkerDatum.fromMap(map["TapMarker"]);
    if (map.containsKey("BatteryLevel"))
      datum = MovisensBatteryLevelDatum.fromMap(map["BatteryLevel"]);
    if (map.containsKey("ConnectionStatus"))
      datum = MovisensConnectionStatusDatum.fromMap(map["ConnectionStatus"]);

    datum.movisensTimestamp = _movisensTimestampToUTC(map['timestamp']);
    datum.movisensDeviceName = deviceName;

    return datum;
  }

  /// Make a Movisens timestamp into UTC format
  static String _movisensTimestampToUTC(String timestamp) {
    List splittedTimestamp = timestamp.split(" ");
    return splittedTimestamp[0] + "T" + splittedTimestamp[1] + ".000Z";
  }

  factory MovisensDatum.fromJson(Map<String, dynamic> json) =>
      _$MovisensDatumFromJson(json);
  Map<String, dynamic> toJson() => _$MovisensDatumToJson(this);
}

/// Movisens Metabolic (MET) level. MET levels are:
///   * sedentary
///   * light
///   * moderate
///   * vigorous
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class MovisensMETLevelDatum extends MovisensDatum {
  DataFormat get format =>
      DataFormat.fromString(MovisensSamplingPackage.MET_LEVEL);

  String? sedentary;
  String? light;
  String? moderate;
  String? vigorous;

  MovisensMETLevelDatum() : super();

  factory MovisensMETLevelDatum.fromMap(String value) {
    MovisensMETLevelDatum metLevelDatum = MovisensMETLevelDatum();
    Map<dynamic, dynamic> map = jsonDecode(value);

    metLevelDatum.sedentary = map['sedentary'];
    metLevelDatum.light = map['light'];
    metLevelDatum.moderate = map['moderate'];
    metLevelDatum.vigorous = map['vigorous'];

    return metLevelDatum;
  }

  factory MovisensMETLevelDatum.fromJson(Map<String, dynamic> json) =>
      _$MovisensMETLevelDatumFromJson(json);
  Map<String, dynamic> toJson() => _$MovisensMETLevelDatumToJson(this);
}

/// Movisens movement (accelerometer) reading.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class MovisensMovementAccelerationDatum extends MovisensDatum {
  DataFormat get format =>
      DataFormat.fromString(MovisensSamplingPackage.MOVEMENT_ACCELERATION);

  String? movementAcceleration;

  MovisensMovementAccelerationDatum() : super();

  factory MovisensMovementAccelerationDatum.fromMap(String value) {
    MovisensMovementAccelerationDatum movementAccelerationDatum =
        MovisensMovementAccelerationDatum();
    Map<dynamic, dynamic> map = jsonDecode(value);
    movementAccelerationDatum.movementAcceleration =
        map['movement_acceleration'];

    return movementAccelerationDatum;
  }

  factory MovisensMovementAccelerationDatum.fromJson(
          Map<String, dynamic> json) =>
      _$MovisensMovementAccelerationDatumFromJson(json);
  Map<String, dynamic> toJson() =>
      _$MovisensMovementAccelerationDatumToJson(this);
}

/// Representing a tap marker event from a user tap on the Movisens device.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class MovisensTapMarkerDatum extends MovisensDatum {
  DataFormat get format =>
      DataFormat.fromString(MovisensSamplingPackage.TAP_MARKER);

  String? tapMarker;

  MovisensTapMarkerDatum() : super();

  factory MovisensTapMarkerDatum.fromMap(String value) {
    MovisensTapMarkerDatum tapMakerDatum = MovisensTapMarkerDatum();
    Map<dynamic, dynamic> map = jsonDecode(value);
    tapMakerDatum.tapMarker = map['tap_marker'];

    return tapMakerDatum;
  }

  factory MovisensTapMarkerDatum.fromJson(Map<String, dynamic> json) =>
      _$MovisensTapMarkerDatumFromJson(json);
  Map<String, dynamic> toJson() => _$MovisensTapMarkerDatumToJson(this);
}

/// The battery level of the Movisens device.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class MovisensBatteryLevelDatum extends MovisensDatum {
  DataFormat get format =>
      DataFormat.fromString(MovisensSamplingPackage.BATTERY_LEVEL);

  String? batteryLevel;

  MovisensBatteryLevelDatum() : super();

  factory MovisensBatteryLevelDatum.fromMap(String value) {
    MovisensBatteryLevelDatum batteryLevelDatum = MovisensBatteryLevelDatum();
    Map<dynamic, dynamic> map = jsonDecode(value);
    batteryLevelDatum.batteryLevel = map['battery_level'];

    return batteryLevelDatum;
  }

  factory MovisensBatteryLevelDatum.fromJson(Map<String, dynamic> json) =>
      _$MovisensBatteryLevelDatumFromJson(json);
  Map<String, dynamic> toJson() => _$MovisensBatteryLevelDatumToJson(this);
}

/// The body position of the person wearing the device.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class MovisensBodyPositionDatum extends MovisensDatum {
  DataFormat get format =>
      DataFormat.fromString(MovisensSamplingPackage.BODY_POSITION);

  String? bodyPosition;

  MovisensBodyPositionDatum() : super();

  factory MovisensBodyPositionDatum.fromMap(String value) {
    MovisensBodyPositionDatum bodyPositionDatum = MovisensBodyPositionDatum();
    Map<dynamic, dynamic> map = jsonDecode(value);
    bodyPositionDatum.bodyPosition = map['body_position'];

    return bodyPositionDatum;
  }

  factory MovisensBodyPositionDatum.fromJson(Map<String, dynamic> json) =>
      _$MovisensBodyPositionDatumFromJson(json);
  Map<String, dynamic> toJson() => _$MovisensBodyPositionDatumToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class MovisensMETDatum extends MovisensDatum {
  DataFormat get format => DataFormat.fromString(MovisensSamplingPackage.MET);

  String? met;

  MovisensMETDatum() : super();

  factory MovisensMETDatum.fromMap(String value) {
    MovisensMETDatum metDatum = MovisensMETDatum();
    Map<dynamic, dynamic> map = jsonDecode(value);
    metDatum.met = map['met'];

    return metDatum;
  }

  factory MovisensMETDatum.fromJson(Map<String, dynamic> json) =>
      _$MovisensMETDatumFromJson(json);
  Map<String, dynamic> toJson() => _$MovisensMETDatumToJson(this);
}

/// Heart Rate (HR) in beats pr. minute (BPM).
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class MovisensHRDatum extends MovisensDatum {
  DataFormat get format => DataFormat.fromString(MovisensSamplingPackage.HR);

  /// Heart Rate (HR) in beats pr. minute (BPM).
  String? hr;

  MovisensHRDatum() : super();

  factory MovisensHRDatum.fromMap(String value) {
    MovisensHRDatum hrDatum = MovisensHRDatum();
    Map<dynamic, dynamic> map = jsonDecode(value);
    hrDatum.hr = map['hr'];

    return hrDatum;
  }

  factory MovisensHRDatum.fromJson(Map<String, dynamic> json) =>
      _$MovisensHRDatumFromJson(json);
  Map<String, dynamic> toJson() => _$MovisensHRDatumToJson(this);
}

/// Heart rate variability (HRV).
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class MovisensHRVDatum extends MovisensDatum {
  DataFormat get format => DataFormat.fromString(MovisensSamplingPackage.HRV);

  String? hrv;

  MovisensHRVDatum() : super();

  factory MovisensHRVDatum.fromMap(String value) {
    MovisensHRVDatum hrvDatum = MovisensHRVDatum();
    Map<dynamic, dynamic> map = jsonDecode(value);
    hrvDatum.hrv = map['hrv'];

    return hrvDatum;
  }

  factory MovisensHRVDatum.fromJson(Map<String, dynamic> json) =>
      _$MovisensHRVDatumFromJson(json);
  Map<String, dynamic> toJson() => _$MovisensHRVDatumToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class MovisensIsHrvValidDatum extends MovisensDatum {
  DataFormat get format =>
      DataFormat.fromString(MovisensSamplingPackage.IS_HRV_VALID);

  String? isHrvValid;

  MovisensIsHrvValidDatum() : super();

  factory MovisensIsHrvValidDatum.fromMap(String value) {
    MovisensIsHrvValidDatum isHrvValidDatum = MovisensIsHrvValidDatum();
    Map<dynamic, dynamic> map = jsonDecode(value);
    isHrvValidDatum.isHrvValid = map['is_hrv_valid'];

    return isHrvValidDatum;
  }

  factory MovisensIsHrvValidDatum.fromJson(Map<String, dynamic> json) =>
      _$MovisensIsHrvValidDatumFromJson(json);
  Map<String, dynamic> toJson() => _$MovisensIsHrvValidDatumToJson(this);
}

/// Step counts as measured by the Movisens device.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class MovisensStepCountDatum extends MovisensDatum {
  DataFormat get format =>
      DataFormat.fromString(MovisensSamplingPackage.STEP_COUNT);

  String? stepCount;

  MovisensStepCountDatum() : super();

  factory MovisensStepCountDatum.fromMap(String value) {
    MovisensStepCountDatum stepCountDatum = MovisensStepCountDatum();
    Map<dynamic, dynamic> map = jsonDecode(value);
    stepCountDatum.stepCount = map['step_count'];

    return stepCountDatum;
  }
  factory MovisensStepCountDatum.fromJson(Map<String, dynamic> json) =>
      _$MovisensStepCountDatumFromJson(json);
  Map<String, dynamic> toJson() => _$MovisensStepCountDatumToJson(this);
}

/// Connectivity status of the Movisens device.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class MovisensConnectionStatusDatum extends MovisensDatum {
  DataFormat get format =>
      DataFormat.fromString(MovisensSamplingPackage.CONNECTION_STATUS);

  String? connectionStatus;

  MovisensConnectionStatusDatum() : super();

  factory MovisensConnectionStatusDatum.fromMap(String value) {
    MovisensConnectionStatusDatum connectionStatusDatum =
        MovisensConnectionStatusDatum();
    Map<dynamic, dynamic> map = jsonDecode(value);
    connectionStatusDatum.connectionStatus = map['connection_status'];

    return connectionStatusDatum;
  }

  factory MovisensConnectionStatusDatum.fromJson(Map<String, dynamic> json) =>
      _$MovisensConnectionStatusDatumFromJson(json);
  Map<String, dynamic> toJson() => _$MovisensConnectionStatusDatumToJson(this);
}
