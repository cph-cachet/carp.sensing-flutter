/*
 * Copyright 2020 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of survey;

/// A [UserTask] that contains a survey.
///
/// A [SurveyUserTask] is enqueued on the [AppTaskController]'s [userTaskQueue]
/// and can be accessed from here. When a user starts this user task, the
/// [onStart] method is called, and the survey (a [RPTask]) is shown.
class SurveyUserTask extends UserTask {
  static const String SURVEY_TYPE = 'survey';
  static const String COGNITIVE_ASSESSMENT_TYPE = 'cognition';
  static const String INFORMED_CONSENT_TYPE = 'informed_consent';

  // late BuildContext _context;
  final _controller = StreamController<Measurement>();

  /// The [RPAppTask] from which this user task originates from.
  RPAppTask get rpAppTask => task as RPAppTask;

  @override
  bool get hasWidget => true;

  SurveyUserTask(super.executor);

  @override
  Widget? get widget => SurveyPage(
        task: rpAppTask.rpTask,
        resultCallback: _onSurveySubmit,
        onSurveyCancel: _onSurveyCancel,
      );

  @override
  void onStart() {
    super.onStart();
    executor.group.add(_controller.stream);
    executor.start();
  }

  void _onSurveySubmit(RPTaskResult result) {
    executor.stop();
    // when we have the survey result, add it to the data stream
    _controller.add(Measurement.fromData(RPTaskResultData(result)));
    super.onDone();
  }

  void _onSurveyCancel([RPTaskResult? result]) {
    executor.stop();
    // also saved result even though it was canceled by the user
    _controller.add(Measurement.fromData(RPTaskResultData(result)));
    super.onCancel();
  }
}

class SurveyUserTaskFactory implements UserTaskFactory {
  @override
  List<String> types = [
    SurveyUserTask.INFORMED_CONSENT_TYPE,
    SurveyUserTask.SURVEY_TYPE,
    SurveyUserTask.COGNITIVE_ASSESSMENT_TYPE,
  ];

  // always create a [SurveyUserTask]
  @override
  UserTask create(AppTaskExecutor executor) => SurveyUserTask(executor);
}
