part of mobile_sensing_app;

class ProbesBloc {
  bool get isRunning => (sensing.controller != null) ? sensing.controller.executor.state == ProbeState.resumed : false;
  Iterable<ProbeModel> get runningProbes => sensing.runningProbes.map((probe) => ProbeModel(probe));

  Stream<ProbeState> get studyExecutorStateEvents => sensing.controller.executor.stateEvents;
  ProbeState get studyState => sensing.controller.executor.state;
  StudyModel get study => sensing.study != null ? StudyModel(sensing.study) : null;
  Stream<Datum> get samplingEvents => sensing.controller.events;
  int get samplingSize => sensing.controller.samplingSize;

  void init() async {}

  void start() async {
    sensing.start();
  }

  void pause() {
    sensing.controller.pause();
  }

  void resume() async {
    sensing.controller.resume();
  }

  void stop() async {
    sensing.stop();
  }

  void dispose() async {
    sensing.stop();
  }
}

final bloc = ProbesBloc();
