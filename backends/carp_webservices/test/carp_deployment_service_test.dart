import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:carp_webservices/carp_auth/carp_auth.dart';
import 'package:carp_webservices/carp_domain/carp_domain.dart';
import 'package:carp_webservices/carp_service/carp_service.dart';
import 'package:test/test.dart';

import 'credentials.dart';

String _encode(Object object) => const JsonEncoder.withIndent(' ').convert(object);

void main() {
  // CANS DEV
  final String uri = "http://cans.cachet.dk:8087";

  // CANS PROD
  //final String uri = "https://cans.cachet.dk:443";

  // from Barnabas / iPDM-GO test 2020-07-14
  //final String testDeploymentId = "d1f01720-1714-46ee-a16d-da2a566b979e";
  //final String testStudyId = "bc1d3178-c541-46f3-8af2-f313cc9d72fb";

  // from Richard / iPDM-GO test 2020-07-16
  //final String testDeploymentId = "d246170c-515e-40c3-8424-ec1f054f6ba4";
  //final String testStudyId = "64c1784d-52d1-4c3d-99de-24c97fe06939";

  // from Alban - production testing 2020-08-13
  //  final String testDeploymentId = "ab00aeda-9cd0-44d8-902c-9736fec24ab5";
  //  final String testStudyId = "c695ab41-e635-42d7-9b89-57530d0ae3da";

  // from Lori - production testing 2020-08-21
  //final String testDeploymentId = "bb9c2550-f6b7-4948-967f-2e62bdddd840";
  //final String testStudyId = "42ca52da-c768-44f3-9dc5-7f094c192892";

  // from Richard - new JSON model at DEV 2020-09-18
  //final String testStudyId = '682e11d1-ffb8-41fc-81c5-78d2e82fbe94';
  //final String testDeploymentId = 'e286e04b-31c5-4fb2-b4b0-db37c4510ae0';

  // from Richard - new study/deployment at DEV 2020-09-25
  // final String testStudyId = '19d79948-c4f3-4d0b-91c5-7f55a390e338';
  // final String testDeploymentId = '5b4a3a4d-87df-4c09-adf1-fd47e6a78cc7';

  // Generated from Postman script on DEV 2020-10-16
  final String testStudyId = 'f953dbd0-4681-4c56-beb7-2b71b52e7bc3';
  final String testDeploymentId = '234c1392-3e43-4dec-8556-6e0e1055412f';

  final String userId = "user@dtu.dk";

  CarpApp app;
  CarpUser user;
  Study study;

  /// Setup CARP and authenticate.
  /// Runs once before all tests.
  setUpAll(() async {
    study = new Study(testStudyId, userId, deploymentId: testDeploymentId, name: "Test study");
    app = new CarpApp(
      study: study,
      name: "Test",
      uri: Uri.parse(uri),
      oauth: OAuthEndPoint(clientID: clientID, clientSecret: clientSecret),
    );

    CarpService.configure(app);

    user = await CarpService.instance.authenticate(
      username: username,
      password: password,
    );
  });

  /// Close connection to CARP.
  /// Runs once after all tests.
  tearDownAll(() {});

  group("Deployment", () {
    DeploymentReference deploymentReference;

    test('- authentication', () async {
      print('CarpService : ${CarpService.instance.app}');
      print(" - signed in as: $user");
    }, skip: false);

    test('- device ID', () async {
      String id = CarpService.instance.deployment().deviceId;
      print('Device ID : $id');
    }, skip: false);

    test('- get invitations for this account (user)', () async {
      List<ActiveParticipationInvitation> invitations = await CarpService.instance.invitations();
      invitations.forEach((invitation) => print(invitation));
      //assert(invitations.length > 0);
    }, skip: false);

    test('- get deployment status', () async {
      StudyDeploymentStatus status = await CarpService.instance.deployment().getStatus();
      print(_encode(status.toJson()));
      print(status);
      print(status.masterDeviceStatus.device);
      expect(status.studyDeploymentId, study.deploymentId);
    }, skip: false);

    test('- register device', () async {
      DeploymentReference reference = CarpService.instance.deployment();
      StudyDeploymentStatus status = await reference.getStatus();
      print(status);
      expect(status.masterDeviceStatus.device, isNotNull);
      print(status.masterDeviceStatus.device);
      status = await reference.registerDevice(deviceRoleName: status.masterDeviceStatus.device.roleName);
      print(status);
      expect(status.studyDeploymentId, study.deploymentId);
    }, skip: false);

    test('- get master device deployment', () async {
      DeploymentReference reference = CarpService.instance.deployment();
      StudyDeploymentStatus status = await reference.getStatus();
      print(status);
      expect(status.masterDeviceStatus.device, isNotNull);
      print(status.masterDeviceStatus.device);
      MasterDeviceDeployment deployment = await reference.get();
      print(deployment);
      expect(deployment.configuration.deviceId, isNotNull);
    }, skip: false);

    test('- deployment success', () async {
      DeploymentReference reference = CarpService.instance.deployment();
      StudyDeploymentStatus status_1 = await reference.getStatus();
      MasterDeviceDeployment deployment = await reference.get();
      StudyDeploymentStatus status_2 = await reference.success();
      print(status_2);
      expect(status_1.studyDeploymentId, status_2.studyDeploymentId);
      expect(status_2.studyDeploymentId, study.deploymentId);
    }, skip: false);

    test('- unregister device', () async {
      DeploymentReference reference = CarpService.instance.deployment();
      StudyDeploymentStatus status = await reference.getStatus();
      print(status);
      expect(status.masterDeviceStatus.device, isNotNull);
      print(status.masterDeviceStatus.device);
      status = await reference.unRegisterDevice(deviceRoleName: status.masterDeviceStatus.device.roleName);
      print(status);
      expect(status.studyDeploymentId, study.deploymentId);
    }, skip: false);
  }, skip: true);
}
