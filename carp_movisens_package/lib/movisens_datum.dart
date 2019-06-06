part of movisens;

///movisensDatum  which  serializes movisens data into CARPDatum

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class MovisensDatum extends CARPDatum {
  static const DataFormat CARP_DATA_FORMAT =
      DataFormat(NameSpace.CARP, MovisensSamplingPackage.MOVISENS);
  DataFormat get format => CARP_DATA_FORMAT;

  String movisensTimestamp;

  MovisensDatum() : super();

  factory MovisensDatum.fromMap(Map<String, dynamic> map) {
    if (map.containsKey("MetLevel"))
      return MovisensMETLevelDatum.fromMap(map["MetLevel"]);
    if (map.containsKey("Met")) return MovisensMETDatum.fromMap(map["Met"]);

    if (map.containsKey("HR")) return MovisensHRDatum.fromMap(map["HR"]);
    if (map.containsKey("HRV")) return MovisensHRVDatum.fromMap(map["HRV"]);
    if (map.containsKey("IsHrvValid"))
      return MovisensIsHrvValidDatum.fromMap(map["IsHrvValid"]);
    if (map.containsKey("BodyPosition"))
      return MovisensBodyPositionDatum.fromMap(map["BodyPosition"]);
    if (map.containsKey("StepCount"))
      return MovisensStepCountDatum.fromMap(map["StepCount"]);
    if (map.containsKey("MovementAcceleration"))
      return MovisensMovementAccelerationDatum.fromMap(
          map["MovementAcceleration"]);
    if (map.containsKey("TapMarker"))
      return MovisensTapMarkerDatum.fromMap(map["TapMarker"]);
    if (map.containsKey("BatteryLevel"))
      return MovisensBatteryLevelDatum.fromMap(map["BatteryLevel"]);
    if (map.containsKey("ConnectionStatus"))
      return MovisensConnectionStatusDatum.fromMap(map["ConnectionStatus"]);

    return MovisensDatum();
  }
}

/// MovisensMETLevelDatum
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class MovisensMETLevelDatum extends MovisensDatum {
  MovisensMETLevelDatum() : super();

  ///set data format
  static const DataFormat CARP_DATA_FORMAT = DataFormat(
      NameSpace.CARP, '${MovisensSamplingPackage.MOVISENS}.metLevel');
  DataFormat get format => CARP_DATA_FORMAT;

  factory MovisensMETLevelDatum.fromMap(String value) {
    MovisensMETLevelDatum metLevelDatum = MovisensMETLevelDatum();
    Map<dynamic, dynamic> map = jsonDecode(value);
    metLevelDatum.movisensTimestamp = map['timestamp'];
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

  factory MovisensMETLevelDatum.fromJson(Map<String, dynamic> json) =>
      _$MovisensMETLevelDatumFromJson(json);
  Map<String, dynamic> toJson() => _$MovisensMETLevelDatumToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class MovisensMovementAccelerationDatum extends MovisensDatum {
  String movementAcceleration;

  MovisensMovementAccelerationDatum() : super();

  ///set data format

  static const DataFormat CARP_DATA_FORMAT = DataFormat(NameSpace.CARP,
      '${MovisensSamplingPackage.MOVISENS}.movementAcceleration');
  DataFormat get format => CARP_DATA_FORMAT;

  factory MovisensMovementAccelerationDatum.fromMap(String value) {
    MovisensMovementAccelerationDatum movementAccelerationDatum =
        MovisensMovementAccelerationDatum();
    Map<dynamic, dynamic> map = jsonDecode(value);
    movementAccelerationDatum.movisensTimestamp = map['timestamp'];
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

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class MovisensTapMarkerDatum extends MovisensDatum {
  String tapMarker;

  MovisensTapMarkerDatum() : super();

  ///set data format

  static const DataFormat CARP_DATA_FORMAT = DataFormat(
      NameSpace.CARP, '${MovisensSamplingPackage.MOVISENS}.tapMarker');
  DataFormat get format => CARP_DATA_FORMAT;

  factory MovisensTapMarkerDatum.fromMap(String value) {
    MovisensTapMarkerDatum tapMakerDatum = MovisensTapMarkerDatum();
    Map<dynamic, dynamic> map = jsonDecode(value);
    tapMakerDatum.movisensTimestamp = map['timestamp'];
    tapMakerDatum.tapMarker = map['tap_marker'];

    return tapMakerDatum;
  }

  factory MovisensTapMarkerDatum.fromJson(Map<String, dynamic> json) =>
      _$MovisensTapMarkerDatumFromJson(json);
  Map<String, dynamic> toJson() => _$MovisensTapMarkerDatumToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class MovisensBatteryLevelDatum extends MovisensDatum {
  String batteryLevel;

  MovisensBatteryLevelDatum() : super();


  ///set data format
  static const DataFormat CARP_DATA_FORMAT = DataFormat(
      NameSpace.CARP, '${MovisensSamplingPackage.MOVISENS}.batteryLevel');
  DataFormat get format => CARP_DATA_FORMAT;

  factory MovisensBatteryLevelDatum.fromMap(String value) {
    MovisensBatteryLevelDatum batteryLevelDatum = MovisensBatteryLevelDatum();
    Map<dynamic, dynamic> map = jsonDecode(value);
    batteryLevelDatum.movisensTimestamp = map['timestamp'];
    batteryLevelDatum.batteryLevel = map['battery_level'];

    return batteryLevelDatum;
  }
  factory MovisensBatteryLevelDatum.fromJson(Map<String, dynamic> json) =>
      _$MovisensBatteryLevelDatumFromJson(json);
  Map<String, dynamic> toJson() => _$MovisensBatteryLevelDatumToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class MovisensBodyPositionDatum extends MovisensDatum {
  String bodyPosition;

  MovisensBodyPositionDatum() : super();


  ///set data format

  static const DataFormat CARP_DATA_FORMAT = DataFormat(
      NameSpace.CARP, '${MovisensSamplingPackage.MOVISENS}.bodyPosition');
  DataFormat get format => CARP_DATA_FORMAT;

  factory MovisensBodyPositionDatum.fromMap(String value) {
    MovisensBodyPositionDatum bodyPositionDatum = MovisensBodyPositionDatum();
    Map<dynamic, dynamic> map = jsonDecode(value);
    bodyPositionDatum.movisensTimestamp = map['timestamp'];
    bodyPositionDatum.bodyPosition = map['body_position'];

    return bodyPositionDatum;
  }
  factory MovisensBodyPositionDatum.fromJson(Map<String, dynamic> json) =>
      _$MovisensBodyPositionDatumFromJson(json);
  Map<String, dynamic> toJson() => _$MovisensBodyPositionDatumToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class MovisensMETDatum extends MovisensDatum {
  String met;

  MovisensMETDatum() : super();

  ///set data format

  static const DataFormat CARP_DATA_FORMAT =
      DataFormat(NameSpace.CARP, '${MovisensSamplingPackage.MOVISENS}.met');
  DataFormat get format => CARP_DATA_FORMAT;

  factory MovisensMETDatum.fromMap(String value) {
    MovisensMETDatum metDatum = MovisensMETDatum();
    Map<dynamic, dynamic> map = jsonDecode(value);
    metDatum.movisensTimestamp = map['timestamp'];
    metDatum.met = map['met'];

    return metDatum;
  }
  factory MovisensMETDatum.fromJson(Map<String, dynamic> json) =>
      _$MovisensMETDatumFromJson(json);
  Map<String, dynamic> toJson() => _$MovisensMETDatumToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class MovisensHRDatum extends MovisensDatum {
  String hr;

  MovisensHRDatum() : super();

  ///set data format

  static const DataFormat CARP_DATA_FORMAT =
      DataFormat(NameSpace.CARP, '${MovisensSamplingPackage.MOVISENS}.hr');
  DataFormat get format => CARP_DATA_FORMAT;

  factory MovisensHRDatum.fromMap(String value) {
    MovisensHRDatum hrDatum = MovisensHRDatum();

    Map<dynamic, dynamic> map = jsonDecode(value);
    hrDatum.movisensTimestamp = map['timestamp'];
    hrDatum.hr = map['hr'];

    return hrDatum;
  }

  factory MovisensHRDatum.fromJson(Map<String, dynamic> json) =>
      _$MovisensHRDatumFromJson(json);
  Map<String, dynamic> toJson() => _$MovisensHRDatumToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class MovisensHRVDatum extends MovisensDatum {
  String hrv;

  MovisensHRVDatum() : super();

  ///set data format

  static const DataFormat CARP_DATA_FORMAT =
      DataFormat(NameSpace.CARP, '${MovisensSamplingPackage.MOVISENS}.hrv');
  DataFormat get format => CARP_DATA_FORMAT;

  factory MovisensHRVDatum.fromMap(String value) {
    MovisensHRVDatum hrvDatum = MovisensHRVDatum();

    Map<dynamic, dynamic> map = jsonDecode(value);
    hrvDatum.movisensTimestamp = map['timestamp'];
    hrvDatum.hrv = map['hrv'];

    return hrvDatum;
  }
  factory MovisensHRVDatum.fromJson(Map<String, dynamic> json) =>
      _$MovisensHRVDatumFromJson(json);
  Map<String, dynamic> toJson() => _$MovisensHRVDatumToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class MovisensIsHrvValidDatum extends MovisensDatum {
  String isHrvValid;

  MovisensIsHrvValidDatum() : super();

  ///set data format

  static const DataFormat CARP_DATA_FORMAT = DataFormat(
      NameSpace.CARP, '${MovisensSamplingPackage.MOVISENS}.isHrvValid');
  DataFormat get format => CARP_DATA_FORMAT;

  factory MovisensIsHrvValidDatum.fromMap(String value) {
    MovisensIsHrvValidDatum isHrvValidDatum = MovisensIsHrvValidDatum();
    Map<dynamic, dynamic> map = jsonDecode(value);
    isHrvValidDatum.movisensTimestamp = map['timestamp'];
    isHrvValidDatum.isHrvValid = map['is_hrv_valid'];

    return isHrvValidDatum;
  }
  factory MovisensIsHrvValidDatum.fromJson(Map<String, dynamic> json) =>
      _$MovisensIsHrvValidDatumFromJson(json);
  Map<String, dynamic> toJson() => _$MovisensIsHrvValidDatumToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class MovisensStepCountDatum extends MovisensDatum {
  String stepCount;

  MovisensStepCountDatum() : super();

  ///set data format
  static const DataFormat CARP_DATA_FORMAT = DataFormat(
      NameSpace.CARP, '${MovisensSamplingPackage.MOVISENS}.stepCount');
  DataFormat get format => CARP_DATA_FORMAT;

  factory MovisensStepCountDatum.fromMap(String value) {
    MovisensStepCountDatum stepCountDatum = MovisensStepCountDatum();

    Map<dynamic, dynamic> map = jsonDecode(value);
    stepCountDatum.movisensTimestamp = map['timestamp'];
    stepCountDatum.stepCount = map['step_count'];

    return stepCountDatum;
  }
  factory MovisensStepCountDatum.fromJson(Map<String, dynamic> json) =>
      _$MovisensStepCountDatumFromJson(json);
  Map<String, dynamic> toJson() => _$MovisensStepCountDatumToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class MovisensConnectionStatusDatum extends MovisensDatum {
  String connectionStatus;

  MovisensConnectionStatusDatum() : super();



  ///set data format

  static const DataFormat CARP_DATA_FORMAT = DataFormat(
      NameSpace.CARP, '${MovisensSamplingPackage.MOVISENS}.connectionStatus');
  DataFormat get format => CARP_DATA_FORMAT;

  factory MovisensConnectionStatusDatum.fromMap(String value) {
    MovisensConnectionStatusDatum connectionStatusDatum =
        MovisensConnectionStatusDatum();

    Map<dynamic, dynamic> map = jsonDecode(value);
    connectionStatusDatum.movisensTimestamp = map['timestamp'];
    connectionStatusDatum.connectionStatus = map['connection_status'];

    return connectionStatusDatum;
  }
  factory MovisensConnectionStatusDatum.fromJson(Map<String, dynamic> json) =>
      _$MovisensConnectionStatusDatumFromJson(json);
  Map<String, dynamic> toJson() => _$MovisensConnectionStatusDatumToJson(this);
}
