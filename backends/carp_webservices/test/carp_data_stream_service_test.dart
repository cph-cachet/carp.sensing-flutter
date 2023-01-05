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

  /// Runs once before all tests.
  setUpAll(() async {
    Settings().debugLevel = DebugLevel.DEBUG;

    // Initialization of serialization
    CarpMobileSensing();

    app = new CarpApp(
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

    CarpDataStreamService().configureFrom(CarpService());
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

  group("Data Stream Service", () {
    test(
      '- append',
      () async {
        var m1 = Measurement(
            sensorStartTime: 1642505045000000,
            data: Geolocation(
                latitude: 55.68061908805645, longitude: 12.582050313435703)
            // ..sensorSpecificData = SignalStrength(rssi: 0),
            );
        var m2 = Measurement(
            sensorStartTime: 1642505144000000,
            data: Geolocation(
                latitude: 55.680802203873114, longitude: 12.581802212861367));
        var m3 = Measurement(
          sensorStartTime: 1642505045000000,
          data: StepCount(steps: 0),
        );
        var m4 = Measurement(
          sensorStartTime: 1642505144000000,
          data: StepCount(steps: 30),
        );

        var batch = [
          DataStreamBatch(
              dataStream: DataStreamId(
                  studyDeploymentId: testDeploymentId,
                  deviceRoleName: "smartphone",
                  dataType: "dk.cachet.carp.geolocation"),
              firstSequenceId: 0,
              measurements: [m1, m2],
              triggerIds: {0}),
          DataStreamBatch(
              dataStream: DataStreamId(
                  studyDeploymentId: testDeploymentId,
                  deviceRoleName: "smartphone",
                  dataType: "dk.cachet.carp.stepcount"),
              firstSequenceId: 0,
              measurements: [m3, m4],
              triggerIds: {0}),
        ];

        print(toJsonString(batch));

        // await CarpDataStreamService()
        //     .appendToDataStreams(testDeploymentId, batch);
      },
    );

    test(
      '- get',
      () async {
        var list = await CarpDataStreamService().getDataStream(
          DataStreamId(
            studyDeploymentId: testDeploymentId,
            deviceRoleName: "smartphone",
            dataType: 'dk.cachet.carp.geolocation',
          ),
          0,
          100,
        );
        print(toJsonString(list));
      },
    );
  });
}
