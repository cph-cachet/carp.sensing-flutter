part of mobile_sensing_app;

/// This class implements the sensing layer incl. setting up a [Study] with [Task]s and [Measure]s.
class Sensing {
  StudyController controller;

  /// the list of running - i.e. used - probes in this study.
  List<Probe> get runningProbes => (controller != null) ? controller.executor.probes : List();

  Sensing() : super() {
    // create/load and register external sampling packages
    //SamplingPackageRegistry.register(ConnectivitySamplingPackage());
    SamplingPackageRegistry.register(ContextSamplingPackage());
    SamplingPackageRegistry.register(CommunicationSamplingPackage());
    SamplingPackageRegistry.register(AudioSamplingPackage());
    //SamplingPackageRegistry.register(ESenseSamplingPackage());
    SamplingPackageRegistry.register(SurveySamplingPackage());
    SamplingPackageRegistry.register(HealthSamplingPackage());

    // create/load and register external data managers
    DataManagerRegistry.register(CarpDataManager());
//    DataManagerRegistry.register(FirebaseStorageDataManager());
//    DataManagerRegistry.register(FirebaseDatabaseDataManager());
  }

  /// Initialize and setup sensing.
  Future<void> init() async {
    // Create a Study Controller that can manage this study, initialize it, and start it.
    controller = StudyController(bloc.study, debugLevel: DebugLevel.DEBUG);
    //controller = StudyController(study, samplingSchema: aware); // a controller using the AWARE test schema
    //controller = StudyController(study, privacySchemaName: PrivacySchema.DEFAULT); // a controller w. privacy
    await controller.initialize();

    // listening on all data events from the study and print it (for debugging purpose).
    controller.events.forEach(print);

    // listening on a specific probe
    //ProbeRegistry.probes[DataType.LOCATION].events.forEach(print);

    // listening on data manager events
    // controller.dataManager.events.forEach(print);
  }

  /// Stop sensing.
  void stop() async {
    controller.stop();
  }
}

/// A [StudyManager] that can create [Study] locally on this phone.
class LocalStudyManager implements StudyManager {
  Future<void> initialize() {}

  Study _study;

  Future<Study> getStudy(String studyId) async {
    return _getTestingStudy(studyId);

    //return _getConditionalSamplingStudy(studyId);
    //return _getSurveyStudy(studyId);
    //return _getHealthStudy('#6-health');
    //return _getCoverageStudy('#5-coverage');
    //return _getHighFrequencyStudy('DF#4dD-high-frequency');
    //return _getAllProbesAsAwareStudy('#4-aware-carp');
    //return _getAllMeasuresStudy(studyId);
    //return _getAllProbesAsAwareCarpUploadStudy();
    //return _getAudioStudy(studyId);
    //return _getESenseStudy(studyId);
  }

  Future<Study> _getTestingStudy(String studyId) async {
    if (_study == null) {
      _study = Study(studyId, bloc.username)
            ..name = bloc.testStudyName
            ..description = 'This is a study for testing and debugging -- especially on iOS.'
            ..dataEndPoint = getDataEndpoint(DataEndPointTypes.CARP)
//            ..addTriggerTask(
//                ImmediateTrigger(),
//                Task()
//                  ..measures = SamplingSchema.debug().getMeasureList(
//                    namespace: NameSpace.CARP,
//                    types: [
//                      //SensorSamplingPackage.ACCELEROMETER,
//                      //SensorSamplingPackage.GYROSCOPE,
//                      SensorSamplingPackage.LIGHT,
//                      SensorSamplingPackage.PEDOMETER,
//                    ],
//                  ))
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
            ..addTriggerTask(
                PeriodicTrigger(period: Duration(seconds: 20)),
                Task()
                  ..measures = SamplingSchema.debug().getMeasureList(
                    namespace: NameSpace.CARP,
                    types: [
                      AppsSamplingPackage.APP_USAGE,
                      AppsSamplingPackage.APPS,
                    ],
                  ))
            ..addTriggerTask(
                ImmediateTrigger(),
                AutomaticTask()
                  ..measures = SamplingSchema.debug().getMeasureList(
                    namespace: NameSpace.CARP,
                    types: [
                      DeviceSamplingPackage.MEMORY,
                      DeviceSamplingPackage.DEVICE,
                      DeviceSamplingPackage.BATTERY,
                      DeviceSamplingPackage.SCREEN,
                    ],
                  ))
//            ..addTriggerTask(
//                PeriodicTrigger(period: Duration(seconds: 20)),
//                AutomaticTask()
//                  ..measures = SamplingSchema.debug().getMeasureList(
//                    namespace: NameSpace.CARP,
//                    types: [
//                      ContextSamplingPackage.LOCATION,
//                      ContextSamplingPackage.WEATHER,
//                      //ContextSamplingPackage.AIR_QUALITY,
//                    ],
//                  ))
//            ..addTriggerTask(
//                ImmediateTrigger(),
//                AutomaticTask()
//                  ..measures = SamplingSchema.debug().getMeasureList(
//                    namespace: NameSpace.CARP,
//                    types: [
//                      //ContextSamplingPackage.LOCATION,
//                      ContextSamplingPackage.GEOLOCATION,
//                      //ContextSamplingPackage.ACTIVITY,
//                      //ContextSamplingPackage.GEOFENCE,
//                    ],
//                  ))
//            ..addTriggerTask(
//                DelayedTrigger(delay: 30 * 1000),
//                Task('WHO-5 Survey')
//                  ..measures = SamplingSchema.debug().getMeasureList(
//                    namespace: NameSpace.CARP,
//                    types: [
//                      SurveySamplingPackage.SURVEY,
//                    ],
//                  ))
//            ..addTriggerTask(
//                ImmediateTrigger(),
//                AutomaticTask()
//                  ..measures = SamplingSchema.debug().getMeasureList(
//                    namespace: NameSpace.CARP,
//                    types: [
//                      AudioSamplingPackage.NOISE,
//                    ],
//                  ))
//            ..addTriggerTask(
//                PeriodicTrigger(period: Duration(seconds: 20), duration: Duration(seconds: 2)),
//                AutomaticTask()
//                  ..measures.add(AudioMeasure(
//                    MeasureType(NameSpace.CARP, AudioSamplingPackage.AUDIO),
//                    name: "Audio Recording",
//                    studyId: studyId,
//                  )))
//            ..addTriggerTask(
//                ImmediateTrigger(),
//                AutomaticTask()
//                  ..measures = SamplingSchema.debug().getMeasureList(
//                    namespace: NameSpace.CARP,
//                    types: [
//                      CommunicationSamplingPackage.CALENDAR,
//                      CommunicationSamplingPackage.TEXT_MESSAGE_LOG,
//                      CommunicationSamplingPackage.TEXT_MESSAGE,
//                      CommunicationSamplingPackage.PHONE_LOG,
//                      CommunicationSamplingPackage.TELEPHONY,
//                    ],
//                  ))
//            ..addTriggerTask(
//                DelayedTrigger(delay: 10 * 1000),
//                Task('eSense')
//                  ..measures.add(ESenseMeasure(MeasureType(NameSpace.CARP, ESenseSamplingPackage.ESENSE_BUTTON),
//                      name: 'eSense - Button', enabled: true, deviceName: 'eSense-0332'))
//                  ..measures.add(ESenseMeasure(MeasureType(NameSpace.CARP, ESenseSamplingPackage.ESENSE_SENSOR),
//                      name: 'eSense - Sensors', enabled: true, deviceName: 'eSense-0332', samplingRate: 10)))
          //
          ;
    }
    return _study;
  }

  Future<Study> _getConditionalSamplingStudy(String studyId) async {
    if (_study == null) {
      _study = Study(studyId, bloc.username)
            ..name = 'Conditional Sampling Study'
            ..description = 'This is a study for testing and debugging Conditional Sampling'
            ..dataEndPoint = getDataEndpoint(DataEndPointTypes.FILE)
            ..addTriggerTask(
                ConditionalSamplingEventTrigger(
                    measureType: MeasureType(NameSpace.CARP, ContextSamplingPackage.LOCATION),
                    resumeCondition: (datum) {
                      return true;
                    },
                    pauseCondition: (datum) {
                      return true;
                    }),
                AutomaticTask()
                  ..measures = SamplingSchema.debug().getMeasureList(
                    namespace: NameSpace.CARP,
                    types: [
                      ContextSamplingPackage.WEATHER,
                      //ContextSamplingPackage.AIR_QUALITY,
                    ],
                  ))
            ..addTriggerTask(
                PeriodicTrigger(period: Duration(seconds: 20), duration: Duration(seconds: 2)),
                //ImmediateTrigger(),
                AutomaticTask()
                  ..measures = SamplingSchema.debug().getMeasureList(
                    namespace: NameSpace.CARP,
                    types: [
                      ContextSamplingPackage.LOCATION,
                      //ContextSamplingPackage.GEOLOCATION,
                    ],
                  ))
          //
          ;
    }
    return _study;
  }

  Future<Study> _getSurveyStudy(String studyId) async {
    if (_study == null) {
      _study = Study(studyId, bloc.username)
            ..name = bloc.testStudyName
            ..description = 'This is a study for testing and debugging -- especially on iOS.'
            ..dataEndPoint = getDataEndpoint(DataEndPointTypes.FILE)
            ..addTriggerTask(
                PeriodicTrigger(period: Duration(seconds: 20)),
                AutomaticTask()
                  ..measures = SamplingSchema.debug().getMeasureList(
                    namespace: NameSpace.CARP,
                    types: [
                      ContextSamplingPackage.WEATHER,
                      ContextSamplingPackage.AIR_QUALITY,
                    ],
                  ))
            ..addTriggerTask(
                ImmediateTrigger(),
                AutomaticTask()
                  ..measures = SamplingSchema.debug().getMeasureList(
                    namespace: NameSpace.CARP,
                    types: [
                      ContextSamplingPackage.LOCATION,
                      ContextSamplingPackage.GEOLOCATION,
                      //ContextSamplingPackage.ACTIVITY,
                      ContextSamplingPackage.GEOFENCE,
                    ],
                  ))
            ..addTriggerTask(
                DelayedTrigger(delay: Duration(seconds: 30)),
                AutomaticTask()
                  ..measures.add(RPTaskMeasure(
                    MeasureType(NameSpace.CARP, SurveySamplingPackage.SURVEY),
                    name: 'WHO5',
                    enabled: true,
                    surveyTask: who5Task,
                  )))
          //
          ;
    }
    return _study;
  }

  Future<Study> _getHealthStudy(String studyId) async {
    if (_study == null) {
      _study = Study(studyId, bloc.username)
            ..name = studyId
            ..description = 'This is a study for testing the HEALTH Package...'
            ..dataEndPoint = getDataEndpoint(DataEndPointTypes.FILE)
//            ..addTriggerTask(
//                ImmediateTrigger(),
//                AutomaticTask()
//                  ..measures = SamplingSchema.debug().getMeasureList(
//                    namespace: NameSpace.CARP,
//                    types: [
//                      SensorSamplingPackage.LIGHT, // 60 s
//                      //ConnectivitySamplingPackage.BLUETOOTH, // 60 s
//                      //ConnectivitySamplingPackage.WIFI, // 60 s
//                      DeviceSamplingPackage.MEMORY, // 60 s
//                      ContextSamplingPackage.LOCATION, // 30 s
//                      //AudioSamplingPackage.NOISE, // 60 s
//                    ],
//                  ))
            ..addTriggerTask(
                PeriodicTrigger(period: Duration(seconds: 20)),
                AutomaticTask()
                  ..measures = SamplingSchema.debug().getMeasureList(
                    namespace: NameSpace.CARP,
                    types: [
                      ContextSamplingPackage.WEATHER,
                      ContextSamplingPackage.AIR_QUALITY,
                    ],
                  ))
            ..addTriggerTask(
                PeriodicTrigger(period: Duration(minutes: 5)), // 5 min
                AutomaticTask()
                  ..measures = SamplingSchema.debug().getMeasureList(
                    namespace: NameSpace.CARP,
                    types: [
                      AppsSamplingPackage.APP_USAGE, // 60 s
                    ],
                  ))
            ..addTriggerTask(
                //PeriodicTrigger(period: Duration(seconds: 5)),
                DelayedTrigger(delay: Duration(seconds: 5)),
                AutomaticTask()
                  ..measures = SamplingSchema.debug().getMeasureList(
                    namespace: NameSpace.CARP,
                    types: [
                      HealthSamplingPackage.HEALTH,
                    ],
                  ))
          //
          ;
    }
    return _study;
  }

  Future<Study> _getCoverageStudy(String studyId) async {
    if (_study == null) {
      _study = Study(studyId, bloc.username)
            ..name = studyId
            ..description = 'This is a study for testing the coverage of sampling.'
            ..dataEndPoint = getDataEndpoint(DataEndPointTypes.FILE)
            ..addTriggerTask(
                ImmediateTrigger(),
                AutomaticTask()
                  ..measures = SamplingSchema.debug().getMeasureList(
                    namespace: NameSpace.CARP,
                    types: [
                      SensorSamplingPackage.LIGHT, // 60 s
                      //ConnectivitySamplingPackage.BLUETOOTH, // 60 s
                      //ConnectivitySamplingPackage.WIFI, // 60 s
                      DeviceSamplingPackage.MEMORY, // 60 s
                      ContextSamplingPackage.LOCATION, // 30 s
                      AudioSamplingPackage.NOISE, // 60 s
                    ],
                  ))
            ..addTriggerTask(
                PeriodicTrigger(period: Duration(minutes: 5)), // 5 min
                AutomaticTask()
                  ..measures = SamplingSchema.debug().getMeasureList(
                    namespace: NameSpace.CARP,
                    types: [
                      AppsSamplingPackage.APP_USAGE, // 60 s
                    ],
                  ))
            ..addTriggerTask(
                PeriodicTrigger(period: Duration(minutes: 10)), // 10 min
                AutomaticTask()
                  ..measures = SamplingSchema.debug().getMeasureList(
                    namespace: NameSpace.CARP,
                    types: [
                      ContextSamplingPackage.WEATHER,
                      ContextSamplingPackage.AIR_QUALITY,
                    ],
                  ))
          //
          ;
    }
    return _study;
  }

  Future<Study> _getESenseStudy(String studyId) async {
    if (_study == null) {
      _study = Study(studyId, bloc.username)
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
//            AutomaticTask'Weather')
//              ..measures =
//                  SamplingSchema.common(namespace: NameSpace.CARP).getMeasureList([ContextSamplingPackage.WEATHER]))
//        ..addTriggerTask(
//            DelayedTrigger(delay: 10 * 1000),
//            AutomaticTask'Bluetooth')
//              ..measures.add(PeriodicMeasure(MeasureType(NameSpace.CARP, ConnectivitySamplingPackage.BLUETOOTH),
//                  name: 'Nearby Devices (Bluetooth Scan)',
//                  enabled: true,
//                  frequency: 1 * 30 * 1000,
//                  duration: 2 * 1000)));
            ..addTriggerTask(
                PeriodicTrigger(period: Duration(minutes: 2)),
                AutomaticTask()
                  ..measures = SamplingSchema.debug().getMeasureList(
                    namespace: NameSpace.CARP,
                    types: [
                      ContextSamplingPackage.WEATHER,
                    ],
                  ))
            ..addTriggerTask(
                ImmediateTrigger(),
                AutomaticTask()
                  ..measures = SamplingSchema.debug().getMeasureList(
                    namespace: NameSpace.CARP,
                    types: [
                      ContextSamplingPackage.LOCATION,
                      ContextSamplingPackage.ACTIVITY,
                      ContextSamplingPackage.GEOFENCE,
                    ],
                  ))
            ..addTriggerTask(
                ImmediateTrigger(),
                AutomaticTask()
                  ..measures = SamplingSchema.debug().getMeasureList(
                    namespace: NameSpace.CARP,
                    types: [
                      AudioSamplingPackage.NOISE,
                      //ConnectivitySamplingPackage.BLUETOOTH,
                      //ConnectivitySamplingPackage.WIFI,
                    ],
                  ))
//            ..addTriggerTask(
//                DelayedTrigger(delay: 10 * 1000),
//                AutomaticTask'eSense')
//                  ..measures.add(ESenseMeasure(MeasureType(NameSpace.CARP, ESenseSamplingPackage.ESENSE_BUTTON),
//                      name: 'eSense - Button', enabled: true, deviceName: 'eSense-0332'))
//                  ..measures.add(ESenseMeasure(MeasureType(NameSpace.CARP, ESenseSamplingPackage.ESENSE_SENSOR),
//                      name: 'eSense - Sensors', enabled: true, deviceName: 'eSense-0332', samplingRate: 10)))
          //
          ;
    }
    return _study;
  }

  Future<Study> _getAudioStudy(String studyId) async {
    if (_study == null) {
      _study = Study(studyId, bloc.username)
            ..name = 'CARP Mobile Sensing - audio measures'
            ..description = 'This is a study ...'
            ..dataEndPoint = getDataEndpoint(DataEndPointTypes.FILE)
//        ..addTriggerTask(
//            ImmediateTrigger(),
//            AutomaticTask)
//              ..measures.add(AudioMeasure(MeasureType(NameSpace.CARP, AudioSamplingPackage.AUDIO),
//                  name: "Audio", frequency: 1 * 60 * 1000, duration: 4 * 1000, studyId: studyId)))
          ;
    }
    return _study;
  }

  Future<Study> _getAllMeasuresStudy(String studyId) async {
    if (_study == null) {
      _study = Study(studyId, bloc.username)
        ..name = 'CARP Mobile Sensing - all measures available'
        ..description = 'This is a study of with all possible measures available in CARP Mobile Sensing'
        ..dataEndPoint = getDataEndpoint(DataEndPointTypes.FILE)
        ..addTriggerTask(ImmediateTrigger(),
            AutomaticTask()..measures = SamplingSchema.common(namespace: NameSpace.CARP).measures.values.toList());
    }
    return _study;
  }

  Future<Study> _getAllProbesAsAwareCarpUploadStudy(String studyId) async {
    return await _getAllProbesAsAwareStudy(studyId)
      ..dataEndPoint = getDataEndpoint(DataEndPointTypes.CARP);
  }

  Future<Study> _getAllProbesAsAwareStudy(String studyId) async {
    if (_study == null) {
      _study = Study(studyId, bloc.username)
        ..name = 'CARP Mobile Sensing - long term sampling study configures like AWARE'
        ..description = aware.description
        ..dataEndPoint = getDataEndpoint(DataEndPointTypes.FILE)
        ..addTriggerTask(ImmediateTrigger(),
            AutomaticTask()..measures = aware.measures.values.toList()) // add all measures (for now)
        ..addTriggerTask(
            DelayedTrigger(delay: Duration(seconds: 10)),
            AutomaticTask()
              ..measures = SamplingSchema.debug().getMeasureList(
                namespace: NameSpace.CARP,
                types: [
                  //ConnectivitySamplingPackage.BLUETOOTH,
                  //ConnectivitySamplingPackage.WIFI,
                  //ConnectivitySamplingPackage.CONNECTIVITY,
                ],
              ))
        ..addTriggerTask(
            PeriodicTrigger(period: Duration(minutes: 60)),
            AutomaticTask()
              ..measures = SamplingSchema.debug().getMeasureList(
                namespace: NameSpace.CARP,
                types: [
                  ContextSamplingPackage.WEATHER,
                ],
              ));
    }
    return _study;
  }

  Future<Study> _getHighFrequencyStudy(String studyId) async {
    if (_study == null) {
      _study = Study(studyId, bloc.username)
        ..name = 'CARP Mobile Sensing - high-frequency sampling study'
        ..description = mCerebrum.description
        ..dataEndPoint = getDataEndpoint(DataEndPointTypes.FILE)
        ..addTriggerTask(ImmediateTrigger(),
            AutomaticTask()..measures = mCerebrum.measures.values.toList()); // add all measures (for now)
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
        return FileDataEndPoint(bufferSize: 50 * 1000, zip: true, encrypt: false);
      case DataEndPointTypes.CARP:
        return CarpDataEndPoint(
          CarpUploadMethod.DATA_POINT,
          name: 'CANS Testing Server',
          //uri: bloc.uri,
          //clientId: bloc.clientID,
          //clientSecret: bloc.clientSecret,
          //email: bloc.username,
          //password: bloc.password
        );
//        return CarpDataEndPoint(
//          CarpUploadMethod.BATCH_DATA_POINT,
//          name: 'CARP Staging Server',
//          uri: uri,
//          clientId: clientID,
//          clientSecret: clientSecret,
//          email: username,
//          password: password,
//          bufferSize: 40 * 1000,
//          zip: false,
//          deleteWhenUploaded: false,
//        );
//        return CarpDataEndPoint(
//          CarpUploadMethod.FILE,
//          name: 'CARP Staging Server',
//          uri: uri,
//          clientId: clientID,
//          clientSecret: clientSecret,
//          email: username,
//          password: password,
//          bufferSize: 20 * 1000,
//          zip: true,
//          deleteWhenUploaded: false,
//        );
//      case DataEndPointTypes.FIREBASE_STORAGE:
//        return FirebaseStorageDataEndPoint(firebaseEndPoint, path: 'sensing/data', bufferSize: 50 * 1000, zip: true);
//      case DataEndPointTypes.FIREBASE_DATABSE:
//        return FirebaseDatabaseDataEndPoint(firebaseEndPoint, collection: 'carp_data');
      default:
        return new DataEndPoint(DataEndPointTypes.PRINT);
    }
  }

//  FirebaseEndPoint _firebaseEndPoint;
//  FirebaseEndPoint get firebaseEndPoint {
//    if (_firebaseEndPoint == null) {
//      _firebaseEndPoint = new FirebaseEndPoint(
//        name: "Flutter Sensing Sandbox",
//        uri: 'gs://flutter-sensing-sandbox.appspot.com',
//        projectID: 'flutter-sensing-sandbox',
//        webAPIKey: 'AIzaSyCGy6MeHkiv5XkBtMcMbtgGYOpf6ntNVE4',
//        gcmSenderID: '201621881872',
//        androidGoogleAppID: '1:201621881872:android:8e84e7ccfc85e121',
//        iOSGoogleAppID: '1:159623150305:ios:4a213ef3dbd8997b',
//        firebaseAuthenticationMethod: FireBaseAuthenticationMethods.GOOGLE,
//        //email: "jakob@bardram.net",
//        // remember to change this to the real pw before running, but remove again before committing to git
//        //password: "QAfflkfh23",
//      );
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
          frequency: Duration(milliseconds: 200), // How often to start a measure
          duration: Duration(milliseconds: 2), // Window size
        )),
    MapEntry(
        SensorSamplingPackage.GYROSCOPE,
        PeriodicMeasure(
          MeasureType(NameSpace.CARP, SensorSamplingPackage.GYROSCOPE),
          name: "Gyroscope",
          enabled: true,
          frequency: Duration(milliseconds: 200), // How often to start a measure
          duration: Duration(milliseconds: 2), // Window size
        )),
    MapEntry(
        SensorSamplingPackage.LIGHT,
        PeriodicMeasure(
          MeasureType(NameSpace.CARP, SensorSamplingPackage.LIGHT),
          name: "Ambient Light",
          frequency: Duration(seconds: 60), // How often to start a measure
          duration: Duration(seconds: 1), // Window size
        )),
    MapEntry(
        AppsSamplingPackage.APPS,
        Measure(
          MeasureType(NameSpace.CARP, AppsSamplingPackage.APPS),
          name: 'Installed Apps',
        )),
    MapEntry(AppsSamplingPackage.APP_USAGE,
        MarkedMeasure(MeasureType(NameSpace.CARP, AppsSamplingPackage.APP_USAGE), name: 'App Usage')),
    MapEntry(DeviceSamplingPackage.BATTERY,
        Measure(MeasureType(NameSpace.CARP, DeviceSamplingPackage.BATTERY), name: 'Battery')),
    MapEntry(DeviceSamplingPackage.SCREEN,
        Measure(MeasureType(NameSpace.CARP, DeviceSamplingPackage.SCREEN), name: 'Screen Activity (lock/on/off)')),
//    MapEntry(
//        ConnectivitySamplingPackage.BLUETOOTH,
//        PeriodicMeasure(MeasureType(NameSpace.CARP, ConnectivitySamplingPackage.BLUETOOTH),
//            name: 'Nearby Devices (Bluetooth Scan)', frequency: 60 * 1000, duration: 3 * 1000)),
//    MapEntry(
//        ConnectivitySamplingPackage.WIFI,
//        PeriodicMeasure(MeasureType(NameSpace.CARP, ConnectivitySamplingPackage.WIFI),
//            name: 'Wifi network names (SSID / BSSID)', frequency: 60 * 1000, duration: 5 * 1000)),
    MapEntry(CommunicationSamplingPackage.PHONE_LOG,
        MarkedMeasure(MeasureType(NameSpace.CARP, CommunicationSamplingPackage.PHONE_LOG), name: 'Phone Log')),
    MapEntry(
        CommunicationSamplingPackage.TEXT_MESSAGE_LOG,
        Measure(MeasureType(NameSpace.CARP, CommunicationSamplingPackage.TEXT_MESSAGE_LOG),
            name: 'Text Message (SMS) Log')),
    MapEntry(CommunicationSamplingPackage.TEXT_MESSAGE,
        Measure(MeasureType(NameSpace.CARP, CommunicationSamplingPackage.TEXT_MESSAGE), name: 'Text Message (SMS)')),
    MapEntry(
        ContextSamplingPackage.LOCATION,
        LocationMeasure(MeasureType(NameSpace.CARP, ContextSamplingPackage.LOCATION),
            name: 'Location', enabled: true, frequency: Duration(seconds: 30))),
    MapEntry(ContextSamplingPackage.ACTIVITY,
        Measure(MeasureType(NameSpace.CARP, ContextSamplingPackage.ACTIVITY), name: 'Activity Recognition')),
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
          frequency: Duration(milliseconds: 200), // How often to start a measure
          duration: Duration(milliseconds: 2), // Window size
        )),
    MapEntry(
        SensorSamplingPackage.GYROSCOPE,
        PeriodicMeasure(
          MeasureType(NameSpace.CARP, SensorSamplingPackage.GYROSCOPE),
          name: "Gyroscope",
          frequency: Duration(milliseconds: 200), // How often to start a measure
          duration: Duration(milliseconds: 2), // Window size
        )),
    MapEntry(
        SensorSamplingPackage.LIGHT,
        PeriodicMeasure(
          MeasureType(NameSpace.CARP, SensorSamplingPackage.LIGHT),
          name: "Ambient Light",
          frequency: Duration(milliseconds: 200), // How often to start a measure
          duration: Duration(milliseconds: 2), // Window size
        )),
//    MapEntry(ContextSamplingPackage.LOCATION,
//        Measure(MeasureType(NameSpace.CARP, ContextSamplingPackage.LOCATION), name: 'Location')),
  ]);
