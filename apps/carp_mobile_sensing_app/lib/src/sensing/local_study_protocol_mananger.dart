/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
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
  Future initialize() async {}

  @override
  Future<SmartphoneStudyProtocol> getStudyProtocol(String studyId) async {
    SmartphoneStudyProtocol protocol = SmartphoneStudyProtocol(
      ownerId: 'abc@dtu.dk',
      name: 'CAMS App Study No. 2',
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
        ? FileDataEndPoint()
        : CarpDataEndPoint(
            uploadMethod: CarpUploadMethod.DATA_POINT,
            name: 'CARP Server',
          );

    // set the format of the data to upload - e.g. Open mHealth
    protocol.dataEndPoint!.dataFormat = bloc.dataFormat;

    // Define which devices are used for data collection.
    Smartphone phone = Smartphone(roleName: 'SM-A320FL');
    ESenseDevice eSense = ESenseDevice(
      roleName: 'eSense earplug',
      deviceName: 'eSense-0223',
      samplingRate: 10,
    );
    // MovisensDevice movisens = MovisensDevice();

    protocol
      ..addMasterDevice(phone)
      ..addConnectedDevice(eSense);

    protocol.addTriggeredTask(
        ImmediateTrigger(),
        AutomaticTask()
          ..measures = SamplingPackageRegistry().debug.getMeasureList(
            types: [
              DeviceSamplingPackage.DEVICE,
              DeviceSamplingPackage.BATTERY,
              SensorSamplingPackage.PEDOMETER, // 60 s
              SensorSamplingPackage.LIGHT, // 60 s
              ConnectivitySamplingPackage.CONNECTIVITY,
              ConnectivitySamplingPackage.WIFI, // 60 s
              ConnectivitySamplingPackage.BLUETOOTH, // 60 s
              MediaSamplingPackage.NOISE, // 60 s
              DeviceSamplingPackage.MEMORY, // 60 s
              DeviceSamplingPackage.SCREEN, // event-based
              ContextSamplingPackage.ACTIVITY, // event-based
              ContextSamplingPackage.GEOLOCATION, // event-based
              // ContextSamplingPackage.MOBILITY, // event-based
            ],
          ),
        phone);

    // // a random trigger - 2-8 times during time period of 8-20
    // protocol.addTriggeredTask(
    //     RandomRecurrentTrigger(
    //       startTime: Time(hour: 8),
    //       endTime: Time(hour: 20),
    //       minNumberOfTriggers: 3,
    //       maxNumberOfTriggers: 8,
    //     ),
    //     AutomaticTask()
    //       ..measures = SamplingPackageRegistry().debug().getMeasureList(
    //         types: [
    //           DeviceSamplingPackage.DEVICE,
    //         ],
    //       ),
    //     phone);

    // protocol.addTriggeredTask(
    //     PeriodicTrigger(
    //       period: const Duration(minutes: 1),
    //       duration: const Duration(seconds: 2),
    //     ),
    //     AutomaticTask()
    //       ..measures = SamplingPackageRegistry().debug().getMeasureList(
    //         types: [
    //           ContextSamplingPackage.LOCATION,
    //         ],
    //       ),
    //     phone);

    protocol.addTriggeredTask(
        PeriodicTrigger(
          period: const Duration(minutes: 30),
          duration: const Duration(seconds: 2),
        ),
        AutomaticTask()
          ..addMeasure(WeatherMeasure(
              type: ContextSamplingPackage.WEATHER,
              name: 'Weather',
              description:
                  "Collects local weather from the WeatherAPI web service",
              apiKey: '12b6e28582eb9298577c734a31ba9f4f'))
          ..addMeasure(AirQualityMeasure(
              type: ContextSamplingPackage.AIR_QUALITY,
              name: 'Air Quality',
              description:
                  "Collects local air quality from the Air Quality Index (AQI) web service",
              apiKey: '9e538456b2b85c92647d8b65090e29f957638c77')),
        phone);

    // protocol.addTriggeredTask(
    //     PeriodicTrigger(
    //       period: Duration(minutes: 2),
    //       duration: Duration(seconds: 30),
    //     ),
    //     AutomaticTask()
    //       ..measures = SamplingPackageRegistry().debug().getMeasureList(
    //         types: [
    //           AudioVideoSamplingPackage.AUDIO,
    //         ],
    //       ),
    //     phone);

    protocol.addTriggeredTask(
        ImmediateTrigger(),
        AutomaticTask()
          ..measures = SamplingPackageRegistry().debug.getMeasureList(
            types: [
              ESenseSamplingPackage.ESENSE_BUTTON,
              ESenseSamplingPackage.ESENSE_SENSOR,
            ],
          ),
        eSense);

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
        return FileDataEndPoint();
      case DeploymentMode.CARP_PRODUCTION:
      case DeploymentMode.CARP_STAGING:
        return CarpDataEndPoint(
          uploadMethod: CarpUploadMethod.DATA_POINT,
          name: 'CARP Server',
        );
    }
  }

  Future<bool> saveStudyProtocol(String studyId, StudyProtocol protocol) async {
    throw UnimplementedError();
  }
}
