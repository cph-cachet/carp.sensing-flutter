part of mobile_sensing_app;

class ProbesModel {
  List<ProbeModel> _probes = [];
  List<ProbeModel> get probes => _probes;
}

class ProbeModel {
  Probe probe;
  String get type => probe.type;
  Measure get measure => probe.measure;
  ProbeStateType get state => probe.state.type;
  //int get length async => await probe.events.length;
  Stream<ProbeStateType> get stateEvents => probe.stateEvents;

  ///A printer-friendly name for this probe.
  String get name => probe.name;

  ///A printer-friendly description of this probe.
  String get description => ProbeDescription.probeTypeDescription[type];

  /// The icon for this type of probe.
  Icon get icon => ProbeDescription.probeTypeIcon[type];

  /// The icon for the runtime state of this probe.
  Icon get stateIcon => ProbeDescription.probeStateIcon[state];

  ProbeModel(this.probe)
      : assert(probe != null, 'A ProbeModel must be initialized with a real Probe.'),
        super();
}
