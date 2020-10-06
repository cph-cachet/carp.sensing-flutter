# CARP Apps Sampling Package

[![pub package](https://img.shields.io/pub/v/carp_apps_package.svg)](https://pub.dartlang.org/packages/carp_apps_package)

This library contains a sampling package for app-related sampling to work with 
the [`carp_mobile_sensing`](https://pub.dartlang.org/packages/carp_mobile_sensing) framework.
This packages supports sampling of the following [`Measure`](https://pub.dartlang.org/documentation/carp_mobile_sensing/latest/domain/Measure-class.html) types:

* `apps`
* `app_usage`

See the [wiki]() for further documentation, particularly on available [measure types](https://github.com/cph-cachet/carp.sensing-flutter/wiki/A.-Measure-Types)
and [sampling schemas](https://github.com/cph-cachet/carp.sensing-flutter/wiki/D.-Sampling-Schemas).

For Flutter plugins for other CARP products, see [CARP Mobile Sensing in Flutter](https://github.com/cph-cachet/carp.sensing-flutter/blob/master/README.md).

If you're interested in writing you own sampling packages for CARP, see the description on
how to [extend](https://github.com/cph-cachet/carp.sensing-flutter/wiki/4.-Extending-CARP-Mobile-Sensing) CARP on the wiki.

## Installing

To use this package, add the following to you `pubspc.yaml` file. Note that
this package only works together with `carp_mobile_sensing`.

`````dart
dependencies:
  flutter:
    sdk: flutter
  carp_mobile_sensing: # see the newest version
  carp_apps_package: # see the newest version
  ...
`````

### Android Integration

Edit your app's `manifest.xml` file such that it contains the following:

````xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="<YOUR_PACKAGE_NAME>"
    xmlns:tools="http://schemas.android.com/tools">

   <uses-permission android:name="android.permission.PACKAGE_USAGE_STATS" tools:ignore="ProtectedPermissions"/>
   ...
</manifest>
````

### iOS Integration
Not supported.

## Using it
See the example.

`````dart
  SamplingPackageRegistry().register(AppsSamplingPackage());

  Study study = Study("1234", "bardram", name: "bardram study");

  // creating a task collecting step counts and blood pressure data for the last two days
  study.addTriggerTask(
    ImmediateTrigger(), // a simple trigger that starts immediately
    Task(name: 'Step and blood pressure')
      ..addMeasure(
        Measure(
          MeasureType(NameSpace.CARP, AppsSamplingPackage.APP_USAGE),
          name: 'App usage',
        ),
      )
      ..addMeasure(
          Measure( MeasureType(NameSpace.CARP, AppsSamplingPackage.APPS),
            name: 'Blood Pressure Diastolic'),
      )
  );

  // Create a Study Controller that can manage this study, initialize it, and start it.
  StudyController controller = StudyController(study);

  // await initialization before starting
  await controller.initialize();
  controller.resume();

  // listening on all data events from the study
  controller.events.forEach(print);
`````
