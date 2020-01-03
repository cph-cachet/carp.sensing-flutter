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

// This probe requests access to location permissions (both on Android and iOS).
/// The [WifiProbe] get the wifi connectivity status of the phone and
/// collect a [WifiDatum].
///
/// Note, that in order to make this probe work on iOS (especially after iOS 12 and 13), there
/// is a set of requirements to meet for the app using this probe. See
///
///  * [connectivity](https://pub.dev/packages/connectivity)
///  * [CNCopyCurrentNetworkInfo](https://developer.apple.com/documentation/systemconfiguration/1614126-cncopycurrentnetworkinfo)
class WifiProbe extends PeriodicDatumProbe {
  Future<Datum> getDatum() async {
    String ssid = await Connectivity().getWifiName();
    String bssid = await Connectivity().getWifiBSSID();

    return WifiDatum()
      ..ssid = ssid
      ..bssid = bssid;
  }
}

// This probe requests access to location PERMISSIONS (on Android). Don't ask why.....
// TODO - implement request for getting permission.

/// The [BluetoothProbe] scans for nearby and visible Bluetooth devices and collects
/// a [BluetoothDatum] that lists each device found during the scan.
/// Uses a [PeriodicMeasure] for configuration the [frequency] and [duration] of the scan.
class BluetoothProbe extends PeriodicDatumProbe {
  /// Default timeout for bluetooth scan - 2 secs
  static const DEFAULT_TIMEOUT = 2 * 1000;

  Future<Datum> getDatum() async {
    Datum datum;
    try {
      List<ScanResult> results = await FlutterBlue.instance
          .startScan(scanMode: ScanMode.lowLatency, timeout: duration ?? Duration(milliseconds: DEFAULT_TIMEOUT));
      datum = BluetoothDatum.fromScanResult(results);
    } catch (error) {
      await FlutterBlue.instance.stopScan();
      datum = ErrorDatum('Error scanning for bluetooth - $error');
    }

    return datum;
  }
}
