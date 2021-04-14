/*
 * Copyright 2020 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of survey;

/// A class representing how to configure a [RPTask] survey as a sensing [Measure].
///
/// This measure should be part of an [AppTask] in order for the app to handle
/// how it wants to show the survey to the user.
/// Note that only the first [RPTaskMeasure] in an [AppTask] is used.
/// Hence, an [AppTask] should be used for each survey.
///
/// The app task holding a survey measure can then be triggered in different ways.
/// For example:
///
///  * a [PeriodicTrigger] would allow to collect the survey on a regular basis (frequency)
///  * a [ScheduledTrigger] can be used to trigger the survey at a specific schedule (i.e., day and time)
///  * a [RecurrentScheduledTrigger] allow to schedule a recurrent survey, e.g every Monday at 8pm.
///
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class RPTaskMeasure extends CAMSMeasure {
  // TODO - remove when research_package supports serialization
  /// The survey to be issued to the user.
  @JsonKey(ignore: true)
  RPTask surveyTask;

  RPTaskMeasure({
    @required String type,
    String name,
    String description,
    bool enabled,
    this.surveyTask,
  }) : super(
          type: type,
          name: name,
          description: description,
          enabled: enabled,
        );

  Function get fromJsonFunction => _$RPTaskMeasureFromJson;
  factory RPTaskMeasure.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json);
  Map<String, dynamic> toJson() => _$RPTaskMeasureToJson(this);
}

/// Holds information about the result of a survey.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class RPTaskResultDatum extends Datum {
  DataFormat get format => DataFormat.fromString(SurveySamplingPackage.SURVEY);

  RPTaskResult surveyResult;

  RPTaskResultDatum([this.surveyResult]);

  factory RPTaskResultDatum.fromJson(Map<String, dynamic> json) =>
      _$RPTaskResultDatumFromJson(json);
  Map<String, dynamic> toJson() => _$RPTaskResultDatumToJson(this);
}
