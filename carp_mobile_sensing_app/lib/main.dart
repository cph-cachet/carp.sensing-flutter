/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
import 'package:flutter/material.dart';
import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:carp_firebase_backend/carp_firebase_backend.dart';
import 'package:carp_backend/carp_backend.dart';

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
///
///
/// Note that it implements a [ProbeListener] and hence listen on any data created by the probes.
/// This is used to write to a log, which is displayed in a simple scrollable text view.
/// This example uses a [FirebaseStorageDataManager] and code for registry and creation is also included.
class Sensing implements ProbeListener {
  final String username = "researcher";
  final String password = "password";
  final String uri = "http://staging.carp.cachet.dk:8080";
  final String clientID = "carp";
  final String clientSecret = "carp";
  final String testStudyId = "8";

  Console console;
  StudyExecutor executor;

  Sensing(this.console) {
    // Register a [FirebaseStorageDataManager] in the [DataManagerRegistry].
    DataManagerRegistry.register(DataEndPointType.FIREBASE_STORAGE, new FirebaseStorageDataManager());
    DataManagerRegistry.register(DataEndPointType.FIREBASE_DATABASE, new FirebaseDatabaseDataManager());
    DataManagerRegistry.register(DataEndPointType.FILE, new FileDataManager());
    DataManagerRegistry.register(DataEndPointType.CARP, new CarpDataManager());
  }

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
    study.dataEndPoint = getDataEndpoint(DataEndPointType.CARP);

    // note that in this version, we start the sensors (accelerometer, etc.)
    // in order to generate a lot of data quickly for testing purposes
    study.tasks.add(sensorTask);
    study.tasks.add(pedometerTask);
    study.tasks.add(hardwareTask);
    study.tasks.add(appTask);
    study.tasks.add(connectivityTask);
    study.tasks.add(commTask);
    study.tasks.add(locationTask);
//    study.tasks.add(audioTask);
//    study.tasks.add(contextTask);
//    study.tasks.add(noiseTask);
//    study.tasks.add(appUsageTask);
//    study.tasks.add(environmentTask);

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
        return FileDataEndPoint(bufferSize: 500 * 1000, zip: true, encrypt: false);
      case DataEndPointType.CARP:
//        return CarpDataEndPoint(CarpUploadMethod.DATA_POINT,
//            name: 'CARP Staging Server',
//            uri: uri,
//            clientId: clientID,
//            clientSecret: clientSecret,
//            email: study.userId,
//            password: password);
        return CarpDataEndPoint(CarpUploadMethod.FILE,
            name: 'CARP Staging Server',
            uri: uri,
            clientId: clientID,
            clientSecret: clientSecret,
            email: study.userId,
            password: password,
            bufferSize: 500 * 1000,
            zip: true);
      case DataEndPointType.FIREBASE_STORAGE:
        return FirebaseStorageDataEndPoint(firebaseEndPoint, path: 'sensing/data', bufferSize: 50 * 1000, zip: true);
      case DataEndPointType.FIREBASE_DATABASE:
        return FirebaseDatabaseDataEndPoint(firebaseEndPoint, collection: 'carp_data');
      default:
        return new DataEndPoint(DataEndPointType.PRINT);
    }
  }

  FirebaseEndPoint _firebaseEndPoint;
  FirebaseEndPoint get firebaseEndPoint {
    if (_firebaseEndPoint == null) {
      _firebaseEndPoint = new FirebaseEndPoint(
          name: "Flutter Sensing Sandbox",
          uri: 'gs://flutter-sensing-sandbox.appspot.com',
          projectID: 'flutter-sensing-sandbox',
          webAPIKey: 'AIzaSyCGy6MeHkiv5XkBtMcMbtgGYOpf6ntNVE4',
          gcmSenderID: '201621881872',
          androidGoogleAppID: '1:201621881872:android:8e84e7ccfc85e121',
          iOSGoogleAppID: '1:159623150305:ios:4a213ef3dbd8997b',
          firebaseAuthenticationMethod: FireBaseAuthenticationMethods.PASSWORD,
          email: "jakob@bardram.net",
          password: "dumt_password");
    }
    return _firebaseEndPoint;
  }

  Task _appTask;
  Task _appUsageTask;
  Task _audioTask;
  Task _commTask;
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
    if (_appTask == null) {
      _appTask = new Task("Application Task");
      PollingProbeMeasure am = new PollingProbeMeasure(ProbeRegistry.APPS_MEASURE);
      am.name = "Installed apps";
      am.frequency = 5 * 1000;
      _appTask.addMeasure(am);
    }
    return _appTask;
  }

  /// A task collecting app information about installed apps on the device
  Task get appUsageTask {
    if (_appUsageTask == null) {
      _appUsageTask = new Task("AppUsage Task");
      AppUsageMeasure aum = new AppUsageMeasure(ProbeRegistry.APP_USAGE_MEASURE);
      aum.name = "App foreground usage time";
      int hourly = 60 * 60 * 1000;
      aum.frequency = 10 * 1000;
      aum.duration = hourly; // Go back one hour
      _appUsageTask.addMeasure(aum);
    }
    return _appUsageTask;
  }

  /// A task collecting audio data as files.
  Task get audioTask {
    if (_audioTask == null) {
      _audioTask = new Task("Audio task");

      AudioMeasure aum = new AudioMeasure(ProbeRegistry.AUDIO_MEASURE,
          name: 'Audio',
          frequency: 10 * 1000, // once every 10 seconds
          duration: 2 * 1000, // 2 seconds
          soundFileDirPath: "${FileDataManager.CARP_FILE_PATH}/${study.id}/sound");

      _audioTask.addMeasure(aum);
    }
    return _audioTask;
  }

  /// A task collecting information about communication:
  /// - phone log
  /// - messages (sms) log
  /// - an event every time a sms is recieved
  ///
  /// Works only on Android.
  Task get commTask {
    if (_commTask == null) {
      _commTask = new Task("Communication Task");

      _commTask.addMeasure(PhoneLogMeasure(ProbeRegistry.PHONELOG_MEASURE, name: "Entire phone log", days: -1));

      TextMessageMeasure tm_1 =
          new TextMessageMeasure(ProbeRegistry.TEXT_MESSAGE_LOG_MEASURE, name: "Text Message Log");
      tm_1.collectBodyOfMessage = false;
      _commTask.addMeasure(tm_1);

      TextMessageMeasure tm_2 = new TextMessageMeasure(ProbeRegistry.TEXT_MESSAGE_MEASURE, name: "Text Messages");
      _commTask.addMeasure(tm_2);
    }
    return _commTask;
  }

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

  /// A task collecting context information, such as activity.
  Task get contextTask {
    if (_contextTask == null) {
      _contextTask = new Task("Context task");

      _contextTask
          .addMeasure(ListeningProbeMeasure(ProbeRegistry.ACTIVITY_MEASURE, name: "Activity Recognition Probe"));
    }
    return _contextTask;
  }

  /// A task collecting environment information, such as the weather.
  Task get environmentTask {
    if (_environmentTask == null) {
      _environmentTask = new Task("Environment task");

      _environmentTask.addMeasure(WeatherMeasure(ProbeRegistry.WEATHER_MEASURE,
          apiKey: '12b6e28582eb9298577c734a31ba9f4f', name: "Weather Probe", frequency: 15 * 1000));
    }
    return _environmentTask;
  }

  /// A task with three types of hardware measures:
  /// - free memory
  /// - battery
  /// - screen activity (lock, on, off)
  Task get hardwareTask {
    if (_hardwareTask == null) {
      _hardwareTask = new Task("Hardware Task");

      _hardwareTask.addMeasure(
          PollingProbeMeasure(ProbeRegistry.MEMORY_MEASURE, name: 'Polling of availabel memory', frequency: 2 * 1000));
      _hardwareTask.addMeasure(ListeningProbeMeasure(ProbeRegistry.BATTERY_MEASURE, name: 'Battery'));
      _hardwareTask.addMeasure(ListeningProbeMeasure(ProbeRegistry.SCREEN_MEASURE, name: 'Screen Lock/Unlock'));
    }
    return _hardwareTask;
  }

  /// A task collecting location information.
  Task get locationTask {
    if (_locationTask == null) {
      _locationTask = new Task("Location Task");
      _locationTask.addMeasure(LocationMeasure(ProbeRegistry.LOCATION_MEASURE, name: 'Location'));
    }
    return _locationTask;
  }

  /// A task collecting audio data as files.
  Task get noiseTask {
    if (_noiseTask == null) {
      _noiseTask = new Task("Noise task");

      NoiseMeasure nm = new NoiseMeasure(ProbeRegistry.NOISE_MEASURE,
          name: 'Noise',
          frequency: 30 * 1000, // How often to start a measure
          duration: 10 * 1000, // Window size: 10 seconds,
          samplingRate: 500 // Sample a data point every 500 ms
          );

      _noiseTask.addMeasure(nm);
    }
    return _noiseTask;
  }

  /// A task collecting pedometer (step count) data on a regular basis.
  Task get pedometerTask {
    if (_pedometerTask == null) {
      _pedometerTask = new Task("Pedometer task");

      SensorMeasure pm = new SensorMeasure(ProbeRegistry.PEDOMETER_MEASURE,
          name: 'Pedometer', //
          frequency: 30 * 1000 // Sample once every 30 seconds
          );
      _pedometerTask.addMeasure(pm);
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
//      _sensorTask.addMeasure(gm);

      SensorMeasure lm = new SensorMeasure(ProbeRegistry.LIGHT_MEASURE);
      lm.name = 'Light';
      lm.frequency = 8 * 1000; // once every 8 second
      lm.duration = 1000; // 1 second
      _sensorTask.addMeasure(lm);
    }
    return _sensorTask;
  }
}
