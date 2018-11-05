# CARP Mobile Sensing Framework in Flutter

This library contains the software architecture for the CARP sensing framework implemented in Flutter.
Supports cross-platform (iOS and Android) sensing.

## Usage
To use this plugin, add `carp_mobile_sensing` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

This plugin relies on `json_serialization: ^1.0.0` which again rely on Dart 2.1. 
This mean that (at the time of writing) you should use the `dev` channel in Flutter. 
This can be set using the following Flutter command:

```
flutter channel dev
```

Note that there are two issues with Android to consider:

* [Issue #1](https://github.com/cph-cachet/carp.sensing/issues/2) - make sure your app's android `build.graddle` has a `minSdkVersion 19` (instead of `16` ).
* [Issue #2](https://github.com/cph-cachet/carp.sensing/issues/1) - update the he file `build.graddle` in `flutter_blue` and change the JDK parameters to `26` (instead of `27`).

### Android Integration

Add the following to your apps `manifest.xml` file located in `android/app/src/main`:

````xml
<manifest
   ...
   <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
   <uses-permission android:name="android.permission.RECORD_AUDIO"/>
   <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
   <uses-permission android:name="com.google.android.gms.permission.ACTIVITY_RECOGNITION" />

   <application
      ...
      <!-- service for using the Android activity recognition API -->
      <service android:name="at.resiverbindet.activityrecognition.activity.ActivityRecognizedService" />
    </application>
</manifest>
````

### iOS Integration

Add this permission in `Info.plist`:

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

Below is a very simple / minimum example.

## Example


```dart
// Import package
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';

... {
  // Instantiate a new study
  Study study = new Study("1234", "bardram", name: "Test study #1");

  // Setting the data endpoint to print to the console
  study.dataEndPoint = new DataEndPoint(DataEndPointType.PRINT);

  // Create a task to hold measures
  Task task = new Task("Simple Task");

  // Create a battery and location measures and add them to the task
  // Both are listening on events from changes from battery and location
  task.addMeasure(new BatteryMeasure(ProbeRegistry.BATTERY_MEASURE));
  task.addMeasure(new LocationMeasure(ProbeRegistry.LOCATION_MEASURE));

  // Create an executor that can execute this study, initialize it, and start it.
  StudyExecutor executor = new StudyExecutor(study);
  executor.initialize();
  executor.start();
}
```

There is a very simple [example](example) app which shows how a study can be created with different tasks and measures.
This app just prints the sensing data to a console screen on the phone.

##Auto generation of files 

Files depending on JSON serialization can be generated using `build_runner`, by running the following command in the root of your Flutter project:
```
flutter packages pub run build_runner build --delete-conflicting-outputs
```
 
## Features and bugs

Please read about existing issues and file new feature requests and bug reports at the [issue tracker][tracker].

[tracker]: https://github.com/cph-cachet/carp.sensing/issues

## License

This software is copyright (c) 2018 [Copenhagen Center for Health Technology (CACHET)](http://www.cachet.dk/) 
at the [Technical University of Denmark (DTU)](http://www.dtu.dk).
This software is made available 'as-is' in a MIT [license](/LICENSE).


