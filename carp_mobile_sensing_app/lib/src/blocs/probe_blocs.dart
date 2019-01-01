part of mobile_sensing_app;

class ProbesBloc {
  final Sensing _sensing = Sensing();
  final _probesFetcher = PublishSubject<ProbeModel>();

  bool get isRunning => _sensing.executor.isRunning;

  //Observable<ProbeModel> get runningProbes => _probesFetcher.stream;
  Iterable<ProbeModel> get runningProbes => _sensing.runningProbes.values.map((probe) => ProbeModel(probe));

  void init() async {
//    await _sensing.start();
//    _sensing.runningProbes.forEach((key, probe) => _probesFetcher.sink.add(ProbeModel(probe)));
  }

  void start() async {
    await _sensing.start();
    //_sensing.runningProbes.forEach((key, probe) => _probesFetcher.sink.add(ProbeModel(probe)));
  }

  void pause() {
    _sensing.executor.pause();
  }

  void resume() async {
    _sensing.executor.resume();
  }

  void stop() async {
    await _sensing.stop();
  }

  void dispose() async {
    await _sensing.stop();
    _probesFetcher.close();
  }
}

final bloc = ProbesBloc();
