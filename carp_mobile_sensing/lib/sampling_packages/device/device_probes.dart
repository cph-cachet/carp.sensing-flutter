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
  @override
  Stream<Datum>? get stream {
    Battery battery = Battery();
    late StreamController<Datum> controller;
    late StreamSubscription<BatteryState> subscription;

    void _onData(BatteryState state) async {
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

    subscription = battery.onBatteryStateChanged.listen(
      _onData,
      onError: (Object error) => controller.addError(error),
      onDone: () => controller.close(),
    );

    return controller.stream;
  }
}

/// A probe collecting screen events:
///  - SCREEN ON
///  - SCREEN OFF
///  - SCREEN UNLOCK
/// which are stored as a [ScreenDatum].
///
/// This probe is only available on Android.
class ScreenProbe extends StreamProbe {
  Screen screen = Screen();

  @override
  Stream<Datum>? get stream => (screen.screenStateStream != null)
      ? screen.screenStateStream!
          .map((event) => ScreenDatum.fromScreenStateEvent(event))
      : null;
}

/// A probe that collects free virtual memory on a regular basis
/// as specified in [PeriodicMeasure.frequency].
class MemoryProbe extends IntervalDatumProbe {
  @override
  bool onInitialize() {
    // check if SysInfo is available (seems not to be available on iOS)
    SysInfo.getFreePhysicalMemory();
    return true;
  }

  @override
  Future<Datum?> getDatum() async => FreeMemoryDatum(
        SysInfo.getFreePhysicalMemory(),
        SysInfo.getFreeVirtualMemory(),
      );
}

/// A probe that collects the device info about this device.
class DeviceProbe extends DatumProbe {
  @override
  Future<Datum?> getDatum() async => DeviceDatum(
        DeviceInfo().platform,
        DeviceInfo().deviceID,
        deviceName: DeviceInfo().deviceName,
        deviceModel: DeviceInfo().deviceModel,
        deviceManufacturer: DeviceInfo().deviceManufacturer,
        operatingSystem: DeviceInfo().operatingSystem,
        hardware: DeviceInfo().hardware,
      );
}
