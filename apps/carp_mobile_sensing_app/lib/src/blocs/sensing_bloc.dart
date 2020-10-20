part of mobile_sensing_app;

class SensingBLoC {
  //  User credentials
  final String username = "user";
  final String password = "...";
  final String userId = "user@cachet.dk";
  final String uri = "https://cans.cachet.dk:443";
  final String testStudyId = "#16 - coverage :: using geolocator package";

  final Sensing sensing = Sensing();
  final StudyManager manager = LocalStudyManager();

  Study _study;
  Study get study => _study;

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
    await sensing.init();
  }

  void resume() async => sensing.controller.resume();
  void pause() => sensing.controller.pause();
  void stop() async => sensing.stop();
  void dispose() async => sensing.stop();
}

final bloc = SensingBLoC();
