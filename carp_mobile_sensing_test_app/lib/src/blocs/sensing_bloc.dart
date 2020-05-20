part of mobile_sensing_app;

class SensingBLoC {
  final Sensing sensing = Sensing();
  SurveyPage surveyPage;

  /// Is sensing running, i.e. has the study executor been resumed?
  bool get isRunning => (sensing.controller != null) && sensing.controller.executor.state == ProbeState.resumed;

  /// Get the study for this app.
  StudyModel get study => sensing.study != null ? StudyModel(sensing.study) : null;

  /// Get a list of running probes
  Iterable<ProbeModel> get runningProbes => sensing.runningProbes.map((probe) => ProbeModel(probe));

  /// Get the data model for this study.
  DataModel get data => null;

  void init() async => await sensing.init();

  void resume() async => sensing.controller.resume();

  void pause() => sensing.controller.pause();

  void stop() async => sensing.stop();

  void dispose() async => sensing.stop();

  void onSurveyTriggered(SurveyPage surveyPage) => this.surveyPage = surveyPage;

  void onSurveySubmit(RPTaskResult result) => this.surveyPage = null;
}

final bloc = SensingBLoC();
