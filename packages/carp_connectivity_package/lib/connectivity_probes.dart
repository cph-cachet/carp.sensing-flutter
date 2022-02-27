/*
 * Copyright 2018-2020 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of connectivity;

/// The [ConnectivityProbe] listens to the connectivity status of the phone and
/// collect a [ConnectivityDatum] every time the connectivity state changes.
class ConnectivityProbe extends StreamProbe {
  Stream<Datum> get stream =>
      Connectivity().onConnectivityChanged.map((ConnectivityResult event) =>
          ConnectivityDatum.fromConnectivityResult(event));
}

// This probe requests access to location permissions (both on Android and iOS).
// See https://pub.dev/packages/wifi_info_flutter
/// The [WifiProbe] get the wifi connectivity status of the phone and
/// collect a [WifiDatum].
///
/// Note, that in order to make this probe work on iOS (especially after iOS
/// 12 and 13), there is a set of requirements to meet for the app using this
/// probe. See
///
///  * [connectivity](https://pub.dev/packages/connectivity)
///  * [CNCopyCurrentNetworkInfo](https://developer.apple.com/documentation/systemconfiguration/1614126-cncopycurrentnetworkinfo)
///
/// Please note that it this probes does not work on emulators (returns null).
///
/// From Android 8.0 onwards the GPS must be ON (high accuracy) in order to be
/// able to obtain the BSSID.
class WifiProbe extends PeriodicDatumProbe {
  Future<Datum> getDatum() async {
    String? ssid = await NetworkInfo().getWifiName();
    String? bssid = await NetworkInfo().getWifiBSSID();
    String? ip = await NetworkInfo().getWifiIP();

    return WifiDatum(ssid: ssid, bssid: bssid, ip: ip);
  }
}

/// The [BluetoothProbe] scans for nearby and visible Bluetooth devices and
/// collects a [BluetoothDatum] that lists each device found during the scan.
/// Uses a [PeriodicMeasure] for configuration the [frequency] and [duration]
/// of the scan.
class BluetoothProbe extends PeriodicDatumProbe {
  /// Default timeout for bluetooth scan - 4 secs
  static const DEFAULT_TIMEOUT = 4 * 1000;

  Future<Datum> getDatum() async {
    Datum datum;
    try {
      List<ScanResult> results = await FlutterBluePlus.instance.startScan(
          scanMode: ScanMode.lowLatency,
          timeout: duration ?? Duration(milliseconds: DEFAULT_TIMEOUT));
      datum = BluetoothDatum.fromScanResult(results);
    } catch (error) {
      await FlutterBluePlus.instance.stopScan();
      datum = ErrorDatum('Error scanning for bluetooth - $error');
    }

    return datum;
  }
}
