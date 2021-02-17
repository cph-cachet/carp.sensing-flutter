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
  static const String DEMOGRAPHIC_SURVEY_TYPE = 'demographic';
  static const String WHO5_SURVEY_TYPE = 'who5';

  BuildContext _context;
  SurveyProbe _surveyProbe;

  SurveyUserTask(AppTaskExecutor ex) : super(ex) {
    // looking for the survey probe (i.e. a [SurveyProbe]) in this executor
    // we need to add the callback functions to it later
    for (Probe probe in executor.probes) {
      if (probe is SurveyProbe) {
        _surveyProbe = probe;
        break; // only supports one survey pr. task
      }
    }
  }

  void onStart(BuildContext context) {
    // saving the build context for later use
    _context = context;
    _surveyProbe.onSurveyTriggered = _onSurveyTriggered;
    _surveyProbe.onSurveySubmit = _onSurveySubmit;
    _surveyProbe.onSurveyCancel = _onSurveyCancel;

    super.onStart(context);
    executor?.resume();
  }

  void _onSurveyTriggered(SurveyPage surveyPage) {
    Navigator.push(
      _context,
      MaterialPageRoute(builder: (context) => surveyPage),
    );
  }

  void _onSurveySubmit(RPTaskResult result) {
    executor?.pause();
    super.onDone(_context);
  }

  void _onSurveyCancel(RPTaskResult result) {
    executor?.pause();
    super.onCancel(_context);
  }
}

class SurveyUserTaskFactory implements UserTaskFactory {
  List<String> types = [
    SurveyUserTask.WHO5_SURVEY_TYPE,
    SurveyUserTask.SURVEY_TYPE,
    SurveyUserTask.DEMOGRAPHIC_SURVEY_TYPE,
  ];

  // always create a [SurveyUserTask]
  UserTask create(AppTaskExecutor executor) => SurveyUserTask(executor);
}
