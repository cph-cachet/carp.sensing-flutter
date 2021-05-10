import 'dart:convert';
import 'dart:io';
import 'package:test/test.dart';

import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
// import 'package:carp_connectivity_package/connectivity.dart';
import 'package:carp_esense_package/esense.dart';
import 'package:carp_context_package/context.dart';
import 'package:carp_audio_package/audio.dart';
import 'package:carp_backend/carp_backend.dart';
import 'package:carp_webservices/carp_auth/carp_auth.dart';
import 'package:carp_webservices/carp_services/carp_services.dart';

import '../lib/main.dart';
import 'credentials.dart';

String _encode(Object object) =>
    const JsonEncoder.withIndent(' ').convert(object);

void main() {
  // creating an empty protocol to initialize json serialization
  CAMSStudyProtocol protocol = CAMSStudyProtocol();
  Smartphone phone;
  ESenseDevice eSense;

  setUp(() async {
    // register the eSense sampling package since we're using eSense measures
    // SamplingPackageRegistry().register(ConnectivitySamplingPackage());
    SamplingPackageRegistry().register(ContextSamplingPackage());
    SamplingPackageRegistry().register(AudioSamplingPackage());
    SamplingPackageRegistry().register(ESenseSamplingPackage());

    // Define which devices are used for data collection.
    phone = Smartphone();
    eSense = ESenseDevice();
  });

  group("Local Study Protocol Manager", () {
    setUp(() async {
      // Create a new study protocol.
      protocol = await LocalStudyProtocolManager().getStudyProtocol('1234');
    });

    test('CAMSStudyProtocol -> JSON', () async {
      print(protocol);
      print(toJsonString(protocol));
      expect(protocol.ownerId, 'AB');
    });

    test('StudyProtocol -> JSON -> StudyProtocol :: deep assert', () async {
      print('#1 : $protocol');
      final studyJson = toJsonString(protocol);

      CAMSStudyProtocol protocolFromJson = CAMSStudyProtocol.fromJson(
          json.decode(studyJson) as Map<String, dynamic>);
      expect(toJsonString(protocolFromJson), equals(studyJson));
      print('#2 : $protocolFromJson');
    });

    test('JSON File -> StudyProtocol', () async {
      // Read the study protocol from json file
      String plainJson =
          File('test/json/cams_study_protocol.json').readAsStringSync();

      CAMSStudyProtocol protocol = CAMSStudyProtocol.fromJson(
          json.decode(plainJson) as Map<String, dynamic>);

      expect(protocol.ownerId, 'AB');
      expect(protocol.masterDevices.first.roleName, phone.roleName);
      expect(protocol.connectedDevices.first.roleName, eSense.roleName);
      print(toJsonString(protocol));
    });
  });

  group("Data points", () {
    test(' -> JSON', () async {
      ESenseButtonDatum datum = ESenseButtonDatum()
        ..pressed = true
        ..deviceName = 'eSense-123';

      final DataPoint data = DataPoint.fromData(datum);
      expect(data.carpHeader.dataFormat.namespace,
          ESenseSamplingPackage.ESENSE_NAMESPACE);

      print(_encode(data.toJson()));
    });
  });

  CarpApp app;
  CarpUser user;
  CarpStudyProtocolManager manager = CarpStudyProtocolManager();

  group("CARP Study Protocol Manager", () {
    setUp(() async {
      app = new CarpApp(
        name: "Test",
        studyId: testStudyId,
        uri: Uri.parse(uri),
        oauth: OAuthEndPoint(clientID: clientID, clientSecret: clientSecret),
      );

      CarpService().configure(app);
      await manager.initialize();

      user = await CarpService().authenticate(
        username: username,
        password: password,
      );
    });

    test('- authentication', () async {
      print('CarpService : ${CarpService().app}');
      print(" - signed in as: $user");
      expect(user.accountId, accountId);
    });

    test('- get study protocol', () async {
      CAMSStudyProtocol study =
          await manager.getStudyProtocol(testDeploymentId);
      print('study: $study');
      print(_encode(study));
    }, skip: false);
  });
}
