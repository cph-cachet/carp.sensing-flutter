import 'dart:convert';

import 'package:carp_serializable/carp_serializable.dart';
import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:carp_webservices/carp_auth/carp_auth.dart';
import 'package:carp_webservices/carp_services/carp_services.dart';
import 'package:test/test.dart';
import 'package:iso_duration_parser/iso_duration_parser.dart';

import 'credentials.dart';

String _encode(Object object) =>
    const JsonEncoder.withIndent(' ').convert(object);

void main() {
  CarpApp app;
  CarpUser? user;
  String? ownerId, name;
  late StudyProtocol protocol, custom;

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
    name = 'test_protocol';

    // a very simple protocol
    protocol = StudyProtocol(
        ownerId: ownerId!,
        name: name!,
        description: 'Generated from carp_webservices unit test.')
      ..addPrimaryDevice(Smartphone(roleName: 'smartphone'));

    // a custom protocol
    var customDevice = CustomProtocolDevice(roleName: 'Custom device');
    custom = StudyProtocol(
        ownerId: ownerId!,
        name: 'custom_test_protocol',
        description:
            'Custom protocol generated from carp_webservices unit test.');
    custom.addPrimaryDevice(customDevice);
    custom.addTaskControl(
        ElapsedTimeTrigger(
            sourceDeviceRoleName: customDevice.roleName,
            elapsedTime: IsoDuration(seconds: 0)),
        CustomProtocolTask(
            name: 'Custom device task', studyProtocol: '{"version":"1.0"}'),
        customDevice);
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
        print(toJsonString(protocol));
        await CarpProtocolService().add(protocol);
      },
    );

    test(
      '- add custom',
      () async {
        print(toJsonString(custom!));
        await CarpProtocolService().add(custom, '1.3');
      },
    );

    test(
      '- addVersion',
      () async {
        await CarpProtocolService().addVersion(custom);
      },
    );

    test(
      '- updateParticipantDataConfiguration',
      () async {},
    );

    test(
      '- getBy',
      () async {
        var p = await CarpProtocolService().getBy(protocol.id);
        print(p);
      },
    );

    test(
      '- getAllFor',
      () async {
        List<StudyProtocol> protocols =
            await CarpProtocolService().getAllForOwner(ownerId!);
        print(protocols);
      },
    );

    test(
      '- getVersionHistoryFor',
      () async {
        List<ProtocolVersion> versions =
            await CarpProtocolService().getVersionHistoryFor(protocol.id);
        print(versions);
      },
    );

    test(
      '- createCustomProtocol',
      () async {
        StudyProtocol protocol =
            await CarpProtocolService().createCustomProtocol(
          ownerId!,
          name!,
          'Made from Dart unit test.',
          '{"version":1}',
        );

        print(_encode(protocol));
      },
    );
  });
}
