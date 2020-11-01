part of mobile_sensing_app;

class SensingBLoC {
  //  User credentials
  final String username = "user";
  final String password = "...";
  final String userId = "user@cachet.dk";
  final String uri = "https://cans.cachet.dk:443";
  final String testStudyId = "#18 - activity recognition";

  Study _study;
  Study get study => _study;

  /// Is sensing running, i.e. has the study executor been resumed?
  bool get isRunning => (Sensing().controller != null) && Sensing().controller.executor.state == ProbeState.resumed;

  /// Get the study for this app.
  StudyModel get studyModel => study != null ? StudyModel(study) : null;

  /// Get a list of running probes
  Iterable<ProbeModel> get runningProbes => Sensing().runningProbes.map((probe) => ProbeModel(probe));

  /// Get the data model for this study.
  DataModel get data => null;

  void init() async {
    // set global debug level
    globalDebugLevel = DebugLevel.DEBUG;
    _study ??= await Sensing().getStudy(testStudyId);
    debug('Study : $study');
    await Sensing().initialize();
  }

  void resume() async => Sensing().controller.resume();
  void pause() => Sensing().controller.pause();
  void stop() async => Sensing().controller.stop();
  void dispose() async => Sensing().controller.stop();
}

final bloc = SensingBLoC();
