import 'dart:convert';
import 'dart:io';

import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:test/test.dart';

String _encode(Object object) =>
    const JsonEncoder.withIndent(' ').convert(object);

void main() {
  // StudyProtocol protocol;

  setUp(() {
    // FromJsonFactory().register(CAMSStudyProtocol());
    // FromJsonFactory().register(ProtocolOwner());
    registerFromJsonFunctions();
  });

  test('CAMSStudyProtocol -> JSON', () async {
    // Create a new study protocol.
    CAMSStudyProtocol protocol = CAMSStudyProtocol()
      ..name = 'Track patient movement'
      ..owner = ProtocolOwner(
        id: 'jakba',
        name: 'Jakob E. Bardram',
        email: 'jakba@dtu.dk',
      );

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
    expect(protocol.ownerId, 'jakba');
  });

  test('JSON -> StudyProtocol', () async {
    // Read the study protocol from json file
    String plainJson = File('test/json/study_1.json').readAsStringSync();

    CAMSStudyProtocol protocol = CAMSStudyProtocol.fromJson(
        json.decode(plainJson) as Map<String, dynamic>);

    expect(protocol.ownerId, 'jakba');
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
