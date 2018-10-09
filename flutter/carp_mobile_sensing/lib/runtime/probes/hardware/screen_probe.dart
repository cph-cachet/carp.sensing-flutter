/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
import 'dart:async';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:screen_state/screen_state.dart';

/**
 * The [ScreenProbe] listens to screen actions which are: SCREEN ON/OFF/UNLOCK.
 */
class ScreenProbe extends StreamSubscriptionListeningProbe {
  Screen _screen;

  ScreenProbe(ScreenMeasure measure) : super(measure);

  @override
  void initialize() {
    super.initialize();
    _screen = new Screen();
  }

  @override
  Future start() async {
    super.start();
    subscription = _screen.screenStateEvents.listen(onData, onError: onError, onDone: onDone, cancelOnError: true);
  }

  void onData(dynamic event) async {
    assert(event is ScreenStateEvent);
    ScreenStateEvent state = event;
    ScreenDatum _sd = new ScreenDatum();
    _sd.screenEvent = '$event';
    this.notifyAllListeners(_sd);
  }
}
