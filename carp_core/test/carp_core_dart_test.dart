import 'dart:convert';
import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:test/test.dart';
import 'package:carp_core/carp_core.dart';
import 'package:carp_serializable/carp_serializable.dart';
import 'package:iso_duration_parser/iso_duration_parser.dart';

void main() {
  late StudyProtocol protocol;

  setUp(() {
    Core();

    protocol = StudyProtocol(
      ownerId: 'xyz@dtu.dk',
      name: 'Test Study Protocol',
      description: 'For testing purposes.',
    );

    final phone_1 = Smartphone(roleName: 'phone_1');
    final phone_2 = Smartphone(roleName: 'phone_2');
    final monitor = DefaultDeviceConfiguration(roleName: 'hr_monitor');
    final bike = AltBeacon(roleName: 'bike');
    // final monitor = AltBeacon(roleName: 'hr_monitor');
    // final bike = AltBeacon(roleName: 'bike');

    protocol
      ..addParticipantRole(ParticipantRole('Runner'))
      ..addParticipantRole(ParticipantRole('Cyclist'))
      ..addPrimaryDevice(phone_1)
      ..addPrimaryDevice(phone_2)
      ..addConnectedDevice(monitor, phone_1)
      ..addConnectedDevice(bike, phone_1)
      ..changeDeviceAssignment(phone_1, AssignedTo(roleNames: {'Runner'}))
      ..changeDeviceAssignment(phone_2, AssignedTo(roleNames: {'Cyclist'}));

    protocol.addTaskControl(
      // TriggerConfiguration(sourceDeviceRoleName: phone.roleName),
      TriggerConfiguration(),
      BackgroundTask(
          name: 'Start measures',
          duration: const IsoDuration(hours: 1),
          measures: [
            Measure(type: Acceleration.dataType),
            Measure(type: Geolocation.dataType),
            Measure(type: StepCount.dataType),
          ]),
      phone_1,
      Control.Start,
    );

    protocol.addTaskControl(
      ElapsedTimeTrigger(
        // sourceDeviceRoleName: phone.roleName,
        elapsedTime: const IsoDuration(hours: 1),
      ),
      BackgroundTask(
          name: 'Start Heart Monitor',
          duration: const IsoDuration(hours: 1),
          measures: [
            Measure(type: ECG.dataType),
            Measure(type: EDA.dataType),
            Measure(type: HeartRate.dataType),
          ]),
      phone_1,
      Control.Start,
    );

    protocol.addTaskControl(
      ElapsedTimeTrigger(
        // sourceDeviceRoleName: phone.roleName,
        elapsedTime: const IsoDuration(hours: 1),
      ),
      BackgroundTask(
          name: 'Start Heart Monitor',
          duration: const IsoDuration(hours: 1),
          measures: [
            Measure(type: Acceleration.dataType),
            Measure(type: SignalStrength.dataType),
          ]),
      phone_2,
      Control.Start,
    );

    Measure measure = Measure(type: 'dk.cachet.carp.steps');
    measure.overrideSamplingConfiguration = BatteryAwareSamplingConfiguration(
        normal: GranularitySamplingConfiguration(Granularity.Detailed),
        low: GranularitySamplingConfiguration(Granularity.Balanced),
        critical: GranularitySamplingConfiguration(Granularity.Coarse));

    protocol.addTaskControl(
      ManualTrigger(),
      BackgroundTask()..addMeasure(measure),
      phone_1,
      Control.Start,
    );
  });

  test('StudyProtocol -> JSON', () async {
    print(protocol);
    print(toJsonString(protocol));
    expect(protocol.ownerId, 'xyz@dtu.dk');
    expect(protocol.triggers.length, 4);
    expect(protocol.triggers.keys.first, '0');
    expect(protocol.tasks.length, 4);
    expect(protocol.taskControls.length, 4);
    expect(protocol.participantRoles?.length, 2);
    expect(protocol.assignedDevices?.length, 2);
  });

  test('Add Request -> JSON', () async {
    print(toJsonString(Add(protocol)));
    // expect(toJsonString(expected), toJsonString(request));
  });

  test('JSON -> StudyProtocol', () async {
    final plainJson =
        File('test/json/carp.core-dart/study_protocol.json').readAsStringSync();

    final protocol =
        StudyProtocol.fromJson(json.decode(plainJson) as Map<String, dynamic>);

    expect(protocol.ownerId, 'xyz@dtu.dk');
    expect(protocol.primaryDevices.first.roleName, 'phone_1');
    print(toJsonString(protocol));

    final studyJson = toJsonString(protocol);

    final protocolFromJson =
        StudyProtocol.fromJson(json.decode(studyJson) as Map<String, dynamic>);
    expect(toJsonString(protocolFromJson), equals(studyJson));
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

  test('Deployment', () async {
    StudyProtocol trackPatientStudy = StudyProtocol(
      ownerId: 'abc@dtu.dk',
      name: 'Tracking',
    )..addPrimaryDevice(Smartphone());

    print(toJsonString(trackPatientStudy));

    Smartphone patientPhone =
        trackPatientStudy.primaryDevices.first as Smartphone;

    // This is called by `StudyService` when deploying a participant group.
    var invitation = ParticipantInvitation(
        participantId: const Uuid().v1(),
        assignedRoles: AssignedTo.all(),
        identity: EmailAccountIdentity("test@test.com"),
        invitation: StudyInvitation(
            "Movement study", "This study tracks your movements."));

    print(toJsonString(invitation));

    var registration = patientPhone.createRegistration(
      deviceId: "xxxxxxxxx",
      deviceDisplayName: "Pixel 6 Pro (Android 12)",
    );
    expect(registration, isNotNull);

    print(toJsonString(registration));
  });

  test('DataStreamsConfiguration -> JSON', () async {
    String studyDeploymentId = "c9cc5317-48da-45f2-958e-58bc07f34681";
    DataStreamsConfiguration configuration = DataStreamsConfiguration(
        studyDeploymentId: studyDeploymentId,
        expectedDataStreams: {
          ExpectedDataStream(
            deviceRoleName: 'phone',
            dataType: 'dk.cachet.carp.geolocation',
          ),
          ExpectedDataStream(
            deviceRoleName: 'phone',
            dataType: 'dk.cachet.carp.stepcount',
          ),
        });

    print(toJsonString(configuration));
    expect(configuration.expectedDataStreams, isNotEmpty);
  });

  test('DataStreamBatch -> JSON', () async {
    String studyDeploymentId = "c9cc5317-48da-45f2-958e-58bc07f34681";
    DataStreamBatch batch = DataStreamBatch(
      dataStream: DataStreamId(
          studyDeploymentId: studyDeploymentId,
          deviceRoleName: 'phone',
          dataType: 'dk.cachet.carp.geolocation'),
      firstSequenceId: 0,
      measurements: [
        Measurement(
            sensorStartTime: DateTime.now().millisecondsSinceEpoch,
            data: Geolocation(
              latitude: 55.68061908805645,
              longitude: 12.582050313435703,
            )
            // ..sensorSpecificData = SignalStrength(rssi: 23),
            ),
        Measurement(
          sensorStartTime: DateTime.now().millisecondsSinceEpoch,
          data: Geolocation(
            latitude: 55.680802203873114,
            longitude: 12.581802212861367,
          ),
        ),
      ],
      triggerIds: {0},
    );

    print(toJsonString(batch));
    expect(batch.measurements, isNotEmpty);
  });

  test('RequiredDataStreams -> JSON', () async {
    var streams = StudyDeployment(protocol).requiredDataStreams;
    print(toJsonString(streams));
    expect(streams.expectedDataStreams, isNotEmpty);
  });

  test('WebTask', () async {
    var task = WebTask(
        url:
            'https://cans.cachet.dk/portal/playground/studies/\$DEPLOYMENT_ID/settings?participant=\$PARTICIPANT_ID&trigger_id=\$TRIGGER_ID');

    expect(task.getUrl('12345-1234', 'ecec573e-442b-4563-8e2c-62b7693011df', 1),
        'https://cans.cachet.dk/portal/playground/studies/ecec573e-442b-4563-8e2c-62b7693011df/settings?participant=12345-1234&trigger_id=1');
  });
}
