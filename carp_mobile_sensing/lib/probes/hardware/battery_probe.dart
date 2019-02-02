/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of hardware;

/// The [BatteryProbe] listens to the hardware battery and collect a [BatteryDatum]
/// every time the battery state changes. For example, battery level or charging mode.
class BatteryProbe extends StreamProbe {
  //BatteryProbe(Measure measure) : super(measure, batteryStream);
  BatteryProbe() : super(batteryStream);
}

Stream<Datum> get batteryStream {
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

//  Stream<Datum> get stream async* {
//    await for (var state in battery.onBatteryStateChanged) {
//      int level = await battery.batteryLevel;
//      yield BatteryDatum.fromBatteryState(measure, level, state);
//    }
//  }
