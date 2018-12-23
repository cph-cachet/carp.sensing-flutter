/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of hardware;

/// Listens to screen actions which are: SCREEN ON/OFF/UNLOCK which are stored as a [ScreenDatum].
class ScreenProbe extends StreamSubscriptionListeningProbe {
  Screen _screen;

  /// A [ScreenProbe] is a listening probe and takes a [ListeningProbeMeasure] as configuration.
  ScreenProbe(Measure measure) : super(measure);

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

  Stream<Datum> get stream => null;

  void onData(dynamic event) async {
    assert(event is ScreenStateEvent);
    ScreenDatum _sd = new ScreenDatum(measure: measure);

    switch (event) {
      case ScreenStateEvent.SCREEN_ON:
        _sd.screenEvent = "SCREEN_ON";
        break;
      case ScreenStateEvent.SCREEN_OFF:
        _sd.screenEvent = "SCREEN_OFF";
        break;
      case ScreenStateEvent.SCREEN_UNLOCKED:
        _sd.screenEvent = "SCREEN_UNLOCKED";
        break;
    }
    this.notifyAllListeners(_sd);
  }
}
