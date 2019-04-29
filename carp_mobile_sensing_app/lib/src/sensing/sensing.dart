part of mobile_sensing_app;

/// This class implements the sensing layer incl. setting up a [Study] with [Task]s and [Measure]s.
class Sensing {
  Study study;
  final String testStudyId = "8";

  StudyController controller;
  StudyManager mock = new StudyMock();

  /// the list of running - i.e. used - probes in this study.
  List<Probe> get runningProbes => (controller != null) ? controller.executor.probes : List();

  Sensing() : super() {
    // register the sampling packages
    SamplingPackageRegistry.register(CommunicationSamplingPackage());
    SamplingPackageRegistry.register(ContextSamplingPackage());
    SamplingPackageRegistry.register(AudioSamplingPackage());

    // register data endpoints
    DataManagerRegistry.register(DataEndPointType.PRINT, new ConsoleDataManager());
    DataManagerRegistry.register(DataEndPointType.FILE, new FileDataManager());
    DataManagerRegistry.register(DataEndPointType.CARP, new CarpDataManager());
    //DataManagerRegistry.register(DataEndPointType.FIREBASE_STORAGE, new FirebaseStorageDataManager());
    //DataManagerRegistry.register(DataEndPointType.FIREBASE_DATABASE, new FirebaseDatabaseDataManager());
  }

  /// Start sensing.
  Future<void> start() async {
    // Get the study.
    study = await mock.getStudy(testStudyId);

    print(study.toString());

    // Create a Study Controller that can manage this study, initialize it, and start it.
    controller = StudyController(study);
    //controller = StudyController(study, privacySchemaName: PrivacySchema.DEFAULT); // a controller w. privacy
    await controller.initialize();
    controller.start();
    print("Sensing started ...");

    // listening on all data events from the study and print it (for debugging purpose).
    controller.events.forEach(print);

    // listening on a specific probe
    //ProbeRegistry.probes[DataType.LOCATION].events.forEach(print);
  }

  /// Stop sensing.
  void stop() async {
    controller.stop();
    study = null;
    print("Sensing stopped ...");
  }
}

/// Used as a mock [StudyManager] to generate a local [Study].
class StudyMock implements StudyManager {
  final String username = "researcher@example.com";
  final String password = "password";
  final String uri = "http://staging.carp.cachet.dk:8080";
  final String clientID = "carp";
  final String clientSecret = "carp";
  String studyId;

  @override
  Future<void> initialize() {
    // TODO: implement
  }

  Study _study;
  Future<Study> getStudy(String studyId) async {
    if (_study == null) {
      _study = Study('DF#4dD-3', username)
        ..name = 'CARP Mobile Sensing - default configuration'
        ..description =
            'This is a long description of a Study which can run forever and take up a lot of space and drain you battery and you have to agree to an informed consent which - by all standards - do not comply to any legal framework....'
        ..dataEndPoint = getDataEndpoint(DataEndPointType.PRINT)
        ..dataFormat = NameSpace.OMH
        ..addTask(Task()
          ..measures =
              SamplingSchema.common(namespace: NameSpace.CARP).getMeasureList([DataType.AUDIO, DataType.BLUETOOTH]));

//    ..addTask(Task()..measures = SamplingSchema.common(namespace: NameSpace.CARP).measures.values.toList());

      // adding the measures to two separate tasks, while also adding a new light measure to the 2nd task
//      _study.addTask(Task('Activity Sensing Task #1')
//        ..measures = SamplingSchema.common()
//            .getMeasureList([DataType.PEDOMETER, DataType.LOCATION, DataType.ACTIVITY, DataType.WEATHER]));
//      _study.addTask(Task('Phone Sensing Task #2')
//        ..measures = SamplingSchema.common().getMeasureList([DataType.SCREEN, DataType.NOISE])
//        ..addMeasure(PeriodicMeasure(MeasureType(NameSpace.CARP, DataType.LIGHT),
//            name: "Ambient Light", frequency: 11 * 1000, duration: 700)));

      //_study.tasks.forEach((task) => task.measures.forEach((measure) => measure.enabled = true));

      // adding a set of specific measures from the `common` sampling schema to one no-name task
//      _study.addTask(Task()
//        ..measures = SamplingSchema.common().getMeasureList(
//            [DataType.PEDOMETER, DataType.LOCATION, DataType.ACTIVITY, DataType.WEATHER],
//            namespace: NameSpace.CARP));

      // OLD stuff below

//      _study = new Study(studyId, username, name: "Test study #1");

      // specify the [DataEndPoint] for this study.
      //    _study.dataEndPoint = getDataEndpoint(DataEndPointType.PRINT);

//      Task task = Task('Task #1');
//
//      DataType.all.forEach((type) {
//        task.addMeasure(PeriodicMeasure(MeasureType(NameSpace.CARP, type)));
//      });
//
//      _study.addTask(task);

//      _study.tasks.add(sensorTask);
//      _study.tasks.add(pedometerTask);
//      _study.tasks.add(hardwareTask);
//      _study.tasks.add(appTask);
//      _study.tasks.add(connectivityTask);
//      _study.tasks.add(commTask);
//      _study.tasks.add(locationTask);
//      // _study.tasks.add(audioTask);
//      _study.tasks.add(contextTask);
//      _study.tasks.add(noiseTask);
//      _study.tasks.add(appUsageTask);
//      _study.tasks.add(environmentTask);
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
        return CarpDataEndPoint(CarpUploadMethod.DATA_POINT,
            name: 'CARP Staging Server',
            uri: uri,
            clientId: clientID,
            clientSecret: clientSecret,
            email: username,
            password: password);
//        return CarpDataEndPoint(CarpUploadMethod.BATCH_DATA_POINT,
//            name: 'CARP Staging Server',
//            uri: uri,
//            clientId: clientID,
//            clientSecret: clientSecret,
//            email: _study.userId,
//            password: password,
//            bufferSize: 50 * 1000,
//            zip: true);
//      case DataEndPointType.FIREBASE_STORAGE:
//        return FirebaseStorageDataEndPoint(firebaseEndPoint, path: 'sensing/data', bufferSize: 50 * 1000, zip: true);
//      case DataEndPointType.FIREBASE_DATABASE:
//        return FirebaseDatabaseDataEndPoint(firebaseEndPoint, collection: 'carp_data');
      default:
        return new DataEndPoint(DataEndPointType.PRINT);
    }
  }

//  FirebaseEndPoint _firebaseEndPoint;
//  FirebaseEndPoint get firebaseEndPoint {
//    if (_firebaseEndPoint == null) {
//      _firebaseEndPoint = new FirebaseEndPoint(
//          name: "Flutter Sensing Sandbox",
//          uri: 'gs://flutter-sensing-sandbox.appspot.com',
//          projectID: 'flutter-sensing-sandbox',
//          webAPIKey: 'AIzaSyCGy6MeHkiv5XkBtMcMbtgGYOpf6ntNVE4',
//          gcmSenderID: '201621881872',
//          androidGoogleAppID: '1:201621881872:android:8e84e7ccfc85e121',
//          iOSGoogleAppID: '1:159623150305:ios:4a213ef3dbd8997b',
//          firebaseAuthenticationMethod: FireBaseAuthenticationMethods.PASSWORD,
//          email: "jakob@bardram.net",
//          password: "dumt_password");
//    }
//    return _firebaseEndPoint;
//  }

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
    if (_appTask == null)
      _appTask = Task("Application Task")
        ..addMeasure(
            PeriodicMeasure(MeasureType(NameSpace.CARP, DataType.APPS), name: "Installed Apps", frequency: 5 * 1000));

    return _appTask;
  }

  /// A task collecting app information about installed apps on the device
  Task get appUsageTask {
    if (_appUsageTask == null) {
      _appUsageTask = Task("AppUsage Task")
        ..addMeasure(PeriodicMeasure(MeasureType(NameSpace.CARP, DataType.APP_USAGE),
                name: "App Foreground Usage Time", frequency: 10 * 1000, duration: 60 * 60 * 1000) // go back one hour
            );
    }
    return _appUsageTask;
  }

  /// A task collecting audio data as files.
  Task get audioTask {
    if (_audioTask == null) {
      _audioTask = Task("Audio Task")
        ..addMeasure(AudioMeasure(MeasureType(NameSpace.CARP, DataType.AUDIO),
            name: "Ambient Audio",
            frequency: 10 * 1000, // once every 10 sec
            duration: 2 * 1000, // record 2 sec
            studyId: _study.id));
    }
    return _audioTask;
  }

  /// A task collecting information about communication:
  /// - phone log
  /// - messages (sms) log
  /// - an event every time a sms is received
  ///
  /// Works only on Android.
  Task get commTask {
    if (_commTask == null) {
      _commTask = Task("Communication Task")
        ..addMeasure(PhoneLogMeasure(MeasureType(NameSpace.CARP, DataType.PHONE_LOG),
            name: "Phone Log", days: 10)) // 10 days of log
        ..addMeasure(PeriodicMeasure(MeasureType(NameSpace.CARP, DataType.TEXT_MESSAGE_LOG),
            name: "SMS Message Log", frequency: 6 * 1000 // once every 10 sec
            ))
        ..addMeasure(Measure(MeasureType(NameSpace.CARP, DataType.TEXT_MESSAGE), name: "SMS Text Messaging"));
    }
    return _commTask;
  }

  /// A task with two types of connectivity measures:
  /// - connectivity (wifi, ...)
  /// - nearby bluetooth devices
  ///
  /// PERMISSIONS
  /// - location related to Bluetooth
  Task get connectivityTask {
    if (_connectivityTask == null) {
      _connectivityTask = Task("Connectivity Task")
            ..addMeasure(Measure(MeasureType(NameSpace.CARP, DataType.CONNECTIVITY), name: "Connectivity"))
//        ..addMeasure(PeriodicMeasure(MeasureType(NameSpace.CARP, DataType.BLUETOOTH),
//            name: "Nearby Bluetooth Devices",
//            frequency: 1 * 10 * 1000, // every minute
//            duration: 2 * 1000 // scan for 2 secs.
//            ))
          ;
    }
    return _connectivityTask;
  }

  /// A task collecting context information, such as activity.
  Task get contextTask {
    if (_contextTask == null) {
      _contextTask = Task("Context Task")
        ..addMeasure(PeriodicMeasure(MeasureType(NameSpace.CARP, DataType.ACTIVITY), name: "Activity Recognition"));
    }
    return _contextTask;
  }

  /// A task collecting environment information, such as the weather.
  Task get environmentTask {
    if (_environmentTask == null) {
      _environmentTask = Task("Environment Task")
        ..addMeasure(WeatherMeasure(MeasureType(NameSpace.CARP, DataType.WEATHER),
            name: "Local Weather",
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
            name: "Availabel Memory", frequency: 10 * 1000)) // 10 days of log
        ..addMeasure(Measure(MeasureType(NameSpace.CARP, DataType.BATTERY), name: "Battery"))
        ..addMeasure(Measure(MeasureType(NameSpace.CARP, DataType.SCREEN), name: "Screen Activity"));
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
      _noiseTask = Task("Noise Task")
        ..addMeasure(NoiseMeasure(MeasureType(NameSpace.CARP, DataType.NOISE),
            name: "Ambient Noise",
            frequency: 30 * 1000, // How often to start a measure
            duration: 2 * 1000, // Window size
            samplingRate: 400 // Sampling rate at 400 ms
            ));
    }
    return _noiseTask;
  }

  /// A task collecting pedometer (step count) data on a regular basis.
  Task get pedometerTask {
    if (_pedometerTask == null) {
      _pedometerTask = Task("Pedometer Task")
        ..addMeasure(PeriodicMeasure(MeasureType(NameSpace.CARP, DataType.PEDOMETER),
            name: "Pedometer (Step Count)", frequency: 1 * 20 * 1000 // how often to collect step count
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
        ..addMeasure(PeriodicMeasure(
          MeasureType(NameSpace.CARP, DataType.ACCELEROMETER),
          name: "Accelerometer",
          frequency: 8 * 1000, // How often to start a measure
          duration: 20, // Window size
        ))
        ..addMeasure(PeriodicMeasure(MeasureType(NameSpace.CARP, DataType.GYROSCOPE),
            name: "Gyroscope",
            frequency: 9 * 1000, // How often to start a measure
            duration: 100 // Window size
            ))
        ..addMeasure(PeriodicMeasure(MeasureType(NameSpace.CARP, DataType.LIGHT),
                name: "Ambient Light",
                frequency: 11 * 1000, // How often to start a measure
                duration: 700) // Window size
            );
    }
    return _sensorTask;
  }
}
