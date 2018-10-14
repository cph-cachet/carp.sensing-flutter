/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of connectivity;

/// The [ConnectivityProbe] listens to the connectivity status of the phone and collect a [ConnectivityDatum]
/// everytime the connectivity state changes.
class ConnectivityProbe extends StreamSubscriptionListeningProbe {
  Connectivity _connectivity;

  ConnectivityProbe(ConnectivityMeasure measure) : super(measure);

  @override
  void initialize() {
    super.initialize();
    _connectivity = new Connectivity();
  }

  @override
  Future start() async {
    super.start();

    // starting the subscription to the network.
    subscription = _connectivity.onConnectivityChanged
        .listen(onData, onError: onError, onDone: onDone, cancelOnError: true);
  }

  void onData(dynamic event) async {
    assert(event is ConnectivityResult);
    ConnectivityResult result = event;

    ConnectivityDatum _cd = new ConnectivityDatum();
    switch (result) {
      case ConnectivityResult.wifi:
        _cd.connectivityStatus = "wifi";
        break;
      case ConnectivityResult.mobile:
        _cd.connectivityStatus = "mobile";
        break;
      case ConnectivityResult.none:
        _cd.connectivityStatus = "none";
        break;
      default:
        _cd.connectivityStatus = "unknown";
    }

    this.notifyAllListeners(_cd);
  }
}
