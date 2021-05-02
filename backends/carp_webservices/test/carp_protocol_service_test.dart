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
  String ownerId;

  /// Setup CARP and authenticate.
  /// Runs once before all tests.
  setUpAll(() async {
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
    // CANSParticipationService().configureFrom(CarpService());
    // CANSDeploymentService().configureFrom(CarpService());
    CANSProtocolService().configureFrom(CarpService());

    StudyProtocol();
    CAMSStudyProtocol();
    FromJsonFactory();
  });

  /// Close connection to CARP.
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
      () async {},
    );

    test(
      '- addVersion',
      () async {},
    );

    test(
      '- updateParticipantDataConfiguration',
      () async {},
    );

    test(
      '- getBy',
      () async {},
    );

    test(
      '- getAllFor',
      () async {},
    );

    test(
      '- getVersionHistoryFor',
      () async {},
    );

    test(
      '- createCustomProtocol',
      () async {
        StudyProtocol protocol =
            await CANSProtocolService().createCustomProtocol(
          ownerId,
          'Test Protocol',
          'Made from Dart unit test.',
          '{"version":1}',
        );

        print(protocol);
      },
    );
  });
}
