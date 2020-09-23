part of mobile_sensing_app;

class SensingBLoC {
  //  CANS credentials
  final String username = "admin@cachet.dk";
  final String password = "admin";
  final String userId = "user@dtu.dk";
  final String uri = "https://cans.cachet.dk:443";
  final String clientID = "carp";
  final String clientSecret = "carp";

  final String testStudyId = "2";
  final String testStudyName = "iOS-testing-#2";

  final Sensing sensing = Sensing();
  final StudyManager manager = LocalStudyManager();

  Study _study;
  Study get study => _study;

  SurveyPage surveyPage;

  /// Is sensing running, i.e. has the study executor been resumed?
  bool get isRunning => (sensing.controller != null) && sensing.controller.executor.state == ProbeState.resumed;

  /// Get the study for this app.
  StudyModel get studyModel => study != null ? StudyModel(study) : null;

  /// Get a list of running probes
  Iterable<ProbeModel> get runningProbes => sensing.runningProbes.map((probe) => ProbeModel(probe));

  /// Get the data model for this study.
  DataModel get data => null;

  void init() async {
    // set global debug level
    globalDebugLevel = DebugLevel.DEBUG;

    _study ??= await manager.getStudy(testStudyId);

    debug('Study : $study');

    // creating a CarpApp, configuring the CarpService, and authenticate the user
    CarpApp app = new CarpApp(
        study: study,
        name: "Test",
        uri: Uri.parse(uri),
        oauth: OAuthEndPoint(clientID: clientID, clientSecret: clientSecret));

    debug('CarpApp : $app');

    CarpService.configure(app);
    CarpUser user = await CarpService.instance.authenticate(username: username, password: password);
    debug('Signed in user - $user');

    await sensing.init();
  }

  void resume() async => sensing.controller.resume();

  void pause() => sensing.controller.pause();

  void stop() async => sensing.stop();

  void dispose() async => sensing.stop();

  void onSurveyTriggered(SurveyPage surveyPage) => this.surveyPage = surveyPage;

  void onSurveySubmit(RPTaskResult result) => this.surveyPage = null;
}

final bloc = SensingBLoC();
