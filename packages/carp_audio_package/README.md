# CARP Media Sampling Package

[![pub package](https://img.shields.io/pub/v/carp_audio_package.svg)](https://pub.dartlang.org/packages/carp_audio_package)
[![pub points](https://img.shields.io/pub/points/carp_audio_package?color=2E8B57&label=pub%20points)](https://pub.dev/packages/carp_audio_package/score)
[![github stars](https://img.shields.io/github/stars/cph-cachet/carp.sensing-flutter.svg?style=flat&logo=github&colorB=deeppink&label=stars)](https://github.com/cph-cachet/carp.sensing-flutter)
[![MIT License](https://img.shields.io/badge/license-MIT-purple.svg)](https://opensource.org/licenses/MIT)
[![arXiv](https://img.shields.io/badge/arXiv-2006.11904-green.svg)](https://arxiv.org/abs/2006.11904)

This library contains a sampling package for media (audio, video, image, noise) sampling to work with the [`carp_mobile_sensing`](https://pub.dartlang.org/packages/carp_mobile_sensing) package.
This packages supports sampling of the following [`Measure`](https://github.com/cph-cachet/carp.sensing-flutter/wiki/A.-Measure-Types) types:

* `dk.cachet.carp.noise`
* `dk.cachet.carp.audio`
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

Add the following to your app's `AndroidManifest.xml` file located in `android/app/src/main`:

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

The `noise` measure is [event-based](https://github.com/cph-cachet/carp.sensing-flutter/wiki/A.-Measure-Types#event-based-vs-one-time-measures), whereas the `audio`, `video`, and `image` measures are one-time measures. Using the measures from this package in a study protocol would look something like the following examples.

```dart
// Create a study protocol
StudyProtocol protocol = StudyProtocol(
  ownerId: 'owner@dtu.dk',
  name: 'Audio Sensing Example',
);

// Define which devices are used for data collection
// In this case, its only this smartphone
Smartphone phone = Smartphone();
protocol.addPrimaryDevice(phone);

// Add an task that immediately starts collecting noise.
protocol.addTaskControl(
    ImmediateTrigger(),
    BackgroundTask(measures: [
      Measure(type: MediaSamplingPackage.NOISE),
    ]),
    phone);
```

The default sampling configuration of `noise` is to sample every 5 minutes for 10 seconds.
This configuration can, however, be overridden like this:

```dart
// Collect noise, but change the default sampling configuration
protocol.addTaskControl(
    ImmediateTrigger(),
    BackgroundTask(measures: [
      Measure(type: MediaSamplingPackage.NOISE)
        ..overrideSamplingConfiguration = PeriodicSamplingConfiguration(
          interval: const Duration(seconds: 30),
          duration: const Duration(seconds: 5),
        ),
    ]),
    phone);
```

And `audio` measure is a one-time measure and must be started and stopped explicitly.
The following example show how this can be done:

```dart
// Sample an audio recording
var audioTask = BackgroundTask(measures: [
  Measure(type: MediaSamplingPackage.AUDIO),
]);

// Start the audio task after 20 secs and stop it after 40 secs
protocol
  ..addTaskControl(
    DelayedTrigger(delay: const Duration(seconds: 20)),
    audioTask,
    phone,
    Control.Start,
  )
  ..addTaskControl(
    DelayedTrigger(delay: const Duration(seconds: 40)),
    audioTask,
    phone,
    Control.Stop,
  );
```

Note that the `image` and `video` measures are not used in background sensing and hence do not have a probe associated. These measures are only used in a [`AppTask`](https://github.com/cph-cachet/carp.sensing-flutter/wiki/4.-The-AppTask-Model), i.e., a task done by the user.
