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
  Future initialize() async {}

  /// Create a new CAMS study protocol.
  Future<SmartphoneStudyProtocol> getStudyProtocol(String studyId) async {
    SmartphoneStudyProtocol protocol = SmartphoneStudyProtocol(
      ownerId: 'alex@uni.dk',
      name: 'CAMS App Study #1',
    );

    protocol.protocolDescription = StudyDescription(
        title: 'CAMS App - Sensing Coverage Study',
        description:
            'The default study testing coverage of most measures. Used in the coverage tests.',
        purpose: 'To test sensing coverage',
        responsible: StudyReponsible(
          id: 'jakba',
          title: 'professor',
          address: 'Ørsteds Plads',
          affiliation: 'Technical University of Denmark',
          email: 'jakba@dtu.dk',
          name: 'Jakob E. Bardram',
        ));

    // add CARP as the data endpoint - w/o authentication info - we expect to be authenticated
    protocol.dataEndPoint = CarpDataEndPoint(
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
              AudioSamplingPackage.NOISE, // 60 s
              DeviceSamplingPackage.MEMORY, // 60 s
              DeviceSamplingPackage.SCREEN, // event-based
              ContextSamplingPackage.ACTIVITY, // event-based
              ContextSamplingPackage.GEOLOCATION, // event-based
              ContextSamplingPackage.MOBILITY, // event-based
            ],
          ),
        phone);

    // a random trigger - 2-8 times during time period of 8-20
    protocol.addTriggeredTask(
        RandomRecurrentTrigger(
          startTime: Time(hour: 8),
          endTime: Time(hour: 20),
          minNumberOfTriggers: 3,
          maxNumberOfTriggers: 8,
        ),
        AutomaticTask()
          ..measures = SamplingPackageRegistry().debug().getMeasureList(
            types: [
              DeviceSamplingPackage.DEVICE,
            ],
          ),
        phone);

    protocol.addTriggeredTask(
        PeriodicTrigger(period: Duration(minutes: 1)),
        AutomaticTask()
          ..measures = SamplingPackageRegistry().debug().getMeasureList(
            types: [
              ContextSamplingPackage.LOCATION,
            ],
          ),
        phone);

    protocol.addTriggeredTask(
        PeriodicTrigger(period: Duration(minutes: 2)),
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
              AudioSamplingPackage.AUDIO,
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

  Future<bool> saveStudyProtocol(String studyId, StudyProtocol protocol) async {
    throw UnimplementedError();
  }
}
