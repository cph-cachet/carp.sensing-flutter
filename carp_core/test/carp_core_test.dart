import 'dart:convert';
import 'dart:io';
import 'package:test/test.dart';
import 'package:carp_core/carp_core.dart';
import 'package:carp_serializable/carp_serializable.dart';

void main() {
  late StudyProtocol protocol;

  setUp(() {
    Core();

    protocol = StudyProtocol(
      ownerId: 'xyz@dtu.dk',
      name: 'Test Study Protocol',
      description: 'For testing purposes.',
    );

    // Define which devices are used for data collection.
    Smartphone phone = Smartphone(roleName: 'masterphone');
    DeviceDescriptor connectedDevice = DeviceDescriptor(
      roleName: 'connected_device',
    );

    protocol
      ..addMasterDevice(phone)
      ..addConnectedDevice(connectedDevice);

    // Define what needs to be measured, on which device, when.
    List<Measure> measures = [
      Measure(type: const DataType(NameSpace.CARP, 'light').toString()),
      Measure(type: const DataType(NameSpace.CARP, 'gps').toString()),
      Measure(type: const DataType(NameSpace.CARP, 'steps').toString()),
    ];

    BackgroundTask task = BackgroundTask(name: 'Start measures')
      ..addMeasures(measures);
    protocol.addTriggeredTask(
      Trigger(sourceDeviceRoleName: phone.roleName),
      task,
      phone,
    );

    Measure measure = Measure(type: 'dk.cachet.carp.steps');
    measure.overrideSamplingConfiguration = BatteryAwareSamplingConfiguration(
        normal: GranularitySamplingConfiguration(Granularity.Detailed),
        low: GranularitySamplingConfiguration(Granularity.Balanced),
        critical: GranularitySamplingConfiguration(Granularity.Coarse));

    protocol.addTriggeredTask(
      ManualTrigger(),
      BackgroundTask()..addMeasure(measure),
      phone,
    );
  });

  test('StudyProtocol -> JSON', () async {
    print(protocol);
    print(toJsonString(protocol));
    expect(protocol.ownerId, 'xyz@dtu.dk');
    expect(protocol.triggers.length, 2);
    expect(protocol.triggers.keys.first, '0');
    expect(protocol.tasks.length, 2);
    expect(protocol.triggeredTasks.length, 2);
  });

  test('JSON -> StudyProtocol', () async {
    // Read the study protocol from json file
    String plainJson = File('test/json/study_protocol.json').readAsStringSync();

    StudyProtocol protocol =
        StudyProtocol.fromJson(json.decode(plainJson) as Map<String, dynamic>);

    expect(protocol.ownerId, 'xyz@dtu.dk');
    expect(protocol.masterDevices.first.roleName, 'masterphone');
    print(toJsonString(protocol));
  });

  test('JSON -> Custom StudyProtocol', () async {
    // Read the study protocol from json file
    String plainJson =
        File('test/json/custom_study_protocol.json').readAsStringSync();

    StudyProtocol protocol =
        StudyProtocol.fromJson(json.decode(plainJson) as Map<String, dynamic>);

    expect(protocol.ownerId, '979b408d-784e-4b1b-bb1e-ff9204e072f3');
    expect(protocol.masterDevices.first.roleName, 'Custom device');
    print(toJsonString(protocol));
  });

  test('DataPoint -> JSON', () async {
    DataPoint dataPoint = DataPoint(
      DataPointHeader(
        studyId: '1234',
        dataFormat: const DataFormat(NameSpace.CARP, 'light'),
      ),
      Data(),
    );

    print(dataPoint);
    print(jsonEncode(dataPoint));
    print(toJsonString(dataPoint));
    assert(dataPoint.carpBody != null);
  });

  test('ScheduledTrigger', () async {
    var st = ScheduledTrigger(
        time: const TimeOfDay(hour: 12),
        recurrenceRule: RecurrenceRule(Frequency.DAILY, interval: 2));
    expect(st.recurrenceRule.toString(),
        RecurrenceRule.fromString('RRULE:FREQ=DAILY;INTERVAL=2').toString());
    print(st);

    st = ScheduledTrigger(
        time: const TimeOfDay(hour: 12),
        recurrenceRule:
            RecurrenceRule(Frequency.DAILY, interval: 2, end: End.count(3)));
    expect(
        st.recurrenceRule.toString(),
        RecurrenceRule.fromString('RRULE:FREQ=DAILY;INTERVAL=2;COUNT=3')
            .toString());
    print(st);

    st = ScheduledTrigger(
        time: const TimeOfDay(hour: 12),
        recurrenceRule: RecurrenceRule(Frequency.DAILY,
            interval: 2, end: End.until(const Duration(days: 30))));
    expect(
        st.recurrenceRule.toString(),
        RecurrenceRule.fromString(
                'RRULE:FREQ=DAILY;INTERVAL=2;UNTIL=2592000000')
            .toString());
    print(st);
  });
}
