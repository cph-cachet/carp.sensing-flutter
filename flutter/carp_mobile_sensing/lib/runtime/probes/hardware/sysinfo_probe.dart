/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
import 'dart:async';
import 'package:system_info/system_info.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';

/// A simple polling probe that collects free virtual memory on a regular basis
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

/// A simple probe that collects the user id and name of the current user from the OS.
class UserProbe extends DatumProbe {
  UserProbe(_measure) : super(_measure);

  @override
  Future<Datum> getDatum() async {
    UserDatum _ud = new UserDatum();
    _ud.userId = SysInfo.userId;
    _ud.userName = SysInfo.userName;

    return _ud;
  }
}
