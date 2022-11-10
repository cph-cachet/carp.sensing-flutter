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
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class Data extends Serializable {
  @JsonKey(ignore: true)
  DataType get format => DataType.fromString(jsonType);

  Data() : super();

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

/// Holds rate of change in velocity, including gravity, along perpendicular
/// [x], [y], and [z] axes in meters per second squared (m/s^2).
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class Acceleration extends SensorData {
  double x, y, z;
  Acceleration(this.x, this.y, this.z) : super();

  @override
  Function get fromJsonFunction => _$AccelerationFromJson;
  factory Acceleration.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as Acceleration;
  @override
  Map<String, dynamic> toJson() => _$AccelerationToJson(this);
}

/// Holds geolocation data as latitude and longitude in decimal degrees within
/// the World Geodetic System 1984.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class Geolocation extends SensorData {
  double latitude;
  double longitude;

  Geolocation({
    required this.latitude,
    required this.longitude,
  }) : super();

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
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class SignalStrength extends SensorData {
  int rssi;
  SignalStrength({required this.rssi}) : super();

  @override
  Function get fromJsonFunction => _$SignalStrengthFromJson;
  factory SignalStrength.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as SignalStrength;
  @override
  Map<String, dynamic> toJson() => _$SignalStrengthToJson(this);
}

/// Step count data as number of steps taken in a corresponding time interval.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class StepCount extends SensorData {
  int steps;
  StepCount(this.steps) : super();

  @override
  Function get fromJsonFunction => _$StepCountFromJson;
  factory StepCount.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as StepCount;
  @override
  Map<String, dynamic> toJson() => _$StepCountToJson(this);
}

/// Heart rate data in beats per minute ([bpm]).
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class HeartRate extends SensorData {
  int bpm;
  HeartRate({required this.bpm}) : super();

  @override
  Function get fromJsonFunction => _$HeartRateFromJson;
  factory HeartRate.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as HeartRate;
  @override
  Map<String, dynamic> toJson() => _$HeartRateToJson(this);
}

/// Electrocardiogram data of a single lead.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class ECG extends SensorData {
  double milliVolt;
  ECG({required this.milliVolt}) : super();

  @override
  Function get fromJsonFunction => _$ECGFromJson;
  factory ECG.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as ECG;
  @override
  Map<String, dynamic> toJson() => _$ECGToJson(this);
}

/// Single-channel electrodermal activity (EDA) data, represented as skin conductance.
/// Among others, also known as galvanic skin response (GSR) or skin conductance response/level.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class EDA extends SensorData {
  double microSiemens;
  EDA({required this.microSiemens}) : super();

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
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class CompletedTask extends Data {
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
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class TriggeredTask extends Data {
  int triggerId;
  String taskName;
  String destinationDeviceRoleName;
  TaskControl control;
  Data? triggerData;

  TriggeredTask({
    required this.triggerId,
    required this.taskName,
    required this.destinationDeviceRoleName,
    required this.control,
    this.triggerData,
  }) : super();
}
