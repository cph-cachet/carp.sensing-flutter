import 'dart:convert';
import 'dart:io';
import 'package:json_annotation/json_annotation.dart';
import 'package:test/test.dart';
import 'package:carp_core/carp_core.dart';

part 'carp_core_test.g.dart';

void main() {
  late StudyProtocol protocol;

  setUp(() {
    protocol = StudyProtocol(
      ownerId: 'xyz@dtu.dk',
      name: 'Test Study Protocol',
      description: 'For testing purposes.',
    );

    // Define which devices are used for data collection.
    Smartphone phone = Smartphone(roleName: 'masterphone');
    DeviceDescriptor eSense = DeviceDescriptor(
      roleName: 'eSense',
    );

    protocol
      ..addMasterDevice(phone)
      ..addConnectedDevice(eSense);

    // Define what needs to be measured, on which device, when.
    List<Measure> measures = [
      Measure(type: DataType(NameSpace.CARP, 'light').toString()),
      Measure(type: DataType(NameSpace.CARP, 'gps').toString()),
      Measure(type: DataType(NameSpace.CARP, 'steps').toString()),
    ];

    BackgroundTask task = BackgroundTask(name: 'Start measures')
      ..addMeasures(measures);
    protocol.addTriggeredTask(
      Trigger(sourceDeviceRoleName: phone.roleName),
      task,
      phone,
    );
    protocol.addTriggeredTask(
      ManualTrigger(sourceDeviceRoleName: phone.roleName),
      task,
      phone,
    );
  });

  test('StudyProtocol -> JSON', () async {
    print(protocol);
    print(toJsonString(protocol));
    expect(protocol.ownerId, 'xyz@dtu.dk');
    expect(protocol.triggers.length, 2);
    expect(protocol.triggers.keys.first, '0');
    expect(protocol.tasks.length, 1);
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
        dataFormat: DataFormat(NameSpace.CARP, 'light'),
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
        time: TimeOfDay(hour: 12),
        recurrenceRule: RecurrenceRule(Frequency.DAILY, interval: 2));
    expect(st.recurrenceRule.toString(),
        RecurrenceRule.fromString('RRULE:FREQ=DAILY;INTERVAL=2').toString());
    print(st);

    st = ScheduledTrigger(
        time: TimeOfDay(hour: 12),
        recurrenceRule:
            RecurrenceRule(Frequency.DAILY, interval: 2, end: End.count(3)));
    expect(
        st.recurrenceRule.toString(),
        RecurrenceRule.fromString('RRULE:FREQ=DAILY;INTERVAL=2;COUNT=3')
            .toString());
    print(st);

    st = ScheduledTrigger(
        time: TimeOfDay(hour: 12),
        recurrenceRule: RecurrenceRule(Frequency.DAILY,
            interval: 2, end: End.until(Duration(days: 30))));
    expect(
        st.recurrenceRule.toString(),
        RecurrenceRule.fromString(
                'RRULE:FREQ=DAILY;INTERVAL=2;UNTIL=2592000000')
            .toString());
    print(st);
  });

  test('A & B -> JSON', () async {
    A a = A();
    B b = B();
    a.index = 1;

    b.index = 2;
    b.str = 'abc';

    print(toJsonString(a));
    print(toJsonString(b));
  });
}

/// An example class.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class A extends Serializable {
  int? index;

  A() : super();

  Function get fromJsonFunction => _$AFromJson;
  factory A.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as A;
  Map<String, dynamic> toJson() => _$AToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class B extends A {
  String? str;

  B() : super();

  String get jsonType => 'dk.cachet.$runtimeType';

  Function get fromJsonFunction => _$BFromJson;
  factory B.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as B;
  Map<String, dynamic> toJson() => _$BToJson(this);
}
