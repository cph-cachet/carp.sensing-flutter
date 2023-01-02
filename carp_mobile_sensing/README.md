# CARP Mobile Sensing Framework in Flutter

[![pub package](https://img.shields.io/pub/v/carp_mobile_sensing.svg)](https://pub.dartlang.org/packages/carp_mobile_sensing)
[![style: effective dart](https://img.shields.io/badge/style-dart_recommended_lints-40c4ff.svg)](https://pub.dev/packages/lints)
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
  carp_core: ^latest
  carp_mobile_sensing: ^latest
`````

### Android Integration

Set the minimum android SDK to 21 and Java SDK Version to 33 by setting the `minSdkVersion`, the `compileSdkVersion`, and `targetSdkVersion` in the `build.gradle` file, located in the `android/app/` folder:

```gradle
android {
    compileSdkVersion 33

    defaultConfig {
        minSdkVersion 21
        targetSdkVersion 33
        ...
    }
    ...
}
```

The pedometer (step count) probe needs permission to `ACTIVITY_RECOGNITION`.
Add the following to your app's `manifest.xml` file located in `android/app/src/main`:

````xml
    <uses-permission android:name="android.permission.ACTIVITY_RECOGNITION"/>
````

### iOS Integration

The pedometer (step count) probe uses `NSMotion` on iOS and the `NSMotionUsageDescription` needs to be specified in the app's `Info.plist` file located in `ios/Runner`:

```xml
  <key>NSMotionUsageDescription</key>
  <string>Collecting step count.</string>
```

> **NOTE:** Other CAMS sampling packages require additional permissions in the `manifest.xml` or `Info.plist` files.
> See the documentation for each package.

## Documentation

The [Dart API doc](https://pub.dartlang.org/documentation/carp_mobile_sensing/latest/) describes the different libraries and classes.

The [wiki](https://github.com/cph-cachet/carp.sensing/wiki) contains detailed documentation on the CARP Mobile Sensing Framework, including
the [domain model](https://github.com/cph-cachet/carp.sensing-flutter/wiki/2.-Domain-Model),
how to use it by create a [Study configuration](https://github.com/cph-cachet/carp.sensing-flutter/wiki/3.-Using-CARP-Mobile-Sensing),
how to [extend](https://github.com/cph-cachet/carp.sensing-flutter/wiki/4.-Extending-CARP-Mobile-Sensing) it, and
an overview of the different [Measure types available](https://github.com/cph-cachet/carp.sensing-flutter/wiki/A.-Measure-Types).

A more scientific documentation of CAMS is available at [arxiv.org](https://arxiv.org/abs/2006.11904):

* Bardram, Jakob E. "The CARP Mobile Sensing Framework--A Cross-platform, Reactive, Programming Framework and Runtime Environment for Digital Phenotyping." arXiv preprint arXiv:2006.11904 (2020). [[pdf](https://arxiv.org/pdf/2006.11904.pdf)]

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

There is a **very simple** [example app](https://github.com/cph-cachet/carp.sensing-flutter/blob/master/carp_mobile_sensing/example/lib/main.dart) app which shows how a study can be created with different tasks and measures.
This app just prints the sensing data to a console screen on the phone.
There is also a range of different [examples](https://github.com/cph-cachet/carp.sensing-flutter/blob/master/carp_mobile_sensing/example/lib/example.dart) on how to create a study to take inspiration from.

However, the [CARP Mobile Sensing App](https://github.com/cph-cachet/carp.sensing-flutter/tree/master/apps/carp_mobile_sensing_app) provides a **MUCH** better example of how to use the framework in a Flutter BLoC architecture, including good documentation of how to do this.

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
// import packages
import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';

void example() async {
  // create a study protocol storing data in files
  SmartphoneStudyProtocol protocol = SmartphoneStudyProtocol(
    ownerId: 'AB',
    name: 'Track patient movement',
    dataEndPoint: FileDataEndPoint(
      bufferSize: 500 * 1000,
      zip: true,
      encrypt: false,
    ),
  );

  // Define which devices are used for data collection.
  // In this case, its only this smartphone.
  Smartphone phone = Smartphone();
  protocol.addMasterDevice(phone);

  // Add a background task that immediately starts collecting step counts,
  // ambient light, screen activity, and battery level.
  protocol.addTriggeredTask(
      ImmediateTrigger(),
      BackgroundTask()
        ..addMeasures([
          Measure(type: SensorSamplingPackage.PEDOMETER),
          Measure(type: SensorSamplingPackage.LIGHT),
          Measure(type: DeviceSamplingPackage.SCREEN),
          Measure(type: DeviceSamplingPackage.BATTERY),
        ]),
      phone);
```

The above example defines a simple [`SmartphoneStudyProtocol`](https://pub.dev/documentation/carp_mobile_sensing/latest/domain/SmartphoneStudyProtocol-class.html) which will store data in a file locally on the phone using a [`FileDataEndPoint`](https://pub.dev/documentation/carp_mobile_sensing/latest/domain/FileDataEndPoint-class.html).
Sampling is configured by adding a [`TriggeredTask`](https://pub.dev/documentation/carp_mobile_sensing/latest/domain/TriggeredTask-class.html) to the protocol using an [`ImmediateTrigger`](https://pub.dev/documentation/carp_mobile_sensing/latest/domain/ImmediateTrigger-class.html) which triggers a [`BackgroundTask`](https://pub.dev/documentation/carp_mobile_sensing/latest/domain/BackgroundTask-class.html) containing four different [`Measure`](https://pub.dev/documentation/carp_core/latest/carp_core_protocols/Measure-class.html).

Sampling can be configured in a very sophisticated ways, by specifying different types of devices, triggers, tasks, measures and sampling configurations.
See the CAMS [wiki](https://github.com/cph-cachet/carp.sensing-flutter/wiki/) for an overview.

You can write your own `DataEndPoint` definitions and coresponding `DataManager`s for uploading data to your own data endpoint. See the wiki on how to [add a new data manager](https://github.com/cph-cachet/carp.sensing-flutter/wiki/4.3-Adding-a-New-Data-Manager).

### Using a `DeploymentService`

A device deployment specifies how a study protocol is executed on a specific device - in this case a smartphone.
A `StudyProtocol` can be deployed to a `DeploymentService` which handles the deployment of protocols for different devices. CAMS comes with a simple deployment service (the `SmartphoneDeploymentService`) which runs locally on the phone. This can be used to deploy a protocol and get back a [`MasterDeviceDeployment`](https://pub.dev/documentation/carp_core/latest/carp_core_deployment/MasterDeviceDeployment-class.html), which can be executed on the phone.

```dart
...

// Use the on-phone deployment service.
DeploymentService deploymentService = SmartphoneDeploymentService();

// Create a study deployment using the protocol
StudyDeploymentStatus status =
    await deploymentService.createStudyDeployment(protocol);
```

### Running a `SmartphoneDeploymentController`

A study deployment for a phone (master device) is handled by a [`SmartPhoneClientManager`](https://pub.dev/documentation/carp_mobile_sensing/latest/runtime/SmartPhoneClientManager-class.html).
This client manager controls the execution of a study deployment using a [`SmartphoneDeploymentController`](https://pub.dev/documentation/carp_mobile_sensing/latest/runtime/SmartphoneDeploymentController-class.html).

```dart
...

String studyDeploymentId = ... // any id obtained e.g. from an invitation
String deviceRolename = ... // the rolename of this phone in the protocol;

// Create and configure a client manager for this phone
SmartPhoneClientManager client = SmartPhoneClientManager();
await client.configure(deploymentService: deploymentService);

// Create a study object based on the deployment id and the rolename
Study study = Study(studyDeploymentId, deviceRoleName);

// Add the study to the client manager and get a study runtime to control this deployment.
await client.addStudy(study);
SmartphoneDeploymentController? controller = client.getStudyRuntime(study);

// Deploy the study on this phone.
await controller?.tryDeployment();

// Configure the controller and start sampling.
await controller?.configure();
controller?.start();
```

### Using the generated data

The generated data can be accessed and used in the app. Access to data is done by listening on the `data` streams from the study deployment controller or some of its underlying executors or probes. Below are a few examples on how to listen on data streams.

```dart
...

// listening to the stream of all data events from the controller
controller.data.listen((dataPoint) => print(dataPoint));

// listen only on CARP events
controller?.data
    .where((dataPoint) => dataPoint.data!.format.namespace == NameSpace.CARP)
    .listen((event) => print(event));

// listen on LIGHT events only
controller?.data
    .where((dataPoint) =>
        dataPoint.data!.format.toString() == SensorSamplingPackage.LIGHT)
    .listen((event) => print(event));

// map events to JSON and then print
controller?.data
    .map((dataPoint) => dataPoint.toJson())
    .listen((event) => print(event));

// subscribe to the stream of data
StreamSubscription<DataPoint> subscription =
    controller!.data.listen((DataPoint dataPoint) {
  // do something w. the datum, e.g. print the json
  print(JsonEncoder.withIndent(' ').convert(dataPoint));
});
```

### Controlling the sampling of data

The execution of sensing can be controlled on runtime in a number of ways. For example:

```dart
...

// Sampling can be paused and resumed
controller.pause();
controller.resume();

// Pause specific probe(s)
ProbeRegistry()
  .lookup(SensorSamplingPackage.ACCELEROMETER)
  .forEach((probe) => probe.pause());

// Adapt a measures.
//
// Note that this will only work if the protocol is created locally on the
// phone (as in the example above)
// If downloaded and deserialized from json, then we need to locate the
// measures in the deployment
lightMeasure
  ..overrideSamplingConfiguration = PeriodicSamplingConfiguration(
    interval: const Duration(minutes: 5),
    duration: const Duration(seconds: 10),
  );

// Restart the light probe(s)
controller.executor
    ?.lookupProbe(SensorSamplingPackage.LIGHT)
    .forEach((probe) => probe.restart());

// Alternatively mark the deplyment as changed - calling hasChanged()
// this will force a restart of the entire sampling
controller.deployment?.hasChanged();

// Once the sampling has to stop, e.g. in a Flutter dispose() methods, call stop.
// Note that once a sampling has stopped, it cannot be restarted.
controller.stop();
await subscription.cancel();
```

## Features and bugs

Please read about existing issues and file new feature requests and bug reports at the [issue tracker][tracker].

[tracker]: https://github.com/cph-cachet/carp.sensing-flutter/issues

## License

This software is copyright (c) [Copenhagen Center for Health Technology (CACHET)](https://www.cachet.dk/) at the [Technical University of Denmark (DTU)](https://www.dtu.dk).
This software is available 'as-is' under a [MIT license](https://github.com/cph-cachet/carp.sensing-flutter/blob/master/LICENSE).
