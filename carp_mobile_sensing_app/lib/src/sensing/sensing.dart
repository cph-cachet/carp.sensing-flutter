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
    // right now the audio plugin throws an exception
    // see https://github.com/dooboolab/flutter_sound/issues/93
    // TODO - enable once issue is solved.
    //SamplingPackageRegistry.register(AudioSamplingPackage());

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

    // Create a Study Controller that can manage this study, initialize it, and start it.
    //controller = StudyController(study);
    //controller = StudyController(study, samplingSchema: aware); // a controller using the AWARE test schema
    controller = StudyController(study, samplingSchema: mCerebrum); // a controller using the AWARE test schema
    //controller = StudyController(study, privacySchemaName: PrivacySchema.DEFAULT); // a controller w. privacy
    await controller.initialize();
    controller.start();

    // listening on all data events from the study and print it (for debugging purpose).
    //controller.events.forEach(print);

    //ProbeRegistry.probes.forEach((key, probe) => probe.stateEvents.forEach(print));

    // listening on a specific probe
    //ProbeRegistry.probes[DataType.LOCATION].events.forEach(print);
  }

  /// Stop sensing.
  void stop() async {
    controller.stop();
    study = null;
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
      _study = Study('DF#4dD-aware', username)
        ..name = 'CARP Mobile Sensing - AWARE configuration'
        ..description = mCerebrum.description
        ..dataEndPoint = getDataEndpoint(DataEndPointType.FILE)
        ..addTriggerTask(
            ImmediateTrigger(), Task()..measures = mCerebrum.measures.values.toList()); // add all measures (for now)
    }
    return _study;
  }

  /// Return a [DataEndPoint] of the specified type.
  DataEndPoint getDataEndpoint(DataEndPointType type) {
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

}

SamplingSchema get aware => SamplingSchema()
  ..type = SamplingSchemaType.NORMAL
  ..name = 'AWARE equivalent sampling schema'
  ..description =
      'This Study is a technical evaluation of the CARP Mobile Sensing framework. It simulates the AWARE configuration in order to compare data sampling and battery drain.'
  ..powerAware = false
  ..measures.addEntries([
    MapEntry(
        SensorSamplingPackage.ACCELEROMETER,
        PeriodicMeasure(
          MeasureType(NameSpace.CARP, SensorSamplingPackage.ACCELEROMETER),
          name: "Accelerometer",
          frequency: 200, // How often to start a measure
          duration: 2, // Window size
        )),
    MapEntry(
        SensorSamplingPackage.GYROSCOPE,
        PeriodicMeasure(MeasureType(NameSpace.CARP, SensorSamplingPackage.GYROSCOPE),
            name: "Gyroscope",
            frequency: 200, // How often to start a measure
            duration: 2 // Window size
            )),
    MapEntry(
        SensorSamplingPackage.LIGHT,
        PeriodicMeasure(MeasureType(NameSpace.CARP, SensorSamplingPackage.LIGHT),
            name: "Ambient Light",
            frequency: 200, // How often to start a measure
            duration: 10 // Window size
            )),
    MapEntry(
        AppsSamplingPackage.APPS,
        PeriodicMeasure(
          MeasureType(NameSpace.CARP, AppsSamplingPackage.APPS),
          // collect list of installed apps once pr. day
          name: 'Installed Apps',
          frequency: 24 * 60 * 60 * 1000,
        )),
    MapEntry(
        AppsSamplingPackage.APP_USAGE,
        PeriodicMeasure(MeasureType(NameSpace.CARP, AppsSamplingPackage.APP_USAGE),
            // collect app usage every 10 min for the last 10 min
            name: 'Apps Usage',
            frequency: 10 * 60 * 1000,
            duration: 10 * 60 * 1000)),
    MapEntry(DeviceSamplingPackage.BATTERY,
        Measure(MeasureType(NameSpace.CARP, DeviceSamplingPackage.BATTERY), name: 'Battery')),
    MapEntry(DeviceSamplingPackage.SCREEN,
        Measure(MeasureType(NameSpace.CARP, DeviceSamplingPackage.SCREEN), name: 'Screen Activity (lock/on/off)')),
    MapEntry(
        ConnectivitySamplingPackage.BLUETOOTH,
        PeriodicMeasure(MeasureType(NameSpace.CARP, ConnectivitySamplingPackage.BLUETOOTH),
            name: 'Nearby Devices (Bluetooth Scan)', frequency: 60 * 1000, duration: 3 * 1000)),
    MapEntry(
        ConnectivitySamplingPackage.WIFI,
        PeriodicMeasure(MeasureType(NameSpace.CARP, ConnectivitySamplingPackage.WIFI),
            name: 'Wifi network names (SSID / BSSID)', frequency: 60 * 1000, duration: 5 * 1000)),
    MapEntry(
        CommunicationSamplingPackage.PHONE_LOG,
        PhoneLogMeasure(MeasureType(NameSpace.CARP, CommunicationSamplingPackage.PHONE_LOG),
            // collect phone log once pr. day
            name: 'Phone Log',
            //frequency: 60 * 1000,
            frequency: 1 * 24 * 60 * 60 * 1000,
            days: 2)),
    MapEntry(
        CommunicationSamplingPackage.TEXT_MESSAGE_LOG,
        PeriodicMeasure(
          MeasureType(NameSpace.CARP, CommunicationSamplingPackage.TEXT_MESSAGE_LOG),
          // collect text messages once pr. day
          name: 'Text Message (SMS) Log',
          frequency: 1 * 24 * 60 * 60 * 1000,
          //frequency: 60 * 1000
        )),
    MapEntry(CommunicationSamplingPackage.TEXT_MESSAGE,
        Measure(MeasureType(NameSpace.CARP, CommunicationSamplingPackage.TEXT_MESSAGE), name: 'Text Message (SMS)')),
    MapEntry(ContextSamplingPackage.LOCATION,
        Measure(MeasureType(NameSpace.CARP, ContextSamplingPackage.LOCATION), name: 'Location')),
    MapEntry(ContextSamplingPackage.ACTIVITY,
        Measure(MeasureType(NameSpace.CARP, ContextSamplingPackage.ACTIVITY), name: 'Activity Recognition')),
    MapEntry(
        ContextSamplingPackage.WEATHER,
        WeatherMeasure(MeasureType(NameSpace.CARP, ContextSamplingPackage.WEATHER),
            // collect local weather once pr. hour
            name: 'Local Weather',
            frequency: 60 * 60 * 1000,
            apiKey: '12b6e28582eb9298577c734a31ba9f4f')),
  ]);

SamplingSchema get mCerebrum => SamplingSchema()
  ..type = SamplingSchemaType.NORMAL
  ..name = 'mCerebrum and AWARE equivalent sampling schema - high frequency'
  ..description =
      'This Study is a technical evaluation of the CARP Mobile Sensing framework. It simulates the mCerebrum power test in the SenSys 2017 paper with high frequency (50Hz) data sampling.'
  ..powerAware = false
  ..measures.addEntries([
    MapEntry(
        SensorSamplingPackage.ACCELEROMETER,
        PeriodicMeasure(
          MeasureType(NameSpace.CARP, SensorSamplingPackage.ACCELEROMETER),
          name: "Accelerometer",
          frequency: 20, // How often to start a measure
          duration: 1, // Window size
        )),
    MapEntry(
        SensorSamplingPackage.GYROSCOPE,
        PeriodicMeasure(MeasureType(NameSpace.CARP, SensorSamplingPackage.GYROSCOPE),
            name: "Gyroscope",
            frequency: 20, // How often to start a measure
            duration: 1 // Window size
            )),
    MapEntry(
        SensorSamplingPackage.LIGHT,
        PeriodicMeasure(MeasureType(NameSpace.CARP, SensorSamplingPackage.LIGHT),
            name: "Ambient Light",
            frequency: 20, // How often to start a measure
            duration: 10 // Window size
            )),
    MapEntry(ContextSamplingPackage.LOCATION,
        Measure(MeasureType(NameSpace.CARP, ContextSamplingPackage.LOCATION), name: 'Location')),
  ]);
