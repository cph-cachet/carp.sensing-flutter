part of mobile_sensing_app;

class StudyModel {
  Study study;

  String get name => study.name;
  String get description => study.description ?? 'No description available.';
  Image get image => Image.asset('assets/study.png');
  String get userID => study.userId;
  String get samplingStrategy => study.samplingStrategy;
  String get dataEndpoint => study.dataEndPoint.toString();

  /// Events on the state of the study executor
  Stream<ProbeState> get studyExecutorStateEvents => Sensing().controller.executor.stateEvents;

  /// Current state of the study executor (e.g., resumed, paused, ...)
  ProbeState get studyState => Sensing().controller.executor.state;

  /// Get all sesing events (i.e. all [Datum] objects being collected).
  Stream<Datum> get samplingEvents => Sensing().controller.events;

  /// The total sampling size so far since this study was started.
  int get samplingSize => Sensing().controller.samplingSize;

  StudyModel(this.study)
      : assert(study != null, 'A StudyModel must be initialized with a real Study.'),
        super();
}
