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

    // Define which devices are used for data collection.
    Smartphone phone = Smartphone();
    ESenseDevice eSense = ESenseDevice();

    protocol
      ..addMasterDevice(phone)
      ..addConnectedDevice(eSense);

    protocol.addTriggeredTask(
        ImmediateTrigger(),
        AutomaticTask()
          ..measures = SamplingPackageRegistry().debug().getMeasureList(
            types: [
              SensorSamplingPackage.LIGHT, // 60 s
              // ConnectivitySamplingPackage.CONNECTIVITY,
              // ConnectivitySamplingPackage.WIFI, // 60 s
              AudioVideoSamplingPackage.NOISE, // 60 s
              DeviceSamplingPackage.MEMORY, // 60 s
              DeviceSamplingPackage.SCREEN, // event-based
              ContextSamplingPackage.ACTIVITY, // event-based
              ContextSamplingPackage.GEOLOCATION, // event-based
              ContextSamplingPackage.MOBILITY, // event-based
            ],
          ),
        phone);

    protocol.addTriggeredTask(
        ImmediateTrigger(),
        AutomaticTask()
          ..measures = SamplingPackageRegistry().debug().getMeasureList(
            types: [
              DeviceSamplingPackage.DEVICE,
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

    protocol.addTriggeredTask(
        PeriodicTrigger(
          period: Duration(minutes: 1),
          duration: const Duration(seconds: 2),
        ),
        AutomaticTask()
          ..measures = SamplingPackageRegistry().debug().getMeasureList(
            types: [
              ContextSamplingPackage.LOCATION,
            ],
          ),
        phone);

    protocol.addTriggeredTask(
        PeriodicTrigger(
          period: Duration(minutes: 2),
          duration: const Duration(seconds: 2),
        ),
        AutomaticTask()
          ..measures = SamplingPackageRegistry().debug().getMeasureList(
            types: [
              ContextSamplingPackage.WEATHER,
              ContextSamplingPackage.AIR_QUALITY,
            ],
          ),
        phone);

    protocol.addTriggeredTask(
        PeriodicTrigger(
          period: Duration(minutes: 2),
          duration: Duration(seconds: 30),
        ),
        AutomaticTask()
          ..measures = SamplingPackageRegistry().debug().getMeasureList(
            types: [
              AudioVideoSamplingPackage.AUDIO,
            ],
          ),
        phone);

    protocol.addTriggeredTask(
        ImmediateTrigger(),
        AutomaticTask()
          ..measures = SamplingPackageRegistry().debug().getMeasureList(
            types: [
              ESenseSamplingPackage.ESENSE_BUTTON,
              ESenseSamplingPackage.ESENSE_SENSOR,
            ],
          ),
        eSense);

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
