/*
 * Copyright 2019-2023 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of carp_movisens_package;

/// A probe collecting data from the Movisens device using a [StreamProbe].
abstract class MovisensProbe extends StreamProbe {
  @override
  MovisensDeviceManager get deviceManager =>
      super.deviceManager as MovisensDeviceManager;

  @override
  Stream<Measurement>? get stream => events?.map(
      (event) => Measurement.fromData(MovisensData.fromMovisensEvent(event)));

  Stream<movisens.MovisensEvent>? get events;
}

abstract class MovisensPhysicalActivityProbe extends MovisensProbe {
  @override
  bool onInitialize() {
    deviceManager.device?.physicalActivityService?.enableNotify();
    return true;
  }
}

class MovisensMETLevelProbe extends MovisensPhysicalActivityProbe {
  @override
  Stream<movisens.MovisensEvent>? get events =>
      deviceManager.device?.physicalActivityService?.metLevelEvents;
}
