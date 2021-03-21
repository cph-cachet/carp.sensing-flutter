# CARP Health Sampling Package

[![pub package](https://img.shields.io/pub/v/carp_health_package.svg)](https://pub.dartlang.org/packages/carp_health_package)

This library contains a sampling package for sampling health data from Apple Health and/or Google Fit to work with 
the [`carp_mobile_sensing`](https://pub.dartlang.org/packages/carp_mobile_sensing) framework.
This packages supports sampling of the following [`Measure`](https://pub.dev/documentation/carp_core/latest/carp_core/Measure-class.html) types:

* `health`

A [`HealthMeasure`](https://pub.dev/documentation/carp_health_package/latest/health_lib/HealthMeasure-class.html) can be configured to collect a specific [`HealthDataType`](https://pub.dev/documentation/health/latest/health/HealthDataType-class.html).

A `HealthDataType` can be:

  * BODY_FAT_PERCENTAGE,
  * HEIGHT,
  * WEIGHT,
  * BODY_MASS_INDEX,
  * WAIST_CIRCUMFERENCE,
  * STEPS,
  * ...

See the [`HealthDataType`](https://pub.dev/documentation/health/latest/health/HealthDataType-class.html) documentation for a complete list.


See the [wiki]() for further documentation, particularly on available [measure types](https://github.com/cph-cachet/carp.sensing-flutter/wiki/A.-Measure-Types)
and [sampling schemas](https://github.com/cph-cachet/carp.sensing-flutter/wiki/D.-Sampling-Schemas).

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
  carp_core: ^0.20.0
  carp_mobile_sensing: ^0.20.0
  carp_health_package: ^0.20.0
  ...
`````

### Android Integration

This package uses AndroidX. 
See Flutter [AndroidX compatibility](https://flutter.dev/docs/development/packages-and-plugins/androidx-compatibility)

Replace the content of the `android/gradle.properties` file with the following lines:

```
org.gradle.jvmargs=-Xmx1536M
android.enableJetifier=true
android.useAndroidX=true
```

Google Fit can be tricky to set up and it requires a separate app to be installed. 
Please follow this [guide to set up Google Fit](https://developers.google.com/fit/android/get-started).
Also - check out the documentation of the [`health`](https://pub.dev/packages/health) package.



### iOS Integration

Add this permission in the `Info.plist` file located in `ios/Runner`:


```xml
<key>NSHealthShareUsageDescription</key>
<string>We will sync your data with the Apple Health app to give you better insights</string>
<key>NSHealthUpdateUsageDescription</key>
<string>We will sync your data with the Apple Health app to give you better insights</string>
```


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
