part of mobile_sensing_app;

/// This class implements the sensing layer incl. setting up a [Study] with [Task]s and [Measure]s.
class Sensing {
  Study study;
  final String testStudyId = "iOS-testing-#2";

  StudyController controller;
  StudyManager mock = new StudyMock();

  /// the list of running - i.e. used - probes in this study.
  List<Probe> get runningProbes => (controller != null) ? controller.executor.probes : List();

  Sensing() : super() {
    // create/load and register external sampling packages
    SamplingPackageRegistry.register(ContextSamplingPackage());
    SamplingPackageRegistry.register(CommunicationSamplingPackage());
    SamplingPackageRegistry.register(AudioSamplingPackage());
    SamplingPackageRegistry.register(ESenseSamplingPackage());

    // create/load and register external data managers
    DataManagerRegistry.register(CarpDataManager());
    //DataManagerRegistry.register(FirebaseStorageDataManager());
    //DataManagerRegistry.register(FirebaseDatabaseDataManager());
  }

  /// Start sensing.
  Future<void> start() async {
    // Get the study.
    study = await mock.getStudy(testStudyId);

    // Create a Study Controller that can manage this study, initialize it, and start it.
    controller = StudyController(study);
    //controller = StudyController(study, samplingSchema: aware); // a controller using the AWARE test schema
    //controller = StudyController(study, privacySchemaName: PrivacySchema.DEFAULT); // a controller w. privacy
    await controller.initialize();

    controller.start();

    // listening on all data events from the study and print it (for debugging purpose).
    controller.events.forEach(print);

    //ProbeRegistry.probes.forEach((key, probe) => probe.stateEvents.forEach(print));

    // listening on a specific probe
    //ProbeRegistry.probes[DataType.LOCATION].events.forEach(print);

    // listening on data manager events
    // controller.dataManager.events.forEach(print);
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
  final String testStudyId = "2";

  String studyId;

  Future<void> initialize() {}

  Study _study;

  Future<Study> getStudy(String studyId) async {
    //return _getHighFrequencyStudy('DF#4dD-high-frequency');
    //return _getAllProbesAsAwareStudy('DF#4dD-aware-carp');
    //return _getAllMeasuresStudy(studyId);
    //return _getAllProbesAsAwareCarpUploadStudy();
    //return _getAudioStudy(studyId);
    //return _getESenseStudy(studyId);
    return _getTestingStudy(studyId);
  }

  Future<Study> _getTestingStudy(String studyId) async {
    if (_study == null) {
      _study = Study(studyId, username)
            ..name = 'Testing ...'
            ..description = 'This is a study for testing and debugging -- especially on iOS.'
            ..dataEndPoint = FileDataEndPoint(bufferSize: 500 * 1000, zip: false, encrypt: false)
            ..addTriggerTask(
                ImmediateTrigger(),
                Task()
                  ..measures = SamplingSchema.debug().getMeasureList(
                    namespace: NameSpace.CARP,
                    types: [
                      //SensorSamplingPackage.ACCELEROMETER,
                      //SensorSamplingPackage.GYROSCOPE,
                      SensorSamplingPackage.LIGHT,
                      SensorSamplingPackage.PEDOMETER,
                    ],
                  ))
//            ..addTriggerTask(
//                DelayedTrigger(delay: 10 * 1000),
//                Task()
//                  ..measures = SamplingSchema.debug().getMeasureList(
//                    namespace: NameSpace.CARP,
//                    types: [
//                      ConnectivitySamplingPackage.BLUETOOTH,
//                      ConnectivitySamplingPackage.WIFI,
//                      ConnectivitySamplingPackage.CONNECTIVITY,
//                    ],
//                  ))
//        ..addTriggerTask(
//            ImmediateTrigger(),
//            Task()
//              ..measures = SamplingSchema.debug().getMeasureList(
//                namespace: NameSpace.CARP,
//                types: [
//                  AppsSamplingPackage.APP_USAGE,
//                  AppsSamplingPackage.APPS,
//                ],
//              ))
//        ..addTriggerTask(
//            ImmediateTrigger(),
//            Task()
//              ..measures = SamplingSchema.debug().getMeasureList(
//                namespace: NameSpace.CARP,
//                types: [
//                  DeviceSamplingPackage.MEMORY,
//                  DeviceSamplingPackage.DEVICE,
//                  DeviceSamplingPackage.BATTERY,
//                  DeviceSamplingPackage.SCREEN,
//                ],
//              ))
//        ..addTriggerTask(
//            PeriodicTrigger(period: 2 * 60 * 1000),
//            Task()
//              ..measures = SamplingSchema.debug().getMeasureList(
//                namespace: NameSpace.CARP,
//                types: [
//                  ContextSamplingPackage.WEATHER,
//                ],
//              ))
            ..addTriggerTask(
                ImmediateTrigger(),
                Task()
                  ..measures = SamplingSchema.debug().getMeasureList(
                    namespace: NameSpace.CARP,
                    types: [
                      ContextSamplingPackage.LOCATION,
                      ContextSamplingPackage.ACTIVITY,
                      ContextSamplingPackage.GEOFENCE,
                    ],
                  ))
//            ..addTriggerTask(
//                ImmediateTrigger(),
//                Task()
//                  ..measures = SamplingSchema.debug().getMeasureList(
//                    namespace: NameSpace.CARP,
//                    types: [
//                      AudioSamplingPackage.NOISE,
//                    ],
//                  ))
            ..addTriggerTask(
                PeriodicTrigger(period: 1 * 53 * 1000, duration: 2 * 1000),
                Task('Audio')
                  ..measures
                      .add(Measure(MeasureType(NameSpace.CARP, AudioSamplingPackage.AUDIO), name: "Audio Recording")))
            ..addTriggerTask(
                ImmediateTrigger(),
                Task()
                  ..measures = SamplingSchema.debug().getMeasureList(
                    namespace: NameSpace.CARP,
                    types: [
                      CommunicationSamplingPackage.CALENDAR,
                      CommunicationSamplingPackage.TEXT_MESSAGE_LOG,
                      CommunicationSamplingPackage.TEXT_MESSAGE,
                      CommunicationSamplingPackage.PHONE_LOG,
                      CommunicationSamplingPackage.TELEPHONY,
                    ],
                  ))
            ..addTriggerTask(
                DelayedTrigger(delay: 10 * 1000),
                Task('eSense')
                  ..measures.add(ESenseMeasure(MeasureType(NameSpace.CARP, ESenseSamplingPackage.ESENSE_BUTTON),
                      name: 'eSense - Button', enabled: true, deviceName: 'eSense-0332'))
                  ..measures.add(ESenseMeasure(MeasureType(NameSpace.CARP, ESenseSamplingPackage.ESENSE_SENSOR),
                      name: 'eSense - Sensors', enabled: true, deviceName: 'eSense-0332', samplingRate: 10)))
          //
          ;
    }
    return _study;
  }

  Future<Study> _getESenseStudy(String studyId) async {
    if (_study == null) {
      _study = Study(studyId, username)
        ..name = 'CARP Mobile Sensing - eSense sampling demo'
        ..description =
            'This is a study designed to test the eSense earable computing platform together with CARP Mobile Sensing'
        ..dataEndPoint = getDataEndpoint(DataEndPointTypes.FILE)
//        ..addTriggerTask(
//            ImmediateTrigger(),
//            Task('eSense')
//              ..measures.add(ESenseMeasure(MeasureType(NameSpace.CARP, ESenseSamplingPackage.ESENSE_BUTTON),
//                  name: 'eSense - Button', enabled: true, deviceName: 'eSense-0332'))
//              ..measures.add(ESenseMeasure(MeasureType(NameSpace.CARP, ESenseSamplingPackage.ESENSE_SENSOR),
//                  name: 'eSense - Sensors', enabled: true, deviceName: 'eSense-0332', samplingRate: 10)))
//        ..addTriggerTask(
//            ImmediateTrigger(),
//            Task('Context')
//              ..measures = SamplingSchema.common().getMeasureList([
//                ContextSamplingPackage.LOCATION,
//                ContextSamplingPackage.ACTIVITY,
//                SensorSamplingPackage.PEDOMETER,
//              ], namespace: NameSpace.CARP))
//        ..addTriggerTask(
//            ImmediateTrigger(),
//            Task('Noise')
//              ..measures.add(NoiseMeasure(MeasureType(NameSpace.CARP, AudioSamplingPackage.NOISE),
//                  name: 'Ambient Noise', enabled: true, frequency: 37 * 1000, duration: 5 * 1000)))
//        // audio recording and noise is conflicting... can't run at the same time...
////            ..measures.add(AudioMeasure(MeasureType(NameSpace.CARP, AudioSamplingPackage.AUDIO),
////                name: "Audio", frequency: 1 * 53 * 1000, duration: 4 * 1000, studyId: studyId)))
//        ..addTriggerTask(
//            PeriodicTrigger(period: 1 * 60 * 1000, duration: 2000),
//            Task('Weather')
//              ..measures =
//                  SamplingSchema.common(namespace: NameSpace.CARP).getMeasureList([ContextSamplingPackage.WEATHER]))
//        ..addTriggerTask(
//            DelayedTrigger(delay: 10 * 1000),
//            Task('Bluetooth')
//              ..measures.add(PeriodicMeasure(MeasureType(NameSpace.CARP, ConnectivitySamplingPackage.BLUETOOTH),
//                  name: 'Nearby Devices (Bluetooth Scan)',
//                  enabled: true,
//                  frequency: 1 * 30 * 1000,
//                  duration: 2 * 1000)));
        ..addTriggerTask(
            ImmediateTrigger(),
            Task()
              ..measures = SamplingSchema.debug().getMeasureList(
                namespace: NameSpace.CARP,
                types: [
                  //ESenseSamplingPackage.ESENSE_BUTTON,
                  //ESenseSamplingPackage.ESENSE_SENSOR,
//                  AudioSamplingPackage.NOISE,
//                  ContextSamplingPackage.LOCATION,
//                  ContextSamplingPackage.ACTIVITY,
//                  ContextSamplingPackage.WEATHER,
                  ConnectivitySamplingPackage.BLUETOOTH,
                  //ConnectivitySamplingPackage.WIFI,
                ],
              ));

//            ..measures.add(ESenseMeasure(MeasureType(NameSpace.CARP, ESenseSamplingPackage.ESENSE_BUTTON),
//                name: 'eSense - Button', enabled: true, deviceName: 'eSense-0332'))
//            ..measures.add(ESenseMeasure(MeasureType(NameSpace.CARP, ESenseSamplingPackage.ESENSE_SENSOR),
//                name: 'eSense - Sensors', enabled: true, deviceName: 'eSense-0332', samplingRate: 10)),
//        );

//    ..measures = ESenseSamplingPackage().debug.measures.values.toList());
    }
    return _study;
  }

  Future<Study> _getAudioStudy(String studyId) async {
    if (_study == null) {
      _study = Study(studyId, username)
            ..name = 'CARP Mobile Sensing - audio measures'
            ..description = 'This is a study ...'
            ..dataEndPoint = getDataEndpoint(DataEndPointTypes.FILE)
//        ..addTriggerTask(
//            ImmediateTrigger(),
//            Task()
//              ..measures.add(AudioMeasure(MeasureType(NameSpace.CARP, AudioSamplingPackage.AUDIO),
//                  name: "Audio", frequency: 1 * 60 * 1000, duration: 4 * 1000, studyId: studyId)))
          ;
    }
    return _study;
  }

  Future<Study> _getAllMeasuresStudy(String studyId) async {
    if (_study == null) {
      _study = Study(studyId, username)
        ..name = 'CARP Mobile Sensing - all measures available'
        ..description = 'This is a study of with all possible measures available in CARP Mobile Sensing'
        ..dataEndPoint = getDataEndpoint(DataEndPointTypes.FILE)
        ..addTriggerTask(ImmediateTrigger(),
            Task()..measures = SamplingSchema.common(namespace: NameSpace.CARP).measures.values.toList());
    }
    return _study;
  }

  Future<Study> _getAllProbesAsAwareCarpUploadStudy() async {
    return await _getAllProbesAsAwareStudy(testStudyId)
      ..dataEndPoint = getDataEndpoint(DataEndPointTypes.CARP);
  }

  Future<Study> _getAllProbesAsAwareStudy(String studyId) async {
    if (_study == null) {
      _study = Study(studyId, username)
        ..name = 'CARP Mobile Sensing - long term sampling study configures like AWARE'
        ..description = aware.description
        ..dataEndPoint = getDataEndpoint(DataEndPointTypes.FILE)
        ..addTriggerTask(
            ImmediateTrigger(), Task()..measures = aware.measures.values.toList()) // add all measures (for now)
//        ..addTriggerTask(
//            PeriodicTrigger(period: 60 * 1000), // add periodic weather measure, once pr. min.
//            Task()..addMeasure(aware.measures[ContextSamplingPackage.WEATHER]))
        ..addTriggerTask(
            PeriodicTrigger(period: 60 * 1000), // add periodic app log measure, once pr. day
            Task()..addMeasure(aware.measures[AppsSamplingPackage.APPS]));
    }
    return _study;
  }

  Future<Study> _getHighFrequencyStudy(String studyId) async {
    if (_study == null) {
      _study = Study(studyId, username)
        ..name = 'CARP Mobile Sensing - high-frequency sampling study'
        ..description = mCerebrum.description
        ..dataEndPoint = getDataEndpoint(DataEndPointTypes.FILE)
        ..addTriggerTask(
            ImmediateTrigger(), Task()..measures = mCerebrum.measures.values.toList()); // add all measures (for now)
    }
    return _study;
  }

  /// Return a [DataEndPoint] of the specified type.
  DataEndPoint getDataEndpoint(String type) {
    assert(type != null);
    switch (type) {
      case DataEndPointTypes.PRINT:
        return new DataEndPoint(DataEndPointTypes.PRINT);
      case DataEndPointTypes.FILE:
        return FileDataEndPoint(bufferSize: 500 * 1000, zip: true, encrypt: false);
      case DataEndPointTypes.CARP:
        return CarpDataEndPoint(CarpUploadMethod.DATA_POINT,
            name: 'CARP Staging Server',
            uri: uri,
            clientId: clientID,
            clientSecret: clientSecret,
            email: username,
            password: password);
//        return CarpDataEndPoint(
//          CarpUploadMethod.BATCH_DATA_POINT,
//          name: 'CARP Staging Server',
//          uri: uri,
//          clientId: clientID,
//          clientSecret: clientSecret,
//          email: _study.userId,
//          password: password,
//          bufferSize: 500 * 1000,
//          zip: false,
//          deleteWhenUploaded: false,
//        );
//        return CarpDataEndPoint(
//          CarpUploadMethod.FILE,
//          name: 'CARP Staging Server',
//          uri: uri,
//          clientId: clientID,
//          clientSecret: clientSecret,
//          email: _study.userId,
//          password: password,
//          bufferSize: 500 * 1000,
//          zip: true,
//          deleteWhenUploaded: false,
//        );
//      case DataEndPointTypes.FIREBASE_STORAGE:
//        return FirebaseStorageDataEndPoint(firebaseEndPoint, path: 'sensing/data', bufferSize: 50 * 1000, zip: true);
//      case DataEndPointTypes.FIREBASE_DATABSE:
//        return FirebaseDatabaseDataEndPoint(firebaseEndPoint, collection: 'carp_data');
//      default:
        return new DataEndPoint(DataEndPointTypes.PRINT);
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
//          // remember to change this to the real pw before running, but remove again before committing to git
//          password: "mit_password");
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
          enabled: true,
          frequency: 200, // How often to start a measure
          duration: 2, // Window size
        )),
    MapEntry(
        SensorSamplingPackage.GYROSCOPE,
        PeriodicMeasure(MeasureType(NameSpace.CARP, SensorSamplingPackage.GYROSCOPE),
            name: "Gyroscope",
            enabled: true,
            frequency: 200, // How often to start a measure
            duration: 2 // Window size
            )),
    MapEntry(
        SensorSamplingPackage.LIGHT,
        PeriodicMeasure(MeasureType(NameSpace.CARP, SensorSamplingPackage.LIGHT),
            name: "Ambient Light",
            frequency: 60 * 1000, // How often to start a measure
            duration: 1000 // Window size
            )),
    MapEntry(
        AppsSamplingPackage.APPS,
        Measure(
          MeasureType(NameSpace.CARP, AppsSamplingPackage.APPS),
          name: 'Installed Apps',
        )),
    MapEntry(
        AppsSamplingPackage.APP_USAGE,
        AppUsageMeasure(MeasureType(NameSpace.CARP, AppsSamplingPackage.APP_USAGE),
            // collect app usage every 10 min for the last 10 min
            name: 'Apps Usage',
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
            name: 'Phone Log', days: 1)),
    MapEntry(
        CommunicationSamplingPackage.TEXT_MESSAGE_LOG,
        Measure(MeasureType(NameSpace.CARP, CommunicationSamplingPackage.TEXT_MESSAGE_LOG),
            name: 'Text Message (SMS) Log')),
    MapEntry(CommunicationSamplingPackage.TEXT_MESSAGE,
        Measure(MeasureType(NameSpace.CARP, CommunicationSamplingPackage.TEXT_MESSAGE), name: 'Text Message (SMS)')),
//    MapEntry(ContextSamplingPackage.LOCATION,
//        Measure(MeasureType(NameSpace.CARP, ContextSamplingPackage.LOCATION), name: 'Location')),
//    MapEntry(ContextSamplingPackage.ACTIVITY,
//        Measure(MeasureType(NameSpace.CARP, ContextSamplingPackage.ACTIVITY), name: 'Activity Recognition')),
//    MapEntry(
//        ContextSamplingPackage.WEATHER,
//        WeatherMeasure(MeasureType(NameSpace.CARP, ContextSamplingPackage.WEATHER),
//            name: 'Local Weather', apiKey: '12b6e28582eb9298577c734a31ba9f4f')),
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
          frequency: 200, // How often to start a measure
          duration: 1, // Window size
        )),
    MapEntry(
        SensorSamplingPackage.GYROSCOPE,
        PeriodicMeasure(MeasureType(NameSpace.CARP, SensorSamplingPackage.GYROSCOPE),
            name: "Gyroscope",
            frequency: 200, // How often to start a measure
            duration: 1 // Window size
            )),
    MapEntry(
        SensorSamplingPackage.LIGHT,
        PeriodicMeasure(MeasureType(NameSpace.CARP, SensorSamplingPackage.LIGHT),
            name: "Ambient Light",
            frequency: 200, // How often to start a measure
            duration: 2 // Window size
            )),
//    MapEntry(ContextSamplingPackage.LOCATION,
//        Measure(MeasureType(NameSpace.CARP, ContextSamplingPackage.LOCATION), name: 'Location')),
  ]);
