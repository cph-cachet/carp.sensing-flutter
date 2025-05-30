# CARP Health Sampling Package

[![pub package](https://img.shields.io/pub/v/carp_health_package.svg)](https://pub.dartlang.org/packages/carp_health_package)
[![pub points](https://img.shields.io/pub/points/carp_health_package?color=2E8B57&label=pub%20points)](https://pub.dev/packages/carp_health_package/score)
[![github stars](https://img.shields.io/github/stars/cph-cachet/carp.sensing-flutter.svg?style=flat&logo=github&colorB=deeppink&label=stars)](https://github.com/cph-cachet/carp.sensing-flutter)
[![MIT License](https://img.shields.io/badge/license-MIT-purple.svg)](https://opensource.org/licenses/MIT)
[![arXiv](https://img.shields.io/badge/arXiv-2006.11904-green.svg)](https://arxiv.org/abs/2006.11904)

This library contains a sampling package for sampling health data from Apple Health and Google Health Connect to work with the [carp_mobile_sensing](https://pub.dartlang.org/packages/carp_mobile_sensing) framework. It uses the [health](https://pub.dev/packages/health) plugin for this.
This packages supports sampling of the following [`Measure`](https://pub.dev/documentation/carp_core/latest/carp_core_common/Measure-class.html) type:

* `dk.cachet.carp.health`

See the [wiki](https://github.com/cph-cachet/carp.sensing-flutter/wiki) for further documentation, particularly on available [measure types](https://github.com/cph-cachet/carp.sensing-flutter/wiki/A.-Measure-Types).
See the [CARP Mobile Sensing App](https://github.com/cph-cachet/carp.sensing-flutter/tree/main/apps/carp_mobile_sensing_app) for an example of how to build a mobile sensing app in Flutter.

For Flutter plugins for other CARP products, see [CARP Mobile Sensing in Flutter](https://github.com/cph-cachet/carp.sensing-flutter).

If you're interested in writing you own sampling packages for CARP, see the description on
how to [extend](https://github.com/cph-cachet/carp.sensing-flutter/wiki/5.-Extending-CARP-Mobile-Sensing) CARP on the wiki.

## Installing

To use this package, add the following to you `pubspc.yaml` file. Note that
this package only works together with `carp_mobile_sensing`.

`````dart
dependencies:
  carp_core: ^latest
  carp_mobile_sensing: ^latest
  carp_health_package: ^latest
  ...
`````

Then, follow the setup guides in the [health](https://pub.dev/packages/health#setup) plugin. Note that there are quite a lot of details to getting the Health plugin to work, including handling permissions.
For example, on Android, if the user denies access to the health data types TWICE, then the permissions are permanently denied and the app cannot ask anymore. In this case, the app cannot be used to request permissions. Instead, the user must manually go to the settings of the phone and enable the permissions. So make sure to follow the guideline carefully.

### Android Integration

This sampling package **only** supports Google [Health Connect](https://health.google/health-connect-android/). To configure your app to use Health Connect, follow the documentation on the [`health`](https://pub.dev/packages/health#health-connect-android-option-2) package and on the [Android Developer page](https://developer.android.com/guide/health-and-fitness/health-connect/get-started).

> [!IMPORTANT]  
> Health Connect requires API level 34 and quite some edits to the `Manifest.xml` file, including declaring permissions to **all** the health data types you want to access. Read more on [Health Connect data types and permissions](https://developer.android.com/health-and-fitness/guides/health-connect/plan/data-types). If you are targeting SDK levels < 34 make sure to install the Health Connect app. Read more on the ["Get started with Health Connect "](https://developer.android.com/health-and-fitness/guides/health-connect/develop/get-started) page.

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="dk.cachet.carp_mobile_sensing_app"
    xmlns:tools="http://schemas.android.com/tools">

    <!-- Check whether Health Connect is installed or not -->
    <queries>
        <package android:name="com.google.android.apps.healthdata" />
        <intent>
            <action android:name="androidx.health.ACTION_SHOW_PERMISSIONS_RATIONALE" />
        </intent>
    </queries>    

    ...

     <!-- Permissions for Health Connect -->
    <uses-permission android:name="android.permission.health.READ_STEPS"/>
    <uses-permission android:name="android.permission.health.READ_WEIGHT"/>

    ...

   <application
        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:launchMode="singleTop"

            ...

            <!-- Intention to show Permissions screen for Health Connect API -->
            <intent-filter>
                <action android:name="androidx.health.ACTION_SHOW_PERMISSIONS_RATIONALE" />
            </intent-filter>
        </activity>

```

### iOS Integration

See the setup guide for iOS in the [health](https://pub.dev/packages/health#apple-health-ios) package.

Add this permission in the `Info.plist` file located in `ios/Runner`:

```xml
<key>NSHealthShareUsageDescription</key>
<string>We will sync your data with the Apple Health app to give you better insights</string>
<key>NSHealthUpdateUsageDescription</key>
<string>We will sync your data with the Apple Health app to give you better insights</string>
```

Then open your Flutter project in XCode by right clicking on the `ios` folder and selecting "Open in XCode". Enable "HealthKit" by adding a capability inside the "Signing & Capabilities" tab of the Runner target's settings.

## Using it

To use this package, import it into your app together with the
[`carp_mobile_sensing`](https://pub.dartlang.org/packages/carp_mobile_sensing) package:

`````dart
import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:carp_health_package/health_package.dart';
import 'package:health/health.dart';
`````

Before creating a study and running it, register this package in the
[`SamplingPackageRegistry`](https://pub.dev/documentation/carp_mobile_sensing/latest/runtime/SamplingPackageRegistry-class.html).

`````dart
SamplingPackageRegistry().register(HealthSamplingPackage());
`````

Now we can define a study protocol with a health device:

```dart
  // Create a study protocol
  StudyProtocol protocol = StudyProtocol(
    ownerId: 'owner@dtu.dk',
    name: 'Health Sensing Example',
  );

  // Define which devices are used for data collection.

  // First add this smartphone.
  final phone = Smartphone();
  protocol.addPrimaryDevice(phone);

  // Create and add a health service (device)
  final healthService = HealthService();
  protocol.addConnectedDevice(healthService, phone);
```

There are two ways to use the health package in a CAMS protocol:

* Defining a [**App Task**](https://github.com/cph-cachet/carp.sensing-flutter/wiki/4.-The-AppTask-Model) where the user is asked to collect his/her own health data
* Defining a [**Background Sensing Task**](https://github.com/cph-cachet/carp.sensing-flutter/wiki/3.-Using-CARP-Mobile-Sensing#defining-a-study-protocol), where health data is collected in the background

### Health App Task

Defining an app task to collect health data is done using the `HealthAppTask` task, like shown below:

```dart
  // Create a health app task for the user to collect his own health data once pr. day
  protocol.addTaskControl(
      PeriodicTrigger(period: Duration(hours: 24)),
      HealthAppTask(
          title: "Press here to collect your physical health data",
          description:
              "This will collect your weight, exercise time, steps, and sleep "
              "time from the Health database on the phone.",
          types: [
            HealthDataType.WEIGHT,
            HealthDataType.STEPS,
            HealthDataType.BASAL_ENERGY_BURNED,
            HealthDataType.SLEEP_SESSION,
          ]),
      phone);
```

In this case, a user task will be added to the task list once per day and when the user clicks (start) this user task, the health data types specified in the list of `types` are collected. Once data collection is done, the user task is marked as done in the task list.

> [!NOTE]  
> A `HealthAppTask` will ask the user to give permissions to collect the listed types, if not granted. This will open up the OS-level permission dialogue on both Android and iOS.

### Background Sensing Task

Background sampling of health data can be configured by a measure in the protocol. This measure is created using the factory method `HealthSamplingPackage.getHealthMeasure()` that takes a list of of [`HealthDataType`](https://pub.dev/documentation/health/latest/health/HealthDataType.html) types.

```dart
  // Automatically collect a set of health data every hour.
  protocol.addTaskControl(
      PeriodicTrigger(period: Duration(minutes: 60)),
      BackgroundTask(measures: [
        HealthSamplingPackage.getHealthMeasure([
          HealthDataType.STEPS,
          HealthDataType.BASAL_ENERGY_BURNED,
          HealthDataType.WEIGHT,
          HealthDataType.SLEEP_SESSION,
        ])
      ]),
      healthService);
```

Background sensing of health data is done by the `HealthService` specified in the protocol above.

> [!NOTE]  
> Background collection of health data **does not** ask for permissions (this will cause the app to show the Health permission dialogue at an arbitrary time to the user, which is not compliant to [the UX guidelines from Google](https://developer.android.com/health-and-fitness/guides/health-connect/design/permissions-and-data) and Apple to only show this dialogue in the context where the collection of health data is explained to the user). Handling of permissions is done via the `HealthService` by using the `hasPermissions()` and `requestPermissions(()` methods.

> [!NOTE]  
> Health data can only be collected when the app is in the foreground and the phone is unlocked. This applies both for Android and iOS. Hence, the term "background sensing" should be taken with a gran of salt.

One way to ensure that health data is collected while the app is in foreground, is to add the collection of health measures to an App Task (e.g., a survey):

```dart
  protocol.addTaskControl(
      RecurrentScheduledTrigger(
        type: RecurrentType.daily,
        time: TimeOfDay(hour: 13),
      ),
      RPAppTask(
          type: SurveyUserTask.SURVEY_TYPE,
          name: 'WHO-5 Survey',
          rpTask: who5Task,
          measures: [
            Measure(type: SensorSamplingPackage.AMBIENT_LIGHT),
            HealthSamplingPackage.getHealthMeasure([
              HealthDataType.HEART_RATE,
              HealthDataType.STEPS,
            ])
          ]),
      phone);
```

In this case, ambient light, heart rate and steps are collected as part of the user filling in a WHO-5 survey.

### Configuration

The health measures are [one-time measures](https://github.com/cph-cachet/carp.sensing-flutter/wiki/A.-Measure-Types#event-based-vs-one-time-measures), which implies that health data is collected when the measure is triggered. In the examples above, this happens either when the user click the user task or periodically (once pr. hour). Configuration of what data to collect is done via the [`HealthSamplingConfiguration`](https://pub.dev/documentation/carp_health_package/latest/health_package/HealthSamplingConfiguration-class.html) which is used to override the default configuration (default is to collect nothing). The `getHealthMeasure()` factory method is a convenient way to create a `Measure` with the correct `HealthSamplingConfiguration`.

The `HealthSamplingConfiguration` can be configured to collect a set of [`HealthDataType`](https://pub.dev/documentation/health/latest/health/HealthDataType-class.html) data, like:

* BODY_FAT_PERCENTAGE,
* HEIGHT,
* WEIGHT,
* BODY_MASS_INDEX,
* WAIST_CIRCUMFERENCE,
* STEPS,
* ...

See the [`HealthDataType`](https://pub.dev/documentation/health/latest/health/HealthDataType.html) documentation for a complete list.

A `HealthSamplingConfiguration` is a [`HistoricSamplingConfiguration`](https://pub.dev/documentation/carp_mobile_sensing/latest/domain/HistoricSamplingConfiguration-class.html). This means that when triggered, the task and measure will try to collect data back to the last time data was collected. Hence, this measure is suited for configuration using some trigger that collects data on a regular basis, like the `PeriodicTrigger` used above.

See the `example.dart` file for a full example of how to set up a CAMS study protocol for this sampling package.

## Collected Data

The data collected is contained in a [`HealthData`](https://pub.dev/documentation/carp_health_package/latest/health_package/HealthData-class.html) object, which wraps the data collected from a [`HealthDataPoint`](https://pub.dev/documentation/health/latest/health/HealthDataPoint-class.html). For example, workout collected from Apple Health serialized to JSON may looks like this:

```json
{
 "sensorStartTime": 1700415799841973,
 "data": {
  "__type": "dk.cachet.carp.health.workout",
  "uuid": "4321",
  "value": {
   "workoutActivityType": "AEROBICS",
   "totalEnergyBurned": 8,
   "totalEnergyBurnedUnit": "KILOCALORIE",
   "totalDistance": 1000,
   "totalDistanceUnit": "METER"
  },
  "unit": "NO_UNIT",
  "date_from": "2023-11-19T09:43:19.841907Z",
  "date_to": "2023-11-19T17:43:19.841907Z",
  "data_type": "WORKOUT",
  "platform": "APPLE_HEALTH",
  "device_id": "1234",
  "source_id": "4321",
  "source_name": "4321"
 }
}
```

Similarly, step counts collected from Google Health Connect would look like this.

```json
{
  "sensorStartTime": 1704582000000000,
  "sensorEndTime": 1704668399999000,
  "data": {
   "__type": "dk.cachet.carp.health.steps",
   "uuid": "85328732-41d3-53b2-a81e-007f33bee353",
   "value": {
    "numericValue": "1982"
   },
   "unit": "COUNT",
   "date_from": "2024-01-06T23:00:00.000Z",
   "date_to": "2024-01-07T22:59:59.999Z",
   "data_type": "STEPS",
   "platform": "GOOGLE_HEALTH_CONNECT",
   "device_id": "SP1A.210812.016",
   "source_id": "",
   "source_name": "com.sec.android.app.shealth"
  }
}
```

The type of the collected health data is `dk.cachet.carp.health.workout` or `dk.cachet.carp.health.steps`. In general, the collected health data has the type of `dk.cachet.carp.health.<health_type>`, where `health_type` is the lower-case version of the [`HealthDataType`](https://pub.dev/documentation/health/latest/health/HealthDataType.html).
