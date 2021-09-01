/*
 * Copyright 2019 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

import 'dart:async';
import 'dart:convert';

import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';

/// This is an example of how to set up a study by using the `common`
/// sampling schema. Used in the README file.
void example_1() async {
  // create a study protocol
  StudyProtocol protocol = StudyProtocol(
    ownerId: 'AB',
    name: 'Track patient movement',
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
            DeviceSamplingPackage.SCREEN,
            DeviceSamplingPackage.BATTERY,
          ],
        )),
      phone);

  // deploy this protocol using the on-phone deployment service
  StudyDeploymentStatus status =
      await SmartphoneDeploymentService().createStudyDeployment(protocol);

  String studyDeploymentId = status.studyDeploymentId;
  String deviceRolename = status.masterDeviceStatus!.device.roleName;

  // create and configure a client manager for this phone
  SmartPhoneClientManager client = SmartPhoneClientManager();
  await client.configure();

  // create a study runtime to control this deployment
  StudyDeploymentController controller =
      await client.addStudy(studyDeploymentId, deviceRolename);

  // configure the controller and resume sampling
  await controller.configure();
  controller.resume();

  // listening and print all data events from the study
  controller.data.forEach(print);
}

/// This is a more elaborate example used in the README.md file.
void example_2() async {
  // Create a study protocol
  StudyProtocol protocol = StudyProtocol(
    ownerId: 'user@dtu.dk',
    name: 'Tracking',
    description: 'Tracking patient movment',
  );

  // define which devices are used for data collection
  // in this case, its only this smartphone
  Smartphone phone = Smartphone();
  protocol.addMasterDevice(phone);

  // automatically collect accelerometer and gyroscope data
  // but delay the sampling by 10 seconds
  protocol.addTriggeredTask(
      DelayedTrigger(delay: Duration(seconds: 10)),
      AutomaticTask(name: 'Sensor Task')
        ..addMeasure(Measure(type: SensorSamplingPackage.ACCELEROMETER))
        ..addMeasure(Measure(type: SensorSamplingPackage.GYROSCOPE)),
      phone);

  // create a light measure variable to be used later
  PeriodicMeasure lightMeasure = PeriodicMeasure(
    type: SensorSamplingPackage.LIGHT,
    frequency: const Duration(seconds: 11),
    duration: const Duration(milliseconds: 100),
  );
  // add it to the study to start immediately
  protocol.addTriggeredTask(
    ImmediateTrigger(),
    AutomaticTask(name: 'Light')..addMeasure(lightMeasure),
    phone,
  );

  // deploy this protocol using the on-phone deployment service
  StudyDeploymentStatus status =
      await SmartphoneDeploymentService().createStudyDeployment(protocol);

  String studyDeploymentId = status.studyDeploymentId;
  String deviceRolename = status.masterDeviceStatus!.device.roleName;

  // create and configure a client manager for this phone
  SmartPhoneClientManager client = SmartPhoneClientManager();
  await client.configure();

  StudyDeploymentController controller =
      await client.addStudy(studyDeploymentId, deviceRolename);

  // you can change the deployment locally, before starting the
  // execution of it - e.g. setting another data endpoint.
  controller.deployment!.dataEndPoint = FileDataEndPoint(
    bufferSize: 500 * 1000,
    zip: true,
    encrypt: false,
  );

  // configure the controller with a data endpoint that saves data as
  // file of size 500 KB, which are zipped (this is the same as above)
  await controller.configure(
    dataEndPoint: FileDataEndPoint(
      bufferSize: 500 * 1000,
      zip: true,
      encrypt: false,
    ),
  );

  // resume sampling
  controller.resume();

  // listening to the stream of all data events from the controller
  controller.data.listen((dataPoint) => print(dataPoint));

  // listen only on CARP events
  controller.data
      .where((dataPoint) => dataPoint.data!.format.namespace == NameSpace.CARP)
      .listen((event) => print(event));

  // listen on LIGHT events only
  controller.data
      .where((dataPoint) =>
          dataPoint.data!.format.toString() == SensorSamplingPackage.LIGHT)
      .listen((event) => print(event));

  // map events to JSON and then print
  controller.data
      .map((dataPoint) => dataPoint.toJson())
      .listen((event) => print(event));

  // listening on a specific event type
  // this is equivalent to the statement above
  ProbeRegistry()
      .eventsByType(SensorSamplingPackage.LIGHT)
      .listen((dataPoint) => print(dataPoint));

  // subscribe to the stream of data
  StreamSubscription<DataPoint> subscription =
      controller.data.listen((DataPoint dataPoint) {
    // do something w. the datum, e.g. print the json
    print(JsonEncoder.withIndent(' ').convert(dataPoint));
  });

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
}

/// Example of device management.
///
/// In this example we assume that the protocol has been deployed
/// (e.g. to the CARP server) and that we get it from there.
///
/// The steps involved in this example is then:
///  * get the study deployment status
///  * create the devices needed in the protocol
///  * register the devices which are available
///  * get the study deployment for this master device
///  * start the sensing
void example_3() async {
  // we assume that we know the study deployment id
  // this might have been obtained from an invitation
  String studyDeploymentId = '2938y4h-rfhklwe98-erhui';

  // get the status of this deployment
  StudyDeploymentStatus status = await SmartphoneDeploymentService()
      .getStudyDeploymentStatus(studyDeploymentId);

  // register the needed devices - listed in the deployment status
  status.devicesStatus.forEach((deviceStatus) async {
    String type = deviceStatus.device.type;
    String deviceRoleName = deviceStatus.device.roleName;

    // create and register the device in the CAMS DeviceRegistry
    await DeviceController().createDevice(type);

    // if the device manager is created succesfully on the phone
    if (DeviceController().hasDevice(type)) {
      // ask the device manager for a unique id of the device
      String deviceId = DeviceController().getDevice(type)!.id;
      DeviceRegistration registration = DeviceRegistration(deviceId);
      // (all of the above can actually be handled directly by the SmartphoneDeploymentService.registerDevice() method)

      // register the device in the deployment service
      await SmartphoneDeploymentService()
          .registerDevice(studyDeploymentId, deviceRoleName, registration);
    }
  });

  // now get the study deployment for this master device and its registered devices
  SmartphoneDeployment deployment = await SmartphoneDeploymentService()
      .getDeviceDeployment(studyDeploymentId);

  print(deployment);
}

/// An example of how to use the [SamplingSchema] model.
void samplingSchemaExample() async {
  // creating a sampling schema focused on activity and outdoor context (weather)
  SamplingSchema activitySchema = SamplingSchema(
      type: SamplingSchemaType.normal,
      name: 'Connectivity Sampling Schema',
      powerAware: true)
    ..measures.addEntries([
      MapEntry(
          SensorSamplingPackage.PEDOMETER,
          PeriodicMeasure(
              type: SensorSamplingPackage.PEDOMETER,
              enabled: true,
              frequency: const Duration(minutes: 1))),
      MapEntry(DeviceSamplingPackage.SCREEN,
          Measure(type: DeviceSamplingPackage.SCREEN)),
    ]);

  StudyProtocol protocol = StudyProtocol(
    ownerId: 'AB',
    name: 'Track patient movement',
  );
  Smartphone phone = Smartphone(roleName: 'phone');
  protocol.addMasterDevice(phone);

  // adding a set of specific measures from the `common` sampling schema to one overall task
  protocol.addTriggeredTask(
      ImmediateTrigger(),
      AutomaticTask(name: 'Sensing Task #1')
        ..measures = DeviceSamplingPackage().common.getMeasureList(
          types: [
            DeviceSamplingPackage.SCREEN,
            DeviceSamplingPackage.BATTERY,
          ],
        ),
      phone);

  protocol.addTriggeredTask(
      ImmediateTrigger(),
      AutomaticTask(name: 'One Common Sensing Task')
        ..measures = SensorSamplingPackage().common.getMeasureList(
          types: [
            SensorSamplingPackage.PEDOMETER,
            SensorSamplingPackage.ACCELEROMETER,
            SensorSamplingPackage.GYROSCOPE,
          ],
        ),
      phone);

  // adding all measure from the activity schema to one overall 'sensing' task
  protocol.addTriggeredTask(
      ImmediateTrigger(),
      AutomaticTask(name: 'Sensing Task')
        ..measures = activitySchema.measures.values.toList(),
      phone);

  // adding the measures to two separate tasks, while also adding a new light measure to the 2nd task
  protocol.addTriggeredTask(
      ImmediateTrigger(),
      AutomaticTask(name: 'Activity Sensing Task #1')
        ..measures = activitySchema.getMeasureList(
          types: [
            SensorSamplingPackage.PEDOMETER,
            SensorSamplingPackage.ACCELEROMETER,
          ],
        ),
      phone);

  protocol.addTriggeredTask(
      ImmediateTrigger(),
      AutomaticTask(name: 'Phone Sensing Task #2')
        ..measures = activitySchema.getMeasureList(
          types: [
            DeviceSamplingPackage.SCREEN,
          ],
        )
        ..addMeasure(PeriodicMeasure(
          type: SensorSamplingPackage.LIGHT,
          frequency: const Duration(seconds: 11),
          duration: const Duration(milliseconds: 100),
        )),
      phone);
}

void recurrentScheduledTriggerExample() {
  // collect every day at 13:30
  RecurrentScheduledTrigger(
      type: RecurrentType.daily, time: Time(hour: 13, minute: 30));

  // collect every other day at 13:30
  RecurrentScheduledTrigger(
      type: RecurrentType.daily,
      separationCount: 1,
      time: Time(hour: 13, minute: 30));

  // collect every wednesday at 12:23
  RecurrentScheduledTrigger(
      type: RecurrentType.weekly,
      dayOfWeek: DateTime.wednesday,
      time: Time(hour: 12, minute: 23));

  // collect every 2nd monday at 12:23
  RecurrentScheduledTrigger(
      type: RecurrentType.weekly,
      dayOfWeek: DateTime.monday,
      separationCount: 1,
      time: Time(hour: 12, minute: 23));

  // collect monthly in the second week on a monday at 14:30
  RecurrentScheduledTrigger(
      type: RecurrentType.monthly,
      weekOfMonth: 2,
      dayOfWeek: DateTime.monday,
      time: Time(hour: 14, minute: 30));

  // collect quarterly on the 11th day of the first month in each quarter at 21:30
  RecurrentScheduledTrigger(
      type: RecurrentType.monthly,
      dayOfMonth: 11,
      separationCount: 2,
      time: Time(hour: 21, minute: 30));
}

/// An example of how to configure a [StudyDeploymentController] with the
/// default privacy schema.
void study_controller_example() async {
  // create and configure a client manager for this phone
  SmartPhoneClientManager client = SmartPhoneClientManager();
  await client.configure();

  StudyDeploymentController controller =
      await client.addStudy('1234', 'master_phone');

  // configure the controller with the default privacy schema and resume sampling
  await controller.configure(
    privacySchemaName: PrivacySchema.DEFAULT,
  );
  controller.resume();
}

/// An example of using the AppTask model
void app_task_example() async {
  Smartphone phone = Smartphone(roleName: 'phone');

  StudyProtocol protocol = StudyProtocol(
    ownerId: 'user@dtu.dk',
    name: 'Tracking',
  )
    ..addTriggeredTask(
        ImmediateTrigger(), // collect device info as an app task
        AppTask(
          type: SensingUserTask.ONE_TIME_SENSING_TYPE,
          title: 'Device',
          description: 'Collect device info',
        )..addMeasure(Measure(type: DeviceSamplingPackage.DEVICE)),
        phone)
    ..addTriggeredTask(
        ImmediateTrigger(), // start collecting screen events as an app task
        AppTask(
          type: SensingUserTask.SENSING_TYPE,
          title: 'Screen',
          description: 'Collect screen events',
        )..addMeasure(Measure(type: DeviceSamplingPackage.SCREEN)),
        phone);

  print(protocol);
}

void app_task_controller_example() async {
  AppTaskController ctrl = AppTaskController();

  ctrl.userTaskEvents.listen((event) {
    AppTask _task = (event.executor.task as AppTask);
    print('Task: ${_task.title}');
    switch (event.state) {
      case UserTaskState.initialized:
        //
        break;
      case UserTaskState.enqueued:
        //
        break;
      case UserTaskState.dequeued:
        //
        break;
      case UserTaskState.started:
        event.executor.resume();
        break;
      case UserTaskState.canceled:
        //
        break;
      case UserTaskState.done:
        event.executor.pause();
        break;
      default:
        //
        break;
    }
  });
}

/// This is an example of how the carp_core client library works.
/// Example is similar to the carp_core client example in Kotlin at
///
///   https://github.com/cph-cachet/carp.core-kotlin#example
///
void carp_core_client_example() async {
  var deploymentService = SmartphoneDeploymentService();

  ActiveParticipationInvitation? invitation; // get the invitation somehow
  String? studyDeploymentId = invitation?.studyDeploymentId;
  String? deviceToUse = invitation?.devices?.first.deviceRoleName;

  // create a client manager for this phone
  SmartPhoneClientManager client = SmartPhoneClientManager(
    deploymentService: deploymentService,
    deviceRegistry: DeviceController(),
  );

  // which is equivalent to
  client = SmartPhoneClientManager();

  await client.configure();

  StudyDeploymentController controller =
      await client.addStudy(studyDeploymentId!, deviceToUse!);

  if (controller.status == StudyRuntimeStatus.RegisteringDevices) {
    var connectedDevice = controller.remainingDevicesToRegister.first;
    var connectedRegistration = DeviceRegistration();
    await deploymentService.registerDevice(
        studyDeploymentId, connectedDevice.roleName, connectedRegistration);
  }

  // another (more convinient) way to register a connected device
  // that are available on this phone
  var connectedDevice = controller.remainingDevicesToRegister.first;
  await controller.tryRegisterConnectedDevice(connectedDevice);

  // another (even more convinient) way to register all connected device
  // that are available on this phone
  await controller.tryRegisterConnectedDevices();

  await controller.configure();
  controller.resume();
  controller.data.forEach(print);
}
