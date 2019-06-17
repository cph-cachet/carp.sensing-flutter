/*
 * Copyright 2019 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'dart:async';
import 'dart:convert';

/// This is the code for the very minimal example used in the README.md file.
void example() async {
  // Create a study using a File Backend
  Study study = Study("1234", "bardram",
      name: "bardram study",
      dataEndPoint: FileDataEndPoint()
        ..bufferSize = 500 * 1000
        ..zip = true
        ..encrypt = false);

  // add sensor collection from accelerometer and gyroscope
  // careful - these sensors generate a lot of data!
  study.addTriggerTask(
      DelayedTrigger(1000), // delay sampling for one second
      Task('Sensor Task')
        ..addMeasure(PeriodicMeasure(MeasureType(NameSpace.CARP, SensorSamplingPackage.ACCELEROMETER),
            frequency: 10 * 1000, // sample every 10 secs)
            duration: 100 // for 100 ms
            ))
        ..addMeasure(PeriodicMeasure(MeasureType(NameSpace.CARP, SensorSamplingPackage.GYROSCOPE),
            frequency: 20 * 1000, // sample every 20 secs
            duration: 100 // for 100 ms
            )));

  study.addTriggerTask(
      PeriodicTrigger(24 * 60 * 60 * 1000), // trigger sampling once pr. day
      Task('Task collecting a list of all installed apps')
        ..addMeasure(Measure(MeasureType(NameSpace.CARP, AppsSamplingPackage.APPS))));

  // creating measure variable to be used later
  PeriodicMeasure lightMeasure = PeriodicMeasure(MeasureType(NameSpace.CARP, SensorSamplingPackage.LIGHT),
      name: "Ambient Light", frequency: 11 * 1000, duration: 700);
  study.addTriggerTask(ImmediateTrigger(), Task('Light')..addMeasure(lightMeasure));

  // Create a Study Controller that can manage this study, initialize it, and start it.
  StudyController controller = StudyController(study);
  // await initialization before starting
  await controller.initialize();
  controller.start();

  // listening on all data events from the study
  controller.events.forEach(print);

  // listen on only CARP events
  controller.events.where((datum) => datum.format.namepace == NameSpace.CARP).forEach(print);

  // listen on BLUETOOTH events
  controller.events.where((datum) => datum.format.name == ConnectivitySamplingPackage.BLUETOOTH).forEach(print);

  // map events
  controller.events.map((datum) => datum.format.name == ConnectivitySamplingPackage.BLUETOOTH).forEach(print);

  // listening on a specific probe
  ProbeRegistry.probes[AppsSamplingPackage.APPS].events.forEach(print);

  StreamSubscription<Datum> subscription = controller.events.listen((Datum datum) {
    // do something w. the datum, e.g. print the json
    print(JsonEncoder.withIndent(' ').convert(datum));
  });

  // sampling can be paused and resumed
  controller.pause();
  controller.resume();

  // pause / resume specific probe(s)
  ProbeRegistry.lookup(SensorSamplingPackage.ACCELEROMETER).pause();
  ProbeRegistry.lookup(SensorSamplingPackage.ACCELEROMETER).resume();

  // adapt measures on the go - calling hasChanged() force a restart of the probe, which will load the new measure
  lightMeasure
    ..frequency = 12 * 1000
    ..duration = 500
    ..hasChanged();

  // disabling a measure will pause the probe
  lightMeasure
    ..enabled = false
    ..hasChanged();

  // once the sampling has to stop, e.g. in a Flutter dispose() methods, call stop.
  // note that once a sampling has stopped, it cannot be restarted.
  controller.stop();
}

/// An example of how to use the [SamplingSchema] model.
void samplingSchemaExample() async {
  SamplingSchema.common()
      .getMeasureList([AppsSamplingPackage.APPS, DeviceSamplingPackage.DEVICE, DeviceSamplingPackage.SCREEN]);

  // creating a sampling schema focused on connectivity
  SamplingSchema connectivitySchema = SamplingSchema(name: 'Connectivity Sampling Schema', powerAware: true)
    ..measures.addEntries([
      MapEntry(ConnectivitySamplingPackage.CONNECTIVITY,
          Measure(MeasureType(NameSpace.CARP, ConnectivitySamplingPackage.CONNECTIVITY), enabled: true)),
      MapEntry(
          ConnectivitySamplingPackage.BLUETOOTH,
          PeriodicMeasure(MeasureType(NameSpace.CARP, ConnectivitySamplingPackage.BLUETOOTH),
              enabled: true, frequency: 60 * 60 * 1000, duration: 2 * 1000)),
    ]);

  // creating a sampling schema focused on activity and outdoor context (weather)
  SamplingSchema activitySchema = SamplingSchema(name: 'Connectivity Sampling Schema', powerAware: true)
    ..measures.addEntries([
      MapEntry(
          SensorSamplingPackage.PEDOMETER,
          PeriodicMeasure(MeasureType(NameSpace.CARP, SensorSamplingPackage.PEDOMETER),
              enabled: true, frequency: 60 * 60 * 1000)),
      MapEntry(DeviceSamplingPackage.SCREEN,
          Measure(MeasureType(NameSpace.CARP, DeviceSamplingPackage.SCREEN), enabled: true)),
    ]);

  //creating a study
  Study study = Study('DF#4dD', 'user@cachet.dk',
      name: 'A outdoor activity study',
      dataEndPoint: FileDataEndPoint()
        ..bufferSize = 500 * 1000
        ..zip = true
        ..encrypt = false);

  // adding a set of specific measures from the `common` sampling schema to one overall task
  study.addTriggerTask(
      ImmediateTrigger(),
      Task('Sensing Task #1')
        ..measures =
            SamplingSchema.common().getMeasureList([SensorSamplingPackage.PEDOMETER, DeviceSamplingPackage.SCREEN]));

  study.addTriggerTask(
      ImmediateTrigger(),
      Task('One Common Sensing Task')
        ..measures = SamplingSchema.common().getMeasureList([
          ConnectivitySamplingPackage.BLUETOOTH,
          ConnectivitySamplingPackage.CONNECTIVITY,
          SensorSamplingPackage.ACCELEROMETER,
          SensorSamplingPackage.GYROSCOPE,
          AppsSamplingPackage.APPS
        ]));

  // adding all measure from the activity schema to one overall 'sensing' task
  study.addTriggerTask(ImmediateTrigger(), Task('Sensing Task')..measures = activitySchema.measures.values);

  // adding the measures to two separate tasks, while also adding a new light measure to the 2nd task
  study.addTriggerTask(
      ImmediateTrigger(),
      Task('Activity Sensing Task #1')
        ..measures = activitySchema.getMeasureList([
          SensorSamplingPackage.PEDOMETER,
          ConnectivitySamplingPackage.CONNECTIVITY,
          SensorSamplingPackage.ACCELEROMETER
        ]));

  study.addTriggerTask(
      ImmediateTrigger(),
      Task('Phone Sensing Task #2')
        ..measures =
            activitySchema.getMeasureList([DeviceSamplingPackage.SCREEN, ConnectivitySamplingPackage.BLUETOOTH])
        ..addMeasure(PeriodicMeasure(MeasureType(NameSpace.CARP, SensorSamplingPackage.LIGHT),
            name: "Ambient Light", frequency: 11 * 1000, duration: 700)));

  StudyController controller = StudyController(study, samplingSchema: activitySchema);

//    SamplingSchema.common()
//        .getMeasureList([DataType.LOCATION, DataType.WEATHER, DataType.ACTIVITY], namepace: NameSpace.CARP);

  controller = StudyController(study);
  await controller.initialize();
  controller.start();

  // listening on all data events from the study
  controller.events.forEach(print);

  // listening on events from a specific probe
  ProbeRegistry.probes[DeviceSamplingPackage.SCREEN].events.forEach(print);
}

/// This is an example of how to set up a study in a very simple way using [SamplingSchema.common()].
void example_2() {
  Study study = Study('DF#4dD', 'user@cachet.dk',
      name: 'A outdoor activity study',
      dataEndPoint: FileDataEndPoint()
        ..bufferSize = 500 * 1000
        ..zip = true
        ..encrypt = false)
    ..addTriggerTask(ImmediateTrigger(),
        Task()..measures = SamplingSchema.common(namespace: NameSpace.CARP).measures.values.toList());

  // adding a set of specific measures from the `common` sampling schema to one no-name task
  study.addTriggerTask(
      ImmediateTrigger(),
      Task()
        ..measures = SamplingSchema.common().getMeasureList(
            [SensorSamplingPackage.PEDOMETER, DeviceSamplingPackage.SCREEN],
            namespace: NameSpace.CARP));

  StudyController controller = StudyController(study,
      samplingSchema: SamplingSchema.common()
        ..addSamplingSchema(PhoneSamplingSchema.phone())
        ..addSamplingSchema(PhoneSamplingSchema.phone()));
}

/// An example of how to restart probes or an entire sampling study.
void restart_example() {}

/// An example of how to configure a [StudyController]
void study_controller_example() {
  Study study = Study('DF#4dD', 'user@cachet.dk');
  StudyController controller = StudyController(study, privacySchemaName: PrivacySchema.DEFAULT);
}

class PhoneSamplingSchema extends SamplingSchema {
  factory PhoneSamplingSchema.phone({String namespace}) => SamplingSchema.common(namespace: namespace);
}

void samplingPackageExample() {
  SamplingPackageRegistry.register(SensorSamplingPackage());
}
