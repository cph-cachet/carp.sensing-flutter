part of mobile_sensing_app;

class ProbesBloc {
  final Sensing _sensing = Sensing();
  final _probesFetcher = PublishSubject<ProbeModel>();

  Stream<ProbeStateType> get stateChanges => _sensing.manager.executor.stateEvents;

  bool get isRunning =>
      (_sensing.manager != null) ? _sensing.manager.executor.state.type == ProbeStateType.resumed : false;

  //Observable<ProbeModel> get runningProbes => _probesFetcher.stream;
  Iterable<ProbeModel> get runningProbes => _sensing.runningProbes.map((probe) => ProbeModel(probe));
  //Observable<Iterable<ProbeModel>> get runningProbes => _sensing.runningProbes.values.map((probe) => ProbeModel(probe));

  void init() async {
//    await _sensing.start();
//    _sensing.runningProbes.forEach((key, probe) => _probesFetcher.sink.add(ProbeModel(probe)));
  }

  void start() async {
    await _sensing.start();
    //_sensing.runningProbes.forEach((key, probe) => _probesFetcher.sink.add(ProbeModel(probe)));
  }

  void pause() {
    _sensing.manager.pause();
  }

  void resume() async {
    _sensing.manager.resume();
  }

  void stop() async {
    _sensing.stop();
  }

  void dispose() async {
    _sensing.stop();
    _probesFetcher.close();
  }
}

final bloc = ProbesBloc();
