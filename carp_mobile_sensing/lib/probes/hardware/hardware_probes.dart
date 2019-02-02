/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of hardware;

/// Listens to screen actions which are: SCREEN ON/OFF/UNLOCK which are stored as a [ScreenDatum].
//class ScreenProbe extends StreamProbe {
//  ScreenProbe(Measure measure) : super(measure, screenStream);
//}
class ScreenProbe extends StreamProbe {
  ScreenProbe() : super(screenStream);
}

Stream<Datum> get screenStream => Screen().screenStateEvents.map((event) => ScreenDatum.fromScreenStateEvent(event));

///// A polling probe that collects free virtual memory on a regular basis
///// as specified in [PeriodicMeasure.frequency].
//class MemoryPollingProbe extends PeriodicDatumProbe {
//  MemoryPollingProbe(PeriodicMeasure measure) : super(measure);
//
//  Future<Datum> getDatum() async {
//    return FreeMemoryDatum()
//      ..freePhysicalMemory = SysInfo.getFreePhysicalMemory()
//      ..freeVirtualMemory = SysInfo.getFreeVirtualMemory();
//  }
//}
//
///// A probe that collects the device info about this device.
///// Only collects this information once when the [getDatum] method is called.
//class DeviceProbe extends DatumProbe {
//  DeviceProbe(Measure measure) : super(measure);
//
//  Future<Datum> getDatum() async {
//    return DeviceDatum(Device.platform, Device.deviceID,
//        deviceName: Device.deviceName,
//        deviceModel: Device.deviceModel,
//        deviceManufacturer: Device.deviceManufacturer,
//        operatingSystem: Device.operatingSystem,
//        hardware: Device.hardware);
//  }
//}

/// A polling probe that collects free virtual memory on a regular basis
/// as specified in [PeriodicMeasure.frequency].
class MemoryPollingProbe extends PeriodicDatumProbe2 {
  MemoryPollingProbe() : super();

  Future<Datum> getDatum() async {
    return FreeMemoryDatum()
      ..freePhysicalMemory = SysInfo.getFreePhysicalMemory()
      ..freeVirtualMemory = SysInfo.getFreeVirtualMemory();
  }
}

/// A probe that collects the device info about this device.
/// Only collects this information once when the [getDatum] method is called.
class DeviceProbe extends DatumProbe {
  DeviceProbe() : super();

  Future<Datum> getDatum() async {
    return DeviceDatum(Device.platform, Device.deviceID,
        deviceName: Device.deviceName,
        deviceModel: Device.deviceModel,
        deviceManufacturer: Device.deviceManufacturer,
        operatingSystem: Device.operatingSystem,
        hardware: Device.hardware);
  }
}
