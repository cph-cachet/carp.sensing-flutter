import 'dart:convert';

import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:carp_webservices/carp_auth/carp_auth.dart';
import 'package:carp_webservices/carp_services/carp_services.dart';
import 'package:test/test.dart';

import 'credentials.dart';

String _encode(Object object) =>
    const JsonEncoder.withIndent(' ').convert(object);

void main() {
  CarpApp app;
  CarpUser user;
  String ownerId, name;

  /// Setup CARP and authenticate.
  /// Runs once before all tests.
  setUpAll(() async {
    Settings().debugLevel = DebugLevel.DEBUG;

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

    ownerId = CarpService().currentUser.accountId;
    name = 'test_protocol';
    CANSProtocolService().configureFrom(CarpService());
  });

  /// Runs once after all tests.
  tearDownAll(() {});

  group("Base services", () {
    test('- authentication', () async {
      print('CarpService : ${CarpService().app}');
      print(" - signed in as: $user");
      //expect(user.accountId, testParticipantId);
    }, skip: false);
  });

  group("Protocol", () {
    test(
      '- add',
      () async {
        StudyProtocol protocol = StudyProtocol(
            ownerId: ownerId,
            name: '$name-1.1',
            description: 'Generated from carp_webservices unit test.')
          ..addMasterDevice(Smartphone(roleName: 'smartphone'));

        await CANSProtocolService().add(protocol, '1.1');
      },
    );

    test(
      '- add custom protocol',
      () async {
        // StudyProtocol protocol =
        //     await CANSProtocolService().createCustomProtocol(
        //   ownerId,
        //   name,
        //   'Made from Dart unit test.',
        //   '{"version":1}',
        // );

        var customDevice = CustomProtocolDevice(roleName: 'Custom device');

        StudyProtocol protocol = StudyProtocol(
            ownerId: ownerId,
            name: '$name',
            description: 'Generated from carp_webservices unit test.');
        protocol.addMasterDevice(customDevice);
        protocol.addTriggeredTask(
            ElapsedTimeTrigger(
                sourceDeviceRoleName: customDevice.roleName,
                elapsedTime: Duration(seconds: 0)),
            CustomProtocolTask(
                name: 'Custom device task', studyProtocol: '{"version":"1.0"}'),
            customDevice);

        await CANSProtocolService().add(protocol, '1.3');
      },
    );

    test(
      '- addVersion',
      () async {
        StudyProtocol protocol =
            await CANSProtocolService().createCustomProtocol(
          ownerId,
          name,
          'Made from Dart unit test.',
          '{"version":2}',
        );

        await CANSProtocolService().addVersion(protocol);
      },
    );

    test(
      '- updateParticipantDataConfiguration',
      () async {},
    );

    test(
      '- getBy',
      () async {
        StudyProtocol protocol =
            await CANSProtocolService().getBy(StudyProtocolId(ownerId, name));
        print(protocol);
      },
    );

    test(
      '- getAllFor',
      () async {
        List<StudyProtocol> protocols =
            await CANSProtocolService().getAllFor(ownerId);
        print(protocols);
      },
    );

    test(
      '- getVersionHistoryFor',
      () async {
        List<ProtocolVersion> versions = await CANSProtocolService()
            .getVersionHistoryFor(StudyProtocolId(ownerId, name));
        print(versions);
      },
    );

    test(
      '- createCustomProtocol',
      () async {
        StudyProtocol protocol =
            await CANSProtocolService().createCustomProtocol(
          ownerId,
          name,
          'Made from Dart unit test.',
          '{"version":1}',
        );

        print(_encode(protocol));
      },
    );
  });
}
