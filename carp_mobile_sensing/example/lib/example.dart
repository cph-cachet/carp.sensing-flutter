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

/// This is an example of how to set up a the most minimal study
/// Used in the intro on the wiki
Future<void> example_0() async {
  // STEP I -- DEFINE PROTOCOL

  // Create a study protocol
  SmartphoneStudyProtocol protocol = SmartphoneStudyProtocol(
    ownerId: 'AB',
    name: 'Track patient movement',
  );

  // Define which devices are used for data collection.
  // In this case, its only this smartphone
  var phone = Smartphone();
  protocol.addMasterDevice(phone);

  // Automatically collect step count, ambient light, screen activity, and
  // battery level. Sampling is delaying by 10 seconds.
  protocol.addTriggeredTask(
      DelayedTrigger(delay: Duration(seconds: 10)),
      BackgroundTask(name: 'Sensor Task')
        ..addMeasures([
          Measure(type: SensorSamplingPackage.PEDOMETER),
          Measure(type: SensorSamplingPackage.LIGHT),
          Measure(type: DeviceSamplingPackage.SCREEN),
          Measure(type: DeviceSamplingPackage.BATTERY),
        ]),
      phone);

  // STEP II -- DEPLOY STUDY ON A CLIENT

  // Create and configure a client manager for this phone, and
  // create a study based on the protocol.
  SmartPhoneClientManager client = SmartPhoneClientManager();
  await client.configure();
  Study study = await client.addStudyProtocol(protocol);

  // Get the study controller and try to deploy the study.
  SmartphoneDeploymentController? controller = client.getStudyRuntime(study);
  await controller?.tryDeployment();

  // Configure the controller.
  await controller?.configure();

  // STEP III -- RUN THE STUDY

  // Start the study
  controller?.start();

  // Listening and print all data events from the study
  controller?.data.forEach(print);
}

/// This is an example of how to set up a study.
/// This protocol uses the default sampling configuration and stores
/// collected data in buffered files.
///
/// Used in the README file.
void example_1() async {
  // Create a study protocol storing data in files.
  SmartphoneStudyProtocol protocol = SmartphoneStudyProtocol(
    ownerId: 'AB',
    name: 'Track patient movement',
    dataEndPoint: FileDataEndPoint(
      bufferSize: 500 * 1000,
      zip: true,
      encrypt: false,
      dataFormat: NameSpace.OMH,
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

  // Use the on-phone deployment service.
  DeploymentService deploymentService = SmartphoneDeploymentService();

  // Create a study deployment using the protocol.
  StudyDeploymentStatus status =
      await deploymentService.createStudyDeployment(protocol);

  // Create and configure a client manager for this phone.
  SmartPhoneClientManager client = SmartPhoneClientManager();
  await client.configure(deploymentService: deploymentService);

  // Create a study object based on the deployment id and the rolename
  Study study = Study(
    status.studyDeploymentId,
    status.masterDeviceStatus!.device.roleName,
  );

  // Add the study to the client manager and get a study runtime to control this deployment
  await client.addStudy(study);
  SmartphoneDeploymentController? controller = client.getStudyRuntime(study);

  // Deploy the study on this phone.
  await controller?.tryDeployment();

  // Configure the controller and start sampling.
  await controller?.configure();
  controller?.start();

  // Print all data events from the study
  controller?.data.forEach(print);
}

/// This is a more elaborate example used in the README.md file.
void example_2() async {
  // Create a study protocol
  SmartphoneStudyProtocol protocol = SmartphoneStudyProtocol(
    ownerId: 'abc@dtu.dk',
    name: 'Tracking',
    protocolDescription: StudyDescription(
        title: 'CAMS App - Sensing Coverage Study',
        description:
            'The default study testing coverage of most measures. Used in the coverage tests.',
        purpose: 'To test sensing coverage',
        responsible: StudyResponsible(
          id: 'abc',
          title: 'professor',
          address: 'Ørsteds Plads',
          affiliation: 'Technical University of Denmark',
          email: 'abc@dtu.dk',
          name: 'Alex B. Christensen',
        )),
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

  // automatically collect accelerometer and gyroscope data
  // but delay the sampling by 10 seconds
  protocol.addTriggeredTask(
      DelayedTrigger(delay: Duration(seconds: 10)),
      BackgroundTask(name: 'Sensor Task')
        ..addMeasure(Measure(type: SensorSamplingPackage.ACCELEROMETER))
        ..addMeasure(Measure(type: SensorSamplingPackage.GYROSCOPE)),
      phone);

  // specify details of a light measure
  Measure lightMeasure = Measure(
    type: SensorSamplingPackage.LIGHT,
  )..overrideSamplingConfiguration = PeriodicSamplingConfiguration(
      interval: const Duration(minutes: 10),
      duration: const Duration(seconds: 20),
    );

  // add it to the study to start immediately
  protocol.addTriggeredTask(
    ImmediateTrigger(),
    BackgroundTask(name: 'Light')..addMeasure(lightMeasure),
    phone,
  );

  // use the on-phone deployment service
  DeploymentService deploymentService = SmartphoneDeploymentService();

  // create a study deployment using the protocol
  StudyDeploymentStatus status =
      await deploymentService.createStudyDeployment(protocol);

  // create and configure a client manager for this phone
  SmartPhoneClientManager client = SmartPhoneClientManager();
  await client.configure(deploymentService: deploymentService);

  Study study = Study(
    status.studyDeploymentId,
    status.masterDeviceStatus!.device.roleName,
  );

  // create a study runtime to control this deployment
  await client.addStudy(study);
  SmartphoneDeploymentController? controller = client.getStudyRuntime(study);

  // deploy the study on this phone (controller)
  await controller?.tryDeployment();

  // resume sampling
  controller?.start();

  // listening to the stream of all data events from the controller
  controller?.data.listen((dataPoint) => print(dataPoint));

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

  // Sampling can be paused and resumed
  controller.executor?.pause();
  controller.executor?.resume();

  // Pause specific probe(s)
  controller.executor
      ?.lookupProbe(SensorSamplingPackage.ACCELEROMETER)
      .forEach((probe) => probe.pause());

  // Adapt a measure
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

// /// An example of how to use the [SamplingSchema] model.
// void samplingSchemaExample() async {
//   // creating a sampling schema focused on activity and outdoor context (weather)
//   SamplingSchema activitySchema = SamplingSchema(
//       type: SamplingSchemaType.normal,
//       name: 'Connectivity Sampling Schema',
//       powerAware: true)
//     ..measures.addEntries([
//       MapEntry(
//           SensorSamplingPackage.PEDOMETER,
//           PeriodicMeasure(
//               type: SensorSamplingPackage.PEDOMETER,
//               enabled: true,
//               frequency: const Duration(minutes: 1))),
//       MapEntry(DeviceSamplingPackage.SCREEN,
//           Measure(type: DeviceSamplingPackage.SCREEN)),
//     ]);

//   StudyProtocol protocol = StudyProtocol(
//     ownerId: 'AB',
//     name: 'Track patient movement',
//   );
//   Smartphone phone = Smartphone(roleName: 'phone');
//   protocol.addMasterDevice(phone);

//   // adding a set of specific measures from the `common` sampling schema to one overall task
//   protocol.addTriggeredTask(
//       ImmediateTrigger(),
//       AutomaticTask(name: 'Sensing Task #1')
//         ..measures = DeviceSamplingPackage().common.getMeasureList(
//           types: [
//             DeviceSamplingPackage.SCREEN,
//             DeviceSamplingPackage.BATTERY,
//           ],
//         ),
//       phone);

//   protocol.addTriggeredTask(
//       ImmediateTrigger(),
//       AutomaticTask(name: 'One Common Sensing Task')
//         ..measures = SensorSamplingPackage().common.getMeasureList(
//           types: [
//             SensorSamplingPackage.PEDOMETER,
//             SensorSamplingPackage.ACCELEROMETER,
//             SensorSamplingPackage.GYROSCOPE,
//           ],
//         ),
//       phone);

//   // adding all measure from the activity schema to one overall 'sensing' task
//   protocol.addTriggeredTask(
//       ImmediateTrigger(),
//       AutomaticTask()..measures = activitySchema.measures.values.toList(),
//       phone);

//   // adding the measures to two separate tasks, while also adding a
//   // new light measure to the 2nd task
//   protocol.addTriggeredTask(
//       ImmediateTrigger(),
//       AutomaticTask(name: 'Activity Sensing Task #1')
//         ..measures = activitySchema.getMeasureList(
//           types: [
//             SensorSamplingPackage.PEDOMETER,
//             SensorSamplingPackage.ACCELEROMETER,
//           ],
//         ),
//       phone);

//   protocol.addTriggeredTask(
//       ImmediateTrigger(),
//       AutomaticTask(name: 'Phone Sensing Task #2')
//         ..measures = activitySchema.getMeasureList(
//           types: [
//             DeviceSamplingPackage.SCREEN,
//           ],
//         )
//         ..addMeasure(PeriodicMeasure(
//           type: SensorSamplingPackage.LIGHT,
//           frequency: const Duration(seconds: 11),
//           duration: const Duration(milliseconds: 100),
//         )),
//       phone);
// }

// void samplingSchemaExample_2() {
//   StudyProtocol protocol = StudyProtocol(
//     ownerId: 'AB',
//     name: 'Track patient movement',
//   );
//   Smartphone phone = Smartphone(roleName: 'phone');
//   protocol.addMasterDevice(phone);

//   protocol.addTriggeredTask(
//       ImmediateTrigger(),
//       AutomaticTask()
//         ..measures = SamplingPackageRegistry().common.measures.values.toList(),
//       phone);
// }

// void samplingSchemaExample_3() async {
//   String studyDeploymentId = '1234';
//   String deviceRolename = 'masterphone';

//   // create and configure a client manager for this phone
//   SmartPhoneClientManager client = SmartPhoneClientManager();
//   await client.configure();

//   // create a study runtime to control this deployment
//   SmartphoneDeploymentController controller =
//       await client.addStudy(studyDeploymentId, deviceRolename);

//   // deploy the study on this phone (controller)
//   await controller.tryDeployment();

//   // configure the controller and resume sampling
//   await controller.configure(
//     samplingSchema: SamplingPackageRegistry().common,
//     privacySchemaName: PrivacySchema.DEFAULT,
//   );
//   controller.resume();
// }

/// Examples of different [RecurrentScheduledTrigger] configurations.
void recurrentScheduledTriggerExample() {
  // collect every day at 13:30
  RecurrentScheduledTrigger(
    type: RecurrentType.daily,
    time: TimeOfDay(hour: 13, minute: 30),
    duration: Duration(seconds: 1),
  );

  // collect every other day at 13:30
  RecurrentScheduledTrigger(
    type: RecurrentType.daily,
    separationCount: 1,
    time: TimeOfDay(hour: 13, minute: 30),
    duration: Duration(seconds: 1),
  );

  // collect every wednesday at 12:23
  RecurrentScheduledTrigger(
    type: RecurrentType.weekly,
    dayOfWeek: DateTime.wednesday,
    time: TimeOfDay(hour: 12, minute: 23),
    duration: Duration(seconds: 1),
  );

  // collect every 2nd monday at 12:23
  RecurrentScheduledTrigger(
    type: RecurrentType.weekly,
    dayOfWeek: DateTime.monday,
    separationCount: 1,
    time: TimeOfDay(hour: 12, minute: 23),
    duration: Duration(seconds: 1),
  );

  // collect monthly in the second week on a monday at 14:30
  RecurrentScheduledTrigger(
    type: RecurrentType.monthly,
    weekOfMonth: 2,
    dayOfWeek: DateTime.monday,
    time: TimeOfDay(hour: 14, minute: 30),
    duration: Duration(seconds: 1),
  );

  // collect quarterly on the 11th day of the first month in each quarter at 21:30
  RecurrentScheduledTrigger(
    type: RecurrentType.monthly,
    dayOfMonth: 11,
    separationCount: 2,
    time: TimeOfDay(hour: 21, minute: 30),
    duration: Duration(seconds: 1),
  );
}

/// An example of how to configure a [SmartphoneDeploymentController] with the
/// default privacy schema.
void study_controller_example() async {
  // create and configure a client manager for this phone
  SmartPhoneClientManager client = SmartPhoneClientManager();

  await client.configure();

  Study study = Study('1234', 'master_phone');

  // add the study and get the study runtime (controller)
  await client.addStudy(study);
  SmartphoneDeploymentController? controller = client.getStudyRuntime(study);

  // configure the controller with the default privacy schema and start sampling
  await controller?.configure(
    privacySchemaName: PrivacySchema.DEFAULT,
  );

  controller?.start();
}

/// An example of using the AppTask model
void app_task_example() async {
  Smartphone phone = Smartphone(roleName: 'phone');

  StudyProtocol protocol = StudyProtocol(
    ownerId: 'user@dtu.dk',
    name: 'Tracking',
  )
    // collect device info as an app task
    ..addTriggeredTask(
        ImmediateTrigger(),
        AppTask(
          type: BackgroundSensingUserTask.ONE_TIME_SENSING_TYPE,
          title: 'Device',
          description: 'Collect device info',
        )..addMeasure(Measure(type: DeviceSamplingPackage.DEVICE)),
        phone)
    // start collecting screen events as an app task
    ..addTriggeredTask(
        ImmediateTrigger(),
        AppTask(
          type: BackgroundSensingUserTask.SENSING_TYPE,
          title: 'Screen',
          description: 'Collect screen events',
        )..addMeasure(Measure(type: DeviceSamplingPackage.SCREEN)),
        phone);

  print(protocol);
}

/// An example of how to listen to different [UserTask] event in the
/// [AppTaskController].
void app_task_controller_example() async {
  AppTaskController ctrl = AppTaskController();

  ctrl.userTaskEvents.listen((userTask) {
    AppTask _task = (userTask.executor.task as AppTask);
    print('Task: ${_task.title}');
    switch (userTask.state) {
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
        userTask.executor.resume();
        break;
      case UserTaskState.canceled:
        //
        break;
      case UserTaskState.done:
        userTask.executor.pause();
        break;
      default:
        //
        break;
    }
  });
}
