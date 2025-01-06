part of 'survey.dart';

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
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class RPAppTask extends AppTask {
  /// The survey to be issued to the user.
  RPTask rpTask;

  RPAppTask({
    super.name,
    List<Measure>? measures,
    required super.type,
    super.title,
    super.description,
    super.instructions,
    super.minutesToComplete,
    super.expire,
    super.notification,
    required this.rpTask,
  }) {
    // Add the survey as a measure type to be collected and later uploaded
    //   - issue #342
    super.measures = (measures ?? [])
      ..add(Measure(type: SurveySamplingPackage.SURVEY));
  }

  @override
  Function get fromJsonFunction => _$RPAppTaskFromJson;
  factory RPAppTask.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson<RPAppTask>(json);

  @override
  Map<String, dynamic> toJson() => _$RPAppTaskToJson(this);
}

/// The status of a finished survey.
enum SurveyStatus { unknown, submitted, canceled }

/// Holds information about the result of a survey.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class RPTaskResultData extends Data {
  static const dataType = SurveySamplingPackage.SURVEY;

  /// The status of [result] (was the survey submitted or canceled?)
  /// When a survey is canceled, [result] holds the data inputted by the user
  /// until it was canceled.
  SurveyStatus status;

  // The survey result.
  RPTaskResult? result;

  RPTaskResultData([this.status = SurveyStatus.unknown, this.result]);

  @override
  Function get fromJsonFunction => _$RPTaskResultDataFromJson;
  factory RPTaskResultData.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson<RPTaskResultData>(json);

  @override
  Map<String, dynamic> toJson() => _$RPTaskResultDataToJson(this);

  @override
  String get jsonType => dataType;
}
