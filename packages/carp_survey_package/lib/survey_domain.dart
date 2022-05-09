/*
 * Copyright 2020 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of survey;

/// Specify the configuration of a [RPTask] survey.
///
/// This configuration is typically used as the `overrideSamplingConfiguration``
/// in a [Measure]. Such a measure should be part of an [AppTask] in order for
/// the app to handle how it wants to show the survey to the user.
/// Note that only the first [RPTaskMeasure] in an [AppTask] is used.
/// Hence, an [AppTask] should be used for each survey.
///
/// The app task holding a survey measure can then be triggered in different ways.
/// For example:
///
///  * a [PeriodicTrigger] would allow to collect the survey on a regular basis (frequency)
///  * a [RecurrentScheduledTrigger] allow to schedule a recurrent survey, e.g every Monday at 8pm.
///
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class RPTaskSamplingConfiguration extends PersistentSamplingConfiguration {
  /// The survey to be issued to the user.
  RPTask surveyTask;

  RPTaskSamplingConfiguration({required this.surveyTask}) : super();

  Function get fromJsonFunction => _$RPTaskSamplingConfigurationFromJson;
  Map<String, dynamic> toJson() => _$RPTaskSamplingConfigurationToJson(this);
  factory RPTaskSamplingConfiguration.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as RPTaskSamplingConfiguration;
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
