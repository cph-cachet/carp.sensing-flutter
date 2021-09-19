/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of mobile_sensing_app;

/// This is a simple local [StudyProtocolManager].
///
/// This class shows how to configure a [StudyProtocol] with [Tigger]s,
/// [TaskDescriptor]s and [Measure]s.
class LocalStudyProtocolManager implements StudyProtocolManager {
  Future initialize() async {}

  /// Create a new CAMS study protocol.
  Future<StudyProtocol> getStudyProtocol(String studyId) async {
    StudyProtocol protocol = StudyProtocol(
      ownerId: 'alex@uni.dk',
      name: 'CAMS App - Sensing Coverage Study',
      description: 'This is a protocol for testing the coverage of sampling.',
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
              // ContextSamplingPackage.GEOLOCATION, // event-based
              //ContextSamplingPackage.MOBILITY, // event-based
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
