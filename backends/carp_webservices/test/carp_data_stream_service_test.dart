import 'package:carp_serializable/carp_serializable.dart';
import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:carp_webservices/carp_auth/carp_auth.dart';
import 'package:carp_webservices/carp_services/carp_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/test.dart';

import 'carp_properties.dart';
import 'credentials.dart';

void main() {
  CarpUser? user;

  /// Runs once before all tests.
  setUpAll(() async {
    Settings().debugLevel = DebugLevel.debug;
    SharedPreferences.setMockInitialValues({});
    WidgetsFlutterBinding.ensureInitialized();
    CarpMobileSensing.ensureInitialized();

    await CarpAuthService().configure(CarpProperties().authProperties);
    CarpService().configure(CarpProperties().app);

    user = await CarpAuthService().authenticateWithUsernamePassword(
      username: username,
      password: password,
    );

    CarpDataStreamService().configureFrom(CarpService());
  });

  /// Runs once after all tests.
  tearDownAll(() {});

  group("Base services", () {
    test('- authentication', () async {
      debugPrint('CarpService : ${CarpService().app}');
      debugPrint(" - signed in as: $user");
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

        debugPrint(toJsonString(batch));

        await CarpDataStreamService()
            .appendToDataStreams(testDeploymentId, batch);
      },
    );

    test(
      '- append - measurements UNKNOWN to carp-core.kotlin',
      () async {
        debugPrint('Start uploading...');

        var m1 = Measurement(
          sensorStartTime: 1642505045000000,
          data: BatteryState(100),
        );
        var m2 = Measurement(
          sensorStartTime: 1642505045000000,
          data: BatteryState(100),
        );

        var batch = [
          DataStreamBatch(
              dataStream: DataStreamId(
                  studyDeploymentId: testDeploymentId,
                  deviceRoleName: phoneRoleName,
                  dataType: BatteryState.dataType),
              firstSequenceId: 0,
              measurements: [m1, m2],
              triggerIds: {0}),
        ];

        debugPrint(toJsonString(batch));

        await CarpDataStreamService()
            .appendToDataStreams(testDeploymentId, batch);
        debugPrint('Done uploading.');
      },
    );

    test(
      '- get',
      () async {
        debugPrint('Getting 100 ...');
        var list = await CarpDataStreamService().getDataStream(
          DataStreamId(
            studyDeploymentId: testDeploymentId,
            deviceRoleName: phoneRoleName,
            dataType: BatteryState.dataType,
          ),
          0,
          100,
        );
        debugPrint(toJsonString(list));
        debugPrint('N = ${list.length}');
      },
    );

    // Some test data
    List<DataStreamBatch> geoLocationBatch = [
      DataStreamBatch(
          dataStream: DataStreamId(
              studyDeploymentId: testDeploymentId,
              deviceRoleName: phoneRoleName,
              dataType: Geolocation.dataType),
          firstSequenceId: 0,
          measurements: [
            Measurement(
              sensorStartTime: 1642505045000000,
              data: Geolocation(
                  latitude: 55.68061908805645, longitude: 12.582050313435703)
                ..sensorSpecificData = SignalStrength(rssi: 0),
            ),
            Measurement(
                sensorStartTime: 1642505144000000,
                data: Geolocation(
                    latitude: 55.680802203873114,
                    longitude: 12.581802212861367)),
          ],
          triggerIds: {
            0
          })
    ];

    Future<List<DataStreamBatch>> getGeoLocationBatches() async =>
        await CarpDataStreamService().getDataStream(
          DataStreamId(
            studyDeploymentId: testDeploymentId,
            deviceRoleName: phoneRoleName,
            dataType: Geolocation.dataType,
          ),
          0,
          100,
        );

    // This test tests for data upload/download consistency as reported in Issue #16
    // - https://github.com/cph-cachet/carp-webservices-spring/issues/16
    test(
      '- upload & get - checking consistency (Issue #16)',
      () async {
        debugPrint('Getting Geolocation measurements ...');
        var list = await getGeoLocationBatches();
        debugPrint('N = ${list.length}');

        debugPrint('Uploading another batch of Geolocation measurements...');
        await CarpDataStreamService()
            .appendToDataStreams(testDeploymentId, geoLocationBatch);

        var list2 = await getGeoLocationBatches();
        debugPrint('N = ${list2.length}');

        expect(list2.length, list.length + 1);
      },
    );
  });
}
