# CARP Movisens Sampling Package

This library contains a [`carp_mobile_sensing`](https://pub.dartlang.org/packages/carp_mobile_sensing) (CAMS) sampling package for collecting data from [Movisens](https://www.movisens.com) devices:

* [Move 4](https://docs.movisens.com/Sensors/Move4/)
* [EcgMove 4](https://docs.movisens.com/Sensors/EcgMove4/)
* [EdaMove 4](https://docs.movisens.com/Sensors/EdaMove4/)

> [!IMPORTANT]
> As stressed by Movisens, none of the Movisens devices are medical devices. Do not use them for medical purposes.

This packages supports sampling of the following [`Measure`](https://pub.dev/documentation/carp_core/latest/carp_core_protocols/Measure-class.html) types:

* `dk.cachet.carp.movisens.activity` – Physical activity like body positions, step count, inclination, acceleration, and metabolic (MET) levels.
* `dk.cachet.carp.movisens.hr` - Heart Rate (HR), HR Variability (HRV), Mean HR
* `dk.cachet.carp.movisens.eda` - Elecrodermal Activity
* `dk.cachet.carp.movisens.skin_temperature` - Skin temperature.
* `dk.cachet.carp.movisens.tap_marker` - Markers of user tapping on the sensor.

These measures collect different types of data (note that the package defines its own namespace of `dk.cachet.carp.movisens...`):

**Physical Activity:**

* `dk.cachet.carp.movisens.activity.steps`
* `dk.cachet.carp.movisens.activity.body_position`
* `dk.cachet.carp.movisens.activity.inclination`
* `dk.cachet.carp.movisens.activity.movement_acceleration`
* `dk.cachet.carp.movisens.activity.met_level`
* `dk.cachet.carp.movisens.activity.met`

**Heart Rate:**

* `dk.cachet.carp.movisens.hr.hr_mean`
* `dk.cachet.carp.movisens.hr.hrv`
* `dk.cachet.carp.movisens.hr.is_hrv_valid`

**Misc:**

* `dk.cachet.carp.movisens.eda`
* `dk.cachet.carp.movisens.skin_temperature`
* `dk.cachet.carp.movisens.tap_marker`

For understanding how to use the Movisens Devices, please consult the [Movisens Documentation](https://docs.movisens.com).

See the [wiki](https://github.com/cph-cachet/carp.sensing-flutter/wiki) for further documentation on how to use the CARP Mobile Sensing (CAMS) framework.
See the [CARP Mobile Sensing App](https://github.com/cph-cachet/carp.sensing-flutter/tree/master/apps/carp_mobile_sensing_app) for an example of how to build a mobile sensing app in Flutter.
For Flutter plugins for other CARP products, see [CARP Mobile Sensing in Flutter](https://github.com/cph-cachet/carp.sensing-flutter).

If you're interested in writing you own sampling packages for CAMS, see the description on how to [extend](https://github.com/cph-cachet/carp.sensing-flutter/wiki/4.-Extending-CARP-Mobile-Sensing) CARP on the wiki.

## Installing

To use this package, add the following to you `pubspc.yaml` file. Note that
this package only works together with `carp_mobile_sensing`.

`````dart
dependencies:
  carp_core: ^latest
  carp_mobile_sensing: ^latest
  carp_movisens_package: ^latest
  ...
`````

### Android Integration

Add the following to your app's `manifest.xml` file located in `android/app/src/main`:

```xml
  <uses-permission android:name="android.permission.BLUETOOTH" />
  <uses-permission android:name="android.permission.BLUETOOTH_ADMIN" />
  <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
```

Update the Android `minSdkVersion` to at least 19 in the `android/app/build.gradle` file.

### iOS Integration

Add the following to your `ios/Runner/Info.plist` file:

```xml
<dict>
  <key>NSBluetoothAlwaysUsageDescription</key>
  <string>Need BLE permission</string>
  <key>NSBluetoothPeripheralUsageDescription</key>
  <string>Need BLE permission</string>
  <key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
  <string>Need Location permission</string>
  <key>NSLocationAlwaysUsageDescription</key>
  <string>Need Location permission</string>
  <key>NSLocationWhenInUseUsageDescription</key>
  <string>Need Location permission</string>
````

## Usage

To use this package, import it into your app together with the
[`carp_mobile_sensing`](https://pub.dartlang.org/packages/carp_mobile_sensing) package:

`````dart
import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:movisens_package/movisens.dart';
`````

Before creating a study and running it, register this package in the
[SamplingPackageRegistry](https://pub.dartlang.org/documentation/carp_mobile_sensing/latest/runtime/SamplingPackageRegistry.html).

`````dart
 SamplingPackageRegistry().register(MovisensSamplingPackage());
`````

Once the package is registered, Movisens measures can be added to a study protocol like this.

````dart
  // register this sampling package before using its measures
  SamplingPackageRegistry().register(MovisensSamplingPackage());

  // Create a study protocol
  StudyProtocol protocol = StudyProtocol(
    ownerId: 'owner@dtu.dk',
    name: 'Movisens Example',
  );

  // define which devices are used for data collection - both phone and Movisens
  Smartphone phone = Smartphone();
  MovisensDevice movisens = MovisensDevice(
    deviceName: 'MOVISENS Sensor 02655',
    sensorLocation: SensorLocation.Chest,
    sex: Sex.Male,
    height: 175,
    weight: 75,
    age: 25,
  );

  protocol
    ..addPrimaryDevice(phone)
    ..addConnectedDevice(movisens);

  // adding a movisens measure
  protocol.addTaskControl(
      ImmediateTrigger(),
      BackgroundTask(name: 'Movisens Task', measures: [
        Measure(type: MovisensSamplingPackage.ACTIVITY),
      ]),
      movisens);
````

This protocol collects physical activity data (steps, inclination, etc.) from a Movisens device with the name `MOVISENS Sensor 02655`.
The default Movisens names of devices are `MOVISENS Sensor <serial>`, where `serial` is the 5-digit serial number written on the back of the device.
Once this protocol is deployed on a phone and connected to a Movisens device using Bluetooth, it will start to collect the physical activity data from the device.
Please see the [CARP Mobile Sensing App](https://github.com/cph-cachet/carp.sensing-flutter/tree/master/apps/carp_mobile_sensing_app) for an example of how to build a mobile sensing app that can handle protocols and connect to devices.
