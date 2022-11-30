/*
 * Copyright 2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_core_common;

// This file holds all the CARP Core defined data type.
// In CARP Core Kotlin, this is the "dk.cachet.carp.common.application.data" domain.

/// Holds data for a [DataType].
/// This is an abstract class and contains no data as such.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class Data extends Serializable {
  @JsonKey(ignore: true)
  DataType get format => DataType.fromString(jsonType);

  Data() : super();

  /// Is this data equivalent to [other]?
  /// This is a custom 'soft' equal (==) operator used to compare two data objects.
  /// Used in triggering something when a piece of data is collected.
  bool equivalentTo(Data other) => false;

  @override
  Function get fromJsonFunction => _$DataFromJson;
  factory Data.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as Data;
  @override
  Map<String, dynamic> toJson() => _$DataToJson(this);
  @override
  String get jsonType => '${NameSpace.CARP}.$runtimeType'.toLowerCase();
}

/// Holds data for a [DataType] collected by a sensor which may include additional
/// [sensorSpecificData].
abstract class SensorData extends Data {
  /// Additional sensor-specific data pertaining to this data point.
  /// This can be used to append highly-specific sensor data to an otherwise
  /// common data type.
  Data? sensorSpecificData;
}

/// Change in velocity, including gravity, along perpendicular
/// [x], [y], and [z] axes in meters per second squared (m/s^2).
/// Typically captured by an accelerometer.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class Acceleration extends SensorData {
  static const dataType = CarpDataTypes.ACCELERATION_TYPE_NAME;
  double x, y, z;
  Acceleration({this.x = 0, this.y = 0, this.z = 0}) : super();

  @override
  Function get fromJsonFunction => _$AccelerationFromJson;
  factory Acceleration.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as Acceleration;
  @override
  Map<String, dynamic> toJson() => _$AccelerationToJson(this);
}

/// Rate of rotation of the device in 3D space.
/// Typically captured by a gyroscope.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class Rotation extends SensorData {
  static const dataType = CarpDataTypes.ROTATION_TYPE_NAME;
  double x, y, z;
  Rotation({this.x = 0, this.y = 0, this.z = 0}) : super();

  @override
  Function get fromJsonFunction => _$RotationFromJson;
  factory Rotation.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as Rotation;
  @override
  Map<String, dynamic> toJson() => _$RotationToJson(this);
}

/// Magnetic field of the device in 3D space, measured in microteslas μT
/// for each three-dimensional axis.
/// Typically captured by a magnetometer sensor.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class MagneticField extends SensorData {
  static const dataType = CarpDataTypes.MAGNETIC_FIELD_TYPE_NAME;
  double x, y, z;
  MagneticField({this.x = 0, this.y = 0, this.z = 0}) : super();

  @override
  Function get fromJsonFunction => _$MagneticFieldFromJson;
  factory MagneticField.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as MagneticField;
  @override
  Map<String, dynamic> toJson() => _$MagneticFieldToJson(this);
}

/// Geolocation data as latitude and longitude in decimal degrees within
/// the World Geodetic System 1984.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class Geolocation extends SensorData {
  static const dataType = CarpDataTypes.GEOLOCATION_TYPE_NAME;

  double latitude;
  double longitude;

  Geolocation({this.latitude = 0, this.longitude = 0}) : super();

  @override
  Function get fromJsonFunction => _$GeolocationFromJson;
  factory Geolocation.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as Geolocation;
  @override
  Map<String, dynamic> toJson() => _$GeolocationToJson(this);
}

/// The relative received signal strength of a wireless device.
/// The unit of the received signal strength indicator ([rssi]) is arbitrary
/// and determined by the chip manufacturer, but the greater the value,
/// the stronger the signal.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class SignalStrength extends SensorData {
  static const dataType = CarpDataTypes.SIGNAL_STRENGTH_TYPE_NAME;

  int rssi;
  SignalStrength({this.rssi = 0}) : super();

  @override
  Function get fromJsonFunction => _$SignalStrengthFromJson;
  factory SignalStrength.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as SignalStrength;
  @override
  Map<String, dynamic> toJson() => _$SignalStrengthToJson(this);
}

/// Step count data as number of steps taken in a corresponding time interval.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class StepCount extends SensorData {
  static const dataType = CarpDataTypes.STEP_COUNT_TYPE_NAME;

  int steps;
  StepCount({this.steps = 0}) : super();

  @override
  Function get fromJsonFunction => _$StepCountFromJson;
  factory StepCount.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as StepCount;
  @override
  Map<String, dynamic> toJson() => _$StepCountToJson(this);
}

/// Heart rate data in beats per minute ([bpm]).
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class HeartRate extends SensorData {
  static const dataType = CarpDataTypes.HEART_RATE_TYPE_NAME;

  int bpm;
  HeartRate({this.bpm = 0}) : super();

  @override
  Function get fromJsonFunction => _$HeartRateFromJson;
  factory HeartRate.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as HeartRate;
  @override
  Map<String, dynamic> toJson() => _$HeartRateToJson(this);
}

/// Electrocardiogram data of a single lead.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class ECG extends SensorData {
  static const dataType = CarpDataTypes.ECG_TYPE_NAME;

  double milliVolt;
  ECG({this.milliVolt = 0}) : super();

  @override
  Function get fromJsonFunction => _$ECGFromJson;
  factory ECG.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as ECG;
  @override
  Map<String, dynamic> toJson() => _$ECGToJson(this);
}

/// Single-channel electrodermal activity (EDA) data, represented as skin conductance.
/// Among others, also known as galvanic skin response (GSR) or skin conductance response/level.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class EDA extends SensorData {
  static const dataType = CarpDataTypes.EDA_TYPE_NAME;

  double microSiemens;
  EDA({this.microSiemens = 0}) : super();

  @override
  Function get fromJsonFunction => _$EDAFromJson;
  factory EDA.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as EDA;
  @override
  Map<String, dynamic> toJson() => _$EDAToJson(this);
}

/// Indicates the task with [taskName] was completed.
/// [taskData] holds the result of a completed interactive task, or null if
/// no result is collected.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class CompletedTask extends Data {
  static const dataType = CarpDataTypes.COMPLETED_TASK_TYPE_NAME;

  String taskName;
  Data? taskData;

  CompletedTask({
    required this.taskName,
    this.taskData,
  }) : super();

  @override
  Function get fromJsonFunction => _$CompletedTaskFromJson;
  factory CompletedTask.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as CompletedTask;
  @override
  Map<String, dynamic> toJson() => _$CompletedTaskToJson(this);
}

/// Indicates the task with [taskName] was started or stopped ([control]) by the
/// trigger with [triggerId] on the device with [destinationDeviceRoleName],
/// referring to identifiers in the study protocol.
/// [triggerData] may contain additional information related to the circumstances
/// which caused the trigger to fire.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class TriggeredTask extends Data {
  static const dataType = CarpDataTypes.TRIGGERED_TASK_TYPE_NAME;

  int triggerId;
  String taskName;
  String destinationDeviceRoleName;
  Control control;
  Data? triggerData;

  TriggeredTask({
    required this.triggerId,
    required this.taskName,
    required this.destinationDeviceRoleName,
    required this.control,
    this.triggerData,
  }) : super();

  @override
  Function get fromJsonFunction => _$TriggeredTaskFromJson;
  factory TriggeredTask.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as TriggeredTask;
  @override
  Map<String, dynamic> toJson() => _$TriggeredTaskToJson(this);
}

/// Indicates that some error occurred during data collection. [message]
/// holds any message about the error which might have been captured.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class Error extends Data {
  static const dataType = CarpDataTypes.ERROR_TYPE_NAME;

  /// The original error message returned from the probe, if available.
  String message;

  Error({required this.message}) : super();

  @override
  Function get fromJsonFunction => _$ErrorFromJson;
  factory Error.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as Error;
  @override
  Map<String, dynamic> toJson() => _$ErrorToJson(this);
}
