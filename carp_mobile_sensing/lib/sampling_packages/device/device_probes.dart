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
    Battery _battery = Battery();
    late StreamController<Datum> _controller;
    late StreamSubscription<BatteryState> _subscription;

    void _onData(state) async {
      try {
        int level = await _battery.batteryLevel;
        Datum datum = BatteryDatum.fromBatteryState(level, state);
        _controller.add(datum);
      } catch (error) {
        _controller.addError(error);
      }
    }

    _controller = StreamController<Datum>(
        onListen: () => _subscription.resume(),
        onPause: () => _subscription.pause(),
        onResume: () => _subscription.resume(),
        onCancel: () => _subscription.cancel());

    _subscription = _battery.onBatteryStateChanged.listen(
      _onData,
      onError: (error) => _controller.addError(error),
      onDone: () => _controller.close(),
    );

    return _controller.stream;
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
  void onInitialize() {
    // check if SysInfo is available (seems not to be available on iOS)
    SysInfo.getFreePhysicalMemory();
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
