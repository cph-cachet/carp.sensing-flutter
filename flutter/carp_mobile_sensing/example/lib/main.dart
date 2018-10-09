/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

void example() {
  // Instantiate a new study
  Study study = new Study("1234", "bardram", name: "Test study #1");

  // Setting the data endpoint to print to the console
  study.dataEndPoint = new DataEndPoint(DataEndPointType.PRINT);

  // Create a task to hold measures
  Task task = new Task("Simple Task");

  // Create a battery and location measures and add them to the task
  // Both are listening on events from changes from battery and location
  task.addMeasure(new BatteryMeasure(ProbeRegistry.BATTERY_MEASURE));
  task.addMeasure(new LocationMeasure(ProbeRegistry.LOCATION_MEASURE));

  // Create an executor that can execute this study, initialize it, and start it.
  StudyExecutor executor = new StudyExecutor(study);
  executor.initialize();
  executor.start();
}

class _MyAppState extends State<MyApp> implements ProbeListener {
  String _log = "";
  StudyExecutor executor;

  final Map<String, String> _entries = new Map<String, String>();

  void notify(Datum datum) {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _log without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _log += "\n" + datum.toString();
    });

    //return new Future.value("200 OK");
  }

  @override
  void initState() {
    super.initState();
    startProbes();
  }

  @override
  void dispose() {
    executor.stop();
    super.dispose();
  }

  void startProbes() {
    if (executor != null) {
      executor.stop();
    }
    _study = null;

    print("Study: " + study.name);
//    study.tasks.add(sensorTask);
//    study.tasks.add(pedometerTask);
    study.tasks.add(hardwareTask);
    study.tasks.add(appTask);
    study.tasks.add(commTask);
//    study.tasks.add(testTask);
//    study.tasks.add(locationTask);

    executor = new StudyExecutor(study);
    executor.addProbeListener(this);
    executor.initialize();
    executor.start();
  }

  Study _study;

  Study get study {
    if (_study == null) {
      _study = new Study("1234", "bardram", name: "Test study #1");
      _study.dataEndPoint = new DataEndPoint(DataEndPointType.PRINT);

//      final FileDataEndPoint fileEndPoint = new FileDataEndPoint(DataEndPointType.FILE);
//      fileEndPoint.bufferSize = 500 * 1000;
//      fileEndPoint.zip = true;
//      fileEndPoint.encrypt = false;
//      _study.dataEndPoint = fileEndPoint;

    }
    return _study;
  }

  Task _testTask;

  Task get testTask {
    if (_testTask == null) {
      _testTask = new Task("Test task");
      Measure _measure;

      _measure = new ProbeMeasure(ProbeRegistry.USER_MEASURE);
      _measure.name = 'One-time collection of OS user information';
      _testTask.addMeasure(_measure);

      _measure = new PollingProbeMeasure(ProbeRegistry.MEMORY_MEASURE);
      _measure.name = 'Polling of availabel memory';
      (_measure as PollingProbeMeasure).frequency = 2 * 1000; // 2 secs.
      _testTask.addMeasure(_measure);
    }
    return _testTask;
  }

  Task _sensorTask;

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

  Task get pedometerTask {
    if (_pedometerTask == null) {
      _pedometerTask = new Task("Pedometer task");

      PedometerMeasure pm = new PedometerMeasure(ProbeRegistry.PEDOMETER_MEASURE);
      pm.name = 'Pedometer';
      pm.frequency = 8 * 1000; // once every 8 second
      _pedometerTask.addMeasure(pm);
    }
    return _pedometerTask;
  }

  Task _hardwareTask;

  Task get hardwareTask {
    if (_hardwareTask == null) {
      _hardwareTask = new Task("Hardware Task");

      BatteryMeasure bm = new BatteryMeasure(ProbeRegistry.BATTERY_MEASURE);
      bm.name = 'Battery';
      _hardwareTask.addMeasure(bm);

      ConnectivityMeasure cm = new ConnectivityMeasure(ProbeRegistry.CONNECTIVITY_MEASURE);
      cm.name = 'Connectivity';
      _hardwareTask.addMeasure(cm);

      ScreenMeasure sm = new ScreenMeasure(ProbeRegistry.SCREEN_MEASURE);
      sm.name = 'Screen Lock/Unlock';
      _hardwareTask.addMeasure(sm);

//      BluetoothMeasure blue_m = new BluetoothMeasure(ProbeRegistry.BLUETOOTH_MEASURE);
//      blue_m.name = 'Nearby Bluetooth Devices';
//      _hardwareTask.addMeasure(blue_m);
    }
    return _hardwareTask;
  }

  Task _appTask;

  Task get appTask {
    if (_appTask == null) {
      _appTask = new Task("Application Task");
      PollingProbeMeasure am = new PollingProbeMeasure(ProbeRegistry.APPS_MEASURE);
      am.name = "Apps";
      am.frequency = 5 * 1000; // 8 secs.
      _appTask.addMeasure(am);
    }
    return _appTask;
  }

  Task _commTask;

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

  Task get locationTask {
    if (_locationTask == null) {
      _locationTask = new Task("Location Task");
      LocationMeasure lm = new LocationMeasure(ProbeRegistry.LOCATION_MEASURE);
      lm.name = 'Location';
      _locationTask.addMeasure(lm);
    }
    return _locationTask;
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
          appBar: new AppBar(
            title: const Text('CARP Sensing Console'),
          ),
          body: new ListView(children: [
            new RaisedButton(
              child: const Text('Restart probes'),
              color: Theme.of(context).accentColor,
              elevation: 4.0,
              splashColor: Colors.greenAccent,
              onPressed: startProbes,
            ),
            new SingleChildScrollView(
              child: new Text(_log),
            ),
          ])),
    );
  }
}
