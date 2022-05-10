import 'dart:convert';
import 'dart:io';
import 'package:test/test.dart';

import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:carp_communication_package/communication.dart';

void main() {
  late StudyProtocol protocol;
  Smartphone phone;

  setUp(() {
    // make sure that the json functions are loaded
    DomainJsonFactory();

    // register the context sampling package
    SamplingPackageRegistry().register(CommunicationSamplingPackage());

    // Create a new study protocol.
    protocol = StudyProtocol(
      ownerId: 'alex@uni.dk',
      name: 'Context package test',
    );

    // Define which devices are used for data collection.
    phone = Smartphone();
    protocol.addMasterDevice(phone);

    // adding all available measures to one one trigger and one task
    protocol.addTriggeredTask(
      ImmediateTrigger(),
      BackgroundTask()
        ..measures = SamplingPackageRegistry()
            .dataTypes
            .map((type) => Measure(type: type))
            .toList(),
      phone,
    );
  });

  test('CAMSStudyProtocol -> JSON', () async {
    print(protocol);
    print(toJsonString(protocol));
    expect(protocol.ownerId, 'alex@uni.dk');
  });

  test('StudyProtocol -> JSON -> StudyProtocol :: deep assert', () async {
    print('#1 : $protocol');
    final studyJson = toJsonString(protocol);

    StudyProtocol protocolFromJson =
        StudyProtocol.fromJson(json.decode(studyJson) as Map<String, dynamic>);
    expect(toJsonString(protocolFromJson), equals(studyJson));
    print('#2 : $protocolFromJson');
  });
  test('JSON File -> StudyProtocol', () async {
    // Read the study protocol from json file
    String plainJson = File('test/json/study_protocol.json').readAsStringSync();

    StudyProtocol protocol =
        StudyProtocol.fromJson(json.decode(plainJson) as Map<String, dynamic>);

    expect(protocol.ownerId, 'alex@uni.dk');
    expect(protocol.masterDevices.first.roleName, Smartphone.DEFAULT_ROLENAME);
    print(toJsonString(protocol));
  });

  test('Privacy - TextMessageDatum', () {
    TextMessageDatum msg = TextMessageDatum.fromTextMessage(
        TextMessage(id: 123, address: '25550446', body: 'Hej Jakob'));
    print(msg);

    print(toJsonString(msg));

    TextMessageDatum pMsg = TransformerSchemaRegistry()
        .lookup(PrivacySchema.DEFAULT)!
        .transform(msg) as TextMessageDatum;
    expect(pMsg.textMessage!.address, isNot('25550446'));
    expect(pMsg.textMessage!.body, isNot('Hej Jakob'));
    print(pMsg);
  });

  test('Privacy - TextMessageLogDatum', () {
    TextMessageLogDatum log = TextMessageLogDatum()
      ..textMessageLog
          .add(TextMessage(id: 123, address: '25550446', body: 'Hej Jakob'))
      ..textMessageLog
          .add(TextMessage(id: 1232, address: '25550467', body: 'Hej Eva'));

    print(toJsonString(log));

    log.textMessageLog.forEach(print);

    TextMessageLogDatum pLog = TransformerSchemaRegistry()
        .lookup(PrivacySchema.DEFAULT)!
        .transform(log) as TextMessageLogDatum;
    //expect(p_msg.textMessage.address, isNot('25550446'));
    //expect(p_msg.textMessage.body, isNot('Hej Jakob'));
    pLog.textMessageLog.forEach(print);
  });

  test('Privacy - PhoneLogDatum', () {
    PhoneLogDatum log = PhoneLogDatum()
      ..phoneLog.add(PhoneCall(
          DateTime.now(), 'ingoing', 23444, '2555 0446', '25550446', 'Jakob'))
      ..phoneLog.add(PhoneCall(
          DateTime.now(), 'ingoing', 2344444, '2555 0467', '25550457', 'Eva'));

    print(toJsonString(log));

    log.phoneLog.forEach(print);

    PhoneLogDatum pLog = TransformerSchemaRegistry()
        .lookup(PrivacySchema.DEFAULT)!
        .transform(log) as PhoneLogDatum;
    pLog.phoneLog.forEach(print);
  });

  test('Calendar', () {
    CalendarDatum cal = CalendarDatum()
      ..calendarEvents.add(CalendarEvent('122', 'wer', 'møde #1'))
      ..calendarEvents.add(CalendarEvent('122', 'wer', 'møde #1'));

    print(toJsonString(cal));

    CalendarDatum pCal = TransformerSchemaRegistry()
        .lookup(PrivacySchema.DEFAULT)!
        .transform(cal) as CalendarDatum;
    print(toJsonString(pCal));
  });
}
