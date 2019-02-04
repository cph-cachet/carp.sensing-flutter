# CARP Audio Sampling Package

[![pub package](https://img.shields.io/pub/v/carp_audio_package.svg)](https://pub.dartlang.org/packages/carp_audio_package)

This library contains a sampling package for audio to work with 
the [`carp_mobile_sensing`](https://pub.dartlang.org/packages/carp_mobile_sensing) package.
This packages supports sampling of the following [`Measure`](https://pub.dartlang.org/documentation/carp_mobile_sensing/latest/core/Measure-class.html) types:

* `audio`
* `noise`

See the [wiki]() for further documentation, particularly on available [probes](https://github.com/cph-cachet/carp.sensing-flutter/wiki/Probes)
and [sampling schemas](https://github.com/cph-cachet/carp.sensing-flutter/wiki/Schemas#sampling-schema).


For Flutter plugins for other CARP products, see [CARP Mobile Sensing in Flutter](https://github.com/cph-cachet/carp.sensing-flutter/blob/master/README.md).

If you're interested in writing you own sampling packages for CARP, see the description on
how to [extend](https://github.com/cph-cachet/carp.sensing-flutter/wiki/Extending) CARP on the wiki.

## Installing

To use this package, add the following to you `pubspc.yaml` file. Note that
this package only works together with `carp_mobile_sensing`.

`````dart
dependencies:
  flutter:
    sdk: flutter
  carp_mobile_sensing: ^0.3.0
  carp_audio_package: ^0.3.0
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
   <uses-permission android:name="android.permission.RECORD_AUDIO"/>
   <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
   <uses-permission android:name="android.permission.PACKAGE_USAGE_STATS" tools:ignore="ProtectedPermissions"/>

</manifest>
````

### iOS Integration

Add this permission in the `Info.plist` file located in `ios/Runner`:

```xml
<key>NSMicrophoneUsageDescription</key>
<string>Uses the microphone to record ambient noise in the phone's environment.</string>
<key>UIBackgroundModes</key>
  <array>
  <string>audio</string>
  <string>external-accessory</string>
  <string>fetch</string>
</array>

```

