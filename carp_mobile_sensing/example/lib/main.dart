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
  ConsolePage({Key key, this.title}) : super(key: key);
  Console createState() => Console();
}

/// A simple UI with a console that logs/prints the sensed data in a json format.
class Console extends State<ConsolePage> {
  String _log = '';
  Sensing sensing;

  void initState() {
    super.initState();
    sensing = Sensing();
    settings.init().then((future) {
      sensing.init().then((future) {
        log("Setting up study protocol: ${sensing.protocol}");
      });
    });
  }

  void dispose() {
    sensing.stop();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder(
          stream: sensing.controller?.data,
          builder: (context, AsyncSnapshot<DataPoint> snapshot) {
            if (snapshot.hasData) _log += '${toJsonString(snapshot.data)}\n';
            return Text(_log);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: restart,
        tooltip: 'Restart study & probes',
        child: sensing.isRunning ? Icon(Icons.pause) : Icon(Icons.play_arrow),
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
      if (sensing.isRunning) {
        sensing.pause();
        log('\nSensing paused ...');
      } else {
        sensing.resume();
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
///  * create and initialize a [StudyDeploymentController]
///  * start/pause/resume/stop sensing via this study controller
///
/// This example is useful for creating a Business Logical Object (BLOC) in a
/// Flutter app. See e.g. the CARP Mobile Sensing App.
class Sensing {
  StudyProtocol protocol;
  StudyDeploymentStatus _status;
  StudyDeploymentController controller;

  /// Initialize sensing.
  Future init() async {
    settings.debugLevel = DebugLevel.DEBUG;

    // get the protocol from the local protocol manager (defined below)
    protocol = await LocalStudyProtocolManager().getStudyProtocol('ignored');

    // deploy this protocol using the on-phone deployment service
    _status =
        await SmartphoneDeploymentService().createStudyDeployment(protocol);

    String studyDeploymentId = _status.studyDeploymentId;
    String deviceRolename = _status.masterDeviceStatus.device.roleName;

    // create and configure a client manager for this phone
    SmartPhoneClientManager client = SmartPhoneClientManager();
    await client.configure();

    StudyDeploymentController controller =
        await client.addStudy(studyDeploymentId, deviceRolename);

    // configure the controller and resume sampling
    await controller.configure(
      privacySchemaName: PrivacySchema.DEFAULT,
      transformer: ((datum) => datum),
    );
    controller.resume();

    // listening on the data stream and print them as json to the debug console
    controller.data.listen((data) => print(toJsonString(data)));
  }

  /// Get the status of the study deployment.
  StudyDeploymentStatus get status => _status;

  /// Is sensing running, i.e. has the study executor been resumed?
  bool get isRunning =>
      (controller != null) && controller.executor.state == ProbeState.resumed;

  /// Resume sensing
  void resume() async => controller.resume();

  /// Pause sensing
  void pause() async => controller.pause();

  /// Stop sensing.
  void stop() async => controller.stop();
}

/// This is a simple local [StudyProtocolManager].
///
/// This class shows how to configure a [StudyProtocol] with [Tigger]s,
/// [TaskDescriptor]s and [Measure]s.
class LocalStudyProtocolManager implements StudyProtocolManager {
  Future initialize() async {}

  /// Create a new CAMS study protocol.
  Future<StudyProtocol> getStudyProtocol(String studyId) async {
    CAMSStudyProtocol protocol = CAMSStudyProtocol()
      ..name = 'Track patient movement'
      ..owner = ProtocolOwner(
        id: 'AB',
        name: 'Alex Boyon',
        email: 'alex@uni.dk',
      );

    // Define which devices are used for data collection.
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
              DeviceSamplingPackage.DEVICE,
              DeviceSamplingPackage.BATTERY,
              DeviceSamplingPackage.SCREEN,
            ],
          ),
        phone);

    return protocol;
  }

  Future<bool> saveStudyProtocol(String studyId, StudyProtocol protocol) async {
    throw UnimplementedError();
  }
}
