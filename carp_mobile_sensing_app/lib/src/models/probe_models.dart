part of mobile_sensing_app;

class ProbesModel {
  List<ProbeModel> _probes = [];
  List<ProbeModel> get probes => _probes;
}

class ProbeModel {
  Probe probe;
  String get type => probe.measure.type.name;
  Measure get measure => probe.measure;
  bool get isRunning => probe.isRunning;

  ///A printer-friendly name for this probe.
  String get name => probe.name;

  ///A printer-friendly description of this probe.
  String get description => ProbeRegistry.probeTypeDescription[type];

  ProbeModel(this.probe)
      : assert(probe != null, 'A ProbeModel must be initialized with a real Probe.'),
        super();
}
