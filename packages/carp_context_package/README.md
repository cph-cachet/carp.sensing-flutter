# CARP Context Sampling Package

[![pub package](https://img.shields.io/pub/v/carp_context_package.svg)](https://pub.dartlang.org/packages/carp_context_package)

This library contains a sampling package for context sampling to work with 
the [`carp_mobile_sensing`](https://pub.dartlang.org/packages/carp_mobile_sensing) framework.
This packages supports sampling of the following [`Measure`](https://pub.dartlang.org/documentation/carp_mobile_sensing/latest/domain/Measure-class.html) types:

* `location`
* `geolocation`
* `activity`
* `weather`
* `geofence`
* `air_quality`
* `mobility_features`

See the [wiki]() for further documentation, particularly on available [measure types](https://github.com/cph-cachet/carp.sensing-flutter/wiki/A.-Measure-Types)
and [sampling schemas](https://github.com/cph-cachet/carp.sensing-flutter/wiki/D.-Sampling-Schemas).

For Flutter plugins for other CARP products, see [CARP Mobile Sensing in Flutter](https://github.com/cph-cachet/carp.sensing-flutter/blob/master/README.md).

If you're interested in writing you own sampling packages for CARP, see the description on
how to [extend](https://github.com/cph-cachet/carp.sensing-flutter/wiki/4.-Extending-CARP-Mobile-Sensing) CARP on the wiki.

## Installing

To use this package, add the following to you `pubspc.yaml` file. Note that
this package only works together with `carp_mobile_sensing`.

`````dart
dependencies:
  flutter:
    sdk: flutter
  carp_mobile_sensing: ^0.9.0
  carp_context_package: ^0.9.0
  ...
`````

### Android Integration

Add the following to your app's `manifest.xml` file located in `android/app/src/main`:

````xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="<your_package_name>"
    xmlns:tools="http://schemas.android.com/tools">

   ...
   
    <!-- The following permissions are used for CARP Mobile Sensing -->
    <uses-permission android:name="android.permission.PACKAGE_USAGE_STATS" tools:ignore="ProtectedPermissions"/>
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>

    <!-- The following permissions are used in the Context Package -->
    <uses-permission android:name="com.google.android.gms.permission.ACTIVITY_RECOGNITION" />
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" />
    <uses-permission android:name="android.permission.WAKE_LOCK" />
    <uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
    <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>


   <application
      ...
        <!-- service for using the Android activity recognition API -->
        <service android:name="dk.cachet.activity_recognition_flutter.activity.ActivityRecognizedService" />
        
        <!-- Services for background location handling -->
        <receiver
                android:name="rekab.app.background_locator.LocatorBroadcastReceiver"
                android:enabled="true"
                android:exported="true"
        />
        <receiver android:name="rekab.app.background_locator.BootBroadcastReceiver"
                  android:enabled="true">
            <intent-filter>
                <action android:name="android.intent.action.BOOT_COMPLETED"/>
            </intent-filter>
        </receiver>
        <service
                android:name="rekab.app.background_locator.LocatorService"
                android:permission="android.permission.BIND_JOB_SERVICE"
                android:exported="true"
        />
        <service
                android:name="rekab.app.background_locator.IsolateHolderService"
                android:permission="android.permission.FOREGROUND_SERVICE"
                android:exported="true"
        />
        <meta-data
                android:name="flutterEmbedding"
                android:value="2" />

    </application>
</manifest>
````

> **NOTE:** For Android 10 (API 29 and later) use the following permission instead:
>
> `<uses-permission android:name="android.permission.ACTIVITY_RECOGNITION" />`
>
> See [Privacy changes in Android 10](https://developer.android.com/about/versions/10/privacy/changes#physical-activity-recognition).

> **NOTE:** Version 0.5.0 is migrated to AndroidX. This shouldn't result in any functional changes, but it requires any Android apps using this plugin to also 
[migrate](https://developer.android.com/jetpack/androidx/migrate) if they're using the original support library. 
See Flutter [AndroidX compatibility](https://flutter.dev/docs/development/packages-and-plugins/androidx-compatibility)



### iOS Integration

Add this permission in the `Info.plist` file located in `ios/Runner`:


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

Next, overwrite your `AppDelegate.swift` in the XCode project with:

```swift
import UIKit
import Flutter

import background_locator

func registerPlugins(registry: FlutterPluginRegistry) -> () {
    if (!registry.hasPlugin("BackgroundLocatorPlugin")) {
        GeneratedPluginRegistrant.register(with: registry)
    }
}


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    BackgroundLocatorPlugin.setPluginRegistrantCallback(registerPlugins)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

## Using it

To use this package, import it into your app together with the
[`carp_mobile_sensing`](https://pub.dartlang.org/packages/carp_mobile_sensing) package:

`````dart
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:carp_context_package/context.dart';
`````

Before creating a study and running it, register this package in the 
[SamplingPackageRegistry](https://pub.dev/documentation/carp_mobile_sensing/latest/runtime/SamplingPackageRegistry-class.html).

`````dart
SamplingPackageRegistry().register(ContextSamplingPackage());
`````
