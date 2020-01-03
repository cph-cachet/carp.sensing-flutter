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
  carp_mobile_sensing: ^0.6.0
  carp_context_package: ^0.6.0
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
   <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
   <uses-permission android:name="com.google.android.gms.permission.ACTIVITY_RECOGNITION" />
   <uses-permission android:name="android.permission.PACKAGE_USAGE_STATS" tools:ignore="ProtectedPermissions"/>

   <application
      ...
      <!-- service for using the Android activity recognition API -->
      <service android:name="at.resiverbindet.activityrecognition.activity.ActivityRecognizedService" />
    </application>
</manifest>
````

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

> **NOTE:** Activity Recognition does not work on iOS (issue [#18](https://github.com/cph-cachet/carp.sensing-flutter/issues/18))

## Using it

To use this package, import it into your app together with the
[`carp_mobile_sensing`](https://pub.dartlang.org/packages/carp_mobile_sensing) package:

`````dart
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:carp_context_package/context.dart';
`````

Before creating a study and running it, register this package in the 
[SamplingPackageRegistry](https://pub.dartlang.org/documentation/carp_mobile_sensing/latest/runtime/SamplingPackageRegistry.html).

`````dart
SamplingPackageRegistry.register(ContextSamplingPackage());
`````
