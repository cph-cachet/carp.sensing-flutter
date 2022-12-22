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
  Stream<Measurement> get stream => connectivity.Connectivity()
      .onConnectivityChanged
      .map((connectivity.ConnectivityResult event) =>
          Measurement.fromData(Connectivity.fromConnectivityResult(event)));
}

// This probe requests access to location permissions (both on Android and iOS).
// See https://pub.dev/packages/network_info_plus
/// The [WifiProbe] get the wifi connectivity status of the phone and
/// collect a [Wifi].
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
class WifiProbe extends IntervalProbe {
  @override
  Future<Measurement> getMeasurement() async {
    String? ssid = await NetworkInfo().getWifiName();
    String? bssid = await NetworkInfo().getWifiBSSID();
    String? ip = await NetworkInfo().getWifiIP();

    return Measurement.fromData(Wifi(ssid: ssid, bssid: bssid, ip: ip));
  }
}

/// The [BluetoothProbe] scans for nearby and visible Bluetooth devices and
/// collects a [BluetoothDatum] that lists each device found during the scan.
/// Uses a [PeriodicSamplingConfiguration] for configuration the [interval]
/// and [duration] of the scan.
class BluetoothProbe extends BufferingPeriodicStreamProbe {
  /// Default timeout for bluetooth scan - 4 secs
  static const DEFAULT_TIMEOUT = 4 * 1000;
  Data? _data;

  @override
  Stream<dynamic> get bufferingStream => FlutterBluePlus.instance.scanResults;

  @override
  Future<Measurement?> getMeasurement() async =>
      _data != null ? Measurement.fromData(_data!) : null;

  @override
  void onSamplingStart() {
    _data = Bluetooth();
    try {
      FlutterBluePlus.instance.startScan(
          scanMode: ScanMode.lowLatency,
          timeout: samplingConfiguration?.duration ??
              Duration(milliseconds: DEFAULT_TIMEOUT));
    } catch (error) {
      FlutterBluePlus.instance.stopScan();
      _data = Error(message: 'Error scanning for bluetooth - $error');
    }
  }

  @override
  void onSamplingEnd() {
    FlutterBluePlus.instance.stopScan();
    (_data as Bluetooth).endScan = DateTime.now();
  }

  @override
  void onSamplingData(event) {
    if (event is List<ScanResult>) {
      (_data as Bluetooth).addBluetoothDevicesFromScanResults(event);
    }
  }
}
