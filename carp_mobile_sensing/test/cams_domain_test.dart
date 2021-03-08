import 'dart:convert';
import 'dart:io';

import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:test/test.dart';

String _encode(Object object) =>
    const JsonEncoder.withIndent(' ').convert(object);

void main() {
  StudyProtocol protocol;

  setUp(() {
    // // create a file data manager in order to support the file data endpoint
    // FileDataManager();

    // protocol = StudyProtocol(
    //   userId: 'bardram',
    //   name: 'bardram study',
    // );
    // //study.dataEndPoint = DataEndPoint(DataEndPointType.PRINT);
    // protocol.dataEndPoint = FileDataEndPoint()
    //   ..bufferSize = 50 * 1000
    //   ..zip = true
    //   ..encrypt = false;

    // // adding all measure from the common schema to one one trigger and one task
    // protocol.addTriggeredTask(
    //     ImmediateTrigger(), // a simple trigger that starts immediately
    //     AutomaticTaskDescriptor(name: 'Sampling Task')
    //       ..measures = SamplingPackageRegistry()
    //           .common(namespace: NameSpace.CARP)
    //           .measures
    //           .values
    //           .toList() // a task with all measures
    //     );
  });

  test('CAMSStudyProtocol -> JSON', () async {
    // Create a new study protocol.
    CAMSStudyProtocol protocol = CAMSStudyProtocol()
      ..name = 'Track patient movement'
      ..ownerId = 'jakba@dtu.dk';

    // Define which devices are used for data collection.
    Smartphone phone = Smartphone(name: 'SM-A320FL', roleName: 'masterphone');
    DeviceDescriptor eSense = DeviceDescriptor(
      roleName: 'eSense',
    );

    protocol
      ..addMasterDevice(phone)
      ..addConnectedDevice(eSense);

    // Define what needs to be measured, on which device, when.
    List<Measure> measures = [
      Measure(type: DataType(NameSpace.CARP, 'light').toString()),
      DataTypeMeasure(type: DataType(NameSpace.CARP, 'gps').toString()),
      PhoneSensorMeasure(
        type: DataType(NameSpace.CARP, 'steps').toString(),
        duration: 10,
      ),
    ];

    ConcurrentTask task = ConcurrentTask(name: "Start measures")
      ..addMeasures(measures);
    protocol.addTriggeredTask(Trigger(), task, phone);

    print(protocol);
    print(_encode(protocol));
    expect(protocol.ownerId, 'jakba@dtu.dk');
  });

  test('JSON -> StudyProtocol', () async {
    // Read the study protocol from json file
    String plainJson =
        File('lib/carp_core/test/json_files/study_1.json').readAsStringSync();

    StudyProtocol protocol =
        StudyProtocol.fromJson(json.decode(plainJson) as Map<String, dynamic>);

    expect(protocol.ownerId, 'jakba@dtu.dk');
    expect(protocol.masterDevices.first.roleName, 'masterphone');
    print(_encode(protocol));
  });

  test('DataPoint -> JSON', () async {
    DataPoint dataPoint = DataPoint(
      DataPointHeader(
        studyId: '1234',
        dataFormat: DataFormat(NameSpace.CARP, 'light'),
      ),
      Data(),
    );

    print(dataPoint);
    print(_encode(dataPoint));
    assert(dataPoint.carpBody != null);
  });
}
