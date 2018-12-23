/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of hardware;

/// A polling probe that collects free virtual memory on a regular basis
/// as specified in [PeriodicMeasure.frequency].
class MemoryPollingProbe extends PollingProbe {
  /// A [MemoryPollingProbe] is a polling probe and takes a [PeriodicMeasure] as configuration.
  MemoryPollingProbe(PeriodicMeasure measure) : super(measure);

  Stream<Datum> get stream => null;

  @override
  Future<Datum> getDatum() async {
    return FreeMemoryDatum(measure: measure)
      ..freePhysicalMemory = SysInfo.getFreePhysicalMemory()
      ..freeVirtualMemory = SysInfo.getFreeVirtualMemory();
  }
}
