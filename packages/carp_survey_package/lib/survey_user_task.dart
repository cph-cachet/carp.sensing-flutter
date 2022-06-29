/*
 * Copyright 2020 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of survey;

/// A [UserTask] that contains a survey.
///
/// A [SurveyUserTask] is enqued on the [AppTaskController]'s [userTaskQueue]
/// and can be accessed from here. When a user starts this user task, the
/// [onStart] method is called, and the survey (a [RPTask]) is shown.
class SurveyUserTask extends UserTask {
  static const String SURVEY_TYPE = 'survey';
  static const String COGNITIVE_ASSESSMENT_TYPE = 'cognition';
  static const String DEMOGRAPHIC_SURVEY_TYPE = 'demographic';
  static const String WHO5_SURVEY_TYPE = 'who5';

  late BuildContext _context;
  final _controller = StreamController<DataPoint>();

  /// The [RPAppTask] from which this user task originates from.
  RPAppTask get rpAppTask => task as RPAppTask;

  SurveyUserTask(super.executor);

  void onStart(BuildContext context) {
    // saving the build context for later use
    _context = context;

    super.onStart(context);
    executor.group.add(_controller.stream);
    executor.resume();

    _onSurveyTriggered(SurveyPage(
      task: rpAppTask.rpTask,
      resultCallback: _onSurveySubmit,
      onSurveyCancel: _onSurveyCancel,
    ));
  }

  void _onSurveyTriggered(SurveyPage surveyPage) {
    Navigator.push(
      _context,
      MaterialPageRoute(builder: (context) => surveyPage),
    );
  }

  void _onSurveySubmit(RPTaskResult result) {
    executor.pause();
    // when we have the survey result, add it to the data stream
    _controller.add(DataPoint.fromData(RPTaskResultDatum(result)));
    super.onDone(_context);
  }

  void _onSurveyCancel([RPTaskResult? result]) {
    executor.pause();
    // also saved result even though it was canceled by the user
    _controller.add(DataPoint.fromData(RPTaskResultDatum(result)));
    super.onCancel(_context);
  }
}

class SurveyUserTaskFactory implements UserTaskFactory {
  List<String> types = [
    SurveyUserTask.WHO5_SURVEY_TYPE,
    SurveyUserTask.SURVEY_TYPE,
    SurveyUserTask.COGNITIVE_ASSESSMENT_TYPE,
    SurveyUserTask.DEMOGRAPHIC_SURVEY_TYPE,
  ];

  // always create a [SurveyUserTask]
  UserTask create(AppTaskExecutor executor) => SurveyUserTask(executor);
}
