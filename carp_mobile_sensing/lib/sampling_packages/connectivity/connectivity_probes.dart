/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of connectivity;

/// The [ConnectivityProbe] listens to the connectivity status of the phone and
/// collect a [ConnectivityDatum] every time the connectivity state changes.
class ConnectivityProbe extends StreamProbe {
  Stream<Datum> get stream => Connectivity()
      .onConnectivityChanged
      .map((ConnectivityResult event) => ConnectivityDatum.fromConnectivityResult(event));
}

// This probe requests access to location PERMISSIONS (on Android). Don't ask why.....
// TODO - implement request for getting permission.

// TODO - need to reimplement this probe -- taking into consideration if BT is available and only start scans when asked...

/// The [BluetoothProbe] scans for nearby and visible Bluetooth devices and collect
/// a [BluetoothDatum] for each. Uses a [PeriodicMeasure] for configuration the
/// [frequency] and [duration] of the scan.
class BluetoothProbe extends PeriodicStreamProbe {
  /// Default timeout for bluetooth scan - 2 secs
  static const DEFAULT_TIMEOUT = 2 * 1000;

  Stream<Datum> get stream => FlutterBlue.instance
      .scan(scanMode: ScanMode.lowLatency, timeout: duration ?? Duration(milliseconds: DEFAULT_TIMEOUT))
      .map((result) => BluetoothDatum.fromScanResult(result));

  // important to overwrite onDone() as a no-op, so that the super class (StreamProbe) don't close the overall stream.
  @override
  void onDone() {}
}
