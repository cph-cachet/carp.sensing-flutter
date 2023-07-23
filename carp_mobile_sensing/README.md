# CARP Mobile Sensing Framework in Flutter

[![pub package](https://img.shields.io/pub/v/carp_mobile_sensing.svg)](https://pub.dartlang.org/packages/carp_mobile_sensing)
[![pub points](https://img.shields.io/pub/points/carp_mobile_sensing?color=2E8B57&label=pub%20points)](https://pub.dev/packages/carp_mobile_sensing/score)
[![github stars](https://img.shields.io/github/stars/cph-cachet/carp.sensing-flutter.svg?style=flat&logo=github&colorB=deeppink&label=stars)](https://github.com/cph-cachet/carp.sensing-flutter)
[![MIT License](https://img.shields.io/badge/license-MIT-purple.svg)](https://opensource.org/licenses/MIT)
[![arXiv](https://img.shields.io/badge/arXiv-2006.11904-green.svg)](https://arxiv.org/abs/2006.11904)

This library contains the core Flutter package for the [CARP Mobile Sensing (CAMS)](https://carp.cachet.dk/cams/) framework.
Supports cross-platform (iOS and Android) mobile sensing.

For an overview of all CAMS packages, see [CARP Mobile Sensing in Flutter](https://github.com/cph-cachet/carp.sensing-flutter).
For documentation on how to use CAMS, see the [CAMS wiki][wiki].

## Usage

To use this plugin, add [`carp_mobile_sensing`](https://pub.dev/packages/carp_mobile_sensing) as [dependencies in your `pubspec.yaml` file](https://flutter.io/platform-plugins/).

`````yaml
dependencies:
  flutter:
    sdk: flutter
  carp_core: ^latest
  carp_mobile_sensing: ^latest
`````

## Configuration

When you want to add CAMS to you app, there are a few things to do in terms of configuring your app.

First, since CAMS rely on the [awesome_notifications](https://pub.dev/packages/awesome_notifications) plugin, you should configure your app following their [configuration guide](https://pub.dev/packages/awesome_notifications#initial-configurations) for both [Android](https://pub.dev/packages/awesome_notifications#-configuring-android) and [iOS](https://pub.dev/packages/awesome_notifications#-configuring-ios).

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

For notification to work in background mode, you need to configure your iOS app to be [set up for background actions](https://pub.dev/packages/awesome_notifications#-extra-ios-setup-for-background-actions).

-------------------------------------

> **NOTE:** Other CAMS sampling packages require additional permissions in the `manifest.xml` or `Info.plist` files.
> See the documentation for each package.

## Documentation

The [Dart API doc](https://pub.dartlang.org/documentation/carp_mobile_sensing/latest/) describes the different libraries and classes.

The CAMS [wiki][wiki]] contains detailed documentation on the CARP Mobile Sensing Framework, including
the [domain model](https://github.com/cph-cachet/carp.sensing-flutter/wiki/2.-Domain-Model),
how to use it by create a [study configuration](https://github.com/cph-cachet/carp.sensing-flutter/wiki/3.-Using-CARP-Mobile-Sensing),
how to [extend](https://github.com/cph-cachet/carp.sensing-flutter/wiki/5.-Extending-CARP-Mobile-Sensing) it, and
an overview of the available [measure types](https://github.com/cph-cachet/carp.sensing-flutter/wiki/A.-Measure-Types).

More scientific documentation of CAMS is available in the following papers:

* Bardram, Jakob E. "[The CARP Mobile Sensing Framework--A Cross-platform, Reactive, Programming Framework and Runtime Environment for Digital Phenotyping.](https://arxiv.org/abs/2006.11904)" arXiv preprint arXiv:2006.11904 (2020). [[pdf](https://arxiv.org/pdf/2006.11904.pdf)]
* Bardram, Jakob E. "[Software Architecture Patterns for Extending Sensing Capabilities and Data Formatting in Mobile Sensing.](https://www.mdpi.com/1424-8220/22/7/2813)" Sensors 22.7 (2022). [[pdf]](https://www.mdpi.com/1424-8220/22/7/2813/pdf).

```latex
@article{bardram2020carp,
  title={The CARP Mobile Sensing Framework--A Cross-platform, Reactive, Programming Framework and Runtime Environment for Digital Phenotyping},
  author={Bardram, Jakob E},
  journal={arXiv preprint arXiv:2006.11904},
  year={2020}
}

@article{bardram2022software,
  title={Software Architecture Patterns for Extending Sensing Capabilities and Data Formatting in Mobile Sensing},
  author={Bardram, Jakob E},
  journal={Sensors},
  volume={22},
  number={7},
  year={2022},
  publisher={MDPI}
}
```

Please use these references in any scientific papers using CAMS.

## Examples of configuring and using CAMS

There is a **very simple** [example app](https://github.com/cph-cachet/carp.sensing-flutter/blob/master/carp_mobile_sensing/example/lib/main.dart) app which shows how a study can be created with different tasks and measures.
This app just prints the sensing data to a console screen on the phone.
There is also a range of different [examples](https://github.com/cph-cachet/carp.sensing-flutter/blob/master/carp_mobile_sensing/example/lib/example.dart) on how to create a study to take inspiration from.

However, the [CARP Mobile Sensing App](https://github.com/cph-cachet/carp.sensing-flutter/tree/master/apps/carp_mobile_sensing_app) provides a **MUCH** better example of how to use the framework in a Flutter BLoC architecture, including good documentation of how to do this.

Below is a small primer in the use of CAMS.

Following [`carp_core`](https://pub.dev/documentation/carp_core/latest/), a CAMS study can be configured, deployed, executed, and used in different steps:

1. Define a [`SmartphoneStudyProtocol`](https://pub.dev/documentation/carp_mobile_sensing/latest/domain/SmartphoneStudyProtocol-class.html).
2. Deploy this protocol to a [`DeploymentService`](https://pub.dev/documentation/carp_core/latest/carp_core_deployment/DeploymentService-class.html).
3. Get a study deployment for the phone and start executing this study deployment using a [`SmartPhoneClientManager`](https://pub.dev/documentation/carp_mobile_sensing/latest/runtime/SmartPhoneClientManager-class.html).
4. Use the generated data locally in the app or specify how and where to store or upload it using a [`DataEndPoint`](https://pub.dev/documentation/carp_mobile_sensing/latest/domain/DataEndPoint-class.html).

As a mobile sensing framework running on a phone, CAMS could be limited to support only step 3 and 4. However, to support the 'full cycle', CAMS also supports 1-2. This allows for local creation, deployment, and execution of study protocols (which in many [applications](https://carp.cachet.dk/#applications) have shown to be useful).

### Defining a `SmartphoneStudyProtocol`

In CAMS, a sensing protocol is configured in a [`SmartphoneStudyProtocol`](https://pub.dev/documentation/carp_mobile_sensing/latest/domain/SmartphoneStudyProtocol-class.html).
Below is a simple example of how to set up a protocol that samples step counts, ambient light, screen events, and battery events.

```dart
// Create a study protocol storing data in a local SQLite database.
SmartphoneStudyProtocol protocol = SmartphoneStudyProtocol(
  ownerId: 'abc@dtu.dk',
  name: 'Track patient movement',
  dataEndPoint: SQLiteDataEndPoint(),
);

// Define which devices are used for data collection.
// In this case, its only this smartphone.
Smartphone phone = Smartphone();
protocol.addPrimaryDevice(phone);

// Automatically collect step count, ambient light, screen activity, and
// battery level. Sampling is delaying by 10 seconds.
protocol.addTaskControl(
  ImmediateTrigger(),
  BackgroundTask(measures: [
    Measure(type: SensorSamplingPackage.STEP_COUNT),
    Measure(type: SensorSamplingPackage.AMBIENT_LIGHT),
    Measure(type: DeviceSamplingPackage.SCREEN_EVENT),
    Measure(type: DeviceSamplingPackage.BATTERY_STATE),
  ]),
  phone,
);
```

The above example defines a simple [`SmartphoneStudyProtocol`](https://pub.dev/documentation/carp_mobile_sensing/latest/domain/SmartphoneStudyProtocol-class.html) which will store data in a SQLite database locally on the phone using a [`SQLiteDataEndPoint`](https://pub.dev/documentation/carp_mobile_sensing/latest/domain/SQLiteDataEndPoint-class.html).
Sampling is configured by adding a `TaskControl` to the protocol using an [`ImmediateTrigger`](https://pub.dev/documentation/carp_mobile_sensing/latest/domain/ImmediateTrigger-class.html) which triggers a [`BackgroundTask`](https://pub.dev/documentation/carp_mobile_sensing/latest/domain/BackgroundTask-class.html) containing four different [`Measure`](https://pub.dev/documentation/carp_core/latest/carp_core_protocols/Measure-class.html)s.

Sampling can be configured in very sophisticated ways, by specifying different types of devices, triggers, tasks, measures and sampling configurations.
See the CAMS [wiki][wiki] for an overview and more details.

You can write your own `DataEndPoint` definitions and corresponding `DataManager`s for uploading data to your own data endpoint. See the wiki on how to [add a new data manager](https://github.com/cph-cachet/carp.sensing-flutter/wiki/5.-Extending-CARP-Mobile-Sensing#adding-a-new-data-manager).

### Using a `DeploymentService`

A device deployment specifies how a study protocol is executed on a specific device - in this case a smartphone.
According to the [CARP Core domain model](https://github.com/cph-cachet/carp.core-kotlin/blob/develop/docs/carp-deployments.md), a `StudyProtocol` can be deployed to a `DeploymentService` which handles the deployment of protocols for different devices. CAMS comes with a simple deployment service (the `SmartphoneDeploymentService`) which runs locally on the phone. This can be used to deploy a protocol and get back a [`MasterDeviceDeployment`](https://pub.dev/documentation/carp_core/latest/carp_core_deployment/MasterDeviceDeployment-class.html), which can be executed on the phone.

```dart
...

// Use the on-phone deployment service.
DeploymentService deploymentService = SmartphoneDeploymentService();

// Create a study deployment using the protocol
var status = await deploymentService.createStudyDeployment(protocol);
```

### Creating a `SmartPhoneClientManager` and  Running a `SmartphoneDeploymentController`

A study deployment for a phone (master device) is handled by a [`SmartPhoneClientManager`](https://pub.dev/documentation/carp_mobile_sensing/latest/runtime/SmartPhoneClientManager-class.html).
This client manager controls the execution of one or more study deployments using a [`SmartphoneDeploymentController`](https://pub.dev/documentation/carp_mobile_sensing/latest/runtime/SmartphoneDeploymentController-class.html).

```dart
...

String studyDeploymentId = ... // any id obtained e.g. from an invitation
String roleName = ... // the role name of this phone in the protocol

// Create and configure a client manager for this phone
SmartPhoneClientManager client = SmartPhoneClientManager();
await client.configure(deploymentService: deploymentService);

// Add the study to the client manager and get a study runtime to
// control this deployment
Study study = await client.addStudy(studyDeploymentId, roleName);
SmartphoneDeploymentController? controller = client.getStudyRuntime(study);

// Deploy the study on this phone.
await controller?.tryDeployment();

// Configure the controller and start sampling.
await controller?.configure();
controller?.start();
```

### Using the generated data

The generated data can be accessed and used in the app. Access to data is done by listening on the `measurements` streams from the study deployment controller or some of its underlying executors or probes. Below are a few examples on how to listen on data streams.

```dart
// listening to the stream of all measurements from the controller
controller?.measurements.listen((measurement) => print(measurement));

// listen only on CARP measurements
controller?.measurements
    .where(
        (measurement) => measurement.data.format.namespace == NameSpace.CARP)
    .listen((event) => print(event));

// listen on ambient light measurements only
controller?.measurements
    .where((measurement) =>
        measurement.data.format.toString() ==
        SensorSamplingPackage.AMBIENT_LIGHT)
    .listen((measurement) => print(measurement));

// map measurements to JSON and then print
controller?.measurements
    .map((measurement) => measurement.toJson())
    .listen((json) => print(json));

// subscribe to the stream of measurements
StreamSubscription<Measurement> subscription =
    controller!.measurements.listen((Measurement measurement) {
  // do something w. the measurement, e.g. print the json
  print(JsonEncoder.withIndent(' ').convert(measurement));
});
```

### Controlling the sampling of data

The execution of sensing can be controlled on runtime in a number of ways. For example:

```dart
// Sampling can be stopped and started
controller.executor?.stop();
controller.executor?.start();

// Stop specific probe(s)
controller.executor
    ?.lookupProbe(CarpDataTypes.ACCELERATION_TYPE_NAME)
    .forEach((probe) => probe.stop());

// Adapt a measure
//
// Note that this will only work if the protocol is created locally on the
// phone (as in the example above)
// If downloaded and deserialized from json, then we need to locate the
// measure in the deployment
lightMeasure.overrideSamplingConfiguration = PeriodicSamplingConfiguration(
  interval: const Duration(minutes: 5),
  duration: const Duration(seconds: 10),
);

// Restart the light probe(s) in order to load the new configuration
controller.executor
    ?.lookupProbe(SensorSamplingPackage.AMBIENT_LIGHT)
    .forEach((probe) => probe.restart());


  // Once the sampling has to stop, e.g. in a Flutter dispose method,
  // call the controller's dispose method.
  controller.dispose();

  // Cancel the subscription.
  await subscription.cancel();
```

## Features and bugs

Please read about existing issues and file new feature requests and bug reports at the [issue tracker][tracker].

## License

This software is copyright (c) [Copenhagen Center for Health Technology (CACHET)](https://www.cachet.dk/) at the [Technical University of Denmark (DTU)](https://www.dtu.dk).
This software is available 'as-is' under a [MIT license](https://github.com/cph-cachet/carp.sensing-flutter/blob/master/LICENSE).

<!-- LINKS  -->

[tracker]: https://github.com/cph-cachet/carp.sensing-flutter/issues
[wiki]: https://github.com/cph-cachet/carp.sensing-flutter/wiki
