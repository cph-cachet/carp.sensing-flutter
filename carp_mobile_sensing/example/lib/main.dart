/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
import 'package:flutter/material.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:carp_mobile_sensing/core/core.dart';

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

/// This class implements the sensing incl. setting up a [Study] with [Task]s and [Measure]s.
///
/// It listens to all datum [events] from the [StudyExecutor], which is displayed in a simple scrollable text view.
class Sensing {
  final String username = "researcher";
  final String password = "password";
  final String uri = "http://staging.carp.cachet.dk:8080";
  final String clientID = "carp";
  final String clientSecret = "carp";
  final String testStudyId = "8";

  Console console;
  StudyController controller;

  Sensing(this.console) {
    DataManagerRegistry.register(DataEndPointType.PRINT, new ConsoleDataManager());
    DataManagerRegistry.register(DataEndPointType.FILE, new FileDataManager());
  }

  /// (Re)start sensing.
  void start() async {
    console.log("Setting up '${study.name}'...");

    // specify the [DataEndPoint] for this study.
    study.dataEndPoint = getDataEndpoint(DataEndPointType.PRINT);

    // note that in this version, we start the sensors (accelerometer, etc.)
    // in order to generate a lot of data quickly for testing purposes
    //study.tasks.add(sensorTask);
    study.tasks.add(pedometerTask);
    //study.tasks.add(hardwareTask);
    //study.tasks.add(appTask);
    //study.tasks.add(connectivityTask);
    //study.tasks.add(commTask);
    study.tasks.add(locationTask);
    //study.tasks.add(audioTask);
    study.tasks.add(contextTask);
    //study.tasks.add(noiseTask);
    //study.tasks.add(appUsageTask);
    //study.tasks.add(environmentTask);

    // print the study to the console
    console.log(study.toString());

    // Create a Study Controller that can manage this study, initialize it, and start it.
    controller = StudyController(study);
    controller.initialize();
    controller.start();
    console.log("Sensing started ...");

    print('listening on streams...');

    // listening on all probe events from the study
    controller.events.forEach(print);
    //executor.events.forEach((datum) => console.log(datum.toString()));

    // listening on a specific probe
    //ProbeRegistry.probes[DataType.LOCATION].events.forEach(print);
  }

  /// Stop sensing.
  void stop() async {
    controller.stop();
    _study = null;
    console.log("Sensing stopped ...");
  }

  Study _study;

  Study get study {
    if (_study == null) {
      _study = new Study(testStudyId, username, name: "Test study #1");
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
        return FileDataEndPoint(bufferSize: 50 * 1000, zip: true, encrypt: false);
      case DataEndPointType.CARP:
      default:
        return new DataEndPoint(DataEndPointType.PRINT);
    }
  }

  Task _appTask;
  Task _appUsageTask;
  Task _audioTask;
  //Task _commTask;
  Task _connectivityTask;
  Task _contextTask;
  Task _environmentTask;
  Task _hardwareTask;
  Task _locationTask;
  Task _noiseTask;
  Task _pedometerTask;
  Task _sensorTask;

  /// A task collecting app information about installed apps on the device
  Task get appTask {
    if (_appTask == null)
      _appTask = Task("Application Task")
        ..addMeasure(
            PeriodicMeasure(MeasureType(NameSpace.CARP, DataType.APPS), name: "Installed apps", frequency: 30 * 1000));

    return _appTask;
  }

  /// A task collecting app information about installed apps on the device
  Task get appUsageTask {
    if (_appUsageTask == null) {
      _appUsageTask = Task("AppUsage Task")
        ..addMeasure(PeriodicMeasure(MeasureType(NameSpace.CARP, DataType.APP_USAGE),
            name: "App foreground usage time", frequency: 10 * 1000, duration: 60 * 60 * 1000 // go back one hour
            ));
    }
    return _appUsageTask;
  }

  /// A task collecting audio data as files.
  Task get audioTask {
    if (_audioTask == null) {
      _audioTask = Task("Audio Task")
        ..addMeasure(AudioMeasure(MeasureType(NameSpace.CARP, DataType.APP_USAGE),
            name: "App foreground usage time",
            frequency: 10 * 1000, // once every 10 sec
            duration: 2 * 1000, // record 2 sec
            studyId: study.id));
    }
    return _audioTask;
  }

  /// A task collecting information about communication:
  /// - phone log
  /// - messages (sms) log
  /// - an event every time a sms is recieved
  ///
  /// Works only on Android.
//  Task get commTask {
//    if (_commTask == null) {
//      _commTask = Task("Communication Task")
//        ..addMeasure(PhoneLogMeasure(MeasureType(NameSpace.CARP, DataType.PHONE_LOG),
//            name: "Entire phone log", days: 10)) // 10 days of log
//        ..addMeasure(PeriodicMeasure(MeasureType(NameSpace.CARP, DataType.TEXT_MESSAGE_LOG),
//            name: "Entire SMS log", frequency: 6 * 1000 // once every 10 sec
//            ))
//        ..addMeasure(Measure(MeasureType(NameSpace.CARP, DataType.TEXT_MESSAGE), name: "Listen on SMS's"));
//    }
//    return _commTask;
//  }

  /// A task with two types of connectivity measures:
  /// - connectivity (wifi, ...)
  /// - nearby bluetooth devices
  Task get connectivityTask {
    if (_connectivityTask == null) {
      _connectivityTask = Task("Connectivity Task")
        ..addMeasure(Measure(MeasureType(NameSpace.CARP, DataType.CONNECTIVITY))..name = "Connectivity")
        ..addMeasure(PeriodicMeasure(MeasureType(NameSpace.CARP, DataType.BLUETOOTH),
            name: "Nearby Bluetooth Devices",
            frequency: 1 * 10 * 1000, // every minute
            duration: 2 * 1000 // scan for 2 secs.
            ));
    }
    return _connectivityTask;
  }

  /// A task collecting context information, such as activity.
  Task get contextTask {
    if (_contextTask == null) {
      _contextTask = Task("Context Task")
        ..addMeasure(
            PeriodicMeasure(MeasureType(NameSpace.CARP, DataType.ACTIVITY))..name = "Activity Recognition Probe");
    }
    return _contextTask;
  }

  /// A task collecting environment information, such as the weather.
  Task get environmentTask {
    if (_environmentTask == null) {
      _environmentTask = Task("Environment Task")
        ..addMeasure(WeatherMeasure(MeasureType(NameSpace.CARP, DataType.WEATHER),
            name: "Weather Probe",
            frequency: 1 * 30 * 1000, // once every minute
            apiKey: '12b6e28582eb9298577c734a31ba9f4f'));
    }
    return _environmentTask;
  }

  /// A task with three types of hardware measures:
  /// - free memory
  /// - battery
  /// - screen activity (lock, on, off)
  Task get hardwareTask {
    if (_hardwareTask == null) {
      _hardwareTask = Task("Hardware Task")
        ..addMeasure(PeriodicMeasure(MeasureType(NameSpace.CARP, DataType.MEMORY),
            name: "Polling of availabel memory", //
            frequency: 10 * 1000)) // 10 days of log
        ..addMeasure(Measure(MeasureType(NameSpace.CARP, DataType.BATTERY))..name = "Battery")
        ..addMeasure(Measure(MeasureType(NameSpace.CARP, DataType.SCREEN))..name = "Screen Lock/Unlock");
    }
    return _hardwareTask;
  }

  /// A task collecting location information.
  Task get locationTask {
    if (_locationTask == null) {
      _locationTask = Task("Location Task")
        ..addMeasure(Measure(MeasureType(NameSpace.CARP, DataType.LOCATION))..name = "Location");
    }
    return _locationTask;
  }

  /// A task sensing noise.
  Task get noiseTask {
    if (_noiseTask == null) {
      _noiseTask = Task("Audio Task")
        ..addMeasure(NoiseMeasure(MeasureType(NameSpace.CARP, DataType.NOISE),
            name: "Noise",
            frequency: 30 * 1000, // How often to start a measure
            duration: 2 * 1000, // Window size
            samplingRate: 400 // Sample a data point every 400 ms
            ));
    }
    return _noiseTask;
  }

  /// A task collecting pedometer (step count) data on a regular basis.
  Task get pedometerTask {
    if (_pedometerTask == null) {
      _pedometerTask = Task("Pedometer Task")
        ..addMeasure(PeriodicMeasure(MeasureType(NameSpace.CARP, DataType.PEDOMETER),
            name: "Pedometer", //
            frequency: 1 * 30 * 1000 // how often to collect step count
            ));
    }
    return _pedometerTask;
  }

  /// A task collecting sensor data from four sensors:
  /// - the accelerometer
  /// - the gyroscope
  /// - the light sensor
  ///
  /// Note that these sensors collects *a lot of data* and should be used *very* carefully.
  Task get sensorTask {
    if (_sensorTask == null) {
      _sensorTask = Task("Sensor Task")
        ..addMeasure(PeriodicMeasure(MeasureType(NameSpace.CARP, DataType.ACCELEROMETER),
            name: "Accelerometer",
            frequency: 8 * 1000, // How often to start a measure
            duration: 20 // Window size
            ))
        ..addMeasure(PeriodicMeasure(MeasureType(NameSpace.CARP, DataType.GYROSCOPE),
            name: "Gyroscope",
            frequency: 9 * 1000, // How often to start a measure
            duration: 100 // Window size
            ))
        ..addMeasure(PeriodicMeasure(MeasureType(NameSpace.CARP, DataType.LIGHT),
            name: "Light",
            frequency: 11 * 1000, // How often to start a measure
            duration: 700 // Window size
            ));
    }
    return _sensorTask;
  }
}
