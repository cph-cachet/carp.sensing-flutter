/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:flutter/material.dart';

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
  ConsolePage({Key? key, required this.title}) : super(key: key);
  Console createState() => Console();
}

/// A simple UI with a console that logs/prints the sensed data in a json format.
class Console extends State<ConsolePage> {
  String _log = '';
  Sensing? sensing;

  void initState() {
    super.initState();
    sensing = Sensing();
    Settings().init().then((future) {
      sensing!.init().then((future) {
        log('Setting up study protocol: ${sensing!.protocol}');
      });
    });
  }

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
  StudyProtocol? protocol;
  StudyDeploymentStatus? _status;
  SmartphoneDeploymentController? controller;

  /// Initialize sensing.
  Future init() async {
    Settings().debugLevel = DebugLevel.DEBUG;

    // get the protocol from the local protocol manager (defined below)
    protocol = await LocalStudyProtocolManager().getStudyProtocol('ignored');

    // deploy this protocol using the on-phone deployment service
    _status =
        await SmartphoneDeploymentService().createStudyDeployment(protocol!);

    String studyDeploymentId = _status!.studyDeploymentId;
    String deviceRolename = _status!.masterDeviceStatus!.device.roleName;

    // create and configure a client manager for this phone
    SmartPhoneClientManager client = SmartPhoneClientManager();
    await client.configure();

    // add and deploy this study deployment
    controller = await client.addStudy(studyDeploymentId, deviceRolename);
    await controller?.tryDeployment();

    // configure the controller
    // notifications are disabled, since we're not using app tasks in this simple app
    // see https://github.com/cph-cachet/carp.sensing-flutter/wiki/3.1-The-AppTask-Model#notifications
    await controller!.configure(
      enableNotifications: false,
    );

    // controller.resume();

    // listening on the data stream and print them as json
    controller!.data.listen((data) => print(toJsonString(data)));
  }

  /// get the status of the study deployment.
  StudyDeploymentStatus? get status => _status;

  /// is sensing running, i.e. has the study executor been resumed?
  bool get isRunning =>
      (controller != null) && controller!.executor!.state == ProbeState.resumed;

  /// resume sensing
  void resume() async => controller!.resume();

  /// pause sensing
  void pause() async => controller!.pause();

  /// stop sensing.
  void stop() async => controller!.stop();
}

/// This is a simple local [StudyProtocolManager].
///
/// This class shows how to configure a [StudyProtocol] with [Tigger]s,
/// [TaskDescriptor]s and [Measure]s.
class LocalStudyProtocolManager implements StudyProtocolManager {
  Future initialize() async {}

  /// Create a new CAMS study protocol.
  Future<SmartphoneStudyProtocol> getStudyProtocol(String studyId) async {
    SmartphoneStudyProtocol protocol = SmartphoneStudyProtocol(
      ownerId: 'AB',
      name: 'Track patient movement',
    );

    // define which devices are used for data collection.
    Smartphone phone = Smartphone();
    DeviceDescriptor eSense = DeviceDescriptor(roleName: 'esense');

    protocol
      ..addMasterDevice(phone)
      ..addConnectedDevice(eSense);

    // add default measures from the SensorSamplingPackage
    protocol.addTriggeredTask(
        ImmediateTrigger(),
        AutomaticTask()
          ..measures = SamplingPackageRegistry().debug().getMeasureList(
            types: [
              // SensorSamplingPackage.ACCELEROMETER,
              // SensorSamplingPackage.GYROSCOPE,
              SensorSamplingPackage.PERIODIC_ACCELEROMETER,
              SensorSamplingPackage.PERIODIC_GYROSCOPE,
              SensorSamplingPackage.PEDOMETER,
              SensorSamplingPackage.LIGHT,
            ],
          ),
        phone);

    // add default measures from the DeviceSamplingPackage
    protocol.addTriggeredTask(
        ImmediateTrigger(),
        AutomaticTask()
          ..measures = SamplingPackageRegistry().debug().getMeasureList(
            types: [
              DeviceSamplingPackage.MEMORY,
              DeviceSamplingPackage.BATTERY,
              DeviceSamplingPackage.SCREEN,
            ],
          ),
        phone);

    // collect device info only once
    protocol.addTriggeredTask(
        OneTimeTrigger('device'),
        AutomaticTask()
          ..measures = SamplingPackageRegistry().debug().getMeasureList(
            types: [
              DeviceSamplingPackage.DEVICE,
            ],
          ),
        phone);

    // // add a random trigger to collect device info at random times
    // protocol.addTriggeredTask(
    //     RandomRecurrentTrigger(
    //       startTime: Time(hour: 22, minute: 00),
    //       endTime: Time(hour: 22, minute: 30),
    //       minNumberOfTriggers: 2,
    //       maxNumberOfTriggers: 8,
    //     ),
    //     AutomaticTask()
    //       ..measures = SamplingPackageRegistry().debug().getMeasureList(
    //         types: [
    //           DeviceSamplingPackage.DEVICE,
    //         ],
    //       ),
    //     phone);

    // add a ConditionalPeriodicTrigger to chech periodically
    protocol.addTriggeredTask(
        ConditionalPeriodicTrigger(
          period: Duration(seconds: 10),
          resumeCondition: () {
            return ('jakob'.length == 5);
          },
          pauseCondition: () => true,
        ),
        AutomaticTask()
          ..measures = SamplingPackageRegistry().debug().getMeasureList(
            types: [
              DeviceSamplingPackage.DEVICE,
            ],
          ),
        phone);

    return protocol;
  }

  Future<bool> saveStudyProtocol(String studyId, StudyProtocol protocol) async {
    throw UnimplementedError();
  }
}
