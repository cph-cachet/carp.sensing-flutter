import 'dart:convert';
import 'dart:io';
import 'package:test/test.dart';

import '../carp_core_domain.dart';

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

  test('StudyProtocol', () async {
    StudyProtocol protocol = StudyProtocol()
      ..name = 'Test Protocol'
      ..ownerId = 'jakba@dtu.dk';

    print(protocol);
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
    assert(dataPoint.carpBody.id != null);
  });
}
