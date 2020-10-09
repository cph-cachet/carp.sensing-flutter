/*
 * Copyright 2019 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of movisens;

/// An abstract Datum for all Movisens data points.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class MovisensDatum extends CARPDatum {
  static const DataFormat CARP_DATA_FORMAT = DataFormat(NameSpace.CARP, MovisensSamplingPackage.MOVISENS);
  DataFormat get format => CARP_DATA_FORMAT;

  String movisensTimestamp;

  MovisensDatum() : super();

  factory MovisensDatum.fromMap(Map<String, dynamic> map) {
    if (map.containsKey("MetLevel")) return MovisensMETLevelDatum.fromMap(map["MetLevel"]);
    if (map.containsKey("Met")) return MovisensMETDatum.fromMap(map["Met"]);
    if (map.containsKey("HR")) return MovisensHRDatum.fromMap(map["HR"]);
    if (map.containsKey("HRV")) return MovisensHRVDatum.fromMap(map["HRV"]);
    if (map.containsKey("IsHrvValid")) return MovisensIsHrvValidDatum.fromMap(map["IsHrvValid"]);
    if (map.containsKey("BodyPosition")) return MovisensBodyPositionDatum.fromMap(map["BodyPosition"]);
    if (map.containsKey("StepCount")) return MovisensStepCountDatum.fromMap(map["StepCount"]);
    if (map.containsKey("MovementAcceleration")) return MovisensMovementAccelerationDatum.fromMap(map["MovementAcceleration"]);
    if (map.containsKey("TapMarker")) return MovisensTapMarkerDatum.fromMap(map["TapMarker"]);
    if (map.containsKey("BatteryLevel")) return MovisensBatteryLevelDatum.fromMap(map["BatteryLevel"]);
    if (map.containsKey("ConnectionStatus")) return MovisensConnectionStatusDatum.fromMap(map["ConnectionStatus"]);

    return MovisensDatum();
  }
}

/// Make a Movisens timestamp into UTC format
String _movisensTimestampToUTC(String timestamp) {
  List splittedTimestamp = timestamp.split(" ");
  return splittedTimestamp[0] + "T" + splittedTimestamp[1] + ".000Z";
}

/// Movisens Metabolic (MET) level. MET levels are:
///   * sedentary
///   * light
///   * moderate
///   * vigorous
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class MovisensMETLevelDatum extends MovisensDatum {
  MovisensMETLevelDatum() : super();

  static const DataFormat CARP_DATA_FORMAT = DataFormat(NameSpace.CARP, '${MovisensSamplingPackage.MOVISENS}.${MovisensSamplingPackage.MET_LEVEL}');
  DataFormat get format => CARP_DATA_FORMAT;

  factory MovisensMETLevelDatum.fromMap(String value) {
    MovisensMETLevelDatum metLevelDatum = MovisensMETLevelDatum();
    Map<dynamic, dynamic> map = jsonDecode(value);

    metLevelDatum.movisensTimestamp = _movisensTimestampToUTC(map['timestamp']);
    metLevelDatum.sedentary = map['sedentary'];
    metLevelDatum.light = map['light'];
    metLevelDatum.moderate = map['moderate'];
    metLevelDatum.vigorous = map['vigorous'];

    return metLevelDatum;
  }

  String sedentary;
  String light;
  String moderate;
  String vigorous;

  factory MovisensMETLevelDatum.fromJson(Map<String, dynamic> json) => _$MovisensMETLevelDatumFromJson(json);
  Map<String, dynamic> toJson() => _$MovisensMETLevelDatumToJson(this);
}

/// Representing a map of the Movisens device.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class MovisensMovementAccelerationDatum extends MovisensDatum {
  String movementAcceleration;

  MovisensMovementAccelerationDatum() : super();

  static const DataFormat CARP_DATA_FORMAT = DataFormat(NameSpace.CARP, '${MovisensSamplingPackage.MOVISENS}.${MovisensSamplingPackage.MOVEMENT_ACCELERATION}');
  DataFormat get format => CARP_DATA_FORMAT;

  factory MovisensMovementAccelerationDatum.fromMap(String value) {
    MovisensMovementAccelerationDatum movementAccelerationDatum = MovisensMovementAccelerationDatum();
    Map<dynamic, dynamic> map = jsonDecode(value);
    movementAccelerationDatum.movisensTimestamp = _movisensTimestampToUTC(map['timestamp']);
    movementAccelerationDatum.movementAcceleration = map['movement_acceleration'];

    return movementAccelerationDatum;
  }

  factory MovisensMovementAccelerationDatum.fromJson(Map<String, dynamic> json) => _$MovisensMovementAccelerationDatumFromJson(json);
  Map<String, dynamic> toJson() => _$MovisensMovementAccelerationDatumToJson(this);
}

/// Representing a tap marker event from a user tap on the Movisens device.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class MovisensTapMarkerDatum extends MovisensDatum {
  String tapMarker;

  MovisensTapMarkerDatum() : super();

  static const DataFormat CARP_DATA_FORMAT = DataFormat(NameSpace.CARP, '${MovisensSamplingPackage.MOVISENS}.${MovisensSamplingPackage.TAP_MARKER}');
  DataFormat get format => CARP_DATA_FORMAT;

  factory MovisensTapMarkerDatum.fromMap(String value) {
    MovisensTapMarkerDatum tapMakerDatum = MovisensTapMarkerDatum();
    Map<dynamic, dynamic> map = jsonDecode(value);
    tapMakerDatum.movisensTimestamp = _movisensTimestampToUTC(map['timestamp']);
    tapMakerDatum.tapMarker = map['tap_marker'];

    return tapMakerDatum;
  }

  factory MovisensTapMarkerDatum.fromJson(Map<String, dynamic> json) => _$MovisensTapMarkerDatumFromJson(json);
  Map<String, dynamic> toJson() => _$MovisensTapMarkerDatumToJson(this);
}

/// The battery level of the Movisens device.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class MovisensBatteryLevelDatum extends MovisensDatum {
  String batteryLevel;

  MovisensBatteryLevelDatum() : super();

  static const DataFormat CARP_DATA_FORMAT = DataFormat(NameSpace.CARP, '${MovisensSamplingPackage.MOVISENS}.${MovisensSamplingPackage.BATTERY_LEVEL}');
  DataFormat get format => CARP_DATA_FORMAT;

  factory MovisensBatteryLevelDatum.fromMap(String value) {
    MovisensBatteryLevelDatum batteryLevelDatum = MovisensBatteryLevelDatum();
    Map<dynamic, dynamic> map = jsonDecode(value);
    batteryLevelDatum.movisensTimestamp = _movisensTimestampToUTC(map['timestamp']);
    batteryLevelDatum.batteryLevel = map['battery_level'];

    return batteryLevelDatum;
  }

  factory MovisensBatteryLevelDatum.fromJson(Map<String, dynamic> json) => _$MovisensBatteryLevelDatumFromJson(json);
  Map<String, dynamic> toJson() => _$MovisensBatteryLevelDatumToJson(this);
}

/// The body position of the person wearing the device.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class MovisensBodyPositionDatum extends MovisensDatum {
  String bodyPosition;

  MovisensBodyPositionDatum() : super();

  static const DataFormat CARP_DATA_FORMAT = DataFormat(NameSpace.CARP, '${MovisensSamplingPackage.MOVISENS}.${MovisensSamplingPackage.BODY_POSITION}');
  DataFormat get format => CARP_DATA_FORMAT;

  factory MovisensBodyPositionDatum.fromMap(String value) {
    MovisensBodyPositionDatum bodyPositionDatum = MovisensBodyPositionDatum();
    Map<dynamic, dynamic> map = jsonDecode(value);
    bodyPositionDatum.movisensTimestamp = _movisensTimestampToUTC(map['timestamp']);
    bodyPositionDatum.bodyPosition = map['body_position'];

    return bodyPositionDatum;
  }

  factory MovisensBodyPositionDatum.fromJson(Map<String, dynamic> json) => _$MovisensBodyPositionDatumFromJson(json);
  Map<String, dynamic> toJson() => _$MovisensBodyPositionDatumToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class MovisensMETDatum extends MovisensDatum {
  String met;

  MovisensMETDatum() : super();

  static const DataFormat CARP_DATA_FORMAT = DataFormat(NameSpace.CARP, '${MovisensSamplingPackage.MOVISENS}.${MovisensSamplingPackage.MET}');
  DataFormat get format => CARP_DATA_FORMAT;

  factory MovisensMETDatum.fromMap(String value) {
    MovisensMETDatum metDatum = MovisensMETDatum();
    Map<dynamic, dynamic> map = jsonDecode(value);
    metDatum.movisensTimestamp = _movisensTimestampToUTC(map['timestamp']);
    metDatum.met = map['met'];

    return metDatum;
  }

  factory MovisensMETDatum.fromJson(Map<String, dynamic> json) => _$MovisensMETDatumFromJson(json);
  Map<String, dynamic> toJson() => _$MovisensMETDatumToJson(this);
}

/// Heart Rate (HR) in beats pr. minute (BPM).
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class MovisensHRDatum extends MovisensDatum {
  /// Heart Rate (HR) in beats pr. minute (BPM).
  String hr;

  MovisensHRDatum() : super();

  static const DataFormat CARP_DATA_FORMAT = DataFormat(NameSpace.CARP, '${MovisensSamplingPackage.MOVISENS}.${MovisensSamplingPackage.HR}');
  DataFormat get format => CARP_DATA_FORMAT;

  factory MovisensHRDatum.fromMap(String value) {
    MovisensHRDatum hrDatum = MovisensHRDatum();
    Map<dynamic, dynamic> map = jsonDecode(value);
    hrDatum.movisensTimestamp = _movisensTimestampToUTC(map['timestamp']);
    hrDatum.hr = map['hr'];

    return hrDatum;
  }

  factory MovisensHRDatum.fromJson(Map<String, dynamic> json) => _$MovisensHRDatumFromJson(json);
  Map<String, dynamic> toJson() => _$MovisensHRDatumToJson(this);
}

/// Heart rate variability (HRV).
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class MovisensHRVDatum extends MovisensDatum {
  String hrv;

  MovisensHRVDatum() : super();

  static const DataFormat CARP_DATA_FORMAT = DataFormat(NameSpace.CARP, '${MovisensSamplingPackage.MOVISENS}.${MovisensSamplingPackage.HRV}');
  DataFormat get format => CARP_DATA_FORMAT;

  factory MovisensHRVDatum.fromMap(String value) {
    MovisensHRVDatum hrvDatum = MovisensHRVDatum();
    Map<dynamic, dynamic> map = jsonDecode(value);
    hrvDatum.movisensTimestamp = _movisensTimestampToUTC(map['timestamp']);
    hrvDatum.hrv = map['hrv'];

    return hrvDatum;
  }

  factory MovisensHRVDatum.fromJson(Map<String, dynamic> json) => _$MovisensHRVDatumFromJson(json);
  Map<String, dynamic> toJson() => _$MovisensHRVDatumToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class MovisensIsHrvValidDatum extends MovisensDatum {
  String isHrvValid;

  MovisensIsHrvValidDatum() : super();

  static const DataFormat CARP_DATA_FORMAT = DataFormat(NameSpace.CARP, '${MovisensSamplingPackage.MOVISENS}.${MovisensSamplingPackage.IS_HRV_VALID}');
  DataFormat get format => CARP_DATA_FORMAT;

  factory MovisensIsHrvValidDatum.fromMap(String value) {
    MovisensIsHrvValidDatum isHrvValidDatum = MovisensIsHrvValidDatum();
    Map<dynamic, dynamic> map = jsonDecode(value);
    isHrvValidDatum.movisensTimestamp = _movisensTimestampToUTC(map['timestamp']);
    isHrvValidDatum.isHrvValid = map['is_hrv_valid'];

    return isHrvValidDatum;
  }

  factory MovisensIsHrvValidDatum.fromJson(Map<String, dynamic> json) => _$MovisensIsHrvValidDatumFromJson(json);
  Map<String, dynamic> toJson() => _$MovisensIsHrvValidDatumToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class MovisensStepCountDatum extends MovisensDatum {
  String stepCount;

  MovisensStepCountDatum() : super();

  static const DataFormat CARP_DATA_FORMAT = DataFormat(NameSpace.CARP, '${MovisensSamplingPackage.MOVISENS}.${MovisensSamplingPackage.STEP_COUNT}');
  DataFormat get format => CARP_DATA_FORMAT;

  factory MovisensStepCountDatum.fromMap(String value) {
    MovisensStepCountDatum stepCountDatum = MovisensStepCountDatum();
    Map<dynamic, dynamic> map = jsonDecode(value);
    stepCountDatum.movisensTimestamp = _movisensTimestampToUTC(map['timestamp']);
    stepCountDatum.stepCount = map['step_count'];

    return stepCountDatum;
  }
  factory MovisensStepCountDatum.fromJson(Map<String, dynamic> json) => _$MovisensStepCountDatumFromJson(json);
  Map<String, dynamic> toJson() => _$MovisensStepCountDatumToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class MovisensConnectionStatusDatum extends MovisensDatum {
  String connectionStatus;

  MovisensConnectionStatusDatum() : super();

  static const DataFormat CARP_DATA_FORMAT = DataFormat(NameSpace.CARP, '${MovisensSamplingPackage.MOVISENS}.${MovisensSamplingPackage.CONNECTION_STATUS}');
  DataFormat get format => CARP_DATA_FORMAT;

  factory MovisensConnectionStatusDatum.fromMap(String value) {
    MovisensConnectionStatusDatum connectionStatusDatum = MovisensConnectionStatusDatum();
    Map<dynamic, dynamic> map = jsonDecode(value);
    connectionStatusDatum.movisensTimestamp = _movisensTimestampToUTC(map['timestamp']);
    connectionStatusDatum.connectionStatus = map['connection_status'];

    return connectionStatusDatum;
  }

  factory MovisensConnectionStatusDatum.fromJson(Map<String, dynamic> json) => _$MovisensConnectionStatusDatumFromJson(json);
  Map<String, dynamic> toJson() => _$MovisensConnectionStatusDatumToJson(this);
}
