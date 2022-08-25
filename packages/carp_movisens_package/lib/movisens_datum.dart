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

    if (map.containsKey("MetLevel")) {
      datum = MovisensMETLevelDatum.fromMap(map["MetLevel"].toString());
    }
    if (map.containsKey("Met")) {
      datum = MovisensMETDatum.fromMap(map["Met"].toString());
    }
    if (map.containsKey("HR")) {
      datum = MovisensHRDatum.fromMap(map["HR"].toString());
    }
    if (map.containsKey("HRV")) {
      datum = MovisensHRVDatum.fromMap(map["HRV"].toString());
    }
    if (map.containsKey("IsHrvValid")) {
      datum = MovisensIsHrvValidDatum.fromMap(map["IsHrvValid"].toString());
    }
    if (map.containsKey("BodyPosition")) {
      datum = MovisensBodyPositionDatum.fromMap(map["BodyPosition"].toString());
    }
    if (map.containsKey("StepCount")) {
      datum = MovisensStepCountDatum.fromMap(map["StepCount"].toString());
    }
    if (map.containsKey("MovementAcceleration")) {
      datum = MovisensMovementAccelerationDatum.fromMap(
          map["MovementAcceleration"].toString());
    }
    if (map.containsKey("TapMarker")) {
      datum = MovisensTapMarkerDatum.fromMap(map["TapMarker"].toString());
    }
    if (map.containsKey("BatteryLevel")) {
      datum = MovisensBatteryLevelDatum.fromMap(map["BatteryLevel"].toString());
    }
    if (map.containsKey("ConnectionStatus")) {
      datum = MovisensConnectionStatusDatum.fromMap(
          map["ConnectionStatus"].toString());
    }

    datum.movisensTimestamp =
        _movisensTimestampToUTC(map['timestamp'].toString());
    datum.movisensDeviceName = deviceName;

    return datum;
  }

  /// Make a Movisens timestamp into UTC format
  static String _movisensTimestampToUTC(String timestamp) {
    List<String> splittedTimestamp = timestamp.split(" ");
    return "${splittedTimestamp[0]}T${splittedTimestamp[1]}.000Z";
  }

  factory MovisensDatum.fromJson(Map<String, dynamic> json) =>
      _$MovisensDatumFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$MovisensDatumToJson(this);
}

/// Movisens Metabolic (MET) level. MET levels are:
///   * sedentary
///   * light
///   * moderate
///   * vigorous
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class MovisensMETLevelDatum extends MovisensDatum {
  @override
  DataFormat get format =>
      DataFormat.fromString(MovisensSamplingPackage.MET_LEVEL);

  String? sedentary;
  String? light;
  String? moderate;
  String? vigorous;

  MovisensMETLevelDatum() : super();

  MovisensMETLevelDatum.fromMap(String value) {
    final map = jsonDecode(value);

    sedentary = map['sedentary'].toString();
    light = map['light'].toString();
    moderate = map['moderate'].toString();
    vigorous = map['vigorous'].toString();
  }

  factory MovisensMETLevelDatum.fromJson(Map<String, dynamic> json) =>
      _$MovisensMETLevelDatumFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$MovisensMETLevelDatumToJson(this);
}

/// Movisens movement (accelerometer) reading.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class MovisensMovementAccelerationDatum extends MovisensDatum {
  @override
  DataFormat get format =>
      DataFormat.fromString(MovisensSamplingPackage.MOVEMENT_ACCELERATION);

  String? movementAcceleration;

  MovisensMovementAccelerationDatum() : super();

  MovisensMovementAccelerationDatum.fromMap(String value) {
    final map = jsonDecode(value);
    movementAcceleration = map['movement_acceleration'].toString();
  }

  factory MovisensMovementAccelerationDatum.fromJson(
          Map<String, dynamic> json) =>
      _$MovisensMovementAccelerationDatumFromJson(json);
  @override
  Map<String, dynamic> toJson() =>
      _$MovisensMovementAccelerationDatumToJson(this);
}

/// Representing a tap marker event from a user tap on the Movisens device.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class MovisensTapMarkerDatum extends MovisensDatum {
  @override
  DataFormat get format =>
      DataFormat.fromString(MovisensSamplingPackage.TAP_MARKER);

  String? tapMarker;

  MovisensTapMarkerDatum() : super();

  MovisensTapMarkerDatum.fromMap(String value) {
    final map = jsonDecode(value);
    tapMarker = map['tap_marker'].toString();
  }

  factory MovisensTapMarkerDatum.fromJson(Map<String, dynamic> json) =>
      _$MovisensTapMarkerDatumFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$MovisensTapMarkerDatumToJson(this);
}

/// The battery level of the Movisens device.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class MovisensBatteryLevelDatum extends MovisensDatum {
  @override
  DataFormat get format =>
      DataFormat.fromString(MovisensSamplingPackage.BATTERY_LEVEL);

  String? batteryLevel;

  MovisensBatteryLevelDatum() : super();

  MovisensBatteryLevelDatum.fromMap(String value) {
    final map = jsonDecode(value);
    batteryLevel = map['battery_level'].toString();
  }

  factory MovisensBatteryLevelDatum.fromJson(Map<String, dynamic> json) =>
      _$MovisensBatteryLevelDatumFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$MovisensBatteryLevelDatumToJson(this);
}

/// The body position of the person wearing the device.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class MovisensBodyPositionDatum extends MovisensDatum {
  @override
  DataFormat get format =>
      DataFormat.fromString(MovisensSamplingPackage.BODY_POSITION);

  String? bodyPosition;

  MovisensBodyPositionDatum() : super();

  MovisensBodyPositionDatum.fromMap(String value) {
    final map = jsonDecode(value);
    bodyPosition = map['body_position'].toString();
  }

  factory MovisensBodyPositionDatum.fromJson(Map<String, dynamic> json) =>
      _$MovisensBodyPositionDatumFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$MovisensBodyPositionDatumToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class MovisensMETDatum extends MovisensDatum {
  @override
  DataFormat get format => DataFormat.fromString(MovisensSamplingPackage.MET);

  String? met;

  MovisensMETDatum() : super();

  MovisensMETDatum.fromMap(String value) {
    final map = jsonDecode(value);
    met = map['met'].toString();
  }

  factory MovisensMETDatum.fromJson(Map<String, dynamic> json) =>
      _$MovisensMETDatumFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$MovisensMETDatumToJson(this);
}

/// Heart Rate (HR) in beats pr. minute (BPM).
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class MovisensHRDatum extends MovisensDatum {
  @override
  DataFormat get format => DataFormat.fromString(MovisensSamplingPackage.HR);

  /// Heart Rate (HR) in beats pr. minute (BPM).
  String? hr;

  MovisensHRDatum() : super();

  MovisensHRDatum.fromMap(String value) {
    final map = jsonDecode(value);
    hr = map['hr'].toString();
  }

  factory MovisensHRDatum.fromJson(Map<String, dynamic> json) =>
      _$MovisensHRDatumFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$MovisensHRDatumToJson(this);
}

/// Heart rate variability (HRV).
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class MovisensHRVDatum extends MovisensDatum {
  @override
  DataFormat get format => DataFormat.fromString(MovisensSamplingPackage.HRV);

  String? hrv;

  MovisensHRVDatum() : super();

  MovisensHRVDatum.fromMap(String value) {
    final map = jsonDecode(value);
    hrv = map['hrv'].toString();
  }

  factory MovisensHRVDatum.fromJson(Map<String, dynamic> json) =>
      _$MovisensHRVDatumFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$MovisensHRVDatumToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class MovisensIsHrvValidDatum extends MovisensDatum {
  @override
  DataFormat get format =>
      DataFormat.fromString(MovisensSamplingPackage.IS_HRV_VALID);

  String? isHrvValid;

  MovisensIsHrvValidDatum() : super();

  MovisensIsHrvValidDatum.fromMap(String value) {
    final map = jsonDecode(value);
    isHrvValid = map['is_hrv_valid'].toString();
  }

  factory MovisensIsHrvValidDatum.fromJson(Map<String, dynamic> json) =>
      _$MovisensIsHrvValidDatumFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$MovisensIsHrvValidDatumToJson(this);
}

/// Step counts as measured by the Movisens device.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class MovisensStepCountDatum extends MovisensDatum {
  @override
  DataFormat get format =>
      DataFormat.fromString(MovisensSamplingPackage.STEP_COUNT);

  String? stepCount;

  MovisensStepCountDatum() : super();

  MovisensStepCountDatum.fromMap(String value) {
    final map = jsonDecode(value);
    stepCount = map['step_count'].toString();
  }
  factory MovisensStepCountDatum.fromJson(Map<String, dynamic> json) =>
      _$MovisensStepCountDatumFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$MovisensStepCountDatumToJson(this);
}

/// Connectivity status of the Movisens device.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class MovisensConnectionStatusDatum extends MovisensDatum {
  @override
  DataFormat get format =>
      DataFormat.fromString(MovisensSamplingPackage.CONNECTION_STATUS);

  String? connectionStatus;

  MovisensConnectionStatusDatum() : super();

  MovisensConnectionStatusDatum.fromMap(String value) {
    final map = jsonDecode(value);
    connectionStatus = map['connection_status'].toString();
  }

  factory MovisensConnectionStatusDatum.fromJson(Map<String, dynamic> json) =>
      _$MovisensConnectionStatusDatumFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$MovisensConnectionStatusDatumToJson(this);
}
