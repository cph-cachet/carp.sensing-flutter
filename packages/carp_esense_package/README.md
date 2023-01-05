# CARP eSense Sampling Package

This library contains a sampling package for
the [`carp_mobile_sensing`](https://pub.dartlang.org/packages/carp_mobile_sensing) framework
to work with the [eSense](https://www.esense.io) earable computing platform.
This packages supports sampling of the following [`Measure`](https://pub.dev/documentation/carp_core/latest/carp_core_protocols/Measure-class.html) types (note that the package defines its own namespace of `dk.cachet.carp.esense`):

* `dk.cachet.carp.esense.button` : eSense button pressed / released events
* `dk.cachet.carp.esense.sensor` : eSense sensor (accelerometer & gyroscope) events.

See the user documentation on the [eSense device](https://www.esense.io/share/eSense-User-Documentation.pdf) for how to use the device.
See the [`esense_flutter`](https://pub.dev/packages/esense_flutter) Flutter plugin and its [API](https://pub.dev/documentation/esense_flutter/latest/) documentation to understand how sensor data is generated and their data formats.

See the `carp_mobile_sensing` [wiki](https://github.com/cph-cachet/carp.sensing-flutter/wiki) for further documentation, particularly on available [measure types](https://github.com/cph-cachet/carp.sensing-flutter/wiki/A.-Measure-Types).
See the [CARP Mobile Sensing App](https://github.com/cph-cachet/carp.sensing-flutter/tree/master/apps/carp_mobile_sensing_app) for an example of how to build a mobile sensing app in Flutter.

For Flutter plugins for other CARP products, see [CARP Mobile Sensing in Flutter](https://github.com/cph-cachet/carp.sensing-flutter).

If you're interested in writing you own sampling packages for CARP, see the description on
how to [extend](https://github.com/cph-cachet/carp.sensing-flutter/wiki/4.-Extending-CARP-Mobile-Sensing) CARP on the wiki.

## Installing

To use this package, add the following to you `pubspc.yaml` file. Note that
this package only works together with `carp_mobile_sensing`.

`````dart
dependencies:
  flutter:
    sdk: flutter
  carp_core: ^latest
  carp_mobile_sensing: ^latest
  carp_esense_package: ^latest
  ...
`````

### Android Integration

Add the following to your app's `manifest.xml` file located in `android/app/src/main`:

```xml
<uses-permission android:name="android.permission.BLUETOOTH"/>
<uses-permission android:name="android.permission.BLUETOOTH_ADMIN"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-feature android:name="android.hardware.bluetooth_le" android:required="true"/>
```

> **NOTE:** The first time the app starts, make sure to allow it to access the phone location.
This is necessary to use the BLE on Android.
> **NOTE:** This package only supports AndroidX and hence requires any Android app using this plugin to also [migrate](https://developer.android.com/jetpack/androidx/migrate) if they're using the original support library.
See Flutter [AndroidX compatibility](https://flutter.dev/docs/development/packages-and-plugins/androidx-compatibility)

### iOS Integration

Requires iOS 10 or later. Hence, in your `Podfile` in the `ios` folder of your app,
make sure that the platform is set to `10.0`.

```pod
platform :ios, '10.0'
```

Add this permission in the `Info.plist` file located in `ios/Runner`:

```xml
<key>NSBluetoothAlwaysUsageDescription</key>
<string>Uses bluetooth to connect to the eSense device</string>
<key>UIBackgroundModes</key>
<array>
  <string>audio</string>
  <string>external-accessory</string>
  <string>fetch</string>
  <string>bluetooth-central</string>
</array>

```

## Using it

To use this package, import it into your app together with the
[`carp_mobile_sensing`](https://pub.dartlang.org/packages/carp_mobile_sensing) package:

`````dart
import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:carp_esense_package/esense.dart';
`````

Collection of eSense measurements can be added to a study protocol like this.

```dart
  // Create a study protocol
  StudyProtocol protocol = StudyProtocol(
    ownerId: 'owner@dtu.dk',
    name: 'eSense Sensing Example',
  );

  // define which devices are used for data collection - both phone and eSense
  var phone = Smartphone();
  var eSense = ESenseDevice(
    deviceName: 'eSense-0223',
    samplingRate: 10,
  );

  protocol
    ..addPrimaryDevice(phone)
    ..addConnectedDevice(eSense);

  // Add a background task that immediately starts collecting step counts,
  //ambient light, screen activity, and battery level from the phone.
  protocol.addTaskControl(
      ImmediateTrigger(),
      BackgroundTask(measures: [
        Measure(type: SensorSamplingPackage.STEP_COUNT),
        Measure(type: SensorSamplingPackage.AMBIENT_LIGHT),
        Measure(type: DeviceSamplingPackage.SCREEN_EVENT),
        Measure(type: DeviceSamplingPackage.BATTERY_STATE),
      ]),
      phone);

  // Add a background task that immediately starts collecting eSense button and
  // sensor events from the eSense device.
  protocol.addTaskControl(
      ImmediateTrigger(),
      BackgroundTask(measures: [
        Measure(type: ESenseSamplingPackage.ESENSE_BUTTON),
        Measure(type: ESenseSamplingPackage.ESENSE_SENSOR),
      ]),
      eSense);
````

Before executing a study with an eSense measure, register this package in the
[SamplingPackageRegistry](https://pub.dartlang.org/documentation/carp_mobile_sensing/latest/runtime/SamplingPackageRegistry.html).

`````dart
SamplingPackageRegistry().register(ESenseSamplingPackage());
`````

> **NOTE** that the eSense device must be paired with the phone via BLE **before** CAMS can connect to it.
