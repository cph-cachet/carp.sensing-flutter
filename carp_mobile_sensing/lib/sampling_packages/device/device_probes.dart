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
  Stream<DataPoint> get stream {
    Battery battery = Battery();
    StreamController<DataPoint> controller;
    StreamSubscription<BatteryState> subscription;

    void onData(state) async {
      try {
        int level = await battery.batteryLevel;
        DataPoint dataPoint = DataPoint.fromData(
          BatteryDatum.fromBatteryState(level, state),
          // triggerId: triggerId,
          // deviceRoleName: deviceRoleName,
        );
        controller.add(dataPoint);
      } catch (error) {
        controller.addError(error);
      }
    }

    controller = StreamController<DataPoint>(
        onListen: () => subscription.resume(),
        onPause: () => subscription.pause(),
        onResume: () => subscription.resume(),
        onCancel: () => subscription.cancel());

    subscription = battery.onBatteryStateChanged.listen(onData,
        onError: (error) => controller.addError(error),
        onDone: () => controller.close());

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
  void onInitialize(Measure measure) {
    super.onInitialize(measure);
    if (!Platform.isAndroid) {
      throw SensingException('ScreenProbe only available on Android.');
    }
  }

  Stream<DataPoint> get stream =>
      Screen().screenStateStream.map((event) => DataPoint.fromData(
            ScreenDatum.fromScreenStateEvent(event),
            // triggerId: triggerId,
            // deviceRoleName: deviceRoleName,
          ));
}

/// A probe that collects free virtual memory on a regular basis
/// as specified in [PeriodicMeasure.frequency].
class MemoryProbe extends PeriodicDataPointProbe {
  void onInitialize(Measure measure) {
    super.onInitialize(measure);
    // check if SysInfo is available (seems not to be available on iOS)
    SysInfo.getFreePhysicalMemory();
  }

  Future<DataPoint> getDataPoint() async => DataPoint.fromData(
        FreeMemoryDatum()
          ..freePhysicalMemory = SysInfo.getFreePhysicalMemory()
          ..freeVirtualMemory = SysInfo.getFreeVirtualMemory(),
        // triggerId: triggerId,
        // deviceRoleName: deviceRoleName,
      );
}

/// A probe that collects the device info about this device.
class DeviceProbe extends DataPointProbe {
  Future<DataPoint> getDataPoint() async => DataPoint.fromData(
        DeviceDatum(DeviceInfo().platform, DeviceInfo().deviceID,
            deviceName: DeviceInfo().deviceName,
            deviceModel: DeviceInfo().deviceModel,
            deviceManufacturer: DeviceInfo().deviceManufacturer,
            operatingSystem: DeviceInfo().operatingSystem,
            hardware: DeviceInfo().hardware),
        // triggerId: triggerId,
        // deviceRoleName: deviceRoleName,
      );
}
