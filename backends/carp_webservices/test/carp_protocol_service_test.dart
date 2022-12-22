import 'dart:convert';

import 'package:carp_serializable/carp_serializable.dart';
import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:carp_webservices/carp_auth/carp_auth.dart';
import 'package:carp_webservices/carp_services/carp_services.dart';
import 'package:test/test.dart';
import 'package:iso_duration_parser/iso_duration_parser.dart';

import 'credentials.dart';

void main() {
  CarpApp app;
  CarpUser? user;
  String? ownerId;
  late StudyProtocol protocol;
  late Smartphone phone;

  /// Runs once before all tests.
  setUpAll(() async {
    Settings().debugLevel = DebugLevel.DEBUG;

    // Initialization of serialization
    CarpMobileSensing();

    app = new CarpApp(
      // studyId: testStudyId,
      studyDeploymentId: testDeploymentId,
      name: "Test",
      uri: Uri.parse(uri),
      oauth: OAuthEndPoint(clientID: clientID, clientSecret: clientSecret),
    );

    CarpService().configure(app);

    user = await CarpService().authenticate(
      username: username,
      password: password,
    );

    CarpProtocolService().configureFrom(CarpService());
    ownerId = CarpService().currentUser!.accountId;
    phone = Smartphone(roleName: 'smartphone');

    // the study protocol from the json from core
    protocol = StudyProtocol(
        ownerId: ownerId!,
        name: 'Nonmotorized transport study II',
        description:
            'Track how much nonmotorized movement participants perform.')
      ..addPrimaryDevice(phone)
      ..addConnectedDevice(AltBeacon(roleName: "Participant's bike"));

    var trigger = ElapsedTimeTrigger(elapsedTime: IsoDuration.tryParse('PT0S'));

    protocol
      ..addTaskControl(
        trigger,
        BackgroundTask(
            name: 'Monitor movement',
            description: 'Track step count and geolocation for one week.',
            duration: IsoDuration.tryParse('PT168H'),
            measures: [
              Measure(type: 'dk.cachet.carp.geolocation'),
              Measure(type: 'dk.cachet.carp.stepcount'),
            ]),
        phone,
      )
      ..addTaskControl(
        trigger,
        BackgroundTask(
            name: 'Monitor proximity to bike',
            description: 'rack step count and geolocation for one week.',
            duration: IsoDuration.tryParse('PT168H'),
            measures: [
              Measure(type: 'dk.cachet.carp.signalstrength'),
            ]),
        phone,
      );

    protocol.addParticipantRole(ParticipantRole('Participant'));

    protocol.addExpectedParticipantData(
      ExpectedParticipantData(
        attribute:
            ParticipantAttribute(inputDataType: 'dk.cachet.carp.input.sex'),
        assignedTo: AssignedTo(roleNames: {'Participant'}),
      ),
    );

    protocol.applicationData = {'uiTheme': 'black'};
  });

  /// Runs once after all tests.
  tearDownAll(() {});

  group("Base services", () {
    test('- authentication', () async {
      print('CarpService : ${CarpService().app}');
      print(" - signed in as: $user");
      //expect(user.accountId, testParticipantId);
    });
  });

  /// To test the Protocol Service you must be authenticated as a RESEARCHER
  group("Protocol", () {
    test(
      '- add',
      () async {
        // print(toJsonString(protocol));
        await CarpProtocolService().add(protocol);
      },
    );

    test(
      '- addVersion',
      () async {
        protocol.id = testProtocolId;
        await CarpProtocolService().addVersion(protocol);
      },
    );

    test(
      '- getBy',
      () async {
        var p = await CarpProtocolService().getBy(testProtocolId);
        print(toJsonString(p));
      },
    );

    test(
      '- getAllFor',
      () async {
        List<StudyProtocol> protocols =
            await CarpProtocolService().getAllForOwner(ownerId!);
        print(toJsonString(protocols));
      },
    );

    test(
      '- getVersionHistoryFor',
      () async {
        List<ProtocolVersion> versions =
            await CarpProtocolService().getVersionHistoryFor(testProtocolId);
        print(toJsonString(versions));
      },
    );

    test(
      '- updateParticipantDataConfiguration',
      () async {
        var p = await CarpProtocolService().updateParticipantDataConfiguration(
          testProtocolId,
          testProtocolVersion,
          [
            ExpectedParticipantData(
              attribute: ParticipantAttribute(
                  inputDataType: 'dk.cachet.carp.input.sex'),
              // assignedTo: AssignedTo(roleNames: {'Participant'}),
            )
          ],
        );
        print(toJsonString(p));
      },
    );

    test(
      '- createCustomProtocol',
      skip: true,
      () async {
        StudyProtocol protocol =
            await CarpProtocolService().createCustomProtocol(
          ownerId!,
          'Custom Protocol Unit Test',
          'Made from Dart unit test.',
          '{"version":1}',
        );

        print(toJsonString(protocol));
      },
    );
  });
}
