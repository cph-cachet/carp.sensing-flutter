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

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

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
        child: new Text(
          _log,
          style: TextStyle(fontFamily: 'RobotoMono'),
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

/// This class implements the sensing incl. setting up a [Study] with [Task]s and [Measure]s.
/// Note that it implements a [ProbeListener] and hence listen on any data created by the probes.
/// This is used to write to a log, which is displayed in a simple scrollable text view.
class Sensing implements ProbeListener {
  Console console;
  StudyExecutor executor;

  Sensing(this.console);

  /// Callback method called by [ProbeListener]s
  void notify(Datum datum) {
    console.log(datum.toString());
  }

  /// (Re)start sensing.
  void start() async {
    // if an executor/study is already running, stop the old one before creating a new study
    if (executor != null) {
      stop();
    }

    console.log("Setting up '${study.name}'...");

    // specify the [DataEndPoint] for this study.
    study.dataEndPoint = getDataEndpoint(DataEndPointType.PRINT);

    // add tasks to the study
    // note that in this version, don't start the sensors (accelerometer, etc. - they simpley generate too much data....
    //study.tasks.add(sensorTask);
    study.tasks.add(pedometerTask);
    study.tasks.add(hardwareTask);
    study.tasks.add(appTask);
    study.tasks.add(commTask);
    study.tasks.add(locationTask);

    // print the study to the console
    console.log(study.toString());

    // create a new executor
    executor = new StudyExecutor(study);
    // add `this` as a [ProbeListener] so we can update the log.
    // see the [notify()] method
    executor.addProbeListener(this);
    executor.initialize();
    executor.start();
    console.log("Sensing started ...");
  }

  /// Stop sensing.
  void stop() async {
    executor.stop();
    _study = null;
    console.log("Sensing stopped ...");
  }

  Study _study;
  Study get study {
    if (_study == null) {
      _study = new Study("1234", "user@dtu.dk", name: "Test study #1");
    }
    return _study;
  }

  /// Return a [DataEndPoint] of the specified type.
  DataEndPoint getDataEndpoint(String type) {
    assert(type != null);
    switch (type) {
      case DataEndPointType.PRINT:
        return new DataEndPoint(DataEndPointType.PRINT);
      case DataEndPointType.FILE:
        final FileDataEndPoint fileEndPoint = new FileDataEndPoint(DataEndPointType.FILE);
        fileEndPoint.bufferSize = 500 * 1000;
        fileEndPoint.zip = true;
        fileEndPoint.encrypt = false;
        return fileEndPoint;
      default:
        return new DataEndPoint(DataEndPointType.PRINT);
    }
  }

  Task _sensorTask;

  /// A task collecting sensor data from four sensors:
  /// - the accelerometer
  /// - the gyroscope
  /// - the light sensor
  ///
  /// Note that these sensors collects *a lot of data* and should be used *very* carefully.
  Task get sensorTask {
    if (_sensorTask == null) {
      _sensorTask = new Task("Sensor task");

      SensorMeasure am = new SensorMeasure(ProbeRegistry.ACCELEROMETER_MEASURE);
      am.name = 'Accelerometer';
      am.frequency = 8 * 1000; // once every 8 second
      am.duration = 500; // 500 ms
      _sensorTask.addMeasure(am);

      SensorMeasure gm = new SensorMeasure(ProbeRegistry.GYROSCOPE_MEASURE);
      gm.name = 'Gyroscope';
      gm.frequency = 8 * 1000; // once every 8 second
      gm.duration = 100; // 100 ms
      _sensorTask.addMeasure(gm);

      SensorMeasure lm = new SensorMeasure(ProbeRegistry.LIGHT_MEASURE);
      lm.name = 'Light';
      lm.frequency = 8 * 1000; // once every 8 second
      lm.duration = 100; // 500 ms
      _sensorTask.addMeasure(lm);
    }
    return _sensorTask;
  }

  Task _pedometerTask;

  /// A task collecting pedometer (step count) data on a regular basis.
  Task get pedometerTask {
    if (_pedometerTask == null) {
      _pedometerTask = new Task("Pedometer task");

      SensorMeasure pm = new SensorMeasure(ProbeRegistry.PEDOMETER_MEASURE);
      pm.name = 'Pedometer';
      pm.frequency = 5 * 1000; // Sample once every 5 seconds
      _pedometerTask.addMeasure(pm);
    }
    return _pedometerTask;
  }

  Task _hardwareTask;

  /// A task with three types of hardware measures:
  /// - free memory
  /// - battery
  /// - screen activity (lock, on, off)
  Task get hardwareTask {
    if (_hardwareTask == null) {
      _hardwareTask = new Task("Hardware Task");

      _hardwareTask.addMeasure(
          PollingProbeMeasure(ProbeRegistry.MEMORY_MEASURE, name: 'Polling of availabel memory', frequency: 2 * 1000));
      _hardwareTask.addMeasure(BatteryMeasure(ProbeRegistry.BATTERY_MEASURE, name: 'Battery'));
      _hardwareTask.addMeasure(ScreenMeasure(ProbeRegistry.SCREEN_MEASURE, name: 'Screen Lock/Unlock'));
    }
    return _hardwareTask;
  }

  Task _connectivityTask;

  /// A task with three types of connectivity measures:
  /// - connectivity (wifi, ...)
  /// - nearby bluetooth devices
  Task get connectivityTask {
    if (_connectivityTask == null) {
      _connectivityTask = new Task("Connectivity Task");

      _connectivityTask.addMeasure(ConnectivityMeasure(ProbeRegistry.CONNECTIVITY_MEASURE, name: 'Connectivity'));
      _connectivityTask.addMeasure(BluetoothMeasure(ProbeRegistry.BLUETOOTH_MEASURE, name: 'Nearby Bluetooth Devices'));
    }
    return _connectivityTask;
  }

  Task _appTask;

  /// A task collecting app information about installed apps on the device
  Task get appTask {
    if (_appTask == null) {
      _appTask = new Task("Application Task");
      PollingProbeMeasure am = new PollingProbeMeasure(ProbeRegistry.APPS_MEASURE);
      am.name = "Apps";
      am.frequency = 5 * 1000;
      _appTask.addMeasure(am);
    }
    return _appTask;
  }

  Task _commTask;

  /// A task collecting information about communication. So far only collecting:
  /// - messages (sms) done on this device
  ///
  /// Works only on Android.
  Task get commTask {
    if (_commTask == null) {
      _commTask = new Task("Communication Task");
      ProbeMeasure tm = new ProbeMeasure(ProbeRegistry.TEXT_MESSAGE_MEASURE);
      tm.name = "TextMessage";
      _commTask.addMeasure(tm);
    }
    return _commTask;
  }

  Task _locationTask;

  /// A task collecting location information.
  Task get locationTask {
    if (_locationTask == null) {
      _locationTask = new Task("Location Task");
      _locationTask.addMeasure(LocationMeasure(ProbeRegistry.LOCATION_MEASURE, name: 'Location'));
    }
    return _locationTask;
  }
}
