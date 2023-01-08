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
  @override
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

  @override
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
    sensing!.dispose();
    super.dispose();
  }

  @override
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

/// This class handles sensing logic.
///
/// This example is useful for creating a Business Logical Object (BLOC) in a
/// Flutter app. See e.g. the CARP Mobile Sensing App.
class Sensing {
  SmartPhoneClientManager? client;
  SmartphoneDeploymentController? controller;
  Study? study;

  /// Initialize sensing.
  Future<void> init() async {
    Settings().debugLevel = DebugLevel.DEBUG;

    // Get the local protocol.
    StudyProtocol protocol =
        await LocalStudyProtocolManager().getStudyProtocol('ignored');

    // Create and configure a client manager for this phone, and
    // create a study based on the protocol.
    client = SmartPhoneClientManager();
    await client?.configure();
    study = await client?.addStudyProtocol(protocol);

    // Get the study controller and try to deploy the study.
    //
    // Note that if the study has already been deployed on this phone
    // it has been cached locally in a file and the local cache will
    // be used pr. default.
    // If not deployed before (i.e., cached) the study deployment will be
    // fetched from the deployment service.
    controller = client?.getStudyRuntime(study!);
    await controller?.tryDeployment(useCached: false);

    // Configure the controller.
    //
    // Notifications are enabled for demo purpose and if you add an AppTask to the
    // protocol below, you should see notifications on the phone.
    // However, nothing will happen when you click on them.
    // See the PulmonaryMonitor demo app for a full-scale example of how to use
    // the App Task model.
    await controller?.configure(
      enableNotifications: true,
    );

    // Listening on the data stream and print them as json.
    controller?.data.listen((data) => print(toJsonString(data)));
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

  /// Remove sensing from this phone.
  void remove() async => controller?.remove();

  /// Dispose the entire deployment.
  void dispose() async => client?.dispose();

  /// Stop sensing.
  void stop() async => controller!.stop();
}

/// This is a simple local [StudyProtocolManager].
///
/// This class shows how to configure a [StudyProtocol] with Triggers,
/// Tasks and Measures.
class LocalStudyProtocolManager implements StudyProtocolManager {
  Future<void> initialize() async {}

  /// Create a new CAMS study protocol.
  Future<SmartphoneStudyProtocol> getStudyProtocol(String id) async {
    // Create a protocol. Note that the [id] is not used for anything.
    SmartphoneStudyProtocol protocol = SmartphoneStudyProtocol(
        ownerId: 'AB',
        name: 'Track patient movement',
        dataEndPoint: SQLiteDataEndPoint());

    // Define which devices are used for data collection.
    //
    // In this case, its only this phone.
    // See the CARP Mobile Sensing app for a full-blown example of how to
    // use connected devices (e.g., a Polar heart rate monitor) and online
    // services (e.g., a weather service).
    var phone = Smartphone();
    protocol.addMasterDevice(phone);

    // // // Add measures from the [DeviceSamplingPackage] and [SensorSamplingPackage]
    // // // sampling packages.
    // protocol.addTriggeredTask(
    //     ImmediateTrigger(),
    //     BackgroundTask()
    //       ..addMeasures([
    //         // Measure(type: SensorSamplingPackage.ACCELEROMETER),
    //         // Measure(type: SensorSamplingPackage.GYROSCOPE),
    //         Measure(type: DeviceSamplingPackage.MEMORY),
    //         Measure(type: DeviceSamplingPackage.BATTERY),
    //         Measure(type: DeviceSamplingPackage.SCREEN),
    //         Measure(type: SensorSamplingPackage.PEDOMETER),
    //         Measure(type: SensorSamplingPackage.LIGHT)
    //       ]),
    //     phone);

    // // Collect device info only once
    // protocol.addTriggeredTask(
    //     OneTimeTrigger(),
    //     BackgroundTask()
    //       ..addMeasure(Measure(type: DeviceSamplingPackage.DEVICE)),
    //     phone);

    // protocol.addTriggeredTask(
    //     IntervalTrigger(period: Duration(seconds: 5)),
    //     BackgroundTask(measures: [Measure(type: DeviceSamplingPackage.DEVICE)]),
    //     phone);

    protocol.addTriggeredTask(
        PeriodicTrigger(
            period: Duration(seconds: 6), duration: Duration(seconds: 2)),
        BackgroundTask(measures: [
          Measure(type: SensorSamplingPackage.USER_ACCELEROMETER)
        ]),
        phone);

    protocol.addTriggeredTask(IntervalTrigger(period: Duration(seconds: 5)),
        FunctionTask(function: () => print('Her går det godt....!')), phone);

    // // add a random trigger to collect device info at random times
    // protocol.addTriggeredTask(
    //     RandomRecurrentTrigger(
    //       startTime: TimeOfDay(hour: 07, minute: 45),
    //       endTime: TimeOfDay(hour: 22, minute: 30),
    //       minNumberOfTriggers: 2,
    //       maxNumberOfTriggers: 8,
    //     ),
    //     BackgroundTask()
    //       ..addMeasure(Measure(type: DeviceSamplingPackage.DEVICE)),
    //     phone);

    // // add a ConditionalPeriodicTrigger to check periodically
    // protocol.addTriggeredTask(
    //     ConditionalPeriodicTrigger(
    //       period: Duration(seconds: 10),
    //       resumeCondition: () {
    //         //
    //         return ('jakob'.length == 5);
    //       },
    //       pauseCondition: () => true,
    //     ),
    //     BackgroundTask()
    //       ..addMeasure(Measure(type: DeviceSamplingPackage.DEVICE)),
    //     phone);

    // Add an app task 2 minutes after deployment and make a notification.
    //
    // This App Task is added for demo purpose and you should see notifications
    // on the phone. However, nothing will happen when you click on it.
    // See the PulmonaryMonitor demo app for a full-scale example of how to use
    // the App Task model.
    protocol.addTriggeredTask(
        ElapsedTimeTrigger(
          elapsedTime: const Duration(minutes: 2),
        ),
        AppTask(
          type: BackgroundSensingUserTask.ONE_TIME_SENSING_TYPE,
          title: "Elapsed Time - 2 minutes",
          notification: true,
        )..addMeasure(Measure(type: DeviceSamplingPackage.DEVICE)),
        phone);

    // // add an app task at exact date & time
    // protocol.addTriggeredTask(
    //     DateTimeTrigger(schedule: DateTime(2022, 5, 15, 21, 00)),
    //     AppTask(
    //       type: BackgroundSensingUserTask.ONE_TIME_SENSING_TYPE,
    //       title: "DateTime - 15/5 2022 at 21:00",
    //       notification: true,
    //     )..addMeasure(Measure(type: DeviceSamplingPackage.DEVICE)),
    //     phone);

    // // add an app task every hour
    // protocol.addTriggeredTask(
    //     IntervalTrigger(period: const Duration(hours: 1)),
    //     AppTask(
    //       type: BackgroundSensingUserTask.ONE_TIME_SENSING_TYPE,
    //       title: "Interval - Every hour",
    //       notification: true,
    //     )..addMeasure(Measure(type: DeviceSamplingPackage.DEVICE)),
    //     phone);

    // // add a cron job every day at 11:45
    // protocol.addTriggeredTask(
    //     CronScheduledTrigger.parse(cronExpression: '45 11 * * *'),
    //     AppTask(
    //       type: BackgroundSensingUserTask.ONE_TIME_SENSING_TYPE,
    //       title: "Cron - every day at 11:45",
    //       notification: true,
    //     )..addMeasure(Measure(type: DeviceSamplingPackage.DEVICE)),
    //     phone);

    // // add a random app task
    // protocol.addTriggeredTask(
    //     RandomRecurrentTrigger(
    //       startTime: TimeOfDay(hour: 8),
    //       endTime: TimeOfDay(hour: 20),
    //       minNumberOfTriggers: 2,
    //       maxNumberOfTriggers: 8,
    //     ),
    //     AppTask(
    //       type: BackgroundSensingUserTask.ONE_TIME_SENSING_TYPE,
    //       title: "Random - 2-8 times at 08:00-20:00",
    //       notification: true,
    //     )..addMeasure(Measure(type: DeviceSamplingPackage.DEVICE)),
    //     phone);

    return protocol;
  }

  Future<bool> saveStudyProtocol(String studyId, StudyProtocol protocol) async {
    throw UnimplementedError();
  }
}
