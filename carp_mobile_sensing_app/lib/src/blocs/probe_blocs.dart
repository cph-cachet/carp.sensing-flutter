part of mobile_sensing_app;

class ProbesBloc {
  final Sensing _sensing = Sensing();
  final _probesFetcher = PublishSubject<ProbeModel>();

  Observable<ProbeModel> get runningProbes => _probesFetcher.stream;

  init() async {
    await _sensing.start();
    _sensing.runningProbes.forEach((key, probe) => _probesFetcher.sink.add(ProbeModel(probe)));
  }

  dispose() {
    _sensing.stop();
    _probesFetcher.close();
  }
}

final bloc = ProbesBloc();
