/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of hardware;

/// A polling probe that collects free virtual memory on a regular basis as specified in [PollingProbeMeasure.frequency].
class MemoryPollingProbe extends PollingProbe {
  MemoryPollingProbe(PollingProbeMeasure _measure) : super(_measure);

  @override
  Future<Datum> getDatum() async {
    FreeMemoryDatum _fmd = new FreeMemoryDatum();
    _fmd.freePhysicalMemory = SysInfo.getFreePhysicalMemory();
    _fmd.freeVirtualMemory = SysInfo.getFreeVirtualMemory();
    return _fmd;
  }
}
