part of mobile_sensing_app;

/// A view model for a [Probe].
class ProbeViewModel {
  Probe probe;
  String? get type => probe.type;
  Measure? get measure => probe.measure;
  ExecutorState get state => probe.state;
  Stream<ExecutorState> get stateEvents => probe.stateEvents;

  ///A printer-friendly name for this probe.
  String? get name => ProbeDescription.descriptors[type]?.name;

  ///A printer-friendly description of this probe.
  String? get description => ProbeDescription.descriptors[type]?.description;

  /// The icon for this type of probe.
  Icon? get icon => ProbeDescription.probeTypeIcon[type];

  /// The icon for the runtime state of this probe.
  Icon? get stateIcon => ProbeDescription.probeStateIcon[state];

  ProbeViewModel(this.probe) : super();
}
