/*
 * Copyright 2019-2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of movisens;

/// The [Movisens] device handler.
/// Only available after the [MovisensProbe] has been initialized.
Movisens? movisens;

/// User data as specified in the [MovisensMeasure].
/// Only available after the [MovisensProbe] has been initialized.
UserData? userData;

/// A probe collecting data from the Movisens device using a [StreamProbe].
class MovisensProbe extends StreamProbe {
  Future onInitialize(Measure measure) async {
    assert(measure is MovisensMeasure);
    super.onInitialize(measure);
    MovisensMeasure m = measure as MovisensMeasure;
    userData = UserData(
      m.weight!,
      m.height!,
      m.gender!,
      m.age!,
      m.sensorLocation!,
      m.address!,
      m.deviceName!,
    );
    movisens = new Movisens(userData!);
  }

  Stream<MovisensDatum>? get stream => (movisens?.movisensStream != null)
      ? movisens!.movisensStream.map((event) => MovisensDatum.fromMap(event))
      : null;
}
