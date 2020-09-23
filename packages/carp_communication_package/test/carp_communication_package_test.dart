import 'package:test/test.dart';
import 'dart:convert';
import 'dart:io';
import 'package:carp_communication_package/communication.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';

String _encode(Object object) => const JsonEncoder.withIndent(' ').convert(object);

void main() {
  Study study;

  setUp(() {
    SamplingPackageRegistry.register(CommunicationSamplingPackage());

    study = Study("1234", "bardram", name: "bardram study")
      ..dataEndPoint = DataEndPoint(DataEndPointTypes.PRINT)
      ..addTriggerTask(ImmediateTrigger(),
          Task(name: 'Task #1')..measures = SamplingSchema.common(namespace: NameSpace.CARP).measures.values.toList());

    //..addTask(Task('Communication Task')..measures = CommunicationSamplingPackage.common.measures.values.toList())
  });

  test('Study -> JSON', () async {
    print(_encode(study));

    expect(study.id, "1234");
  });

  test('JSON -> Study, assert study id', () async {
    final studyJson = _encode(study);

    Study study_2 = Study.fromJson(json.decode(studyJson) as Map<String, dynamic>);
    expect(study_2.id, study.id);

    print(_encode(study_2));
  });

  test('JSON -> Study, deep assert', () async {
    final studyJson = _encode(study);

    Study study_2 = Study.fromJson(json.decode(studyJson) as Map<String, dynamic>);
    expect(_encode(study_2), equals(studyJson));
  });

  test('Plain JSON string -> Study object', () async {
    print(Directory.current.toString());
    String plainStudyJson = File("test/study_1234.json").readAsStringSync();
    print(plainStudyJson);

    Study plainStudy = Study.fromJson(json.decode(plainStudyJson) as Map<String, dynamic>);
    expect(plainStudy.id, study.id);

    final studyJson = _encode(study);

    Study study_2 = Study.fromJson(json.decode(plainStudyJson) as Map<String, dynamic>);
    expect(_encode(study_2), equals(studyJson));
  });

  test('Privacy - TextMessageDatum', () {
    TextMessageDatum msg =
        TextMessageDatum.fromTextMessage(TextMessage(id: 123, address: '25550446', body: 'Hej Jakob'));
    print(msg);

    print(_encode(msg));

    TextMessageDatum p_msg = TransformerSchemaRegistry.lookup(PrivacySchema.DEFAULT).transform(msg);
    expect(p_msg.textMessage.address, isNot('25550446'));
    expect(p_msg.textMessage.body, isNot('Hej Jakob'));
    print(p_msg);
  });

  test('Privacy - TextMessageLogDatum', () {
    TextMessageLogDatum log = TextMessageLogDatum()
      ..textMessageLog.add(TextMessage(id: 123, address: '25550446', body: 'Hej Jakob'))
      ..textMessageLog.add(TextMessage(id: 1232, address: '25550467', body: 'Hej Eva'));

    print(_encode(log));

    log.textMessageLog.forEach(print);

    TextMessageLogDatum p_log = TransformerSchemaRegistry.lookup(PrivacySchema.DEFAULT).transform(log);
    //expect(p_msg.textMessage.address, isNot('25550446'));
    //expect(p_msg.textMessage.body, isNot('Hej Jakob'));
    p_log.textMessageLog.forEach(print);
  });

  test('Privacy - PhoneLogDatum', () {
    PhoneLogDatum log = PhoneLogDatum()
      ..phoneLog.add(PhoneCall(DateTime.now(), 'ingoing', 23444, '2555 0446', '25550446', 'Jakob'))
      ..phoneLog.add(PhoneCall(DateTime.now(), 'ingoing', 2344444, '2555 0467', '25550457', 'Eva'));

    print(_encode(log));

    log.phoneLog.forEach(print);

    PhoneLogDatum p_log = TransformerSchemaRegistry.lookup(PrivacySchema.DEFAULT).transform(log);
    //expect(p_msg.textMessage.address, isNot('25550446'));
    //expect(p_msg.textMessage.body, isNot('Hej Jakob'));
    p_log.phoneLog.forEach(print);
  });

  test('Calendar', () {
    CalendarDatum cal = CalendarDatum()
      ..calendarEvents.add(CalendarEvent('122', 'wer', 'møde #1'))
      ..calendarEvents.add(CalendarEvent('122', 'wer', 'møde #1'));

    print(_encode(cal));

    CalendarDatum p_cal = TransformerSchemaRegistry.lookup(PrivacySchema.DEFAULT).transform(cal);
    print(_encode(p_cal));
  });

  test('', () {});
}
