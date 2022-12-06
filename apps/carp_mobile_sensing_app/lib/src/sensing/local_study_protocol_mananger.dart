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
      ownerId: 'abc@dtu.dk',
      name: protocolId,
    );

    protocol.protocolDescription = StudyDescription(
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

    protocol.dataEndPoint = (bloc.deploymentMode == DeploymentMode.LOCAL)
        ? SQLiteDataEndPoint()
        : CarpDataEndPoint(
            uploadMethod: CarpUploadMethod.DATA_POINT,
            name: 'CARP Server',
          );

    // set the format of the data to upload - e.g. Open mHealth
    protocol.dataEndPoint!.dataFormat = bloc.dataFormat;

    // define the master device
    Smartphone phone = Smartphone();
    protocol.addMasterDevice(phone);

    Measure bluetoothMeasure =
        Measure(type: ConnectivitySamplingPackage.BLUETOOTH);
    bluetoothMeasure.overrideSamplingConfiguration =
        PeriodicSamplingConfiguration(
      interval: const Duration(seconds: 20),
      duration: const Duration(seconds: 5),
    );

    protocol.addTriggeredTask(ImmediateTrigger(),
        BackgroundTask()..addMeasure(bluetoothMeasure), phone);

    Measure wifiMeasure = Measure(type: ConnectivitySamplingPackage.WIFI);
    wifiMeasure.overrideSamplingConfiguration =
        IntervalSamplingConfiguration(interval: Duration(seconds: 10));

    protocol.addTriggeredTask(
        ImmediateTrigger(), BackgroundTask()..addMeasure(wifiMeasure), phone);

    // // build-in measure from sensor and device sampling packages
    // protocol.addTriggeredTask(
    //     ImmediateTrigger(),
    //     BackgroundTask()
    //       ..addMeasures([
    //         Measure(type: SensorSamplingPackage.PEDOMETER),
    //         Measure(type: SensorSamplingPackage.LIGHT),
    //         Measure(type: DeviceSamplingPackage.SCREEN),
    //         Measure(type: DeviceSamplingPackage.MEMORY),
    //         Measure(type: DeviceSamplingPackage.BATTERY),
    //       ]),
    //     phone);

    // // a random trigger - 3-8 times during time period of 8-20
    // protocol.addTriggeredTask(
    //     RandomRecurrentTrigger(
    //       startTime: TimeOfDay(hour: 8),
    //       endTime: TimeOfDay(hour: 20),
    //       minNumberOfTriggers: 3,
    //       maxNumberOfTriggers: 8,
    //     ),
    //     BackgroundTask()
    //       ..addMeasure(Measure(type: DeviceSamplingPackage.DEVICE)),
    //     phone);

    // // activity measure using the phone
    // protocol.addTriggeredTask(
    //     ImmediateTrigger(),
    //     BackgroundTask()
    //       ..addMeasure(Measure(type: ContextSamplingPackage.ACTIVITY)),
    //     phone);

    // // Define the online location service and add it as a 'device'
    // LocationService locationService = LocationService();
    // protocol.addConnectedDevice(locationService);

    // // Add a background task that collects location on a regular basis
    // protocol.addTriggeredTask(
    //     IntervalTrigger(period: Duration(minutes: 5)),
    //     BackgroundTask()
    //       ..addMeasure(Measure(type: ContextSamplingPackage.LOCATION)),
    //     locationService);

    // // Add a background task that continously collects geolocation and mobility
    // protocol.addTriggeredTask(
    //     ImmediateTrigger(),
    //     BackgroundTask()
    //       ..addMeasure(Measure(type: ContextSamplingPackage.GEOLOCATION))
    //       ..addMeasure(Measure(type: ContextSamplingPackage.MOBILITY)),
    //     locationService);

    // // Define the online weather service and add it as a 'device'
    // WeatherService weatherService =
    //     WeatherService(apiKey: '12b6e28582eb9298577c734a31ba9f4f');
    // protocol.addConnectedDevice(weatherService);

    // // Add a background task that collects weather every 30 miutes.
    // protocol.addTriggeredTask(
    //     IntervalTrigger(period: Duration(minutes: 30)),
    //     BackgroundTask()
    //       ..addMeasure(Measure(type: ContextSamplingPackage.WEATHER)),
    //     weatherService);

    // // Define the online air quality service and add it as a 'device'
    // AirQualityService airQualityService =
    //     AirQualityService(apiKey: '9e538456b2b85c92647d8b65090e29f957638c77');
    // protocol.addConnectedDevice(airQualityService);

    // // Add a background task that air quality every 30 miutes.
    // protocol.addTriggeredTask(
    //     IntervalTrigger(period: Duration(minutes: 30)),
    //     BackgroundTask()
    //       ..addMeasure(Measure(type: ContextSamplingPackage.AIR_QUALITY)),
    //     airQualityService);

    // protocol.addTriggeredTask(
    //     ImmediateTrigger(),
    //     BackgroundTask()..addMeasure(Measure(type: MediaSamplingPackage.NOISE)),
    //     phone);

    // protocol.addTriggeredTask(
    //     ImmediateTrigger(),
    //     BackgroundTask()
    //       ..addMeasures([
    //         Measure(type: ConnectivitySamplingPackage.CONNECTIVITY),
    //         Measure(type: ConnectivitySamplingPackage.WIFI),
    //         Measure(type: ConnectivitySamplingPackage.BLUETOOTH),
    //       ]),
    //     phone);

    // // Add an automatic task that collects SMS messages in/out
    // protocol.addTriggeredTask(
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
    // protocol.addTriggeredTask(
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
    // protocol.addTriggeredTask(
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

    // // define the sSense device and add its measures
    // ESenseDevice eSense = ESenseDevice(
    //   deviceName: 'eSense-0332',
    //   samplingRate: 10,
    // );
    // protocol.addConnectedDevice(eSense);

    // protocol.addTriggeredTask(
    //     ImmediateTrigger(),
    //     BackgroundTask()
    //       ..addMeasure(Measure(type: ESenseSamplingPackage.ESENSE_BUTTON))
    //       ..addMeasure(Measure(type: ESenseSamplingPackage.ESENSE_SENSOR)),
    //     eSense);

    // define the Polar device and add its measures
    PolarDevice polar = PolarDevice(
      identifier: 'B5FC172F',
      name: 'Polar H10',
      polarDeviceType: PolarDeviceType.H10,
      roleName: 'polar-h10-device',
    );
    // PolarDevice polar = PolarDevice(
    //   identifier: 'B36B5B21',
    //   name: 'Polar PVS',
    //   polarDeviceType: PolarDeviceType.PVS,
    //   roleName: 'polar-pvs-device',
    // );

    protocol.addConnectedDevice(polar);

    protocol.addTriggeredTask(
        ImmediateTrigger(),
        BackgroundTask()
          ..addMeasure(Measure(type: PolarSamplingPackage.POLAR_HR))
          ..addMeasure(Measure(type: PolarSamplingPackage.POLAR_ECG))
          ..addMeasure(Measure(type: PolarSamplingPackage.POLAR_PPG))
          ..addMeasure(Measure(type: PolarSamplingPackage.POLAR_PPI)),
        polar);

    // // add a measure for ECG monitoring using the Movisens device
    // protocol.addTriggeredTask(
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
    // protocol.addTriggeredTask(
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

  DataEndPoint getDataEndPoint() {
    switch (bloc.deploymentMode) {
      case DeploymentMode.LOCAL:
        return SQLiteDataEndPoint();
      case DeploymentMode.CARP_PRODUCTION:
      case DeploymentMode.CARP_STAGING:
        return CarpDataEndPoint(
          uploadMethod: CarpUploadMethod.DATA_POINT,
          name: 'CARP Server',
        );
    }
  }

  @override
  Future<bool> saveStudyProtocol(String studyId, StudyProtocol protocol) async {
    throw UnimplementedError();
  }
}
