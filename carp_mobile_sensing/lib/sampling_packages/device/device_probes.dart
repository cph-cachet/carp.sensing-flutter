/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of device;

/// The [BatteryProbe] listens to the hardware battery and collect a [BatteryDatum]
/// every time the battery state changes. For example, battery level or charging mode.
class BatteryProbe extends StreamProbe {
  Stream<Datum> get stream {
    Battery battery = new Battery();
    StreamController<Datum> controller;
    StreamSubscription<BatteryState> subscription;

    void onData(state) async {
      try {
        int level = await battery.batteryLevel;
        Datum datum = BatteryDatum.fromBatteryState(level, state);
        controller.add(datum);
      } catch (error) {
        controller.addError(error);
      }
    }

    controller = StreamController<Datum>(
        onListen: () => subscription.resume(),
        onPause: () => subscription.pause(),
        onResume: () => subscription.resume(),
        onCancel: () => subscription.cancel());

    subscription = battery.onBatteryStateChanged
        .listen(onData, onError: (error) => controller.addError(error), onDone: () => controller.close());

    return controller.stream;
  }

  // Old stream implementation below. Did NOT comply to pause/resume/cancels events.
  // Hence reimplemented using a StreamController as done above.
  // Keeping the below as a WARNING for future implementation of probe event streams

  //Stream<Datum> get stream async* {
  //  await for (var state in battery.onBatteryStateChanged) {
  //    int level = await battery.batteryLevel;
  //    yield BatteryDatum.fromBatteryState(measure, level, state);
  //  }
  //}

}

/// A probe collecting screen events:
///  - SCREEN ON
///  - SCREEN OFF
///  - SCREEN UNLOCK
/// which are stored as a [ScreenDatum].
class ScreenProbe extends StreamProbe {
  Future<void> onInitialize(Measure measure) async {
    super.onInitialize(measure);
    // check if Screen is available (only available on Android)
    Screen().screenStateStream.first;
  }

  Stream<Datum> get stream => Screen().screenStateStream.map((event) => ScreenDatum.fromScreenStateEvent(event));
}

/// A probe that collects free virtual memory on a regular basis
/// as specified in [PeriodicMeasure.frequency].
class MemoryProbe extends PeriodicDatumProbe {
  Future<void> onInitialize(Measure measure) async {
    super.onInitialize(measure);
    // check if SysInfo is available (seems not to be available on iOS)
    SysInfo.getFreePhysicalMemory();
  }

  Future<Datum> getDatum() async {
    return FreeMemoryDatum()
      ..freePhysicalMemory = SysInfo.getFreePhysicalMemory()
      ..freeVirtualMemory = SysInfo.getFreeVirtualMemory();
  }
}

/// A probe that collects the device info about this device.
class DeviceProbe extends DatumProbe {
  Future<Datum> getDatum() async {
    return DeviceDatum(Device.platform, Device.deviceID,
        deviceName: Device.deviceName,
        deviceModel: Device.deviceModel,
        deviceManufacturer: Device.deviceManufacturer,
        operatingSystem: Device.operatingSystem,
        hardware: Device.hardware);
  }
}
