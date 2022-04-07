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
  carp_mobile_sensing: ^latest
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

The pedometer (step count) probe uses `NSMotion` on iOS and the `NSMotionUsageDescription` needs to be specified in the app's `Info.plist` file located in `ios/Runner`:

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

1. Define a [`StudyProtcol`](https://pub.dev/documentation/carp_core/latest/carp_core_protocols/StudyProtocol-class.html).
2. Deploy this protocol to a [`DeploymentService`](https://pub.dev/documentation/carp_core/latest/carp_core_deployment/DeploymentService-class.html).
3. Get a study deployment for the phone and start executing this study deployment using a [`SmartPhoneClientManager`](https://pub.dev/documentation/carp_mobile_sensing/latest/runtime/SmartPhoneClientManager-class.html).
4. Use the generated data locally in the app or specify how and where to store or upload it using a [`DataEndPoint`](https://pub.dev/documentation/carp_core/latest/carp_core_deployment/DataEndPoint-class.html).

Note that as a mobile sensing framework running on a phone, CAMS could be limited to support 3-4. However, to support the 'full cycle', CAMS also supports 1-2. This allows for local creation, deployment, and execution of study protocols (which in many [applications](https://carp.cachet.dk/#applications) have shown to be useful).

### Defining a `StudyProtcol`

In CAMS, a sensing protocol is configured in a [`StudyProtocol`](https://pub.dev/documentation/carp_core/latest/carp_core_protocols/StudyProtocol-class.html). 
Below is a simple example of how to set up a protocol that sense step counts (`pedometer`), ambient light (`light`), screen activity (`screen`), and power consumption (`battery`). 

```dart
// import package
import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';

void example() async {
  // create a study protocol
  SmartphoneStudyProtocol protocol = SmartphoneStudyProtocol(
    ownerId: 'AB',
    name: 'Track patient movement',
    dataEndPoint: FileDataEndPoint(
      bufferSize: 500 * 1000,
      zip: true,
      encrypt: false,
    ),
  );

  // define which devices are used for data collection
  // in this case, its only this smartphone
  Smartphone phone = Smartphone();
  protocol.addMasterDevice(phone);

  // Add an automatic task that immediately starts collecting step counts,
  // ambient light, screen activity, and battery level - using the
  // SamplingPackageRegistry 'common' factory method
  protocol.addTriggeredTask(
      ImmediateTrigger(),
      AutomaticTask()
        ..addMeasures(SamplingPackageRegistry().common.getMeasureList(
          types: [
            SensorSamplingPackage.PEDOMETER,
            SensorSamplingPackage.LIGHT,
            DeviceSamplingPackage.SCREEN,
            DeviceSamplingPackage.BATTERY,
          ],
        )),
      phone);
```

The above example defines a simple [`SmartphoneStudyProtocol`](https://pub.dev/documentation/carp_mobile_sensing/latest/domain/SmartphoneStudyProtocol-class.html) which will store data in a file locally on the phone using a [`FileDataEndPoint`](https://pub.dev/documentation/carp_mobile_sensing/latest/domain/FileDataEndPoint-class.html). Sampling is configured by using the pre-defined [`SamplingSchema`](https://pub.dev/documentation/carp_mobile_sensing/latest/domain/SamplingSchema-class.html) 
named `common`. This sampling schema contains a set of default settings for how to sample the different measures. These measures are triggered immediately when sensing is started (see below), and runs automatically in the background using an [`AutomaticTask`](https://pub.dev/documentation/carp_mobile_sensing/latest/domain/AutomaticTask-class.html).

Sampling can be configured in a very sophisticated ways, by specifying different types of triggers, tasks, and measures - see the  CAMS [domain model](https://github.com/cph-cachet/carp.sensing-flutter/wiki/2.-Domain-Model) for an overview.

You can write your own `DataEndPoint` definitions and coresponding `DataManager`s for uploading data to your own data endpoint. See the wiki on how to [add a new data manager](https://github.com/cph-cachet/carp.sensing-flutter/wiki/4.3-Adding-a-New-Data-Manager).


### Using a `DeploymentService`

A device deployment specifies how a study protocol is executed on a specific device - in this case a smartphone.
A `StudyProtocol` can be deployed to a `DeploymentService` which handles the deployment of protocols for different devices. CAMS comes with a simple deployment service (the `SmartphoneDeploymentService`) which runs locally on the phone. This can be used to deploy a protocol and get back a [`MasterDeviceDeployment`](https://pub.dev/documentation/carp_core/latest/carp_core_deployment/MasterDeviceDeployment-class.html), which can be executed on the phone.

```dart
...

// deploy this protocol using the on-phone deployment service
StudyDeploymentStatus status =
  await SmartphoneDeploymentService().createStudyDeployment(protocol);

...

// you can get the device deployment configuration for this phone....
// ... but this is rarely needed - see below
SmartphoneDeployment deployment = await SmartphoneDeploymentService()
  .getDeviceDeployment(status.studyDeploymentId);

...
```


### Running a `StudyDeploymentController`

A study deployment for a phone (master device) is handled by a [`SmartPhoneClientManager`](https://pub.dev/documentation/carp_mobile_sensing/latest/runtime/SmartPhoneClientManager-class.html).
This client manager is able to create a [`StudyDeploymentController`](https://pub.dev/documentation/carp_mobile_sensing/latest/runtime/StudyDeploymentController-class.html) which controls the execution of a study deployment.

```dart
...

String studyDeploymentId = ... // any id obtained e.g. from an invitation
String deviceRolename = ... // the rolename of this phone in the protocol;

// create and configure a client manager for this phone
SmartPhoneClientManager client = SmartPhoneClientManager();
await client.configure();

// create a study runtime controller to execute and control this deployment
StudyDeploymentController controller = await client.addStudy(studyDeploymentId, deviceRolename);

// deploy the study on this phone (controller)
await controller.tryDeployment();

// configure the controller and resume sampling
await controller.configure();
controller.resume();

// listening and print all data collected by the controller
controller.data.forEach(print);

...
```

### Using the generated data

The generated data can be accessed and used in the app. Access to data is done by listening on the `data` streams from the study deployment controller or some of its underlying executors or probes. Below are a few examples on how to listen on data streams.

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

### Controlling the sampling of data

The execution of sensing can be controlled on runtime in a number of ways. For example:


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
await subscription.cancel();

...
```

## Features and bugs

Please read about existing issues and file new feature requests and bug reports at the [issue tracker][tracker].

[tracker]: https://github.com/cph-cachet/carp.sensing-flutter/issues

## License

This software is copyright (c) [Copenhagen Center for Health Technology (CACHET)](https://www.cachet.dk/) at the [Technical University of Denmark (DTU)](https://www.dtu.dk).
This software is available 'as-is' under a [MIT license](https://github.com/cph-cachet/carp.sensing-flutter/blob/master/LICENSE).

