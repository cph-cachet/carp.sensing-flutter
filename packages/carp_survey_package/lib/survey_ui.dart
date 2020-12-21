part of survey;

/// A full-screen widget that shows a survey (a [RPTask]).
class SurveyPage extends StatelessWidget {
  /// The task to present
  final RPTask task;

  /// The callback function which has to return an [RPTaskResult] object.
  final void Function(RPTaskResult) resultCallback;

  /// The [RPTaskResult] is optional and can be null if no results were created.
  final void Function([RPTaskResult]) onSurveyCancel;

  SurveyPage(this.task, this.resultCallback, {this.onSurveyCancel}) : super();

  Widget build(BuildContext context) {
    return RPUITask(
      task: task,
      onSubmit: (result) {
        resultCallback(result);
      },
      onCancel: onSurveyCancel,
    );
  }
}
