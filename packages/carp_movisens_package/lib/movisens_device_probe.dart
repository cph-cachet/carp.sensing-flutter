/*
 * Copyright 2019 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of movisens;

/// A probe collecting data from the Movisens device using a [StreamProbe].
class MovisensProbe extends StreamProbe {
  Movisens _movisens;
  UserData _userData;

  /// User data from the [MovisensMeasure]. Only available after initialized.
  UserData get userData => _userData;

  Future<void> onInitialize(Measure measure) async {
    assert(measure is MovisensMeasure);
    super.onInitialize(measure);
    MovisensMeasure m = measure as MovisensMeasure;
    _userData = UserData(m.weight, m.height, m.gender, m.age, m.sensorLocation, m.address, m.deviceName);
    _movisens = new Movisens(_userData);
  }

  Stream<MovisensDatum> get stream =>
      (_movisens != null) ? _movisens.movisensStream.map((event) => MovisensDatum.fromMap(event)) : null;
}
