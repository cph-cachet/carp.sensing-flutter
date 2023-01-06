/*
 * Copyright 2020-2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of survey;

/// Specify the configuration of a [RPTask] as a special case of an [AppTask].
/// This can be a survey, a cognitive test, or other tasks that implements the
/// [RPTask] from the Research Package.
///
/// A [RPAppTask] holding a survey can then be triggered in different
/// ways. For example:
///
///  * a [PeriodicTrigger] would trigger the survey on a regular basis.
///  * a [RecurrentScheduledTrigger] would schedule a recurrent survey, e.g every Monday at 8pm.
///
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class RPAppTask extends AppTask {
  /// The survey to be issued to the user.
  RPTask rpTask;

  RPAppTask({
    super.name,
    super.measures,
    required super.type,
    super.title,
    super.description,
    super.instructions,
    super.minutesToComplete,
    super.expire,
    super.notification,
    required this.rpTask,
  });

  @override
  Function get fromJsonFunction => _$RPAppTaskFromJson;

  @override
  Map<String, dynamic> toJson() => _$RPAppTaskToJson(this);
  factory RPAppTask.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as RPAppTask;
}

/// Holds information about the result of a survey.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class RPTaskResultData extends Data {
  static const dataType = SurveySamplingPackage.SURVEY;

  // The survey result.
  RPTaskResult? surveyResult;

  RPTaskResultData([this.surveyResult]);

  factory RPTaskResultData.fromJson(Map<String, dynamic> json) =>
      _$RPTaskResultDataFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$RPTaskResultDataToJson(this);
  @override
  String get jsonType => dataType;
}
