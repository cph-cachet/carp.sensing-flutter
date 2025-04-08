/*
 * Copyright 2018-2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of '../domain.dart';

/// A [Data] object holding a link to a file.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class FileData extends Data {
  static const dataType = CAMSDataType.FILE_TYPE_NAME;

  /// The local path to the attached file on the phone where it is sampled.
  /// This is used by e.g. a data manager to get and manage the file on
  /// the phone.
  // @JsonKey(includeFromJson: false, includeToJson: false)
  String? path;

  /// The name to the attached file.
  String filename;

  /// Should the file also be uploaded, or only this meta data?
  /// Default is true.
  bool upload = true;

  /// Metadata for this file as a map of string key-value pairs.
  Map<String, String>? metadata = <String, String>{};

  /// Create a new [FileData] based the file path and whether it is
  /// to be uploaded or not.
  FileData({required this.filename, this.upload = true}) : super();

  @override
  Function get fromJsonFunction => _$FileDataFromJson;
  factory FileData.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson<FileData>(json);
  @override
  Map<String, dynamic> toJson() => _$FileDataToJson(this);
}

/// Reflects a heart beat data send every [period] minute.
/// Useful for calculating sampling coverage over time.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class Heartbeat extends Data {
  static const dataType = '${CarpDataTypes.CARP_NAMESPACE}.heartbeat';

  /// The period of heartbeats per minute.
  int period;

  /// The type of device.
  String deviceType;

  /// The role name of the device in the protocol.
  String deviceRoleName;

  Heartbeat({
    required this.period,
    required this.deviceType,
    required this.deviceRoleName,
  }) : super();

  @override
  Function get fromJsonFunction => _$HeartbeatFromJson;
  factory Heartbeat.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson<Heartbeat>(json);
  @override
  Map<String, dynamic> toJson() => _$HeartbeatToJson(this);
}

/// Data about an [AppTask] that has been completed.
///
/// [taskType] indicates the type of task completed.
/// [taskData] holds the result of the task, or null if no result is collected.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class CompletedAppTask extends CompletedTask {
  static const dataType = '${CarpDataTypes.CARP_NAMESPACE}.completed_app_task';

  /// The name of the task which was completed.
  /// This is the name of the task as specified in the study protocol.
  String taskName;

  /// The type of task which was completed, if specified.
  ///
  /// Known types are:
  ///  - informed_consent - a task collecting informed consent from the user
  ///  - survey - a survey task
  ///  - cognition - a cognitive assessment task
  ///  - audio - an audio task
  ///  - video - a video task
  ///  - image - an image task
  ///  - health - a task collecting health data
  ///  - sensing - a task collecting sensing data continuously
  ///  - one_time_sensing - a task collecting sensing data once
  String? taskType;

  /// The result of the completed task, if any.
  Data? taskData;

  CompletedAppTask({
    required super.taskName,
    this.taskType,
    super.taskData,
  }) : super();

  @override
  Function get fromJsonFunction => _$CompletedAppTaskFromJson;
  factory CompletedAppTask.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson<CompletedAppTask>(json);
  @override
  Map<String, dynamic> toJson() => _$CompletedAppTaskToJson(this);
}
