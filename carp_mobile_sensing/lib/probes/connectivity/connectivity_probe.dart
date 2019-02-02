/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of connectivity;

/// The [ConnectivityProbe] listens to the connectivity status of the phone and
/// collect a [ConnectivityDatum] everytime the connectivity state changes.
class ConnectivityProbe extends StreamProbe {
  //ConnectivityProbe(Measure measure) : super(measure, connectivityStream);
  ConnectivityProbe() : super(connectivityStream);
}

Stream<Datum> get connectivityStream => Connectivity()
    .onConnectivityChanged
    .map((ConnectivityResult event) => ConnectivityDatum.fromConnectivityResult(event));
