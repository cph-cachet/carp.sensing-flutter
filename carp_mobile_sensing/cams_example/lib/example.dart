/*
 * Copyright 2019 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

import 'dart:async';
import 'dart:convert';

import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
//import 'package:carp_apps_package/apps.dart';

/// This is the code for the very minimal example used in the README.md file.
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
      DelayedTrigger(delay: Duration(seconds: 1)),
      AutomaticTask(name: 'Sensor Task')
        ..addMeasure(PeriodicMeasure(
            MeasureType(NameSpace.CARP, SensorSamplingPackage.ACCELEROMETER),
            frequency: const Duration(seconds: 10),
            duration: const Duration(milliseconds: 100)))
        ..addMeasure(PeriodicMeasure(
            MeasureType(NameSpace.CARP, SensorSamplingPackage.GYROSCOPE),
            frequency: const Duration(seconds: 20),
            duration: const Duration(milliseconds: 100))));

  // creating measure variable to be used later
  PeriodicMeasure lightMeasure = PeriodicMeasure(
    MeasureType(NameSpace.CARP, SensorSamplingPackage.LIGHT),
    name: "Ambient Light",
    frequency: const Duration(seconds: 11),
    duration: const Duration(milliseconds: 100),
  );
  study.addTriggerTask(ImmediateTrigger(),
      AutomaticTask(name: 'Light')..addMeasure(lightMeasure));

  // Create a Study Controller that can manage this study.
  StudyController controller = StudyController(study);

  // await initialization before starting/resuming
  await controller.initialize();
  controller.resume();

  // listening on all data events from the study
  controller.events.forEach(print);

  // listen on only CARP events
  controller.events
      .where((datum) => datum.format.namespace == NameSpace.CARP)
      .forEach(print);

  // listen on LIGHT events only
  controller.events
      .where((datum) => datum.format.name == SensorSamplingPackage.LIGHT)
      .forEach(print);

  // map events to JSON and then print
  controller.events.map((datum) => datum.toJson()).forEach(print);

  // listening on a specific probe registered in the ProbeRegistry
  // this is equivalent to the statement above
  ProbeRegistry.probes[SensorSamplingPackage.LIGHT].events.forEach(print);

  // subscribe to events
  StreamSubscription<Datum> subscription = controller.events.listen((datum) {
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
    ..frequency = const Duration(seconds: 12)
    ..duration = const Duration(milliseconds: 500)
    ..hasChanged();

  // disabling a measure will pause the probe
  lightMeasure
    ..enabled = false
    ..hasChanged();

  // once the sampling has to stop, e.g. in a dispose() method, call stop.
  // note that once a sampling has stopped, it cannot be restarted.
  controller.stop();
  subscription.cancel();
}

/// An example of how to use the [SamplingSchema] model.
void samplingSchemaExample() async {
  SamplingSchema activitySchema =
      SamplingSchema(name: 'Connectivity Sampling Schema', powerAware: true)
        ..measures.addEntries([
          MapEntry(
              SensorSamplingPackage.PEDOMETER,
              PeriodicMeasure(
                  MeasureType(NameSpace.CARP, SensorSamplingPackage.PEDOMETER),
                  enabled: true,
                  frequency: const Duration(minutes: 1))),
          MapEntry(
              DeviceSamplingPackage.SCREEN,
              Measure(MeasureType(NameSpace.CARP, DeviceSamplingPackage.SCREEN),
                  enabled: true)),
        ]);

  Study study = Study("2", 'user@cachet.dk',
      name: 'A outdoor activity study',
      dataFormat: NameSpace.OMH,
      dataEndPoint: FileDataEndPoint()
        ..bufferSize = 500 * 1000
        ..zip = true
        ..encrypt = false);

  // adding a set of specific measures from the `common` sampling schema
  // to one overall task
  study.addTriggerTask(
      ImmediateTrigger(),
      AutomaticTask(name: 'Sensing Task #1')
        ..measures = SamplingSchema.common().getMeasureList(
          namespace: NameSpace.CARP,
          types: [
            SensorSamplingPackage.PEDOMETER,
            DeviceSamplingPackage.SCREEN,
          ],
        ));

  study.addTriggerTask(
      ImmediateTrigger(),
      AutomaticTask(name: 'One Common Sensing Task')
        ..measures = SamplingSchema.common().getMeasureList(
          namespace: NameSpace.CARP,
          types: [
            SensorSamplingPackage.ACCELEROMETER,
            SensorSamplingPackage.GYROSCOPE,
          ],
        ));

  // adding all measure from the activity schema to one overall 'sensing' task
  study.addTriggerTask(
      ImmediateTrigger(),
      AutomaticTask(name: 'Sensing Task')
        ..measures = activitySchema.measures.values);

  // adding the measures to two separate tasks, while also adding a
  // new light measure to the 2nd task
  study.addTriggerTask(
      ImmediateTrigger(),
      AutomaticTask(name: 'Activity Sensing Task #1')
        ..measures = activitySchema.getMeasureList(
          namespace: NameSpace.CARP,
          types: [
            SensorSamplingPackage.PEDOMETER,
//            AppsSamplingPackage.APP_USAGE,
            SensorSamplingPackage.ACCELEROMETER,
          ],
        ));

  study.addTriggerTask(
      ImmediateTrigger(),
      AutomaticTask(name: 'Phone Sensing Task #2')
        ..measures = activitySchema.getMeasureList(
          namespace: NameSpace.CARP,
          types: [
            DeviceSamplingPackage.SCREEN,
//            AppsSamplingPackage.APP_USAGE,
          ],
        )
        ..addMeasure(PeriodicMeasure(
          MeasureType(NameSpace.CARP, SensorSamplingPackage.LIGHT),
          name: "Ambient Light",
          frequency: const Duration(seconds: 11),
          duration: const Duration(milliseconds: 100),
        )));

  StudyController controller =
      StudyController(study, samplingSchema: activitySchema);

  controller = StudyController(study);
  await controller.initialize();
  controller.resume();

  // listening on all data events from the study
  controller.events.forEach(print);

  // listening on events from a specific probe
  ProbeRegistry.lookup(DeviceSamplingPackage.SCREEN).events.forEach(print);

  // listening on data manager events
  controller.dataManager.events.forEach(print);
}

/// This is an example of how to set up a study in a very simple way
/// using [SamplingSchema.common()].
void example_2() async {
  Study study = Study("2", 'user@cachet.dk',
      name: 'An outdoor activity study',
      dataEndPoint: FileDataEndPoint()
        ..bufferSize = 500 * 1000
        ..zip = true
        ..encrypt = false)
    ..addTriggerTask(
        ImmediateTrigger(),
        AutomaticTask()
          ..measures = SamplingSchema.common(namespace: NameSpace.CARP)
              .measures
              .values
              .toList());

  // adding a set of specific measures from the `common` sampling schema
  // to one no-name task
  study.addTriggerTask(
      ImmediateTrigger(),
      AutomaticTask()
        ..measures = SamplingSchema.common().getMeasureList(
          types: [
            SensorSamplingPackage.PEDOMETER,
            DeviceSamplingPackage.SCREEN
          ],
          namespace: NameSpace.CARP,
        ));

  StudyController controller = StudyController(study,
      samplingSchema: SamplingSchema.common()
        ..addSamplingSchema(PhoneSamplingSchema.phone())
        ..addSamplingSchema(PhoneSamplingSchema.phone()));

  await controller.initialize();
  controller.resume();
}

/// This is an example of how to set up a study controller.
void example_3() {
//  StudyController controller = StudyController(
//      study,
//      samplingSchema: ,
//      privacySchemaName: ,
//      dataManager: ,
//      executor: ,
//      transformer:
//  );
//
}

class PhoneSamplingSchema extends SamplingSchema {
  factory PhoneSamplingSchema.phone({String namespace}) =>
      SamplingSchema.common(namespace: namespace);
}

void samplingPackageExample() {
  SamplingPackageRegistry.register(SensorSamplingPackage());
}
