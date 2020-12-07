# CARP Mobile Sensing Framework in Flutter

[![pub package](https://img.shields.io/pub/v/carp_mobile_sensing.svg)](https://pub.dartlang.org/packages/carp_mobile_sensing)
[![style: effective dart](https://img.shields.io/badge/style-pedandic_dart-40c4ff.svg)](https://pub.dev/packages/pedandic_dart)
[![github stars](https://img.shields.io/github/stars/cph-cachet/carp.sensing-flutter.svg?style=flat&logo=github&colorB=deeppink&label=stars)](https://github.com/cph-cachet/carp.sensing-flutter)
[![MIT License](https://img.shields.io/badge/license-MIT-purple.svg)](https://opensource.org/licenses/MIT)

This library contains the core Flutter package for the CARP Mobile Sensing (CAMS) framework.
Supports cross-platform (iOS and Android) mobile sensing.

For an overview of all CAMS packages, see [CARP Mobile Sensing in Flutter](https://github.com/cph-cachet/carp.sensing-flutter).
For documentation on how to use CAMS, see the [CAMS wiki](https://github.com/cph-cachet/carp.sensing-flutter/wiki).

## Usage
To use this plugin, add `carp_mobile_sensing` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

### Android Integration

Add the following to your app's `manifest.xml` file located in `android/app/src/main`:

````xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="<your_package_name"
    xmlns:tools="http://schemas.android.com/tools">

   ...
   
    <!-- The following permissions are used for CARP Mobile Sensing -->
    <uses-permission android:name="android.permission.PACKAGE_USAGE_STATS" tools:ignore="ProtectedPermissions"/>
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />

</manifest>
````
> **NOTE:** Other CAMS sampling packages require additional permissions in the `manifest.xml` file. 
>See the documentation for each package. 

> **NOTE:** Version 0.5.0 is migrated to AndroidX. It requires any Android apps using this plugin to also 
[migrate](https://developer.android.com/jetpack/androidx/migrate) if they're using the original support library. 
See Flutter [AndroidX compatibility](https://flutter.dev/docs/development/packages-and-plugins/androidx-compatibility)


### iOS Integration

The pedometer (step count) probe uses `NSMotion` on iOS and the `NSMotionUsageDescription` needs to be specified 
in the app's `Info.plist` file located in `ios/Runner`:

```xml
  <key>NSMotionUsageDescription</key>
  <string>Collecting step count.</string>
```


## Documentation

The [Dart API doc](https://pub.dartlang.org/documentation/carp_mobile_sensing/latest/) describes the different libraries and classes.

The [wiki](https://github.com/cph-cachet/carp.sensing/wiki) contains detailed documentation on the CARP Mobile Sensing Framework, including 
the [domain model](https://github.com/cph-cachet/carp.sensing-flutter/wiki/2.-Domain-Model), 
how to use it by create a [`Study` configuration](https://github.com/cph-cachet/carp.sensing-flutter/wiki/3.-Using-CARP-Mobile-Sensing), 
how to [extend](https://github.com/cph-cachet/carp.sensing-flutter/wiki/4.-Extending-CARP-Mobile-Sensing) it, and
an overview of the different [`Measure` types available](https://github.com/cph-cachet/carp.sensing-flutter/wiki/A.-Measure-Types).

A more scientific documentation of CAMS is available at *[arxiv.org](https://arxiv.org/abs/2006.11904)*:

 *  Bardram, Jakob E. "The CARP Mobile Sensing Framework--A Cross-platform, Reactive, Programming Framework and Runtime Environment for Digital Phenotyping." arXiv preprint arXiv:2006.11904 (2020). [[pdf](https://arxiv.org/pdf/2006.11904.pdf)]

```latex
@article{bardram2020carp,
  title={The CARP Mobile Sensing Framework--A Cross-platform, Reactive, Programming Framework and Runtime Environment for Digital Phenotyping},
  author={Bardram, Jakob E},
  journal={arXiv preprint arXiv:2006.11904},
  year={2020}
}
```

Please use this as a reference in any scientific papers using CAMS.

## Examples

In CAMS, sensing is configured in a [`Study`](https://pub.dev/documentation/carp_mobile_sensing/latest/domain/Study-class.html) object 
and sensing is controlled by a [`StudyController`](https://pub.dev/documentation/carp_mobile_sensing/latest/runtime/StudyController-class.html).

Below is a simple example of how to set up a study that sense step counts (`pedometer`), ambient light (`light`), 
screen activity (`screen`), and power consumption (`battery`). This data is stores as 
[json](https://github.com/cph-cachet/carp.sensing-flutter/wiki/B.-Sampling-Data-Formats) 
to a [local file](https://github.com/cph-cachet/carp.sensing-flutter/wiki/C.-Data-Backends) on the phone.

```dart
// Import package
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';

void example() async {
  // Create a study using a local file to store data
  Study study = Study("2", 'user@cachet.dk',
      name: 'A study collecting ..',
      dataEndPoint: FileDataEndPoint()
        ..bufferSize = 500 * 1000
        ..zip = true
        ..encrypt = false);

  // Add an automatic task that immediately starts collecting
  // step counts, ambient light, screen activity, and battery level
  study.addTriggerTask(
      ImmediateTrigger(),
      AutomaticTask()
        ..measures = SamplingSchema.common().getMeasureList(
          namespace: NameSpace.CARP,
          types: [
            SensorSamplingPackage.PEDOMETER,
            SensorSamplingPackage.LIGHT,
            DeviceSamplingPackage.SCREEN,
            DeviceSamplingPackage.BATTERY,
          ],
        ));

  // Create a Study Controller that can manage this study.
  StudyController controller = StudyController(study);

  // await initialization before starting/resuming
  await controller.initialize();
  controller.resume();

  // listening and print all data events from the study
  controller.events.forEach(print);
}
```

The above example make use of the pre-defined [`SamplingSchema`](https://pub.dev/documentation/carp_mobile_sensing/latest/domain/SamplingSchema-class.html) 
named `common`. This sampling schema contains a set of default settings for how to sample the different measures. 

Sampling can be configured in a very sophisticated ways, by specifying different types of triggers, tasks, and measures -
see the  CAMS [domain model](https://github.com/cph-cachet/carp.sensing-flutter/wiki/2.-Domain-Model) for an overview.
In the following example, a study is created "by hand", i.e. you specify each trigger, task and measure in the study.

```dart
void example() async {
  // Create a study using a local file to store data
  Study study = Study("1234", "user@dtu.dk",
      name: "An example study",
      dataEndPoint: FileDataEndPoint()
        ..bufferSize = 500 * 1000
        ..zip = true
        ..encrypt = false);

  // automatically collect accelerometer and gyroscope data
  // but delay the sampling by 10 seconds
    study.addTriggerTask(
      DelayedTrigger(delay: Duration(seconds: 10)),
      AutomaticTask(name: 'Sensor Task')
        ..addMeasure(PeriodicMeasure(
            MeasureType(NameSpace.CARP, SensorSamplingPackage.ACCELEROMETER),
            frequency: const Duration(seconds: 5),
            duration: const Duration(seconds: 1)))
        ..addMeasure(PeriodicMeasure(
            MeasureType(NameSpace.CARP, SensorSamplingPackage.GYROSCOPE),
            frequency: const Duration(seconds: 6),
            duration: const Duration(seconds: 2))));

  // create a light measure variable to be used later
  PeriodicMeasure lightMeasure = PeriodicMeasure(
    MeasureType(NameSpace.CARP, SensorSamplingPackage.LIGHT),
    name: "Ambient Light",
    frequency: const Duration(seconds: 11),
    duration: const Duration(milliseconds: 100),
  );
  // add it to the study to start immediately
  study.addTriggerTask(ImmediateTrigger(),
      AutomaticTask(name: 'Light')..addMeasure(lightMeasure));

// Create a Study Controller that can manage this study.
  StudyController controller = StudyController(study);

  // await initialization before starting/resuming
  await controller.initialize();
  controller.resume();

  // listening on all data events from the study
  controller.events.forEach(print);

  // listen on only CARP events
  controller.events
      .where((datum) => datum.format.namespace == NameSpace.CARP)
      .forEach(print);

  // listen on LIGHT events only
  controller.events
      .where((datum) => datum.format.name == SensorSamplingPackage.LIGHT)
      .forEach(print);

  // map events to JSON and then print
  controller.events.map((datum) => datum.toJson()).forEach(print);

  // listening on a specific event type
  // this is equivalent to the statement above
  ProbeRegistry().eventsByType(SensorSamplingPackage.LIGHT).forEach(print);

  // subscribe to events
  StreamSubscription<Datum> subscription =
      controller.events.listen((Datum datum) {
    // do something w. the datum, e.g. print the json
    print(JsonEncoder.withIndent(' ').convert(datum));
  });

  // sampling can be paused and resumed
  controller.pause();
  controller.resume();

  // pause specific probe(s)
  ProbeRegistry()
      .lookup(SensorSamplingPackage.ACCELEROMETER)
      .forEach((probe) => probe.pause());

  // adapt measures on the go - calling hasChanged() force a restart of
  // the probe, which will load the new measure
  lightMeasure
    ..frequency = const Duration(seconds: 12)
    ..duration = const Duration(milliseconds: 500)
    ..hasChanged();

  // disabling a measure will pause the probe
  lightMeasure
    ..enabled = false
    ..hasChanged();

  // once the sampling has to stop, e.g. in a Flutter dispose() methods, call stop.
  // note that once a sampling has stopped, it cannot be restarted.
  controller.stop();
  subscription.cancel();
} 
```

There is a very **simple** [example app](https://github.com/cph-cachet/carp.sensing-flutter/blob/master/carp_mobile_sensing/example/lib/main.dart) app which shows how a study can be created with different tasks and measures.
This app just prints the sensing data to a console screen on the phone. 
There is also a range of different [examples](https://github.com/cph-cachet/carp.sensing-flutter/blob/master/carp_mobile_sensing/example/lib/example.dart) on how to create a study to take inspiration from.

However, the [CARP Mobile Sensing App](https://github.com/cph-cachet/carp.sensing-flutter/tree/master/apps/carp_mobile_sensing_app) 
provides a **MUCH** better example of how to use the package in a Flutter BLoC architecture, including good documentation of how to do this.


## Features and bugs

Please read about existing issues and file new feature requests and bug reports at the [issue tracker][tracker].

[tracker]: https://github.com/cph-cachet/carp.sensing/issues

## License

This software is copyright (c) [Copenhagen Center for Health Technology (CACHET)](https://www.cachet.dk/) 
at the [Technical University of Denmark (DTU)](https://www.dtu.dk).
This software is available 'as-is' under a [MIT license](https://github.com/cph-cachet/carp.sensing-flutter/blob/master/LICENSE).

