# CARP Context Sampling Package

This library contains a sampling package for collection of contextual data to work with the [`carp_mobile_sensing`](https://pub.dartlang.org/packages/carp_mobile_sensing) framework.
This packages supports sampling of the following [`Measure`](https://pub.dev/documentation/carp_core/latest/carp_core_protocols/Measure-class.html) types:

* `dk.cachet.carp.activity`
* `dk.cachet.carp.location`
* `dk.cachet.carp.geolocation`
* `dk.cachet.carp.geofence`
* `dk.cachet.carp.mobility`
* `dk.cachet.carp.weather`
* `dk.cachet.carp.air_quality`

See the [wiki](https://github.com/cph-cachet/carp.sensing-flutter/wiki) for further documentation, particularly on available [measure types](https://github.com/cph-cachet/carp.sensing-flutter/wiki/A.-Measure-Types).
See the [CARP Mobile Sensing App](https://github.com/cph-cachet/carp.sensing-flutter/tree/master/apps/carp_mobile_sensing_app) for an example of how to build a mobile sensing app in Flutter.

For Flutter plugins for other CARP products, see [CARP Mobile Sensing in Flutter](https://github.com/cph-cachet/carp.sensing-flutter).

If you're interested in writing you own sampling packages for CARP, see the description on
how to [extend](https://github.com/cph-cachet/carp.sensing-flutter/wiki/4.-Extending-CARP-Mobile-Sensing) CARP on the wiki.

## Installing

To use this package, add the following to you `pubspc.yaml` file. Note that this package only works together with [`carp_mobile_sensing`](https://pub.dev/packages/carp_mobile_sensing).

`````dart
dependencies:
  flutter:
    sdk: flutter
  carp_mobile_sensing: ^latest
  carp_context_package: ^latest
  ...
`````

### Android Integration

Add the following to your app's `manifest.xml` file located in `android/app/src/main`:

````xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="<your_package_name>"
    xmlns:tools="http://schemas.android.com/tools">

   ...
   
    <!-- The following permissions are used in the Context Package -->
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" />
    <uses-permission android:name="android.permission.WAKE_LOCK" />
    <uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
    <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>

    <!-- For Android 9 (API 28 and earlier), use: -->
    <uses-permission android:name="com.google.android.gms.permission.ACTIVITY_RECOGNITION" />
    <!-- for Android 10 (API 29 and later), use: -->
    <uses-permission android:name="android.permission.ACTIVITY_RECOGNITION" />

</manifest>
````

> **NOTE:** For Android 10 (API 29 and later) use the following permission:
>
> `<uses-permission android:name="android.permission.ACTIVITY_RECOGNITION" />`
>
> See [Privacy changes in Android 10](https://developer.android.com/about/versions/10/privacy/changes#physical-activity-recognition).

### iOS Integration

Add the following permissions in the `Info.plist` file located in `ios/Runner` (use your own text for explanation in the `<string>` tags):

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Uses the location API to record location.</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>Uses the location API to record location.</string>
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>Uses the location API to record location.</string>
<key>NSMotionUsageDescription</key>
<string>Detects activity.</string>
<key>UIBackgroundModes</key>
  <array>
    <string>fetch</string>
    <string>location</string>
  </array>
```

In app settings enable `Background Modes` and check `Location Updates`.

![iOS Setup](https://raw.githubusercontent.com/wiki/rekab-app/background_locator/images/background_location_update.png)

## Using it

To use this package, import it into your app together with the
[`carp_mobile_sensing`](https://pub.dartlang.org/packages/carp_mobile_sensing) package:

`````dart
import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:carp_context_package/context.dart';
`````

Before creating a study and running it, register this package in the [SamplingPackageRegistry](https://pub.dev/documentation/carp_mobile_sensing/latest/runtime/SamplingPackageRegistry-class.html).

````dart
  SamplingPackageRegistry().register(ContextSamplingPackage());
````

In order to use the context measures to a study protocol, this context package uses different "services" to collect data.

The `dk.cachet.carp.activity` measure uses the phone itself and can be added like this:

```dart
  // Create a study protocol
  StudyProtocol protocol = StudyProtocol(
    ownerId: 'owner@dtu.dk',
    name: 'Context Sensing Example',
  );

  // Define the smartphone as the master device.
  Smartphone phone = Smartphone();
  protocol.addMasterDevice(phone);

  // Add a background task that collects activity data from the phone
  protocol.addTriggeredTask(
      ImmediateTrigger(),
      BackgroundTask()
        ..addMeasure(Measure(type: ContextSamplingPackage.ACTIVITY)),
      phone);
```

All of the location-based measures;

* `dk.cachet.carp.location`
* `dk.cachet.carp.geolocation`
* `dk.cachet.carp.geofence`
* `dk.cachet.carp.mobility`

uses the `LocationService` service as a 'connected device' to collect data and can be added to a protocol like this:

```dart
  // Define the online location service and add it as a 'device'
  LocationService locationService = LocationService(
      accuracy: GeolocationAccuracy.high,
      distance: 10,
      interval: const Duration(minutes: 1));
  protocol.addConnectedDevice(locationService);

  // Add a background task that collects location on a regular basis
  protocol.addTriggeredTask(
      IntervalTrigger(period: Duration(minutes: 5)),
      BackgroundTask()
        ..addMeasure(Measure(type: ContextSamplingPackage.LOCATION)),
      locationService);
```

> Note that you would often need to balance the configuration of the `LocationService` with the measure you are collecting. For example, if only using the `mobility` measure, a lower `accuracy`, `distance`, and sampling `interval` could be used.

The `dk.cachet.carp.weather` and `dk.cachet.carp.air_quality` measures uses the online [Open Weather API](https://openweathermap.org/api) and [Air Quality Open Data Platform](https://aqicn.org/data-platform/token/#/), respectively.
In order to use these service, you need to obtain an API key from each of them.
Once you have this, these services can be configured and added to a protocol like this:

```dart
  // Define the online weather service and add it as a 'device'
  WeatherService weatherService =
      WeatherService(apiKey: 'OW_API_key_goes_here');
  protocol.addConnectedDevice(weatherService);

  // Add a background task that collects weather every 30 miutes.
  protocol.addTriggeredTask(
      IntervalTrigger(period: Duration(minutes: 30)),
      BackgroundTask()
        ..addMeasure(Measure(type: ContextSamplingPackage.WEATHER)),
      weatherService);

  // Define the online air quality service and add it as a 'device'
  AirQualityService airQualityService =
      AirQualityService(apiKey: 'WAQI_API_key_goes_here');
  protocol.addConnectedDevice(airQualityService);

  // Add a background task that air quality every 30 miutes.
  protocol.addTriggeredTask(
      IntervalTrigger(period: Duration(minutes: 30)),
      BackgroundTask()
        ..addMeasure(Measure(type: ContextSamplingPackage.AIR_QUALITY)),
      airQualityService);
```

See the `example.dart` file for a full example of how to set up a CAMS study protocol for this context sampling package.
