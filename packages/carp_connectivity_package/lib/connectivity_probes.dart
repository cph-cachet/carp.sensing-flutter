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
  @override
  Stream<Datum> get stream =>
      Connectivity().onConnectivityChanged.map((ConnectivityResult event) =>
          ConnectivityDatum.fromConnectivityResult(event));
}

// This probe requests access to location permissions (both on Android and iOS).
// See https://pub.dev/packages/network_info_plus
/// The [WifiProbe] get the wifi connectivity status of the phone and
/// collect a [WifiDatum].
///
/// Note, that in order to make this probe work on iOS (especially after iOS
/// 12 and 13), there is a set of requirements to meet for the app using this
/// probe. See
///
///  * [network_info_plus](https://pub.dev/packages/network_info_plus)
///  * [CNCopyCurrentNetworkInfo](https://developer.apple.com/documentation/systemconfiguration/1614126-cncopycurrentnetworkinfo)
///
/// Please note that it this probes does not work on emulators (returns null).
///
/// From Android 10.0 onwards the `ACCESS_FINE_LOCATION` permission must be
/// granted.
class WifiProbe extends IntervalDatumProbe {
  @override
  Future<Datum> getDatum() async {
    String? ssid = await NetworkInfo().getWifiName();
    String? bssid = await NetworkInfo().getWifiBSSID();
    String? ip = await NetworkInfo().getWifiIP();

    return WifiDatum(ssid: ssid, bssid: bssid, ip: ip);
  }
}

/// The [BluetoothProbe] scans for nearby and visible Bluetooth devices and
/// collects a [BluetoothDatum] that lists each device found during the scan.
/// Uses a [PeriodicSamplingConfiguration] for configuration the [interval]
/// and [duration] of the scan.
class BluetoothProbe extends BufferingPeriodicStreamProbe {
  /// Default timeout for bluetooth scan - 4 secs
  static const DEFAULT_TIMEOUT = 4 * 1000;
  Datum? _datum;

  @override
  Stream<dynamic> get bufferingStream => FlutterBluePlus.instance.scanResults;

  @override
  Future<Datum?> getDatum() async => _datum;

  @override
  void onSamplingStart() {
    try {
      FlutterBluePlus.instance.startScan(
          scanMode: ScanMode.lowLatency,
          timeout: samplingConfiguration?.duration ??
              Duration(milliseconds: DEFAULT_TIMEOUT));
    } catch (error) {
      FlutterBluePlus.instance.stopScan();
      _datum = ErrorDatum('Error scanning for bluetooth - $error');
    }
  }

  @override
  void onSamplingEnd() => FlutterBluePlus.instance.stopScan();

  @override
  void onSamplingData(event) {
    print('>> scan event: $event');
    if (event is List<ScanResult>) {
      // add the datum for each scan list we get (don't wait for the scan to end)
      addData(BluetoothDatum()
        ..scanResult.addAll(event
            .map((scanResult) => BluetoothDevice.fromScanResult(scanResult))));
    }
  }
}
