part of mobile_sensing_app;

class ProbesModel {
  List<ProbeModel> _probes = [];
  List<ProbeModel> get probes => _probes;
}

class ProbeModel {
  Probe probe;
  String get type => probe.type;
  Measure get measure => probe.measure;
  ProbeState get state => probe.state;
  Stream<ProbeState> get stateEvents => probe.stateEvents;

  ///A printer-friendly name for this probe.
  String get name => probe.name;

  ///A printer-friendly description of this probe.
  String get description => ((probe.measure as CAMSMeasure).description != null)
      ? (probe.measure as CAMSMeasure).description
      : ProbeDescription.probeTypeDescription[type];

  /// The icon for this type of probe.
  Icon get icon => ProbeDescription.probeTypeIcon[type];

  /// The icon for the runtime state of this probe.
  Icon get stateIcon => ProbeDescription.probeStateIcon[state];

  ProbeModel(this.probe)
      : assert(probe != null,
            'A ProbeModel must be initialized with a real Probe.'),
        super();
}

probeStateLabel(ProbeState state) {
  switch (state) {
    case ProbeState.initialized:
      return "Initialized";
    case ProbeState.created:
      return "Created";
    case ProbeState.resumed:
      return "Resumed";
    case ProbeState.paused:
      return "Paused";
    case ProbeState.stopped:
      return "Stopped";
    case ProbeState.undefined:
      return "Undefined";
  }
}
