/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of hardware;

/// The [BatteryProbe] listens to the hardware battery and collect a [BatteryDatum]
/// every time the battery state changes. For example, battery level or charging mode.
class BatteryProbe extends StreamSubscriptionListeningProbe {
  Battery _battery = new Battery();

  BatteryProbe(Measure measure) : super(measure);

  @override
  void initialize() {
    super.initialize();
  }

  @override
  Future start() async {
    super.start();

    // starting the subscription to the battery - triggered every time the charging level changes.
    //subscription = _battery.onBatteryStateChanged.listen(onData, onError: onError, onDone: onDone, cancelOnError: true);
  }

//  Stream<Datum> get stream => _battery.onBatteryStateChanged.map((state) => _getBatteryDatum(measure, state));

  Stream<Datum> get stream => MyStream(_battery.onBatteryStateChanged);

  Stream<BatteryDatum> MyStream(Stream<BatteryState> battery) async* {
    await for (var state in battery) {
      print('>> my_stream - $state');
      int level = await _battery.batteryLevel;
      BatteryDatum datum = BatteryDatum.fromBatteryState(measure, level, state);
      yield datum;
    }
  }

  void onData(dynamic event) async {
    assert(event is BatteryState);
    BatteryState state = event;

    print('>> onData - $state');

    int _batteryLevel = await _battery.batteryLevel;

    BatteryDatum _bd = new BatteryDatum(measure: measure);
    _bd.batteryLevel = _batteryLevel;
    switch (state) {
      case BatteryState.full:
        _bd.batteryStatus = "full";
        break;
      case BatteryState.charging:
        _bd.batteryStatus = "charging";
        break;
      case BatteryState.discharging:
        _bd.batteryStatus = "discharging";
        break;
      default:
        _bd.batteryStatus = "unknown";
    }

    this.notifyAllListeners(_bd);
  }
}
