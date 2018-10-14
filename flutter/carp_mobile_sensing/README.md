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

## Documentation

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

There is a very simple [example](example) app which shows how a study can be created with different taks and measures.
This app just prints the sensing data to a console screen on the phone.
 
## Features and bugs

Please read about existing issues and file new feature requests and bug reports at the [issue tracker][tracker].

[tracker]: https://github.com/cph-cachet/carp.sensing/issues

## License

This software is copyright (c) 2018 [Copenhagen Center for Health Technology (CACHET)](http://www.cachet.dk/) 
at the [Technical University of Denmark (DTU)](http://www.dtu.dk).
This software is made available 'as-is' in a MIT [license](/LICENSE).


