/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
import 'package:carp_serializable/carp_serializable.dart';
import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:flutter/material.dart' hide TimeOfDay;

void main() => runApp(CARPMobileSensingApp());

class CARPMobileSensingApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CARP Mobile Sensing Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ConsolePage(title: 'CARP Mobile Sensing Demo'),
    );
  }
}

class ConsolePage extends StatefulWidget {
  final String title;
  ConsolePage({super.key, required this.title});
  Console createState() => Console();
}

/// A simple UI with a console that shows the sensed data in a json format.
class Console extends State<ConsolePage> {
  String _log = '';
  Sensing? sensing;

  void initState() {
    super.initState();
    sensing = Sensing();
    Settings().init().then((_) {
      sensing!.init().then((_) {
        log('Setting up study : ${sensing!.study}');
        log('Deployment status : ${sensing!.status}');
      });
    });
  }

  @override
  void dispose() {
    sensing!.stop();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder(
          stream: sensing?.controller?.data,
          builder: (context, AsyncSnapshot<DataPoint> snapshot) {
            if (snapshot.hasData) _log += '${toJsonString(snapshot.data!)}\n';
            return Text(_log);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: restart,
        tooltip: 'Restart study & probes',
        child: sensing!.isRunning ? Icon(Icons.pause) : Icon(Icons.play_arrow),
      ),
    );
  }

  void log(String msg) {
    setState(() {
      _log += '$msg\n';
    });
  }

  void clearLog() {
    setState(() {
      _log += '';
    });
  }

  void restart() {
    setState(() {
      if (sensing!.isRunning) {
        sensing!.pause();
        log('\nSensing paused ...');
      } else {
        sensing!.resume();
        log('\nSensing resumed ...');
      }
    });
  }
}

/// This class handles sensing with the following business logic flow:
///
///  * create a [StudyProtocol]
///  * deploy the protocol
///  * register devices
///  * get the deployment configuration
///  * mark the deployment successful
///  * create and initialize a [SmartphoneDeploymentController]
///  * start/pause/resume/stop sensing via this study controller
///
/// This example is useful for creating a Business Logical Object (BLOC) in a
/// Flutter app. See e.g. the CARP Mobile Sensing App.
class Sensing {
  // Specify the deployment id for this study.
  // In a real app, the user would somehow specify this.
  String studyDeploymentId = '83ec1e70-c647-11ec-8b84-214a8597ae84';

  StudyProtocol? protocol;
  DeploymentService service = SmartphoneDeploymentService();
  SmartphoneDeploymentController? controller;
  Study? study;

  /// Initialize sensing.
  Future<void> init() async {
    Settings().debugLevel = DebugLevel.DEBUG;

    // Configure the on-phone deployment service with a protocol.
    protocol =
        await LocalStudyProtocolManager().getStudyProtocol(studyDeploymentId);
    StudyDeploymentStatus status =
        await service.createStudyDeployment(protocol!, studyDeploymentId);

    // Create and configure a client manager for this phone.
    SmartPhoneClientManager client = SmartPhoneClientManager();
    await client.configure(deploymentService: service);

    // Define the study and add it to the client.
    study = Study(
      status.studyDeploymentId,
      status.masterDeviceStatus!.device.roleName,
    );
    await client.addStudy(study!);

    // Get the study controller and try to deploy the study.
    //
    // Note that if the study has already been deployed on this phone
    // it has been cached locally in a file and the local cache will
    // be used pr. default.
    // If not deployed before (i.e., cached) the study deployment will be
    // fetched from the deployment service.
    controller = client.getStudyRuntime(study!);
    await controller?.tryDeployment(useCached: true);

    // Configure the controller.
    //
    // Notifications are disabled, since we're not using app tasks in this
    // simple app.
    await controller!.configure(
      enableNotifications: true,
    );

    // Listening on the data stream and print them as json.
    controller!.data.listen((data) => print(toJsonString(data)));
  }

  /// Is sensing running, i.e. has the study executor been resumed?
  bool get isRunning =>
      (controller != null) &&
      controller!.executor!.state == ExecutorState.resumed;

  /// Status of sensing.
  StudyStatus? get status => controller?.status;

  /// Resume sensing
  void resume() async => controller?.executor?.resume();

  /// Pause sensing
  void pause() async => controller?.executor?.pause();

  /// Stop sensing.
  void stop() async => controller!.stop();
}

/// This is a simple local [StudyProtocolManager].
///
/// This class shows how to configure a [StudyProtocol] with [Tigger]s,
/// [TaskDescriptor]s and [Measure]s.
class LocalStudyProtocolManager implements StudyProtocolManager {
  Future<void> initialize() async {}

  /// Create a new CAMS study protocol.
  Future<SmartphoneStudyProtocol> getStudyProtocol(String id) async {
    SmartphoneStudyProtocol protocol = SmartphoneStudyProtocol(
        ownerId: 'AB',
        name: 'Track patient movement',
        dataEndPoint: SQLiteDataEndPoint());

    // define which devices are used for data collection.
    var phone = Smartphone();
    protocol.addMasterDevice(phone);

    // add default measures from the SensorSamplingPackage
    protocol.addTriggeredTask(
        ImmediateTrigger(),
        BackgroundTask()
          ..addMeasures([
            // Measure(type: SensorSamplingPackage.ACCELEROMETER),
            // Measure(type: SensorSamplingPackage.GYROSCOPE),
            Measure(type: DeviceSamplingPackage.MEMORY),
            Measure(type: DeviceSamplingPackage.BATTERY),
            Measure(type: DeviceSamplingPackage.SCREEN),
            Measure(type: SensorSamplingPackage.PEDOMETER),
            Measure(type: SensorSamplingPackage.LIGHT)
          ]),
        phone);

    // collect device info only once
    protocol.addTriggeredTask(
        OneTimeTrigger(),
        BackgroundTask()
          ..addMeasure(Measure(type: DeviceSamplingPackage.DEVICE)),
        phone);

    // add a random trigger to collect device info at random times
    protocol.addTriggeredTask(
        RandomRecurrentTrigger(
          startTime: TimeOfDay(hour: 07, minute: 45),
          endTime: TimeOfDay(hour: 22, minute: 30),
          minNumberOfTriggers: 2,
          maxNumberOfTriggers: 8,
        ),
        BackgroundTask()
          ..addMeasure(Measure(type: DeviceSamplingPackage.DEVICE)),
        phone);

    // add a ConditionalPeriodicTrigger to check periodically
    protocol.addTriggeredTask(
        ConditionalPeriodicTrigger(
          period: Duration(seconds: 10),
          resumeCondition: () {
            //
            return ('jakob'.length == 5);
          },
          pauseCondition: () => true,
        ),
        BackgroundTask()
          ..addMeasure(Measure(type: DeviceSamplingPackage.DEVICE)),
        phone);

    // add a task 10 minutes after deployment
    protocol.addTriggeredTask(
        ElapsedTimeTrigger(
          elapsedTime: const Duration(minutes: 10),
        ),
        AppTask(
          type: BackgroundSensingUserTask.ONE_TIME_SENSING_TYPE,
          title: "Elapsed Time - 10 minutes",
          notification: true,
        )..addMeasure(Measure(type: DeviceSamplingPackage.DEVICE)),
        phone);

    // add an app task at exact date & time
    protocol.addTriggeredTask(
        DateTimeTrigger(schedule: DateTime(2022, 5, 15, 21, 00)),
        AppTask(
          type: BackgroundSensingUserTask.ONE_TIME_SENSING_TYPE,
          title: "DateTime - 15/5 2022 at 21:00",
          notification: true,
        )..addMeasure(Measure(type: DeviceSamplingPackage.DEVICE)),
        phone);

    // add an app task every hour
    protocol.addTriggeredTask(
        IntervalTrigger(period: const Duration(hours: 1)),
        AppTask(
          type: BackgroundSensingUserTask.ONE_TIME_SENSING_TYPE,
          title: "Interval - Every hour",
          notification: true,
        )..addMeasure(Measure(type: DeviceSamplingPackage.DEVICE)),
        phone);

    // add a cron job every day at 11:45
    protocol.addTriggeredTask(
        CronScheduledTrigger.parse(cronExpression: '45 11 * * *'),
        AppTask(
          type: BackgroundSensingUserTask.ONE_TIME_SENSING_TYPE,
          title: "Cron - every day at 11:45",
          notification: true,
        )..addMeasure(Measure(type: DeviceSamplingPackage.DEVICE)),
        phone);

    // add a random app task
    protocol.addTriggeredTask(
        RandomRecurrentTrigger(
          startTime: TimeOfDay(hour: 8),
          endTime: TimeOfDay(hour: 20),
          minNumberOfTriggers: 2,
          maxNumberOfTriggers: 8,
        ),
        AppTask(
          type: BackgroundSensingUserTask.ONE_TIME_SENSING_TYPE,
          title: "Random - 2-8 times at 08:00-20:00",
          notification: true,
        )..addMeasure(Measure(type: DeviceSamplingPackage.DEVICE)),
        phone);

    return protocol;
  }

  Future<bool> saveStudyProtocol(String studyId, StudyProtocol protocol) async {
    throw UnimplementedError();
  }
}
