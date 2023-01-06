# CARP Media Sampling Package

[![pub package](https://img.shields.io/pub/v/carp_audio_package.svg)](https://pub.dartlang.org/packages/carp_audio_package)
[![github stars](https://img.shields.io/github/stars/cph-cachet/carp.sensing-flutter.svg?style=flat&logo=github&colorB=deeppink&label=stars)](https://github.com/cph-cachet/carp.sensing-flutter)
[![MIT License](https://img.shields.io/badge/license-MIT-purple.svg)](https://opensource.org/licenses/MIT)

This library contains a sampling package for media (audio, video, image, noise) sampling to work with the [`carp_mobile_sensing`](https://pub.dartlang.org/packages/carp_mobile_sensing) package.
This packages supports sampling of the following [`Measure`](https://pub.dev/documentation/carp_core/latest/carp_core/Measure-class.html) types:

* `dk.cachet.carp.audio`
* `dk.cachet.carp.noise`
* `dk.cachet.carp.video`
* `dk.cachet.carp.image`

The name of the Flutter pub.dev package is "audio" for historical reasons - however, it is (now) a "media" package and the CAMS package name is `MediaSamplingPackage`.

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
  carp_audio_package: ^latest
  ...
`````

### Android Integration

Add the following to your app's `manifest.xml` file located in `android/app/src/main`:

````xml
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
````

### iOS Integration

Add this permission in the `Info.plist` file located in `ios/Runner`:

```xml
<key>NSMicrophoneUsageDescription</key>
<string>Uses the microphone to record ambient noise in the phone's environment.</string>
<key>NSCameraUsageDescription</key>
<string>Uses the camera to ....</string>
<key>UIBackgroundModes</key>
  <array>
  <string>audio</string>
  <string>external-accessory</string>
  <string>fetch</string>
</array>
```

## Using it

To use this package, import it into your app together with the
[`carp_mobile_sensing`](https://pub.dartlang.org/packages/carp_mobile_sensing) package:

`````dart
import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:carp_audio_package/media.dart';
`````

Before creating a study and running it, register this package in the
[SamplingPackageRegistry](https://pub.dartlang.org/documentation/carp_mobile_sensing/latest/runtime/SamplingPackageRegistry.html).

```dart
  SamplingPackageRegistry().register(MediaSamplingPackage());
```

Adding audio measure from this package to a study protocol would look something like:

```dart
  // Create a study protocol
  StudyProtocol protocol = StudyProtocol(
    ownerId: 'owner@dtu.dk',
    name: 'Audio Sensing Example',
  );

  // define which devices are used for data collection
  // in this case, its only this smartphone
  Smartphone phone = Smartphone();
  protocol.addPrimaryDevice(phone);

  // Add an automatic task that immediately starts collecting audio and noise.
  protocol.addTaskControl(
      ImmediateTrigger(),
      BackgroundTask(measures: [
        Measure(type: MediaSamplingPackage.AUDIO),
        Measure(type: MediaSamplingPackage.NOISE),
      ]),
      phone);
```
