/*
 * Copyright 2020 Copenhagen Center for Health Technology (CACHET) at the
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
    required String type,
    String? name,
    String title = '',
    String description = '',
    String instructions = '',
    int? minutesToComplete,
    Duration? expire,
    bool notification = false,
    required this.rpTask,
  }) : super(
          type: type,
          name: name,
          title: title,
          description: description,
          instructions: instructions,
          minutesToComplete: minutesToComplete,
          expire: expire,
          notification: notification,
        );

  Function get fromJsonFunction => _$RPAppTaskFromJson;
  Map<String, dynamic> toJson() => _$RPAppTaskToJson(this);
  factory RPAppTask.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as RPAppTask;
}

/// Holds information about the result of a survey.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class RPTaskResultDatum extends Datum {
  DataFormat get format => DataFormat.fromString(SurveySamplingPackage.SURVEY);

  RPTaskResult? surveyResult;

  RPTaskResultDatum([this.surveyResult]);

  factory RPTaskResultDatum.fromJson(Map<String, dynamic> json) =>
      _$RPTaskResultDatumFromJson(json);
  Map<String, dynamic> toJson() => _$RPTaskResultDatumToJson(this);
}
