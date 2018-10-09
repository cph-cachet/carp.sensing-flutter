/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
import 'dart:async';
import 'package:battery/battery.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';

/**
 * The [BatteryProbe] listens to the hardware battery and collect a [BatteryDatum]
 * everytime the battery state changes. For example, battery level or charging mode.
 */
class BatteryProbe extends StreamSubscriptionListeningProbe {
  Battery _battery;

  BatteryProbe(BatteryMeasure measure) : super(measure);

  @override
  void initialize() {
    super.initialize();
    _battery = new Battery();
  }

  @override
  Future start() async {
    super.start();

    // starting the subscription to the battery - triggered every time the charging level changes.
    subscription = _battery.onBatteryStateChanged.listen(onData, onError: onError, onDone: onDone, cancelOnError: true);
  }

  void onData(dynamic event) async {
    assert(event is BatteryState);
    BatteryState state = event;

    int _batteryLevel = await _battery.batteryLevel;

    BatteryDatum _bd = new BatteryDatum();
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
