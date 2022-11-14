/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of device;

/// The [BatteryProbe] listens to the hardware battery and collect a [BatteryState]
/// every time the battery state changes. For example, battery level or charging mode.
class BatteryProbe extends StreamProbe {
  @override
  Stream<Measurement>? get stream {
    late StreamSubscription<battery.BatteryState> subscription;
    late StreamController<Measurement> controller;

    void onData(battery.BatteryState state) async {
      try {
        int level = await battery.Battery().batteryLevel;
        controller.add(
          Measurement.fromData(
            BatteryState.fromBatteryState(level, state),
          ),
        );
      } catch (error) {
        controller.addError(error);
      }
    }

    controller = StreamController<Measurement>(
        onListen: () => subscription.resume(),
        onPause: () => subscription.pause(),
        onResume: () => subscription.resume(),
        onCancel: () => subscription.cancel());

    subscription = battery.Battery().onBatteryStateChanged.listen(
          onData,
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
/// which are stored as a [ScreenEvent].
///
/// This probe is only available on Android.
class ScreenProbe extends StreamProbe {
  Screen screen = Screen();

  @override
  Stream<Measurement>? get stream => (screen.screenStateStream != null)
      ? screen.screenStateStream!.map((event) =>
          Measurement.fromData(ScreenEvent.fromScreenStateEvent(event)))
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
  Future<Measurement?> getMeasurement() async =>
      Measurement.fromData(FreeMemory(
        SysInfo.getFreePhysicalMemory(),
        SysInfo.getFreeVirtualMemory(),
      ));
}

/// A probe that collects the device info about this device.
class DeviceProbe extends DatumProbe {
  @override
  Future<Measurement?> getMeasurement() async =>
      Measurement.fromData(DeviceInformation(
        DeviceInfo().platform,
        DeviceInfo().deviceID,
        deviceName: DeviceInfo().deviceName,
        deviceModel: DeviceInfo().deviceModel,
        deviceManufacturer: DeviceInfo().deviceManufacturer,
        operatingSystem: DeviceInfo().operatingSystem,
        hardware: DeviceInfo().hardware,
      ));
}
