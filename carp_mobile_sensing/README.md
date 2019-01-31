# CARP Mobile Sensing Framework in Flutter

This library contains the software architecture for the CARP sensing framework implemented in Flutter.
Supports cross-platform (iOS and Android) sensing.

[![pub package](https://img.shields.io/pub/v/carp_mobile_sensing.svg)](https://pub.dartlang.org/packages/carp_mobile_sensing)

For Flutter plugins for other CARP products, see [CARP Mobile Sensing in Flutter](https://github.com/cph-cachet/carp.sensing-flutter/blob/master/README.md).

## Usage
To use this plugin, add `carp_mobile_sensing` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

This plugin relies on `json_serialization: ^1.0.0` which again rely on Dart 2.1. 
This mean that (at the time of writing) you should use the `dev` channel in Flutter. 
This can be set using the following Flutter command:

```
flutter channel dev
```

Note that there are two issues with Android to consider:

* [Issue #1](https://github.com/cph-cachet/carp.sensing/issues/2) - make sure your app's android `build.gradle` has a `minSdkVersion 19` (instead of `16` ).
* [Issue #2](https://github.com/cph-cachet/carp.sensing/issues/1) - update the he file `build.gradle` in `flutter_blue` and change the JDK parameters to `26` (instead of `27`).

### Android Integration

Add the following to your apps `manifest.xml` file located in `android/app/src/main`:

````xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="<your_package_name>"
    xmlns:tools="http://schemas.android.com/tools">

   ...
   
   <!-- The following permissions are used for CARP Mobile Sensing -->
   <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
   <uses-permission android:name="android.permission.RECORD_AUDIO"/>
   <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
   <uses-permission android:name="com.google.android.gms.permission.ACTIVITY_RECOGNITION" />
   <uses-permission android:name="android.permission.PACKAGE_USAGE_STATS" tools:ignore="ProtectedPermissions"/>
   <uses-permission android:name="android.permission.CALL_PHONE"/>
   <uses-permission android:name="android.permission.READ_PHONE_STATE"/>
   <uses-permission android:name="android.permission.READ_PHONE_NUMBERS"/>
   <uses-permission android:name="android.permission.READ_SMS"/>

   <application
      ...
      <!-- service for using the Android activity recognition API -->
      <service android:name="at.resiverbindet.activityrecognition.activity.ActivityRecognizedService" />
    </application>
</manifest>
````

### iOS Integration

Add this permission in the `Info.plist` file located in `ios/Runner`:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Uses the location API to record location.</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>Uses the location API to record location.</string>
<key>NSMicrophoneUsageDescription</key>
<string>Uses the microphone to record ambient noise in the phone's environment.</string>
<key>NSMotionUsageDescription</key>
<string>Detects activity.</string>
<key>UIBackgroundModes</key>
  <array>
  <string>audio</string>
  <string>bluetooth-central</string>
  <string>bluetooth-peripheral</string>
  <string>external-accessory</string>
  <string>fetch</string>
  <string>location</string>
</array>

```


## Documentation

The [Dart API doc](https://pub.dartlang.org/documentation/carp_mobile_sensing/latest/) describes the different libraries and classes.

The [wiki](https://github.com/cph-cachet/carp.sensing/wiki) contains detailed documentation on the CARP Mobile Sensing Framework, including 
the [domain model](https://github.com/cph-cachet/carp.sensing/wiki/Domain-Model), its built-in [probes](https://github.com/cph-cachet/carp.sensing/wiki/Probes), 
and how to [extend](https://github.com/cph-cachet/carp.sensing/wiki/Extending) it.

Below is a very simple / minimum example (a better description is available on the [wiki](https://github.com/cph-cachet/carp.sensing-flutter/wiki/Domain-Model)).

## Example


```dart
// Import package
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';

method() {
  // Create a study using a File backend
  Study study = Study("1234", "bardram", name: "bardram study");
  study.dataEndPoint = FileDataEndPoint()
    ..bufferSize = 500 * 1000
    ..zip = true
    ..encrypt = false;

  // add a task to collect location, activity, and weather information
  study.addTask(SequentialTask('Location, Activity, and Weather Task')
    ..addMeasure(Measure(MeasureType(NameSpace.CARP, DataType.LOCATION)))
    ..addMeasure(Measure(MeasureType(NameSpace.CARP, DataType.ACTIVITY)))
    ..addMeasure(WeatherMeasure(MeasureType(NameSpace.CARP, DataType.WEATHER))
      ..enabled = true
      ..frequency = 2 * 60 * 60 * 1000));

  // add sensor collection from accelerometer and gyroscope
  // careful - these sensors generate a lot of data!
  study.addTask(ParallelTask('Sensor Task')
    ..addMeasure(PeriodicMeasure(MeasureType(NameSpace.CARP, DataType.ACCELEROMETER),
        frequency: 10 * 1000, // sample every 10 secs)
        duration: 100 // for 100 ms
        ))
    ..addMeasure(PeriodicMeasure(MeasureType(NameSpace.CARP, DataType.GYROSCOPE),
        frequency: 20 * 1000, // sample every 20 secs
        duration: 100 // for 100 ms
        )));

  study.addTask(Task('Noise Sampling Task')
    ..addMeasure(NoiseMeasure(MeasureType(NameSpace.CARP, DataType.NOISE),
        frequency: 10 * 60 * 1000, // sample sound every 10 min
        duration: 10 * 1000, // for 10 secs
        samplingRate: 500 // configure sampling rate to 500 ms
        )));

  study.addTask(SequentialTask('Task collecting a list of all installed apps')
    ..addMeasure(Measure(MeasureType(NameSpace.CARP, DataType.APPS))));

  // Create a Study Controller that can manage this study, initialize it, and start it.
  StudyController controller = StudyController(study);
  controller.initialize();
  controller.start();

  // listening on all data events from the study
  controller.events.forEach(print);
  controller.events.where((datum) => datum.format.namepace == NameSpace.CARP);

  // listening on a specific probe
  ProbeRegistry.probes[DataType.LOCATION].events.forEach(print);
}
```

There is a very simple [example app](example) app which shows how a study can be created with different tasks and measures.
This app just prints the sensing data to a console screen on the phone.

However, the [CARP Mobile Sensing App](https://github.com/cph-cachet/carp.sensing-flutter/tree/master/carp_mobile_sensing_app) provides a **much** better example of how to use the package in a Flutter BLoC architecture, including good documentation of how to do this.


## Features and bugs

Please read about existing issues and file new feature requests and bug reports at the [issue tracker][tracker].

[tracker]: https://github.com/cph-cachet/carp.sensing/issues

## License

This software is copyright (c) 2018 [Copenhagen Center for Health Technology (CACHET)](http://www.cachet.dk/) 
at the [Technical University of Denmark (DTU)](http://www.dtu.dk).
This software is made available 'as-is' in a MIT [license](/LICENSE).


