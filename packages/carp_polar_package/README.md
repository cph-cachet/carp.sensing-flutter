# CARP Polar Sampling Package

This library contains a sampling package for
the [`carp_mobile_sensing`](https://pub.dartlang.org/packages/carp_mobile_sensing) framework
to work with the [Polar](https://www.polar.com/) heart rate devices.
This packages supports sampling of the following [`Measure`](https://pub.dev/documentation/carp_core/latest/carp_core_protocols/Measure-class.html) types (note that the package defines its own namespace of `dk.cachet.carp.polar`):

* `dk.cachet.carp.polar.accelerometer` : Accelerometer
* `dk.cachet.carp.polar.gyroscope` : Gyroscope
* `dk.cachet.carp.polar.magnetometer` : Magnetometer
* `dk.cachet.carp.polar.ecg` : Electrocardiogram (ECG)
* `dk.cachet.carp.polar.ppi` : Pulse-to-Pulse Interval (PPI)
* `dk.cachet.carp.polar.ppg` : Photoplethysmograpy (PPG)
* `dk.cachet.carp.polar.hr` : Heart rate

This package uses the Flutter [polar](https://pub.dev/packages/polar) plugin, which again is based on the official [Polar API](https://github.com/polarofficial/polar-ble-sdk).
The following devices are supported:

* [H10 Heart rate sensor](https://github.com/polarofficial/polar-ble-sdk#h10-heart-rate-sensor)
* [H9 Heart rate sensor](https://github.com/polarofficial/polar-ble-sdk#h9-heart-rate-sensor)
* [Polar Verity Sense Optical heart rate sensor](https://github.com/polarofficial/polar-ble-sdk#polar-verity-sense-optical-heart-rate-sensor)

See the `carp_mobile_sensing` [wiki](https://github.com/cph-cachet/carp.sensing-flutter/wiki) for further documentation, particularly on available [measure types](https://github.com/cph-cachet/carp.sensing-flutter/wiki/A.-Measure-Types).
See the [CARP Mobile Sensing App](https://github.com/cph-cachet/carp.sensing-flutter/tree/master/apps/carp_mobile_sensing_app) for an example of how to build a mobile sensing app in Flutter.
This demo app also includes support for this Polar sampling package.

For Flutter plugins for other CARP products, see [CARP Mobile Sensing in Flutter](https://github.com/cph-cachet/carp.sensing-flutter).

If you're interested in writing you own sampling packages for CARP, see the description on
how to [extend](https://github.com/cph-cachet/carp.sensing-flutter/wiki/4.-Extending-CARP-Mobile-Sensing) CARP on the wiki.

## Installing

To use this package, add the following to you `pubspec.yaml` file. Note that
this package only works together with `carp_mobile_sensing`.

`````dart
dependencies:
  flutter:
    sdk: flutter
  carp_core: ^latest
  carp_mobile_sensing: ^latest
  carp_polar_package: ^latest
  ...
`````

### Android Integration

See the official Polar description of [Android: Getting started](https://github.com/polarofficial/polar-ble-sdk#android-getting-started).

Add the following to your app's `manifest.xml` file located in `android/app/src/main`:

```xml
   <!-- Polar SDK needs Bluetooth scan permission to search for BLE devices. Polar BLE SDK doesn't use the scan
    to decide the location so "neverForLocation" permission flag can be used.-->
    <uses-permission
        android:name="android.permission.BLUETOOTH_SCAN"
        android:usesPermissionFlags="neverForLocation" />

    <!-- Polar SDK needs Bluetooth connect permission to connect for found BLE devices.-->
    <uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />

    <!-- Allows Polar SDK to connect to paired bluetooth devices. Legacy Bluetooth permission,
     which is needed on devices with API 30 (Android Q) or older. -->
    <uses-permission
        android:name="android.permission.BLUETOOTH"
        android:maxSdkVersion="30" />

    <!-- Allows Polar SDK to discover and pair bluetooth devices. Legacy Bluetooth permission,
     which is needed on devices with API 30 (Android Q) or older. -->
    <uses-permission
        android:name="android.permission.BLUETOOTH_ADMIN"
        android:maxSdkVersion="30" />

    <!-- Polar SDK needs the fine location permission to get results for Bluetooth scan. Request
    fine location permission on devices with API 30 (Android Q). Note, if your application 
    needs location for other purposes than bluetooth then remove android:maxSdkVersion="30"-->
    <uses-permission
        android:name="android.permission.ACCESS_FINE_LOCATION"
        android:maxSdkVersion="30" />

   <!-- The coarse location permission is needed, if fine location permission is requested. Request
     coarse location permission on devices with API 30 (Android Q). Note, if your application 
    needs location for other purposes than bluetooth then remove android:maxSdkVersion="30" -->
    <uses-permission
        android:name="android.permission.ACCESS_COARSE_LOCATION"
        android:maxSdkVersion="30" />
```

> **NOTE:** The first time the app starts, make sure to allow it to access the phone location.
This is necessary to use BLE on Android.

### iOS Integration

See the official Polar description of [iOS: Getting started](https://github.com/polarofficial/polar-ble-sdk#ios-getting-started).

Requires iOS 14 or later. Hence, in your `Podfile` in the `ios` folder of your app,
make sure that the platform is set to `14.0`.

```pod
platform :ios, '14.0'
```

* In your project target settings enable Background Modes, add Uses Bluetooth LE accessories
* In your project target property list add the key [NSBluetoothAlwaysUsageDescription](https://developer.apple.com/documentation/bundleresources/information_property_list/nsbluetoothalwaysusagedescription)

Add this permission in the `Info.plist` file located in `ios/Runner`:

```xml
<key>NSBluetoothAlwaysUsageDescription</key>
<string>Uses bluetooth to connect to the Polar device</string>
<key>UIBackgroundModes</key>
<array>
  <string>bluetooth-central</string>
</array>
```

## Using it

To use this package, import it into your app together with the
[`carp_mobile_sensing`](https://pub.dartlang.org/packages/carp_mobile_sensing) package:

`````dart
import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:carp_polar_package/carp_polar_package.dart';
`````

Collection of Polar measures can be added to a study protocol like this.

```dart
  // Create a study protocol
  StudyProtocol protocol = StudyProtocol(
    ownerId: 'owner@dtu.dk',
    name: 'Polar Sensing Example',
  );

  // define which devices are used for data collection - both phone and eSense
  var phone = Smartphone();
  var polar = PolarDevice(
    roleName: 'hr-sensor',
    identifier: '1C709B20',
    name: 'H10',
    polarDeviceType: PolarDeviceType.H10,
  );

  protocol
    ..addPrimaryDevice(phone)
    ..addConnectedDevice(polar);

  // Add a background task that immediately starts collecting HR and ECG data
  // from the Polar device.
  protocol.addTaskControl(
      ImmediateTrigger(),
      BackgroundTask(measures: [
        Measure(type: PolarSamplingPackage.HR),
        Measure(type: PolarSamplingPackage.ECG),
      ]),
      polar);
````

Before executing a study with an Polar measure, register this package in the
[SamplingPackageRegistry](https://pub.dartlang.org/documentation/carp_mobile_sensing/latest/runtime/SamplingPackageRegistry.html).

`````dart
SamplingPackageRegistry().register(PolarSamplingPackage());
`````

> **NOTE** that the Polar device `identifier` must be specified for the phone to connect to the device via BLE.

This entails that a Polar device and its probes should not be connected and resumed, before the device identifier is know.

Also note that the package does not handle permissions. This should be done on an app level.
