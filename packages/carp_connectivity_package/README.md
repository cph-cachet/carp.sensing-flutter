# CARP Connectivity Sampling Package

[![pub package](https://img.shields.io/pub/v/carp_connectivity_package.svg)](https://pub.dartlang.org/packages/carp_connectivity_package)
[![pub points](https://img.shields.io/pub/points/carp_connectivity_package?color=2E8B57&label=pub%20points)](https://pub.dev/packages/carp_connectivity_package/score)
[![github stars](https://img.shields.io/github/stars/cph-cachet/carp.sensing-flutter.svg?style=flat&logo=github&colorB=deeppink&label=stars)](https://github.com/cph-cachet/carp.sensing-flutter)
[![MIT License](https://img.shields.io/badge/license-MIT-purple.svg)](https://opensource.org/licenses/MIT)
[![arXiv](https://img.shields.io/badge/arXiv-2006.11904-green.svg)](https://arxiv.org/abs/2006.11904)

This library contains a sampling package for collection of connectivity related measures to work with the [`carp_mobile_sensing`](https://pub.dartlang.org/packages/carp_mobile_sensing) framework.
This packages supports sampling of the following [`Measure`](https://github.com/cph-cachet/carp.sensing-flutter/wiki/A.-Measure-Types) types:

* `dk.cachet.carp.wifi`
* `dk.cachet.carp.connectivity`
* `dk.cachet.carp.bluetooth`

See the [wiki](https://github.com/cph-cachet/carp.sensing-flutter/wiki) for further documentation, particularly on available [measure types](https://github.com/cph-cachet/carp.sensing-flutter/wiki/A.-Measure-Types).
See the [CARP Mobile Sensing App](https://github.com/cph-cachet/carp.sensing-flutter/tree/master/apps/carp_mobile_sensing_app) for an example of how to build a mobile sensing app in Flutter.

There is privacy protection of wifi and bluetooth names as part of the default [Privacy Schema](https://github.com/cph-cachet/carp.sensing-flutter/wiki/3.-Using-CARP-Mobile-Sensing#privacy-transformer-schemas).

For Flutter plugins for other CARP products, see [CARP Mobile Sensing in Flutter](https://github.com/cph-cachet/carp.sensing-flutter).

If you're interested in writing you own sampling packages for CARP, see the description on
how to [extend](https://github.com/cph-cachet/carp.sensing-flutter/wiki/5.-Extending-CARP-Mobile-Sensing) CARP on the wiki.

## Installing

To use this package, add the following to you `pubspc.yaml` file. Note that this package only works together with [`carp_mobile_sensing`](https://pub.dev/packages/carp_mobile_sensing).

`````dart
dependencies:
  flutter:
    sdk: flutter
  carp_mobile_sensing: ^latest
  carp_connectivity_package: ^latest
  ...
`````

### Android Integration

As explained in the Android [Wi-Fi scanning overview](https://developer.android.com/guide/topics/connectivity/wifi-scan), access to wifi information required different permission to be set.
For Android >= 10 (API level 29) you need `ACCESS_FINE_LOCATION`, and `ACCESS_COARSE_LOCATION`.
For Android >=12 (API level 31) be sure that your app has `ACCESS_NETWORK_STATE` permission.

Add the following to your app's `AndroidManifest.xml` file located in `android/app/src/main`:

````xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="<your_package_name>"
    xmlns:tools="http://schemas.android.com/tools">

   ...

    <!-- The following permissions are used in the Connectivity Package -->
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>

</manifest>
````

> Note that connectivity changes are **not** communicated to Android apps in the background starting with Android 8 (SDK 26). Hence, connectivity status is only collected when your app is resumed.

### iOS Integration

From iOS >= 13 there is no longer access to wifi information.
See here for the [Flutter](https://pub.dev/packages/network_info_plus) description
and here for the [iOS](https://developer.apple.com/documentation/systemconfiguration/1614126-cncopycurrentnetworkinfo) description.

To enable bluetooth tracking, add these permissions in the `Info.plist` file located in `ios/Runner`:

````xml
<key>NSBluetoothAlwaysUsageDescription</key>
<string>Bluetooth needed</string>
<key>UIBackgroundModes</key>
  <array>
  <string>bluetooth-central</string>
  <string>bluetooth-peripheral</string>
  <string>external-accessory</string>
  <string>fetch</string>
</array>
````

> Note that on iOS, it is [impossible to do a general Bluetooth scan when the screen is off or the app is in background](https://developer.apple.com/forums/thread/652592). This will simply result in an empty scan. Hence, bluetooth devices are only collected when the app is in the foreground.

## Using it

To use this package, import it into your app together with the
[`carp_mobile_sensing`](https://pub.dartlang.org/packages/carp_mobile_sensing) package:

`````dart
import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:carp_connectivity_package/connectivity.dart';
`````

Before creating a study and running it, register this package in the
[`SamplingPackageRegistry`](https://pub.dev/documentation/carp_mobile_sensing/latest/runtime/SamplingPackageRegistry-class.html).

`````dart
SamplingPackageRegistry().register(ConnectivitySamplingPackage());
`````

Collection of connectivity measures can be added to a study protocol like this.

```dart
// Create a study protocol
StudyProtocol protocol = StudyProtocol(
  ownerId: 'owner@dtu.dk',
  name: 'Connectivity Sensing Example',
);

// Define which devices are used for data collection
// In this case, its only this smartphone
Smartphone phone = Smartphone();
protocol.addPrimaryDevice(phone);

// Add an automatic task that immediately starts collecting connectivity,
// nearby bluetooth devices, and wifi information.
protocol.addTaskControl(
    ImmediateTrigger(),
    BackgroundTask(measures: [
      Measure(type: ConnectivitySamplingPackage.CONNECTIVITY),
      Measure(type: ConnectivitySamplingPackage.BLUETOOTH),
      Measure(type: ConnectivitySamplingPackage.WIFI),
    ]),
    phone);
```

The [`BluetoothScanPeriodicSamplingConfiguration`](https://pub.dev/documentation/carp_connectivity_package/latest/connectivity/BluetoothScanPeriodicSamplingConfiguration-class.html) configuration can be used to specify how Bluetooth scanning is to take place:

```dart
protocol.addTaskControl(
    ImmediateTrigger(),
    BackgroundTask(measures: [
      Measure(
          type: ConnectivitySamplingPackage.BLUETOOTH,
          samplingConfiguration: BluetoothScanPeriodicSamplingConfiguration(
            interval: const Duration(minutes: 10),
            duration: const Duration(seconds: 10),
            withRemoteIds: ['123', '456'],
            withServices: ['service1', 'service2'],
          ))
    ]),
    phone);
```
