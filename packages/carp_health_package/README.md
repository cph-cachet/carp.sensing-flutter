# CARP Health Sampling Package

This library contains a sampling package for sampling health data from Apple Health and/or Google Fit to work with the [`carp_mobile_sensing`](https://pub.dartlang.org/packages/carp_mobile_sensing) framework.
This packages supports sampling of the following [`Measure`](https://pub.dev/documentation/carp_core/latest/carp_core_protocols/Measure-class.html) types:

* `dk.cachet.carp.health`

See the [wiki](https://github.com/cph-cachet/carp.sensing-flutter/wiki) for further documentation, particularly on available [measure types](https://github.com/cph-cachet/carp.sensing-flutter/wiki/A.-Measure-Types).
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
  carp_health_package: ^latest
  ...
`````

In general, you need to follow the setup guides in the [health](https://pub.dev/packages/health#setup) plugin.

### Android Integration

The [health](https://pub.dev/packages/health) plugin supports both [Google Fit](https://www.google.com/fit/) and [Health Connect](https://health.google/health-connect-android/).

Google Fit can be tricky to set up and it requires a separate app to be installed.
Please follow this [guide to set up Google Fit](https://developers.google.com/fit/android/get-started).
Check out the documentation of the [`health`](https://pub.dev/packages/health#google-fit-android-option-1) package.

[Health Connect](https://developer.android.com/guide/health-and-fitness/health-connect) seems more simple to setup - see the documentation on the [`health`](https://pub.dev/packages/health#google-fit-android-option-2) package.

Health Connect requires the following lines in the `AndroidManifest.xml` file:

```xml
<queries>
    <package android:name="com.google.android.apps.healthdata" />
        <intent>
            <action android:name="androidx.health.ACTION_SHOW_PERMISSIONS_RATIONALE" />
        </intent>
</queries>
```

### iOS Integration

Add this permission in the `Info.plist` file located in `ios/Runner`:

```xml
<key>NSHealthShareUsageDescription</key>
<string>We will sync your data with the Apple Health app to give you better insights</string>
<key>NSHealthUpdateUsageDescription</key>
<string>We will sync your data with the Apple Health app to give you better insights</string>
```

Then open your Flutter project in XCode by right clicking on the "ios" folder and selecting "Open in XCode". Enable "HealthKit" by adding a capability inside the "Signing & Capabilities" tab of the Runner target's settings.

## Using it

To use this package, import it into your app together with the
[`carp_mobile_sensing`](https://pub.dartlang.org/packages/carp_mobile_sensing) package:

`````dart
import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:carp_health_package/health.dart';
`````

Before creating a study and running it, register this package in the
[SamplingPackageRegistry](https://pub.dartlang.org/documentation/carp_mobile_sensing/latest/runtime/SamplingPackageRegistry.html).

`````dart
SamplingPackageRegistry().register(HealthSamplingPackage());
`````

When defining a study protocol with a health measure, it would look like this:

```dart
  // automatically collect the default (steps) data every hour
  protocol.addTaskControl(
      PeriodicTrigger(period: Duration(minutes: 60)),
      BackgroundTask(measures: [Measure(type: HealthSamplingPackage.HEALTH)]),
      phone);
```

This would collect health data every hour using the default configuration (which only collect step count).
Configuration of what data to collect is done via the `HealthSamplingConfiguration` which can be used to override the default configuration:

```dart
  // automatically collect a set of health data every hour
  protocol.addTaskControl(
      PeriodicTrigger(period: Duration(minutes: 60)),
      BackgroundTask()
        ..addMeasure(Measure(type: HealthSamplingPackage.HEALTH)
          ..overrideSamplingConfiguration =
              HealthSamplingConfiguration(healthDataTypes: [
            HealthDataType.BLOOD_GLUCOSE,
            HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
            HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
            HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
            HealthDataType.HEART_RATE,
            HealthDataType.STEPS,
          ])),
      phone);
```

The `HealthSamplingConfiguration` can be configured to collect a specific set of [`HealthDataType`](https://pub.dev/documentation/health/latest/health/HealthDataType-class.html), like:

* BODY_FAT_PERCENTAGE,
* HEIGHT,
* WEIGHT,
* BODY_MASS_INDEX,
* WAIST_CIRCUMFERENCE,
* STEPS,
* ...

See the [`HealthDataType`](https://pub.dev/documentation/health/latest/health/HealthDataType-class.html) documentation for a complete list.

A `HealthSamplingConfiguration` is a [`HistoricSamplingConfiguration`](https://pub.dev/documentation/carp_mobile_sensing/latest/domain/HistoricSamplingConfiguration-class.html).
This means that when triggered, the task and measure will try to collect data back to the last time data was collected.
Hence, this probe is suited for configuration using some trigger that collects data on a regular basis, like the `PeriodicTrigger` used above.
However, it can also be configured using as an [`AppTask`](https://pub.dev/documentation/carp_mobile_sensing/latest/domain/AppTask-class.html) that asks the user to collect the data.

```dart
  // create an app task for the user to collect his own health data every day
  protocol.addTaskControl(
      PeriodicTrigger(period: Duration(hours: 24)),
      AppTask(
          type: 'health',
          title: "Press here to collect your physical health data",
          description: "This will collect your weight, exercise time, steps, and sleep time from Apple Health.",
          measures: [
            Measure(type: HealthSamplingPackage.HEALTH)
              ..overrideSamplingConfiguration =
                  HealthSamplingConfiguration(healthDataTypes: [
                HealthDataType.WEIGHT,
                HealthDataType.EXERCISE_TIME,
                HealthDataType.STEPS,
                HealthDataType.SLEEP_ASLEEP,
              ])
          ]),
      phone);
```

See the `example.dart` file for a full example of how to set up a CAMS study protocol for this sampling package.
