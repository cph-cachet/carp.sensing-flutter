/*
 * Copyright 2019 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

import 'dart:async';
import 'dart:convert';

import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';

/// This is an example of how to set up a study by using the `common`
/// sampling schema. Used in the README file.
void example_1() async {
  // Create a study using a local file to store data
  Study study = Study('2', 'user@cachet.dk',
      name: 'A study collecting ..',
      dataEndPoint: FileDataEndPoint()
        ..bufferSize = 500 * 1000
        ..zip = true
        ..encrypt = false);

  // Add an automatic task that immediately starts collecting
  // step counts, ambient light, screen activity, and battery level
  study.addTriggerTask(
      ImmediateTrigger(),
      AutomaticTask()
        ..measures = SamplingSchema.common().getMeasureList(
          namespace: NameSpace.CARP,
          types: [
            SensorSamplingPackage.PEDOMETER,
            SensorSamplingPackage.LIGHT,
            DeviceSamplingPackage.SCREEN,
            DeviceSamplingPackage.BATTERY,
          ],
        ));

  // Create a Study Controller that can manage this study.
  StudyController controller = StudyController(study);

  // await initialization before starting/resuming
  await controller.initialize();
  controller.resume();

  // listening and print all data events from the study
  controller.events.forEach(print);
}

/// This is a more elaborate example used in the README.md file.
void example_2() async {
  // Create a study using a local file to store data
  Study study = Study('1234', 'user@dtu.dk',
      name: 'An example study',
      dataEndPoint: FileDataEndPoint()
        ..bufferSize = 500 * 1000
        ..zip = true
        ..encrypt = false);

  // automatically collect accelerometer and gyroscope data
  // but delay the sampling by 10 seconds
  study.addTriggerTask(
      DelayedTrigger(delay: Duration(seconds: 10)),
      AutomaticTask(name: 'Sensor Task')
        ..addMeasure(PeriodicMeasure(MeasureType(NameSpace.CARP, SensorSamplingPackage.ACCELEROMETER),
            frequency: const Duration(seconds: 10), duration: const Duration(milliseconds: 100)))
        ..addMeasure(PeriodicMeasure(MeasureType(NameSpace.CARP, SensorSamplingPackage.GYROSCOPE),
            frequency: const Duration(seconds: 20), duration: const Duration(milliseconds: 100))));

  // create a light measure variable to be used later
  PeriodicMeasure lightMeasure = PeriodicMeasure(
    MeasureType(NameSpace.CARP, SensorSamplingPackage.LIGHT),
    name: 'Ambient Light',
    frequency: const Duration(seconds: 11),
    duration: const Duration(milliseconds: 100),
  );
  // add it to the study to start immediately
  study.addTriggerTask(ImmediateTrigger(), AutomaticTask(name: 'Light')..addMeasure(lightMeasure));

  // Create a Study Controller that can manage this study.
  StudyController controller = StudyController(study);

  // await initialization before starting/resuming
  await controller.initialize();
  controller.resume();

  // listening on all data events from the study
  controller.events.forEach(print);

  // listen on only CARP events
  controller.events.where((datum) => datum.format.namespace == NameSpace.CARP).forEach(print);

  // listen on LIGHT events only
  controller.events.where((datum) => datum.format.name == SensorSamplingPackage.LIGHT).forEach(print);

  // map events to JSON and then print
  controller.events.map((datum) => datum.toJson()).forEach(print);

  // listening on a specific probe registered in the ProbeRegistry
  // this is equivalent to the statement above
  ProbeRegistry().probes[SensorSamplingPackage.LIGHT].events.forEach(print);

  // subscribe to events
  StreamSubscription<Datum> subscription = controller.events.listen((Datum datum) {
    // do something w. the datum, e.g. print the json
    print(JsonEncoder.withIndent(' ').convert(datum));
  });

  // sampling can be paused and resumed
  controller.pause();
  controller.resume();

  // pause / resume specific probe(s)
  ProbeRegistry().lookup(SensorSamplingPackage.ACCELEROMETER).pause();
  ProbeRegistry().lookup(SensorSamplingPackage.ACCELEROMETER).resume();

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
}

/// An example of how to use the [SamplingSchema] model.
void samplingSchemaExample() async {
  // creating a sampling schema focused on activity and outdoor context (weather)
  SamplingSchema activitySchema = SamplingSchema(name: 'Connectivity Sampling Schema', powerAware: true)
    ..measures.addEntries([
      MapEntry(SensorSamplingPackage.PEDOMETER,
          PeriodicMeasure(MeasureType(NameSpace.CARP, SensorSamplingPackage.PEDOMETER), enabled: true, frequency: const Duration(minutes: 1))),
      MapEntry(DeviceSamplingPackage.SCREEN, Measure(MeasureType(NameSpace.CARP, DeviceSamplingPackage.SCREEN), enabled: true)),
    ]);

  //creating a study
  Study study_1 = Study('2', 'user@cachet.dk')
    ..name = 'CARP Mobile Sensing - default configuration'
    ..dataEndPoint = DataEndPoint(DataEndPointTypes.PRINT)
    ..addTriggerTask(ImmediateTrigger(), AutomaticTask()..measures = SamplingSchema.common(namespace: NameSpace.CARP).measures.values.toList());
  print(study_1);

  Study study = Study('2', 'user@cachet.dk',
      name: 'A outdoor activity study',
      dataFormat: NameSpace.OMH,
      dataEndPoint: FileDataEndPoint()
        ..bufferSize = 500 * 1000
        ..zip = true
        ..encrypt = false);

  // adding a set of specific measures from the `common` sampling schema to one overall task
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
  study.addTriggerTask(ImmediateTrigger(), AutomaticTask(name: 'Sensing Task')..measures = activitySchema.measures.values);

  // adding the measures to two separate tasks, while also adding a new light measure to the 2nd task
  study.addTriggerTask(
      ImmediateTrigger(),
      AutomaticTask(name: 'Activity Sensing Task #1')
        ..measures = activitySchema.getMeasureList(
          namespace: NameSpace.CARP,
          types: [
            SensorSamplingPackage.PEDOMETER,
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
          ],
        )
        ..addMeasure(PeriodicMeasure(
          MeasureType(NameSpace.CARP, SensorSamplingPackage.LIGHT),
          name: 'Ambient Light',
          frequency: const Duration(seconds: 11),
          duration: const Duration(milliseconds: 100),
        )));

  StudyController controller = StudyController(study, samplingSchema: activitySchema);

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

void recurrentScheduledTriggerExample() {
  // collect every day at 13:30
  RecurrentScheduledTrigger(type: RecurrentType.daily, time: Time(hour: 13, minute: 30));

  // collect every other day at 13:30
  RecurrentScheduledTrigger(type: RecurrentType.daily, separationCount: 1, time: Time(hour: 13, minute: 30));

  // collect every wednesday at 12:23
  RecurrentScheduledTrigger(type: RecurrentType.weekly, dayOfWeek: DateTime.wednesday, time: Time(hour: 12, minute: 23));

  // collect every 2nd monday at 12:23
  RecurrentScheduledTrigger(type: RecurrentType.weekly, dayOfWeek: DateTime.monday, separationCount: 1, time: Time(hour: 12, minute: 23));

  // collect monthly in the second week on a monday at 14:30
  RecurrentScheduledTrigger(type: RecurrentType.monthly, weekOfMonth: 2, dayOfWeek: DateTime.monday, time: Time(hour: 14, minute: 30));

  // collect quarterly on the 11th day of the first month in each quarter at 21:30
  RecurrentScheduledTrigger(type: RecurrentType.monthly, dayOfMonth: 11, separationCount: 2, time: Time(hour: 21, minute: 30));
}

/// An example of how to configure a [StudyController] with the default privacy schema.
void study_controller_example() async {
  Study study = Study('2', 'user@cachet.dk');
  StudyController controller = StudyController(study, privacySchemaName: PrivacySchema.DEFAULT);
  await controller.initialize();
  controller.resume();
}
