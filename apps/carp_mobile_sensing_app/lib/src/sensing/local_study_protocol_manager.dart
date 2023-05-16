/*
 * Copyright 2019-2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of mobile_sensing_app;

/// This is a simple local [StudyProtocolManager].
///
/// This class shows how to configure a [SmartphoneStudyProtocol] with [Tigger]s,
/// [TaskDescriptor]s and [Measure]s.
class LocalStudyProtocolManager implements StudyProtocolManager {
  @override
  Future<void> initialize() async {}

  @override
  Future<SmartphoneStudyProtocol> getStudyProtocol(String protocolId) async {
    SmartphoneStudyProtocol protocol = SmartphoneStudyProtocol(
      ownerId: accountId,
      name: protocolId,
    );

    protocol.studyDescription = StudyDescription(
        title: 'CAMS App - Sensing Coverage Study',
        description:
            'The default study testing coverage of most measures. Used in the coverage tests.',
        purpose: 'To test sensing coverage',
        responsible: StudyResponsible(
          id: 'abc',
          title: 'professor',
          address: 'Ørsteds Plads',
          affiliation: 'Technical University of Denmark',
          email: 'abc@dtu.dk',
          name: 'Alex B. Christensen',
        ));

    protocol.dataEndPoint = (bloc.deploymentMode == DeploymentMode.local)
        ? SQLiteDataEndPoint()
        : CarpDataEndPoint(
            uploadMethod: CarpUploadMethod.stream,
          );

    // // TODO - for testing - remove later
    // protocol.dataEndPoint = CarpDataEndPoint(
    //   uploadMethod: CarpUploadMethod.datapoint,
    //   uri: uri,
    //   clientId: clientID,
    //   clientSecret: clientSecret,
    //   email: username,
    //   password: password,
    //   uploadInterval: 1,
    // );

    // set the format of the data to upload - e.g. Open mHealth
    protocol.dataEndPoint!.dataFormat = bloc.dataFormat;

    // always add a participant role to the protocol
    // protocol.participantRoles?.add(ParticipantRole('Participant', false));

    final father = 'Father';
    final mother = 'Mother';

    // add participant roles
    protocol.addParticipantRole(ParticipantRole(father));
    protocol.addParticipantRole(ParticipantRole(mother));

    // define the primary device(s)
    // Smartphone phone = Smartphone();
    // protocol.addPrimaryDevice(phone);

    Smartphone fatherPhone = Smartphone(roleName: "Father's Phone");
    protocol.addPrimaryDevice(fatherPhone);
    Smartphone motherPhone = Smartphone(roleName: "Mother's Phone");
    protocol.addPrimaryDevice(motherPhone);

    protocol.changeDeviceAssignment(
        fatherPhone, AssignedTo(roleNames: {father}));
    protocol.changeDeviceAssignment(
        motherPhone, AssignedTo(roleNames: {mother}));

    // build-in measure from sensor and device sampling packages
    protocol.addTaskControl(
        ImmediateTrigger(),
        BackgroundTask(measures: [
          Measure(type: SensorSamplingPackage.STEP_COUNT),
          Measure(type: SensorSamplingPackage.AMBIENT_LIGHT),
          Measure(type: DeviceSamplingPackage.SCREEN_EVENT),
          Measure(type: DeviceSamplingPackage.FREE_MEMORY),
          Measure(type: DeviceSamplingPackage.BATTERY_STATE),
        ]),
        fatherPhone);

    // a random trigger - 3-8 times during time period of 8-20
    protocol.addTaskControl(
        RandomRecurrentTrigger(
          startTime: TimeOfDay(hour: 8),
          endTime: TimeOfDay(hour: 20),
          minNumberOfTriggers: 3,
          maxNumberOfTriggers: 8,
        ),
        BackgroundTask()
          ..addMeasure(Measure(type: DeviceSamplingPackage.DEVICE_INFORMATION)),
        fatherPhone);

    // activity measure using the phone
    protocol.addTaskControl(
        ImmediateTrigger(),
        BackgroundTask()
          ..addMeasure(Measure(type: ContextSamplingPackage.ACTIVITY)),
        motherPhone);

    // Define the online location service and add it as a 'device'
    LocationService locationService = LocationService();
    protocol.addConnectedDevice(locationService, fatherPhone);
    protocol.addConnectedDevice(locationService, motherPhone);

    // Add a background task that collects location on a regular basis
    protocol.addTaskControl(
        PeriodicTrigger(period: Duration(minutes: 5)),
        BackgroundTask(measures: [
          Measure(type: ContextSamplingPackage.CURRENT_LOCATION),
        ]),
        locationService);

    // Add a background task that continuously collects location and mobility
    protocol.addTaskControl(
        ImmediateTrigger(),
        BackgroundTask(measures: [
          Measure(type: ContextSamplingPackage.LOCATION),
          Measure(type: ContextSamplingPackage.MOBILITY),
        ]),
        locationService);

    // Define the online weather service and add it as a 'device'
    WeatherService weatherService = WeatherService(apiKey: openWeatherApiKey);
    protocol.addConnectedDevice(weatherService, fatherPhone);

    // Add a background task that collects weather every 30 minutes.
    protocol.addTaskControl(
        PeriodicTrigger(period: Duration(minutes: 30)),
        BackgroundTask()
          ..addMeasure(Measure(type: ContextSamplingPackage.WEATHER)),
        weatherService);

    // Define the online air quality service and add it as a 'device'
    AirQualityService airQualityService =
        AirQualityService(apiKey: airQualityApiKey);
    protocol.addConnectedDevice(airQualityService, motherPhone);

    // Add a background task that air quality every 30 minutes.
    protocol.addTaskControl(
        PeriodicTrigger(period: Duration(minutes: 30)),
        BackgroundTask()
          ..addMeasure(Measure(type: ContextSamplingPackage.AIR_QUALITY)),
        airQualityService);

    protocol.addTaskControl(
        ImmediateTrigger(),
        BackgroundTask()..addMeasure(Measure(type: MediaSamplingPackage.NOISE)),
        motherPhone);

    protocol.addTaskControl(
        ImmediateTrigger(),
        BackgroundTask()
          ..addMeasures([
            Measure(type: ConnectivitySamplingPackage.CONNECTIVITY),
            Measure(type: ConnectivitySamplingPackage.WIFI),
            Measure(type: ConnectivitySamplingPackage.BLUETOOTH),
          ]),
        motherPhone);

    // // Add an automatic task that collects SMS messages in/out
    // protocol.addTaskControl(
    //     ImmediateTrigger(),
    //     AutomaticTask()
    //       ..addMeasures(SamplingPackageRegistry().common.getMeasureList(
    //         types: [
    //           CommunicationSamplingPackage.TEXT_MESSAGE,
    //         ],
    //       )),
    //     phone);

    // // Add an automatic task that collects the logs for:
    // //  * in/out SMS
    // //  * in/out phone calls
    // //  * calendar entries
    // protocol.addTaskControl(
    //     ImmediateTrigger(),
    //     AutomaticTask()
    //       ..addMeasures(SamplingPackageRegistry().common.getMeasureList(
    //         types: [
    //           CommunicationSamplingPackage.PHONE_LOG,
    //           CommunicationSamplingPackage.TEXT_MESSAGE_LOG,
    //           CommunicationSamplingPackage.CALENDAR,
    //         ],
    //       )),
    //     phone);

    // // Add an automatic task that collects the list of installed apps
    // // and a log of app usage activity
    // protocol.addTaskControl(
    //     PeriodicTrigger(
    //       period: const Duration(minutes: 1),
    //       duration: const Duration(seconds: 10),
    //     ),
    //     AutomaticTask()
    //       ..addMeasures(SamplingPackageRegistry().common.getMeasureList(
    //         types: [
    //           AppsSamplingPackage.APPS,
    //           AppsSamplingPackage.APP_USAGE,
    //         ],
    //       )),
    //     phone);

    // define the sSense device and add its measures
    ESenseDevice eSense = ESenseDevice(
      deviceName: 'eSense-0332',
      samplingRate: 10,
    );
    protocol.addConnectedDevice(eSense, motherPhone);

    protocol.addTaskControl(
        ImmediateTrigger(),
        BackgroundTask()
          ..addMeasure(Measure(type: ESenseSamplingPackage.ESENSE_BUTTON))
          ..addMeasure(Measure(type: ESenseSamplingPackage.ESENSE_SENSOR)),
        eSense);

    // define the Polar device and add its measures
    // PolarDevice polar = PolarDevice(
    //   identifier: 'B5FC172F',
    //   name: 'Polar H10 HR Monitor',
    //   polarDeviceType: PolarDeviceType.H10,
    //   roleName: 'Polar H10',
    // );
    PolarDevice polar = PolarDevice(
      identifier: 'B36B5B21',
      name: 'Polar PVS',
      polarDeviceType: PolarDeviceType.SENSE,
      roleName: 'polar-pvs-device',
    );

    protocol.addConnectedDevice(polar, fatherPhone);

    protocol.addTaskControl(
        ImmediateTrigger(),
        BackgroundTask()
          ..addMeasure(Measure(type: PolarSamplingPackage.HR))
          ..addMeasure(Measure(type: PolarSamplingPackage.ECG))
          ..addMeasure(Measure(type: PolarSamplingPackage.PPG))
          ..addMeasure(Measure(type: PolarSamplingPackage.PPI)),
        polar);

    // // add a measure for ECG monitoring using the Movisens device
    // protocol.addTaskControl(
    //   ImmediateTrigger(),
    //   AutomaticTask()
    //     ..addMeasure(MovisensMeasure(
    //       type: MovisensSamplingPackage.MOVISENS_NAMESPACE,
    //       name: 'Movisens ECG device',
    //       address: '88:6B:0F:CD:E7:F2',
    //       sensorLocation: SensorLocation.chest,
    //       gender: Gender.male,
    //       deviceName: 'Sensor 02655',
    //       height: 175,
    //       weight: 75,
    //       age: 25,
    //     )),
    //   movisens,
    // );

    // // add measures to collect data from Apple Health / Google Fit
    // protocol.addTaskControl(
    //     PeriodicTrigger(
    //       period: Duration(minutes: 60),
    //       duration: Duration(minutes: 10),
    //     ),
    //     AutomaticTask()
    //       ..addMeasures([
    //         HealthMeasure(
    //             type: HealthSamplingPackage.HEALTH,
    //             healthDataType: HealthDataType.BLOOD_GLUCOSE),
    //         HealthMeasure(
    //             type: HealthSamplingPackage.HEALTH,
    //             healthDataType: HealthDataType.STEPS)
    //       ]),
    //     phone);

    return protocol;
  }

  @override
  Future<bool> saveStudyProtocol(String studyId, StudyProtocol protocol) async {
    throw UnimplementedError();
  }
}
