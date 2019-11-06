# CARP Communication Sampling Package

[![pub package](https://img.shields.io/pub/v/carp_communication_package.svg)](https://pub.dartlang.org/packages/carp_communication_package)

This library contains a sampling package for communication sampling to work with 
the [`carp_mobile_sensing`](https://pub.dartlang.org/packages/carp_mobile_sensing) package.
This packages supports sampling of the following [`Measure`](https://pub.dartlang.org/documentation/carp_mobile_sensing/latest/domain/Measure-class.html) types:

* `phone_log`
* `telephony`
* `text-message-log`
* `text-message`
* `calendar`

See the [wiki]() for further documentation, particularly on available [measure types](https://github.com/cph-cachet/carp.sensing-flutter/wiki/A.-Measure-Types)
and [sampling schemas](https://github.com/cph-cachet/carp.sensing-flutter/wiki/D.-Sampling-Schemas).
There is privacy protection of text messages and phone numbers in the default [Privacy Schema](https://github.com/cph-cachet/carp.sensing-flutter/wiki/3.-Using-CARP-Mobile-Sensing#privacy-schema).

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
  carp_mobile_sensing: ^0.5.0
  carp_communication_package: ^0.5.0
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
   <uses-permission android:name="android.permission.CALL_PHONE"/>
   <uses-permission android:name="android.permission.READ_PHONE_STATE"/>
   <uses-permission android:name="android.permission.READ_PHONE_NUMBERS"/>
   <uses-permission android:name="android.permission.READ_SMS"/>
   <uses-permission android:name="android.permission.READ_CALENDAR"/>
   <uses-permission android:name="android.permission.WRITE_CALENDAR"/>

</manifest>
````

> **NOTE:** Version 0.5.0 is migrated to AndroidX. This should not result in any functional changes, but it requires any Android apps using this plugin to also 
[migrate](https://developer.android.com/jetpack/androidx/migrate) if they're using the original support library. 
See Flutter [AndroidX compatibility](https://flutter.dev/docs/development/packages-and-plugins/androidx-compatibility)



### iOS Integration

Add this permission in the `Info.plist` file located in `ios/Runner`:

````xml
<key>NSCalendarsUsageDescription</key>
<string>INSERT_REASON_HERE</string>
````

## Using it

To use this package, import it into your app together with the
[`carp_mobile_sensing`](https://pub.dartlang.org/packages/carp_mobile_sensing) package:

`````dart
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:carp_comunication_package/context.dart';
`````

Before creating a study and running it, register this package in the 
[SamplingPackageRegistry](https://pub.dartlang.org/documentation/carp_mobile_sensing/latest/runtime/SamplingPackageRegistry.html).

`````dart
  SamplingPackageRegistry.register(CommunicationSamplingPackage());
`````
