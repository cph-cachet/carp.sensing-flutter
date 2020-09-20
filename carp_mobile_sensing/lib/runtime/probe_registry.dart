/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of runtime;

//TODO : change probes to use Dart Isolates in order to support dynamic class loading (and isolation).
// Right now registration of probes has to be done manually.
// Later this will be implemented using Dart Isolates.
// HOWEVER, Dart isolates do not support calling a platform channel method from a another isolate
// See issue #13937 >> https://github.com/flutter/flutter/issues/13937

/// The [ProbeRegistry] can create, register, and lookup an instance of a relevant probe
/// based on its [DataType].
class ProbeRegistry {
  static final Map<String, Probe> _probes = {};

  /// Returns a list of running probes.
  static Map<String, Probe> get probes => _probes;

  /// If you create a probe manually, i.e. outside of the [ProbeRegistry] you can register it here.
  static void register(String type, Probe probe) => _probes[type] = probe;

  /// Lookup a [Probe] based on its [DataType].
  static Probe lookup(String type) => _probes[type] ?? create(type);

  /// Create an instance of a probe based on the measure.
  ///
  /// This methods search the [SamplingPackageRegistry] for a [SamplingPackage] which
  /// has a probe of the specified [type].
  static Probe create(String type) {
    Probe _probe;

    SamplingPackageRegistry.packages.forEach((package) {
      if (package.dataTypes.contains(type)) {
        _probe = package.create(type);
      }
    });

    if (_probe != null) register(type, _probe);
    return _probe;
  }
}
