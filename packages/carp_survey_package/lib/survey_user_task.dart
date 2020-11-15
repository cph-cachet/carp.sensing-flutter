/*
 * Copyright 2020 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of survey;

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
    _surveyProbe.onSurveyTriggered = onSurveyTriggered;
    _surveyProbe.onSurveySubmit = onSurveySubmit;

    super.onStart(context);
    executor?.resume();
  }

  void onSurveyTriggered(SurveyPage surveyPage) {
    Navigator.push(
      _context,
      MaterialPageRoute(builder: (context) => surveyPage),
    );
  }

  void onSurveySubmit(RPTaskResult result) {
    executor?.pause();
    super.onDone(_context);
  }
}
