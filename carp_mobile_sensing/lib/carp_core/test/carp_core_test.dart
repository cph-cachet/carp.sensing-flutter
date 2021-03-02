import 'dart:convert';
import 'dart:io';
import 'package:test/test.dart';

import '../carp_core.dart';

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

  test('StudyProtocol -> JSON', () async {
    // Create a new study protocol.
    StudyProtocol protocol = StudyProtocol()
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
      DataTypeMeasure(type: DataType(NameSpace.CARP, 'light')),
      DataTypeMeasure(type: DataType(NameSpace.CARP, 'gps')),
      DataTypeMeasure(type: DataType(NameSpace.CARP, 'steps')),
    ];

    ConcurrentTask task = ConcurrentTask(name: "Start measures")
      ..addMeasures(measures);
    protocol.addTriggeredTask(Trigger(), task, phone);

    print(protocol);
    print(_encode(protocol));
    expect(protocol.ownerId, 'jakba@dtu.dk');
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
