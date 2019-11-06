/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of sensors;

/// The pedometer probe listens to the hardware step count sensor.
///
/// It samples step counts directly from the native OS and reports step counts as they are sensed,
/// typically for each step taken.
class PedometerProbe extends StreamProbe {
  Stream<Datum> get stream => Pedometer().pedometerStream.map((count) => PedometerDatum(count));
}
