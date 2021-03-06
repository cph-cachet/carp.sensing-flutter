import 'dart:convert';

import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:carp_webservices/carp_auth/carp_auth.dart';
import 'package:carp_webservices/carp_domain/carp_domain.dart';
import 'package:carp_webservices/carp_service/carp_service.dart';
import 'package:test/test.dart';
import 'package:carp_backend/carp_backend.dart';

import 'credentials.dart';

String _encode(Object object) =>
    const JsonEncoder.withIndent(' ').convert(object);

void main() {
  CarpApp app;
  CarpUser user;
  CarpStudyManager manager = CarpStudyManager();

  /// Setup CARP and authenticate.
  /// Runs once before all tests.
  setUpAll(() async {
    app = new CarpApp(
      name: "Test",
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

  /// Close connection to CARP.
  /// Runs once after all tests.
  tearDownAll(() {});

  group("Deployment", () {
    test('- authentication', () async {
      print('CarpService : ${CarpService().app}');
      print(" - signed in as: $user");
      //expect(user.accountId, testParticipantId);
    }, skip: false);

    test('- get invitations for this account (user)', () async {
      List<ActiveParticipationInvitation> invitations =
          await CarpService().invitations();
      invitations.forEach((invitation) => print(invitation));
      //assert(invitations.length > 0);
    }, skip: false);

    test('- get deployment status', () async {
      CarpService().app.studyDeploymentId = testDeploymentId;

      StudyDeploymentStatus status =
          await CarpService().deployment().getStatus();
      print(_encode(status.toJson()));
      print(status);
      print(status.masterDeviceStatus.device);
      expect(status.studyDeploymentId, testDeploymentId);
    }, skip: false);

    test('- register device', () async {
      DeploymentReference reference =
          CarpService().deployment(testDeploymentId);
      StudyDeploymentStatus status = await reference.getStatus();
      print(status);
      expect(status.masterDeviceStatus.device, isNotNull);
      print(status.masterDeviceStatus.device);
      status = await reference.registerDevice(
          deviceRoleName: status.masterDeviceStatus.device.roleName);
      print(status);
      expect(status.studyDeploymentId, testDeploymentId);
    }, skip: false);

    test('- get master device deployment', () async {
      DeploymentReference reference =
          CarpService().deployment(testDeploymentId);
      StudyDeploymentStatus status = await reference.getStatus();
      print(status);
      expect(status.masterDeviceStatus.device, isNotNull);
      print(status.masterDeviceStatus.device);
      MasterDeviceDeployment deployment = await reference.get();
      print(deployment);
      deployment.tasks.forEach((task) {
        print(task);
        task?.measures?.forEach(print);
      });
      expect(deployment.configuration.deviceId, isNotNull);
    }, skip: false);

    test('- deployment success', () async {
      DeploymentReference reference =
          CarpService().deployment(testDeploymentId);
      StudyDeploymentStatus status_1 = await reference.getStatus();
      MasterDeviceDeployment deployment = await reference.get();
      print(deployment);
      StudyDeploymentStatus status_2 = await reference.success();
      print(status_2);
      expect(status_1.studyDeploymentId, status_2.studyDeploymentId);
      expect(status_2.studyDeploymentId, testDeploymentId);
    }, skip: false);

    test('- unregister device', () async {
      DeploymentReference reference =
          CarpService().deployment(testDeploymentId);
      StudyDeploymentStatus status = await reference.getStatus();
      print(status);
      expect(status.masterDeviceStatus.device, isNotNull);
      print(status.masterDeviceStatus.device);
      status = await reference.unRegisterDevice(
          deviceRoleName: status.masterDeviceStatus.device.roleName);
      print(status);
      expect(status.studyDeploymentId, testDeploymentId);
    }, skip: false);
  }, skip: true);

  group("Study Manager", () {
    test('- get study', () async {
      Study study = await manager.getStudy(testDeploymentId);
      print('study: $study');
      print(_encode(study));
    }, skip: false);
  });
}
