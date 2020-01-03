/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
import 'package:flutter/material.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';

void main() => runApp(new CARPMobileSensingApp());

class CARPMobileSensingApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'CARP Mobile Sensing Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new ConsolePage(title: 'CARP Mobile Sensing Demo'),
    );
  }
}

class ConsolePage extends StatefulWidget {
  ConsolePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Console createState() => new Console();
}

class Console extends State<ConsolePage> {
  String _log = "";
  Sensing sensing;

  void log(String msg) {
    setState(() {
      _log += "$msg\n";
    });
  }

  void clearLog() {
    setState(() {
      _log += "";
    });
  }

  void restart() {
    log("-------------------------------------\nSensing restarted...");
    sensing.start();
  }

  @override
  void initState() {
    super.initState();
    sensing = new Sensing(this);
    sensing.start();
  }

  @override
  void dispose() {
    sensing.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new SingleChildScrollView(
        child: StreamBuilder(
          stream: sensing.controller.events,
          builder: (context, AsyncSnapshot<Datum> snapshot) {
            if (snapshot.hasData) {
              _log += "${snapshot.data.toString()}\n";
              return Text(_log);
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: restart,
        tooltip: 'Restart study & probes',
        child: new Icon(Icons.cached),
      ),
    );
  }
}

/// This class implements sensing incl. setting up a [Study] with [Task]s and [Measure]s.
///
/// This example is useful for creating a Business Logical Object (BLOC) in a Flutter app.
/// See e.g. the CARP Mobile Sensing App.
class Sensing {
  Study study;
  Console console;
  StudyController controller;

  Sensing(this.console) {
    //DataManagerRegistry.register(DataEndPointType.PRINT, new ConsoleDataManager());
    //DataManagerRegistry.register(DataEndPointType.FILE, new FileDataManager());
  }

  /// (Re)start sensing.
  void start() async {
    console.log("Setting up study...");

    // create the study
    study = Study("2", 'user@cachet.dk',
            name: 'A default / common study',
            dataEndPoint: FileDataEndPoint()
              ..bufferSize = 500 * 1000
              ..zip = true
              ..encrypt = false)
          ..addTriggerTask(
              ImmediateTrigger(),
              Task()
                ..measures = SamplingSchema.debug().getMeasureList(
                  namespace: NameSpace.CARP,
                  types: [
                    SensorSamplingPackage.LIGHT,
                    ConnectivitySamplingPackage.BLUETOOTH,
                    ConnectivitySamplingPackage.WIFI,
                    DeviceSamplingPackage.MEMORY,
                  ],
                ))
//      ..addTriggerTask(ImmediateTrigger(),
//          Task()..measures = SamplingSchema.common(namespace: NameSpace.CARP).measures.values.toList())
        ;

    console.log("Setting up '${study.name}'...");

    // print the study to the console
    console.log(study.toString());

    // Create a Study Controller that can manage this study, initialize it, and start it.
    controller = StudyController(study);
    await controller.initialize();
    controller.start();
    console.log("Sensing started ...");

    // listening on all probe events from the study
    controller.events.forEach(print);

    // listening on a specific probe
    //ProbeRegistry.probes[DataType.LOCATION].events.forEach(print);
  }

  /// Stop sensing.
  void stop() async {
    controller.stop();
    study = null;
    console.log("Sensing stopped ...");
  }
}
