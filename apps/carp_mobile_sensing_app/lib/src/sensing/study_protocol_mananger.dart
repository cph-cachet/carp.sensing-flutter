/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of mobile_sensing_app;

// This is a simple local [StudyProtocolManager].
///
/// This class shows how to configure a [StudyProtocol] with [Tigger]s,
/// [TaskDescriptor]s and [Measure]s.
class LocalStudyProtocolManager implements StudyProtocolManager {
  Future initialize() async {}

  /// Create a new CAMS study protocol.
  Future<StudyProtocol> getStudyProtocol(String ignored) async {
    CAMSStudyProtocol protocol = CAMSStudyProtocol()
      ..name = '#23-Coverage'
      ..dataEndPoint = FileDataEndPoint(
        bufferSize: 50 * 1000,
        zip: true,
        encrypt: false,
      )
      ..owner = ProtocolOwner(
        id: 'AB',
        name: 'Alex Boyon',
        email: 'alex@uni.dk',
      )
      ..protocolDescription = StudyProtocolDescription(
        title: 'Sensing Coverage Study',
        description: 'This is a study for testing the coverage of sampling.',
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
              SensorSamplingPackage.LIGHT, // 10 s
              // ConnectivitySamplingPackage.CONNECTIVITY,
              // ConnectivitySamplingPackage.WIFI, // 60 s
              DeviceSamplingPackage.MEMORY, // 60 s
              AudioSamplingPackage.NOISE, // 60 s
              ContextSamplingPackage.ACTIVITY, // ~3 s
              ContextSamplingPackage.MOBILITY, // ~3 s
            ],
          ),
        phone);

    protocol.addTriggeredTask(
        RandomRecurrentTrigger(
          startTime: Time(hour: 23, minute: 56),
          endTime: Time(hour: 24, minute: 0),
          minNumberOfTriggers: 2,
          maxNumberOfTriggers: 8,
        ),
        AutomaticTask()
          ..measures = SamplingPackageRegistry().debug().getMeasureList(
            types: [
              DeviceSamplingPackage.DEVICE,
              ContextSamplingPackage.LOCATION,
            ],
          ),
        phone);

    // protocol.addTriggeredTask(
    //     PeriodicTrigger(period: Duration(minutes: 1)),
    //     AutomaticTask()
    //       ..measures = SamplingPackageRegistry().debug().getMeasureList(
    //         types: [
    //           DeviceSamplingPackage.DEVICE,
    //           ContextSamplingPackage.LOCATION,
    //         ],
    //       ),
    //     phone);

    protocol.addTriggeredTask(
        PeriodicTrigger(period: Duration(minutes: 5)), // 5 min
        AutomaticTask()
          ..measures = SamplingPackageRegistry().debug().getMeasureList(
            types: [
              ContextSamplingPackage.WEATHER,
              ContextSamplingPackage.AIR_QUALITY,
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
