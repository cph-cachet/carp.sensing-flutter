# CARP Mobile Sensing Framework in Flutter

This library contains the software architecture for the CARP sensing framework implemented in Flutter.
Supports cross-platform (iOS and Android) sensing.

[![pub package](https://img.shields.io/pub/v/carp_mobile_sensing.svg)](https://pub.dartlang.org/packages/carp_mobile_sensing)

For Flutter plugins for other CARP products, see [CARP Mobile Sensing in Flutter](https://github.com/cph-cachet/carp.sensing-flutter/blob/master/README.md).

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
> **NOTE:** Version 0.5.0 is migrated to AndroidX. This should not result in any functional changes, but it requires any Android apps using this plugin to also 
[migrate](https://developer.android.com/jetpack/androidx/migrate) if they're using the original support library. 
See Flutter [AndroidX compatibility](https://flutter.dev/docs/development/packages-and-plugins/androidx-compatibility)


## Documentation

The [Dart API doc](https://pub.dartlang.org/documentation/carp_mobile_sensing/latest/) describes the different libraries and classes.

The [wiki](https://github.com/cph-cachet/carp.sensing/wiki) contains detailed documentation on the CARP Mobile Sensing Framework, including 
the [domain model](https://github.com/cph-cachet/carp.sensing/wiki/Domain-Model), its built-in [probes](https://github.com/cph-cachet/carp.sensing/wiki/Probes), 
and how to [extend](https://github.com/cph-cachet/carp.sensing/wiki/Extending) it.

Below is a few simple / minimum examples (a better description is available on the [wiki](https://github.com/cph-cachet/carp.sensing-flutter/wiki/Domain-Model)).

## Examples

In the following example, a study is created "by hand", i.e. you specify each trigger, task and measure in the study.

```dart
// Import package
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';

void example() async {
  // Create a study using a File Backend
  Study study = Study("1234", "user@dtu.dk",
      name: "An example study",
      dataEndPoint: FileDataEndPoint()
        ..bufferSize = 500 * 1000
        ..zip = true
        ..encrypt = false);

  // add sensor collection from accelerometer and gyroscope
  // careful - these sensors generate a lot of data!
  study.addTriggerTask(
      DelayedTrigger(delay: 1000), // delay sampling for one second
      Task('Sensor Task')
        ..addMeasure(PeriodicMeasure(
          MeasureType(NameSpace.CARP, SensorSamplingPackage.ACCELEROMETER),
          frequency: 10 * 1000, // sample every 10 secs
          duration: 2, // for 2 ms
        ))
        ..addMeasure(PeriodicMeasure(
          MeasureType(NameSpace.CARP, SensorSamplingPackage.GYROSCOPE),
          frequency: 20 * 1000, // sample every 20 secs
          duration: 2, // for 2 ms
        )));

  study.addTriggerTask(
      PeriodicTrigger(period: 24 * 60 * 60 * 1000), // trigger sampling once pr. day
      Task('Task collecting a list of all installed apps')
        ..addMeasure(Measure(MeasureType(NameSpace.CARP, AppsSamplingPackage.APPS))));

  // creating measure variable to be used later
  PeriodicMeasure lightMeasure = PeriodicMeasure(
    MeasureType(NameSpace.CARP, SensorSamplingPackage.LIGHT),
    name: "Ambient Light",
    frequency: 11 * 1000,
    duration: 700,
  );
  study.addTriggerTask(ImmediateTrigger(), Task('Light')..addMeasure(lightMeasure));

  // Create a Study Controller that can manage this study, initialize it, and start it.
  StudyController controller = StudyController(study);

  // await initialization before starting
  await controller.initialize();
  controller.start();

  // listening on all data events from the study
  controller.events.forEach(print);

  // listen on only CARP events
  controller.events.where((datum) => datum.format.namepace == NameSpace.CARP).forEach(print);

  // listen on LIGHT events only
  controller.events.where((datum) => datum.format.name == SensorSamplingPackage.LIGHT).forEach(print);

  // map events to JSON and then print
  controller.events.map((datum) => datum.toJson()).forEach(print);

  // listening on a specific probe registered in the ProbeRegistry
  // this is equivalent to the statement above
  ProbeRegistry.probes[SensorSamplingPackage.LIGHT].events.forEach(print);

  // subscribe to events
  StreamSubscription<Datum> subscription = controller.events.listen((Datum datum) {
    // do something w. the datum, e.g. print the json
    print(JsonEncoder.withIndent(' ').convert(datum));
  });

  // sampling can be paused and resumed
  controller.pause();
  controller.resume();

  // pause / resume specific probe(s)
  ProbeRegistry.lookup(SensorSamplingPackage.ACCELEROMETER).pause();
  ProbeRegistry.lookup(SensorSamplingPackage.ACCELEROMETER).resume();

  // adapt measures on the go - calling hasChanged() force a restart of
  // the probe, which will load the new measure
  lightMeasure
    ..frequency = 12 * 1000
    ..duration = 500
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

However, you can se up a study quite simple, by using [sampling schemas](https://github.com/cph-cachet/carp.sensing-flutter/wiki/Schemas#sampling-schema).
Below is an example of how to add measure to the `study` by using measures from the `common` sampling schema.

`````dart
 // adding a set of specific measures from the `common` sampling schema to one overall task
 study.addTriggerTask(
     ImmediateTrigger(),
     Task()
       ..measures = SamplingSchema.common().getMeasureList(
         namespace: NameSpace.CARP,
         types: [
           SensorSamplingPackage.LIGHT,
           AppsSamplingPackage.APP_USAGE,
           DeviceSamplingPackage.MEMORY,
         ],
       ));
`````

There is a very **simple** [example app](https://github.com/cph-cachet/carp.sensing-flutter/blob/master/carp_mobile_sensing/example/lib/main.dart) app which shows how a study can be created with different tasks and measures.
This app just prints the sensing data to a console screen on the phone. 
There is also a range of different [examples](https://github.com/cph-cachet/carp.sensing-flutter/blob/master/carp_mobile_sensing/example/lib/example.dart) on how to create a study to take inspiration from.

However, the [CARP Mobile Sensing App](https://github.com/cph-cachet/carp.sensing-flutter/tree/master/carp_mobile_sensing_app) 
provides a **MUCH** better example of how to use the package in a Flutter BLoC architecture, including good documentation of how to do this.


## Features and bugs

Please read about existing issues and file new feature requests and bug reports at the [issue tracker][tracker].

[tracker]: https://github.com/cph-cachet/carp.sensing/issues

## License

This software is copyright (c) 2020 [Copenhagen Center for Health Technology (CACHET)](http://www.cachet.dk/) 
at the [Technical University of Denmark (DTU)](http://www.dtu.dk).
This software is made available 'as-is' in a MIT [license](/LICENSE).

