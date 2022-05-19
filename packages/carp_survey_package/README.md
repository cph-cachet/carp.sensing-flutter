# CARP Survey Sampling Package

[![pub package](https://img.shields.io/pub/v/carp_survey_package.svg)](https://pub.dartlang.org/packages/carp_survey_package)

This library contains a sampling package for collecting user-generated data using the [CARP Research Package](https://carp.cachet.dk/research-package/). This includes [surveys](https://carp.cachet.dk/creating-a-survey/) or cognitive tests via the [CARP Cognition Package](https://carp.cachet.dk/cognition-package/). 
This package support the creation of a [RPAppTask] which can be added to a CAMS study protocol.

Read more on the [Research Package API](https://carp.cachet.dk/research-package-api/) and how to [create a survey](https://carp.cachet.dk/creating-a-survey/) and how to [create a cognitive test](https://carp.cachet.dk/creating-cognitive-tests/) on the CARP website.

## Installing

To use this package, add the following to you `pubspc.yaml` file. Note that
this package only works together with `carp_mobile_sensing`.

`````dart
dependencies:
  flutter:
    sdk: flutter
  carp_mobile_sensing: ^latest
  carp_survey_package: ^latest
  ...
`````

## Using it

To use this package, import it into your app together with the
[`carp_mobile_sensing`](https://pub.dartlang.org/packages/carp_mobile_sensing) package:

`````dart
import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:carp_survey_package/survey.dart';
`````

Before creating a study and running it, register this package in the 
[SamplingPackageRegistry](https://pub.dartlang.org/documentation/carp_mobile_sensing/latest/runtime/SamplingPackageRegistry.html).

`````dart
  SamplingPackageRegistry().register(SurveySamplingPackage());
`````

Once this is in place, a survey can be added as a `RPAppTask` to a CAMS protocol like this:

```dart
  // add a WHO-5 survey as an app task
  // plus collect device and ambient light information when survey is done
  protocol.addTriggeredTask(
      DelayedTrigger(delay: Duration(seconds: 30)),
      RPAppTask(
          type: SurveyUserTask.WHO5_SURVEY_TYPE,
          name: 'WHO-5 Survey',
          rpTask: who5Task)
        ..measures.add(Measure(type: DeviceSamplingPackage.DEVICE))
        ..measures.add(Measure(type: SensorSamplingPackage.LIGHT)),
      phone);
````

See the example for a full example.
