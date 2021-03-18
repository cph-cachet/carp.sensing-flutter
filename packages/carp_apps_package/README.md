# CARP Apps Sampling Package

[![pub package](https://img.shields.io/pub/v/carp_apps_package.svg)](https://pub.dartlang.org/packages/carp_apps_package)

This library contains a sampling package for app-related sampling to work with 
the [`carp_mobile_sensing`](https://pub.dartlang.org/packages/carp_mobile_sensing) framework.
This packages supports sampling of the following [`Measure`](https://pub.dev/documentation/carp_core/latest/carp_core/Measure-class.html) types:

* `apps`
* `app_usage`

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
  carp_apps_package: ^0.20.0
  ...
`````

### Android Integration

Edit your app's `manifest.xml` file such that it contains the following:

````xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="<YOUR_PACKAGE_NAME>"
    xmlns:tools="http://schemas.android.com/tools">

   <uses-permission android:name="android.permission.PACKAGE_USAGE_STATS" tools:ignore="ProtectedPermissions"/>
   ...
</manifest>
````

### iOS Integration
Not supported.

## Using it

To use this package, import it into your app together with the
[`carp_mobile_sensing`](https://pub.dartlang.org/packages/carp_mobile_sensing) package:

`````dart
import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:carp_connectivity_package/connectivity.dart';
`````

Before creating a study and running it, register this package in the 
[SamplingPackageRegistry](https://pub.dartlang.org/documentation/carp_mobile_sensing/latest/runtime/SamplingPackageRegistry.html).

`````dart
  SamplingPackageRegistry().register(AppsSamplingPackage());
`````
