# CARP Context Sampling Package

[![pub package](https://img.shields.io/pub/v/carp_context_package.svg)](https://pub.dartlang.org/packages/carp_context_package)
[![pub points](https://img.shields.io/pub/points/carp_context_package?color=2E8B57&label=pub%20points)](https://pub.dev/packages/carp_context_package/score)
[![github stars](https://img.shields.io/github/stars/cph-cachet/carp.sensing-flutter.svg?style=flat&logo=github&colorB=deeppink&label=stars)](https://github.com/cph-cachet/carp.sensing-flutter)
[![MIT License](https://img.shields.io/badge/license-MIT-purple.svg)](https://opensource.org/licenses/MIT)
[![arXiv](https://img.shields.io/badge/arXiv-2006.11904-green.svg)](https://arxiv.org/abs/2006.11904)

This library contains a sampling package for collection of contextual data to work with the [`carp_mobile_sensing`](https://pub.dartlang.org/packages/carp_mobile_sensing) framework.
This packages supports sampling of the following [`Measure`](https://github.com/cph-cachet/carp.sensing-flutter/wiki/A.-Measure-Types) types:

* `dk.cachet.carp.activity`
* `dk.cachet.carp.location`
* `dk.cachet.carp.geofence`
* `dk.cachet.carp.mobility`
* `dk.cachet.carp.weather`
* `dk.cachet.carp.air_quality`

See the [wiki](https://github.com/cph-cachet/carp.sensing-flutter/wiki) for further documentation, particularly on available [measure types](https://github.com/cph-cachet/carp.sensing-flutter/wiki/A.-Measure-Types).
See the [CARP Mobile Sensing App](https://github.com/cph-cachet/carp.sensing-flutter/tree/master/apps/carp_mobile_sensing_app) for an example of how to build a mobile sensing app in Flutter.

For Flutter plugins for other CARP products, see [CARP Mobile Sensing in Flutter](https://github.com/cph-cachet/carp.sensing-flutter).

If you're interested in writing you own sampling packages for CARP, see the description on
how to [extend](https://github.com/cph-cachet/carp.sensing-flutter/wiki/5.-Extending-CARP-Mobile-Sensing) CARP Mobile Sensing on the wiki.

## Installing

To use this package, add the following to you `pubspc.yaml` file. Note that this package only works together with [`carp_mobile_sensing`](https://pub.dev/packages/carp_mobile_sensing).

`````dart
dependencies:
  carp_mobile_sensing: ^latest
  carp_context_package: ^latest
  ...
`````

## Location Permissions

This context package make use of what Apple and Google denote as sensitive information, especially location. Therefore it is important to configure the app to access location information. Please read carefully the [**instructions on how to setup the permission_handler plugin**]( https://pub.dev/packages/permission_handler#setup) - both for Android and iOS.

> [!IMPORTANT]  
> This context package **DOES NOT** asks for accessing location. This should be done by the app since the app should (according to the Apple and Google guidelines) tell the user why location is accessed. The Android Developers documentation contain a good description of how to [request location access at runtime](https://developer.android.com/develop/sensors-and-location/location/permissions#request-location-access-runtime).

### Android

Add the following to your app's `AndroidManifest.xml` file located in `android/app/src/main`:

````xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="<your_package_name>"
    xmlns:tools="http://schemas.android.com/tools">

   ...
   
    <!-- The following permissions are used in the Context Package -->
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" />
    <uses-permission android:name="android.permission.FOREGROUND_SERVICE_LOCATION" />
    <uses-permission android:name="android.permission.WAKE_LOCK" />
    <uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
    <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>

    <!-- For Android 9 (API 28 and earlier), use: -->
    <uses-permission android:name="com.google.android.gms.permission.ACTIVITY_RECOGNITION" />
    <!-- for Android 10 (API 29 and later), use: -->
    <uses-permission android:name="android.permission.ACTIVITY_RECOGNITION" />

</manifest>
````

> [!NOTE]  
> For Android 10 (API 29 and later) use the following permission:
>
> `<uses-permission android:name="android.permission.ACTIVITY_RECOGNITION" />`
>
> See [Privacy changes in Android 10](https://developer.android.com/about/versions/10/privacy/changes#physical-activity-recognition).

> [!NOTE]  
> For Android 14 (API 34 and later) [foreground service types are required](https://developer.android.com/about/versions/14/changes/fgs-types-required) and you should add
>
> `<uses-permission android:name="android.permission.FOREGROUND_SERVICE_LOCATION" />`

### iOS

In order to use Location, you need to set your minimum deployment target to iOS 13.0 or later. Furthermore, you need to enable the macros from the [permission_handler]( https://pub.dev/packages/permission_handler#setup) plugin. Please see the [setup instructions]( https://pub.dev/packages/permission_handler#setup) for iOS.

Change the `post_install` part of your `ios/Podfile`:

```ruby
platform :ios, '14.0'


...

post_install do |installer|
  installer.generated_projects.each do |project|
    project.targets.each do |target|
      target.build_configurations.each do |config|
          config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
      end
    end
  end
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)

    target.build_configurations.each do |config|
      config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= [
        '$(inherited)',
        # See https://pub.dev/packages/permission_handler#setup - under iOS setup

        # the app uses the following permissions:
        'PERMISSION_LOCATION=1',      # Location access
        'PERMISSION_NOTIFICATIONS=1', # CARP Mobile Sensing uses notifications
        'PERMISSION_SENSORS=1',       # Core Motion sensors on iOS (pedometer)
      ]
    end
  end
end

```

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

Also - make sure to activate Background mode for your Runner. Open XCode and go to "Signing & Capabilities". Add the "Background Modes" section and add "Location updates" to the list:

![iOS Setup](https://raw.githubusercontent.com/wiki/rekab-app/background_locator/images/background_location_update.png)

## Using it

To use this package, import it into your app together with the
[`carp_mobile_sensing`](https://pub.dartlang.org/packages/carp_mobile_sensing) package:

`````dart
import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:carp_context_package/context.dart';
`````

Before creating a study and running it, register this package in the [`SamplingPackageRegistry`](https://pub.dev/documentation/carp_mobile_sensing/latest/runtime/SamplingPackageRegistry-class.html).

````dart
SamplingPackageRegistry().register(ContextSamplingPackage());
````

The context package uses different "services" (incl. the phone itself) to collect data.

### Activity Measure

The `ACTIVITY` measure uses the phone itself and can be added like this:

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
protocol.addTaskControl(
    ImmediateTrigger(),
    BackgroundTask(measures: [
      Measure(type: ContextSamplingPackage.ACTIVITY),
    ]),
    phone);
```

### Location Measures

All of the location-based measures;

* `LOCATION`
* `GEOFENCE`
* `MOBILITY`

use the `LocationService` service as a "connected device" to collect data and can be added to a protocol like this:

```dart
// Define the online location service and add it as a 'connected device'
final locationService = LocationService(
    accuracy: GeolocationAccuracy.high,
    distance: 10,
    interval: const Duration(minutes: 1));

protocol.addConnectedDevice(locationService, phone);

// Add a background task that continuously collects location and mobility
// patterns. Delays sampling by 5 minutes.
protocol.addTaskControl(
    DelayedTrigger(delay: Duration(minutes: 5)),
    BackgroundTask(measures: [
      Measure(type: ContextSamplingPackage.LOCATION),
      Measure(type: ContextSamplingPackage.MOBILITY)
    ]),
    locationService);
```

> [!TIP]
> You would often need to balance the configuration of the `LocationService` with the measure you are collecting. For example, if only using the `MOBILITY` measure, a lower `accuracy`, `distance`, and sampling `interval` could be used.

If you only want to collect location information one time during a measurement, you can override the sampling configuration using a `LocationSamplingConfiguration` like this:

```dart
// Add a background task that collects location on a regular basis
// using a periodic trigger and a location sampling configuration that only
// collects location data once.
protocol.addTaskControl(
    PeriodicTrigger(period: Duration(minutes: 5)),
    BackgroundTask(measures: [
      Measure(type: ContextSamplingPackage.LOCATION)
        ..overrideSamplingConfiguration =
            LocationSamplingConfiguration(once: true),
    ]),
    locationService);
```

### Weather and Air Quality Measures

The `WEATHER` and `AIR_QUALITY` measures uses the online [Open Weather API](https://openweathermap.org/api) and [Air Quality Open Data Platform](https://aqicn.org/data-platform/token/#/), respectively.
In order to use these services, you need to obtain an API key from each of them.
Once you have this, these services can be configured and added to a protocol like this:

```dart
// Define the online weather service and add it as a 'device'
final weatherService = WeatherService(apiKey: 'OW_API_key_goes_here');
protocol.addConnectedDevice(weatherService, phone);

// Add a background task that collects weather every 30 minutes.
protocol.addTaskControl(
    PeriodicTrigger(period: Duration(minutes: 30)),
    BackgroundTask(measures: [
      Measure(type: ContextSamplingPackage.WEATHER),
    ]),
    weatherService);

// Define the online air quality service and add it as a 'device'
final airQualityService = AirQualityService(apiKey: 'WAQI_API_key_goes_here');
protocol.addConnectedDevice(airQualityService, phone);

// Add a background task that air quality every 30 minutes.
protocol.addTaskControl(
    PeriodicTrigger(period: Duration(minutes: 30)),
    BackgroundTask(measures: [
      Measure(type: ContextSamplingPackage.AIR_QUALITY),
    ]),
    airQualityService);
```

See the `example.dart` file for more examples of how to set up a CAMS study protocol for this context sampling package.
