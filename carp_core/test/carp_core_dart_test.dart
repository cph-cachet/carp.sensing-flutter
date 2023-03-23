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

    Smartphone phone = Smartphone(roleName: 'phone');
    Smartphone phone_2 = Smartphone(roleName: 'phone_2');
    final monitor = DefaultDeviceConfiguration(roleName: 'hr_monitor');
    final bike = DefaultDeviceConfiguration(roleName: 'bike');
    // final monitor = AltBeacon(roleName: 'hr_monitor');
    // final bike = AltBeacon(roleName: 'bike');

    protocol
      ..addPrimaryDevice(phone)
      ..addPrimaryDevice(phone_2)
      ..addConnectedDevice(monitor, phone)
      ..addConnectedDevice(bike, phone);

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
      phone,
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
      monitor,
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
      bike,
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
      phone,
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
  });

  test('Add Request -> JSON', () async {
    print(toJsonString(Add(protocol)));
    // expect(toJsonString(expected), toJsonString(request));
  });

  test('JSON -> StudyProtocol', () async {
    // Read the study protocol from json file
    String plainJson =
        File('test/json/carp.core-dart/study_protocol.json').readAsStringSync();

    StudyProtocol protocol =
        StudyProtocol.fromJson(json.decode(plainJson) as Map<String, dynamic>);

    expect(protocol.ownerId, 'xyz@dtu.dk');
    expect(protocol.primaryDevices.first.roleName, 'phone');
    print(toJsonString(protocol));
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

  // test('DataPoint -> JSON', () async {
  //   DataPoint dataPoint = DataPoint(
  //     DataPointHeader(
  //       studyId: '1234',
  //       dataFormat: const DataType(NameSpace.CARP, 'light'),
  //     ),
  //     Data(),
  //   );

  //   print(dataPoint);
  //   print(jsonEncode(dataPoint));
  //   print(toJsonString(dataPoint));
  //   assert(dataPoint.carpBody != null);
  // });

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
}
