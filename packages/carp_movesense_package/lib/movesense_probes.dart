/*
 * Copyright 2022-23 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of carp_movesense_package;

abstract class _MovesenseProbe extends StreamProbe {
  @override
  MovesenseDeviceManager get deviceManager =>
      super.deviceManager as MovesenseDeviceManager;
}

class MovesenseHRProbe extends _MovesenseProbe {
  @override
  Stream<Measurement>? get stream {
    var value = null;
    print("connected " + deviceManager.isConnected.toString());
    if (deviceManager.isConnected) {
      MdsAsync.subscribe(
              Mds.createSubscriptionUri(deviceManager.serial, "/Meas/HR"), "{}")
          .listen((event) {
        value = Measurement.fromData(MovesenseHR.fromMoveSenseData(event));
        value = Measurement.fromData(
            MovesenseHR(samples: [MovesenseHRSample(0.0)]));
      });
      if (value != null) {
        print("value type: " + value.runtimeType.toString());
      } else {
        print("value null");
      }
      return value;
    } else {
      print("value null");
      return null;
    }
  }
}
