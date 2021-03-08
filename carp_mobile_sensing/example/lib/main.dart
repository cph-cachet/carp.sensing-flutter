/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:flutter/material.dart';

void main() => runApp(CARPMobileSensingApp());

class CARPMobileSensingApp extends StatelessWidget {
  // This widget is the root of your application.
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
  ConsolePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Console createState() => Console();
}

class Console extends State<ConsolePage> {
  String _log = '';
  Sensing sensing;

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

  void initState() {
    super.initState();
    sensing = Sensing(this);
    sensing.start();
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
          stream: sensing.controller.events,
          builder: (context, AsyncSnapshot<Datum> snapshot) {
            if (snapshot.hasData) {
              _log += '${snapshot.data.toString()}\n';
              return Text(_log);
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _restart,
        tooltip: 'Restart study & probes',
        child: sensing.isRunning ? Icon(Icons.pause) : Icon(Icons.play_arrow),
      ),
    );
  }

  void _restart() {
    setState(() {
      if (sensing.isRunning) {
        sensing.pause();
      } else {
        sensing.resume();
      }
    });
  }
}

/// This class implements sensing incl. setting up a [StudyProtocol] with [TaskDescriptor]s and [Measure]s.
///
/// This example is useful for creating a Business Logical Object (BLOC) in a Flutter app.
/// See e.g. the CARP Mobile Sensing App.
class Sensing {
  StudyProtocol study;
  Console console;
  StudyDeploymentController controller;

  Sensing(this.console);

  /// Start sensing.
  void start() async {
    console.log('Setting up study...');

    // create the study
    study = StudyProtocol(
            userId: 'user@cachet.dk',
            name: 'A default / common study',
            dataEndPoint: FileDataEndPoint()
              ..bufferSize = 500 * 1000
              ..zip = true
              ..encrypt = false)
          ..addTriggeredTask(
              ImmediateTrigger(),
              AutomaticTaskDescriptor()
                ..measures = SamplingPackageRegistry().debug().getMeasureList(
                  namespace: NameSpace.CARP,
                  types: [
                    //SensorSamplingPackage.ACCELEROMETER,
                    //SensorSamplingPackage.GYROSCOPE,
                    SensorSamplingPackage.PERIODIC_ACCELEROMETER,
                    SensorSamplingPackage.PERIODIC_GYROSCOPE,
                    SensorSamplingPackage.LIGHT,
                  ],
                ))
          ..addTriggeredTask(
              ImmediateTrigger(),
              AutomaticTaskDescriptor()
                ..measures = SamplingPackageRegistry().debug().getMeasureList(
                  namespace: NameSpace.CARP,
                  types: [
                    SensorSamplingPackage.PEDOMETER,
                    DeviceSamplingPackage.MEMORY,
                    DeviceSamplingPackage.DEVICE,
                    DeviceSamplingPackage.BATTERY,
                    DeviceSamplingPackage.SCREEN,
                  ],
                ))
        //
        ;

    console.log("Setting up '${study.name}'...");

    // print the study to the console
    console.log(study.toString());

    // Create a Study Controller that can manage this study and initialize it.
    controller = StudyDeploymentController(
      study,
      debugLevel: DebugLevel.DEBUG,
      privacySchemaName: PrivacySchema.DEFAULT,
    );
    await controller.initialize();

    // Resume (i.e. start) data sampling.
    controller.resume();
    console.log('Sensing started ...');

    // listening on all probe events from the study
    controller.events.listen((event) => print(event));
  }

  /// Is sensing running, i.e. has the study executor been resumed?
  bool get isRunning =>
      (controller != null) && controller.executor.state == ProbeState.resumed;

  /// Resume sensing
  void resume() async {
    console.log('\nSensing resumed ...\n');
    controller.resume();
  }

  /// Pause sensing
  void pause() async {
    console.log('\nSensing paused ...\n');
    controller.pause();
  }

  /// Stop sensing.
  void stop() async {
    controller.stop();
    study = null;
    console.log('Sensing stopped ...');
  }
}
