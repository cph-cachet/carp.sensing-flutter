import 'dart:convert';
import 'dart:io';
import 'package:test/test.dart';
import 'package:carp_core/carp_core.dart';

void main() {
  StudyProtocol protocol;

  setUp(() {
    protocol = StudyProtocol(
        owner: ProtocolOwner(id: 'jakba@dtu.dk'),
        name: 'Track patient movement');

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
  });

  test('StudyProtocol -> JSON', () async {
    print(protocol);
    print(toJsonString(protocol));
    expect(protocol.owner.id, 'jakba@dtu.dk');
  });

  test('JSON -> StudyProtocol', () async {
    // Read the study protocol from json file
    String plainJson = File('test/json/study_1.json').readAsStringSync();

    StudyProtocol protocol =
        StudyProtocol.fromJson(json.decode(plainJson) as Map<String, dynamic>);

    expect(protocol.owner.id, 'jakba@dtu.dk');
    expect(protocol.masterDevices.first.roleName, 'masterphone');
    print(toJsonString(protocol));
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
    print(toJsonString(dataPoint));
    assert(dataPoint.carpBody != null);
  });
}
