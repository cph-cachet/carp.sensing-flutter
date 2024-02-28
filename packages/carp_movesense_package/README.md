# CARP Movesense Sampling Package

This library contains a sampling package for
the [`carp_mobile_sensing`](https://pub.dartlang.org/packages/carp_mobile_sensing) framework
to work with the [Movesense](https://www.movesense.com/) heart rate devices.
This packages supports sampling of the following [`Measure`](https://pub.dev/documentation/carp_core/latest/carp_core_protocols/Measure-class.html) types (note that the package defines its own namespace of `dk.cachet.carp.polar`):

* `dk.cachet.carp.movesense.state` : State changes (like moving, tapping, etc.)
* `dk.cachet.carp.movesense.hr` : Heart rate
* `dk.cachet.carp.movesense.ecg` : Electrocardiogram (ECG)
* `dk.cachet.carp.movesense.temperature` : Device temperature
* `dk.cachet.carp.movesense.imu` : 9-axis Inertial Movement Unit (IMU)

This package uses the Flutter [mdsflutter](https://pub.dev/packages/mdsflutter) plugin, which again is based on the official [Movesense Mobile API](https://www.movesense.com/docs/mobile/mobile_sw_overview/).
The following heart rate devices are supported:

* [Movesense Medical (MD)](https://www.movesense.com/product/movesense-medical-mdr/)
* [Movesense HR+](https://www.movesense.com/product/movesense-sensor-hr/)
* [Movesense HR2](https://www.movesense.com/product/movesense-sensor-hr2/)

See the `carp_mobile_sensing` [wiki](https://github.com/cph-cachet/carp.sensing-flutter/wiki) for further documentation, particularly on available [measure types](https://github.com/cph-cachet/carp.sensing-flutter/wiki/A.-Measure-Types).
See the [CARP Mobile Sensing App](https://github.com/cph-cachet/carp.sensing-flutter/tree/master/apps/carp_mobile_sensing_app) for an example of how to build a mobile sensing app in Flutter.
This demo app also includes support for this Polar sampling package.

For Flutter plugins for other CARP products, see [CARP Mobile Sensing in Flutter](https://github.com/cph-cachet/carp.sensing-flutter).

If you are interested in writing your own sampling packages for CARP, see the description on
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
  carp_movesense_package: ^latest
  ...
`````

See the official Movesense description of [using the plugin](https://pub.dev/packages/mdsflutter#additional-steps-for-using-the-plugin).

### Android Integration

Download `mdslib-x.x.x-release.aar` from the [Movesense-mobile-lib](https://bitbucket.org/movesense/movesense-mobile-lib/src/master/) repository and put it somewhere under `android` folder of your app. Preferably create a new folder named `android/libs` and put it there.

In `build.gradle` of your android project, add the following lines (assuming the `.aar` file is in `android/libs` folder):

```grafle
allprojects {
    repositories {
        ...
        flatDir {
            dirs "$rootDir/libs"
        }
    }
}
```

> **NOTE:** The first time the app starts, make sure to allow it to access the phone location.
This is necessary to use BLE on Android.

### iOS Integration

Install the Movesense iOS library using CocoaPods with adding this line to your app's Podfile:

```pod
pod 'Movesense', :git => 'https://bitbucket.org/movesense/movesense-mobile-lib/'
```

* Remove `use_frameworks!` from your Podfile so that `libmds.a` can be used correctly.
* In your project target settings enable Background Modes, add Uses Bluetooth LE accessories
* In your project target property list add the key [NSBluetoothAlwaysUsageDescription](https://developer.apple.com/documentation/bundleresources/information_property_list/nsbluetoothalwaysusagedescription)

Add this permission in the `Info.plist` file located in `ios/Runner`:

```xml
<key>NSBluetoothAlwaysUsageDescription</key>
<string>Uses bluetooth to connect to the Movesense device</string>
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
import 'package:carp_movesense_package/carp_movesense_package.dart';
`````

Collection of Movesense measures can be added to a study protocol like this.

```dart
  // Create a study protocol
  StudyProtocol protocol = StudyProtocol(
    ownerId: 'owner@dtu.dk',
    name: 'Movesense Sensing Example',
  );

  // define which devices are used for data collection - both phone and eSense
  var phone = Smartphone();
  var movesense = MovesenseDevice(
    serial: '220330000122',
    address: '0C:8C:DC:3F:B2:CD',
    name: 'Movesense Medical',
    deviceType: MovesenseDeviceType.MD,
  );

  protocol
    ..addPrimaryDevice(phone)
    ..addConnectedDevice(movesense, phone);

  // Add a background task that immediately starts collecting HR and ECG data
  // from the Polar device.
  protocol.addTaskControl(
      ImmediateTrigger(),
      BackgroundTask(measures: [
        Measure(type: MovesenseSamplingPackage.HR),
        Measure(type: MovesenseSamplingPackage.ECG),
      ]),
      movesense);
````

Before executing a study with an Movesense measure, register this package in the
[SamplingPackageRegistry](https://pub.dartlang.org/documentation/carp_mobile_sensing/latest/runtime/SamplingPackageRegistry.html).

`````dart
SamplingPackageRegistry().register(MovesenseSamplingPackage());
`````

**NOTE** that the Movesense device `address` must be specified before the phone can connect to the device via BLE. This entails that a Movesense device and its probes should not be connected and resumed, before the device address is know.

Also note that the package does not handle permissions for Bluetooth scanning / connectivity.
This should be handled on an app level.

## Known Limitations

### State Events

There is currently a hardware limitation in the Movesense device and only **one** movement state (movement, tap, double_tap, free_fall) can be subscribed at the same time.
See issue [#15](https://github.com/petri-lipponen-movesense/mdsflutter/issues/15).
Therefore the `MovesenseStateChangeProbe` is only able to collect single tap events and the `STATE` measure hence only reports on tap events.
