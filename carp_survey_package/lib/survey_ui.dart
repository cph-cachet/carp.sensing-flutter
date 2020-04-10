part of survey;

class SurveyPage extends StatelessWidget {
  /// The task to present
  final RPTask task;

  /// The callback function which has to return an [RPTaskResult] object.
  void Function(RPTaskResult) resultCallback;

  SurveyPage(this.task, this.resultCallback) : super() {}

  Widget build(BuildContext context) {
    return RPUITask(
      task: task,
      onSubmit: (result) {
        resultCallback(result);
      },
    );
  }
}
