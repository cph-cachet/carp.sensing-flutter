# CARP Mobile Sensing Framework in Flutter

[![pub package](https://img.shields.io/pub/v/carp_mobile_sensing.svg)](https://pub.dartlang.org/packages/carp_mobile_sensing)
[![style: effective dart](https://img.shields.io/badge/style-pedandic_dart-40c4ff.svg)](https://pub.dev/packages/pedandic_dart)
[![github stars](https://img.shields.io/github/stars/cph-cachet/carp.sensing-flutter.svg?style=flat&logo=github&colorB=deeppink&label=stars)](https://github.com/cph-cachet/carp.sensing-flutter)
[![MIT License](https://img.shields.io/badge/license-MIT-purple.svg)](https://opensource.org/licenses/MIT)
[![arXiv](https://img.shields.io/badge/arXiv-2006.11904-green.svg)](https://arxiv.org/abs/2006.11904)

This library contains the core Flutter package for the CARP Mobile Sensing (CAMS) framework.
Supports cross-platform (iOS and Android) mobile sensing.

For an overview of all CAMS packages, see [CARP Mobile Sensing in Flutter](https://github.com/cph-cachet/carp.sensing-flutter).
For documentation on how to use CAMS, see the [CAMS wiki](https://github.com/cph-cachet/carp.sensing-flutter/wiki).

## Usage
To use this plugin, add [`carp_mobile_sensing`](https://pub.dev/packages/carp_mobile_sensing) as [dependencies in your `pubspec.yaml` file](https://flutter.io/platform-plugins/).

`````yaml
dependencies:
  flutter:
    sdk: flutter
  carp_mobile_sensing: ^0.21.0
`````

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
> See the documentation for each package. 

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
how to use it by create a [Study configuration](https://github.com/cph-cachet/carp.sensing-flutter/wiki/3.-Using-CARP-Mobile-Sensing), 
how to [extend](https://github.com/cph-cachet/carp.sensing-flutter/wiki/4.-Extending-CARP-Mobile-Sensing) it, and
an overview of the different [Measure types available](https://github.com/cph-cachet/carp.sensing-flutter/wiki/A.-Measure-Types).

A more scientific documentation of CAMS is available at [arxiv.org](https://arxiv.org/abs/2006.11904):

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

## Examples of configuring and using CAMS

There is a very **simple** [example app](https://pub.dev/packages/carp_mobile_sensing/example) app which shows how a study can be created with different tasks and measures.
This app just prints the sensing data to a console screen on the phone. 
There is also a range of different [examples](https://github.com/cph-cachet/carp.sensing-flutter/blob/master/carp_mobile_sensing/example/lib/example.dart) on how to create a study to take inspiration from.

However, the [CARP Mobile Sensing App](https://github.com/cph-cachet/carp.sensing-flutter/tree/master/apps/carp_mobile_sensing_app) provides a **MUCH** better example of how to use the package in a Flutter BLoC architecture, including good documentation of how to do this.

Below is a small primer in the use of CAMS.

Following [`carp_core`](https://pub.dev/documentation/carp_core/latest/), a CAMS study can be configured, deployed, executed, and used in different steps:

1. Define a [`StudyProtcol`](https://pub.dev/documentation/carp_core/latest/carp_core/StudyProtocol-class.html).
2. Deploy this protocol to a [`DeploymentService`](https://pub.dev/documentation/carp_core/latest/carp_core/DeploymentService-class.html).
3. Get a study deployment for the phone and start executing this study deployment using a [`SmartPhoneClientManager`](https://pub.dev/documentation/carp_mobile_sensing/latest/domain/SmartPhoneClientManager-class.html).
4. Use the generated data locally in the app.

Note that as a mobile sensing framework running on a phone, CAMS could be limited to support 3-4. However, to support the 'full cycle', CAMS also supports 1-2. This allows for local creation, deployment, and execution of study protocols (which in many [applications](https://carp.cachet.dk/#applications) have shown to be useful).

### Defining a `StudyProtcol`

In CAMS, a sensing protocol is configured in a [`CAMSStudyProtocol`](https://pub.dev/documentation/carp_mobile_sensing/latest/domain/CAMSStudyProtocol-class.html). Below is a simple example of how to set up a protocol that sense step counts (`pedometer`), ambient light (`light`), screen activity (`screen`), and power consumption (`battery`). This data is stored as [json](https://github.com/cph-cachet/carp.sensing-flutter/wiki/B.-Sampling-Data-Formats) to a [local file](https://github.com/cph-cachet/carp.sensing-flutter/wiki/C.-Data-Backends) on the phone.

```dart
// Import package
import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';

void example_1() async {
  // create a protocol using a local file to store data
  CAMSStudyProtocol protocol = CAMSStudyProtocol()
    ..name = 'Track patient movement'
    ..owner = ProtocolOwner(
      id: 'AB',
      name: 'Alex Boyon',
      email: 'alex@uni.dk',
    )
    ..dataEndPoint = FileDataEndPoint(
      bufferSize: 500 * 1000,
      zip: true,
      encrypt: false,
    );

  // define which devices are used for data collection
  // in this case, its only this smartphone
  Smartphone phone = Smartphone();
  protocol.addMasterDevice(phone);

  // Add an automatic task that immediately starts collecting
  // step counts, ambient light, screen activity, and battery level
  protocol.addTriggeredTask(
      ImmediateTrigger(),
      AutomaticTask()
        ..addMeasures(SensorSamplingPackage().common.getMeasureList(
          types: [
            SensorSamplingPackage.PEDOMETER,
            SensorSamplingPackage.LIGHT,
          ],
        ))
        ..addMeasures(DeviceSamplingPackage().common.getMeasureList(
          types: [
            DeviceSamplingPackage.SCREEN,
            DeviceSamplingPackage.BATTERY,
          ],
        )),
      phone);
}
```

The above example make use of the pre-defined [`SamplingSchema`](https://pub.dev/documentation/carp_mobile_sensing/latest/domain/SamplingSchema-class.html) 
named `common`. This sampling schema contains a set of default settings for how to sample the different measures. 

Sampling can be configured in a very sophisticated ways, by specifying different types of triggers, tasks, and measures - see the  CAMS [domain model](https://github.com/cph-cachet/carp.sensing-flutter/wiki/2.-Domain-Model) for an overview.


### Using a `DeploymentService`

A `StudyProtocol` can be deployed to a `DeploymentService` which handles the deployment of protocols for different devices. CAMS comes with a simple deployment service which runs locally on the phone. This can be used to deploy a protocol and get back a [`MasterDeviceDeployment`](https://pub.dev/documentation/carp_core/latest/carp_core/MasterDeviceDeployment-class.html), which can be executed on the phone.

```dart
  ...

  // deploy this protocol using the on-phone deployment service
  StudyDeploymentStatus status =
      await CAMSDeploymentService().createStudyDeployment(protocol);

  ...

  // you can get the device deployment configuration for this phone....
  // ... but this is rarely needed - see below
  CAMSMasterDeviceDeployment deployment = await CAMSDeploymentService()
      .getDeviceDeployment(status.studyDeploymentId);

  ...
```


### Running a `StudyDeploymentController`

A study deployment for a phone (master device) is handled by a [`SmartPhoneClientManager`](https://pub.dev/documentation/carp_mobile_sensing/latest/runtime/SmartPhoneClientManager-class.html).
This client manager now hold a [`StudyDeploymentController`](https://pub.dev/documentation/carp_mobile_sensing/latest/runtime/StudyDeploymentController-class.html) which control the execution of a study deployment.


```dart
  ...

  String studyDeploymentId = ... // any id obtained e.g. from an invitation
  String deviceRolename = ... // the rolename of this phone in the protocol;

  // create and configure a client manager for this phone
  SmartPhoneClientManager client = SmartPhoneClientManager();
  await client.configure();

  // create a study runtime to control this deployment
  StudyDeploymentController controller = await client.addStudy(studyDeploymentId, deviceRolename);

  // configure the controller and resume sampling
  await controller.configure();
  controller.resume();

  // listening and print all data collected by the controller
  controller.data.forEach(print);

  ...
```

### Using the generated data

Sensing can be controlled in a number of ways and the generated data can be accessed and used in the app. Access to data is done by listening on the `data` streams from the study deployment controller or some of its underlying executors or probes. Below are a few examples on how to listen on data streams.

```dart
  ...

  // listening to the stream of all data events from the controller
  controller.data.listen((dataPoint) => print(dataPoint));

  // listen only on CARP events
  controller.data
      .where((dataPoint) => dataPoint.data.format.namespace == NameSpace.CARP)
      .listen((event) => print(event));

  // listen on LIGHT events only
  controller.data
      .where((dataPoint) =>
          dataPoint.data.format.toString() == SensorSamplingPackage.LIGHT)
      .listen((event) => print(event));

  // listening on the data generated from all probes 
  // this is equivalent to the statement above
  ProbeRegistry()
      .eventsByType(SensorSamplingPackage.LIGHT)
      .listen((dataPoint) => print(dataPoint));

  // map events to JSON and then print
  controller.data
      .map((dataPoint) => dataPoint.toJson())
      .listen((event) => print(event));

  // subscribe to the stream of data
  StreamSubscription<DataPoint> subscription =
      controller.data.listen((DataPoint dataPoint) {
    // do something w. the datum, e.g. print the json
    print(JsonEncoder.withIndent(' ').convert(dataPoint));
  });

  ...
```

The execution of sensing can be controlled on runtime. For example:


```dart
  ...

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

  ...
```

## Features and bugs

Please read about existing issues and file new feature requests and bug reports at the [issue tracker][tracker].

[tracker]: https://github.com/cph-cachet/carp.sensing-flutter/issues

## License

This software is copyright (c) [Copenhagen Center for Health Technology (CACHET)](https://www.cachet.dk/) at the [Technical University of Denmark (DTU)](https://www.dtu.dk).
This software is available 'as-is' under a [MIT license](https://github.com/cph-cachet/carp.sensing-flutter/blob/master/LICENSE).

