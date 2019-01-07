/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of hardware;

/// Listens to screen actions which are: SCREEN ON/OFF/UNLOCK which are stored as a [ScreenDatum].
class ScreenProbe extends StreamProbe {
  Screen screen = new Screen();

  ScreenProbe() : super();

  Stream<Datum> get stream => screen.screenStateEvents.map((event) => ScreenDatum.fromScreenStateEvent(measure, event));
}
