/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of runtime;

// TODO : change probes to use Dart Isolates in order to support dynamic class loading (and isolation).
// Right now registration of probes has to be done manually.
// Later this will be implemented using Dart Isolates.
// HOWEVER, Dart isolates do not support calling a platform channel method from
// another isolate.
// See issue #13937 >> https://github.com/flutter/flutter/issues/13937

/// The [ProbeRegistry] can create, register, and lookup an instance of a relevant probe
/// based on its [CAMSDataType].
class ProbeRegistry {
  static final ProbeRegistry _instance = ProbeRegistry._();
  ProbeRegistry._();

  /// Get the singleton [ProbeRegistry].
  factory ProbeRegistry() => _instance;

  final Map<String, Set<Probe>> _probes = {};

  /// All running probes mapped according to their [CAMSDataType].
  Map<String, Set<Probe>> get probes => _probes;

  final StreamGroup<Datum> _group = StreamGroup.broadcast();

  /// A stream of all events from all probes.
  Stream<Datum> get events => _group.stream;

  /// A stream of all events from probes of a specific [CAMSDataType].
  Stream<Datum> eventsByType(String type) =>
      _group.stream.where((Datum datum) => datum.format.name == type);

  /// If you create a probe manually, i.e. outside of the [ProbeRegistry]
  /// you can register it here.
  void register(String type, Probe probe) {
    _probes[type] ??= {};
    _probes[type].add(probe);
  }

  /// Lookup a set of [Probe]s based on its [CAMSDataType].
  Set<Probe> lookup(String type) => _probes[type] ?? create(type);

  /// Create an instance of a probe based on the measure.
  ///
  /// This methods search the [SamplingPackageRegistry] for a [SamplingPackage]
  /// which has a probe of the specified [type].
  Probe create(String type) {
    Probe _probe;

    SamplingPackageRegistry().packages.forEach((package) {
      if (package.dataTypes.contains(type)) {
        _probe = package.create(type);
      }
    });

    if (_probe != null) {
      register(type, _probe);
      _group.add(_probe.events);
    }
    return _probe;
  }
}
