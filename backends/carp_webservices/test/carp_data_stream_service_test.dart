import 'package:carp_serializable/carp_serializable.dart';
import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:carp_webservices/carp_auth/carp_auth.dart';
import 'package:carp_webservices/carp_services/carp_services.dart';
import 'package:test/test.dart';

import 'carp_properties.dart';
import 'credentials.dart';

void main() {
  CarpApp app;
  CarpAuthProperties authProperties;
  CarpUser? mockUser;

  /// Runs once before all tests.
  setUpAll(() async {
    Settings().debugLevel = DebugLevel.debug;

    // Initialization of serialization
    CarpMobileSensing.ensureInitialized();

    authProperties = CarpProperties().authProperties;
    app = CarpProperties().app;

    await CarpAuthService().configure(authProperties);
    CarpService().configure(app);

    await CarpAuthService().authenticateWithUsernamePassword(
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
      print(" - signed in as: $mockUser");
      //expect(user.accountId, testParticipantId);
    }, skip: false);
  });

  group("Data Stream Service", () {
    test(
      '- append - measurements KNOWN to carp-core.kotlin',
      () async {
        var m1 = Measurement(
          sensorStartTime: 1642505045000000,
          data: Geolocation(
              latitude: 55.68061908805645, longitude: 12.582050313435703)
            ..sensorSpecificData = SignalStrength(rssi: 0),
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
                  deviceRoleName: phoneRoleName,
                  dataType: Geolocation.dataType),
              firstSequenceId: 0,
              measurements: [m1, m2],
              triggerIds: {0}),
          DataStreamBatch(
              dataStream: DataStreamId(
                  studyDeploymentId: testDeploymentId,
                  deviceRoleName: phoneRoleName,
                  dataType: StepCount.dataType),
              firstSequenceId: 0,
              measurements: [m3, m4],
              triggerIds: {0}),
        ];

        print(toJsonString(batch));

        await CarpDataStreamService()
            .appendToDataStreams(testDeploymentId, batch);
      },
    );

    test(
      '- append - measurements UNKNOWN to carp-core.kotlin',
      () async {
        var m1 = Measurement(
            sensorStartTime: 1642505045000000,
            data: Heartbeat(
                period: 5,
                deviceType: 'carp_webservices_unit_test',
                deviceRoleName: 'smartphone'));
        var m2 = Measurement(
            sensorStartTime: 1642505045000000,
            data: Heartbeat(
                period: 5,
                deviceType: 'carp_webservices_unit_test',
                deviceRoleName: 'smartphone'));
        var m3 = Measurement(
          sensorStartTime: 1642505045000000,
          data: BatteryState(100),
        );
        var m4 = Measurement(
          sensorStartTime: 1642505045000000,
          data: BatteryState(100),
        );

        var batch = [
          // can't add heartbeat measurements to this study, since it's not part of the protocol
          //         studyDeploymentId: testDeploymentId,
          //         deviceRoleName: phoneRoleName,
          //         dataType: Heartbeat.dataType),
          //     firstSequenceId: 0,
          //     measurements: [m1, m2],
          //     triggerIds: {0}),
          DataStreamBatch(
              dataStream: DataStreamId(
                  studyDeploymentId: testDeploymentId,
                  deviceRoleName: phoneRoleName,
                  dataType: BatteryState.dataType),
              firstSequenceId: 0,
              measurements: [m3, m4],
              triggerIds: {0}),
        ];

        print(toJsonString(batch));

        await CarpDataStreamService()
            .appendToDataStreams(testDeploymentId, batch);
      },
    );

    test(
      '- get',
      () async {
        var list = await CarpDataStreamService().getDataStream(
          DataStreamId(
            studyDeploymentId: testDeploymentId,
            deviceRoleName: phoneRoleName,
            dataType: 'dk.cachet.carp.geolocation',
          ),
          0,
          100,
        );
        print(toJsonString(list));
        print('N = ${list.length}');
      },
    );
  });
}
