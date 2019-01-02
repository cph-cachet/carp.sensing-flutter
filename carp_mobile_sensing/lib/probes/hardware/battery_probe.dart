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
  Battery battery = new Battery();

  BatteryProbe(Measure measure) : super(measure);

  Stream<Datum> get stream {
    StreamController<Datum> controller;
    StreamSubscription<BatteryState> subscription;

    void onData(state) async {
      int level = await battery.batteryLevel;
      Datum datum = BatteryDatum.fromBatteryState(measure, level, state);
      controller.add(datum);
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

//  Stream<Datum> get stream async* {
//    await for (var state in battery.onBatteryStateChanged) {
//      int level = await battery.batteryLevel;
//      yield BatteryDatum.fromBatteryState(measure, level, state);
//    }
//  }

}
