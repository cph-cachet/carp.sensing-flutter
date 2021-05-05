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

    CANSParticipationService().configureFrom(CarpService());
    CANSDeploymentService().configureFrom(CarpService());
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

    test('- device ID', () async {
      String id = CANSDeploymentService().deployment().registeredDeviceId;
      print('Registered Device ID : $id');
    }, skip: false);
  });

  group("Participation - deployment id: $testDeploymentId", () {
    test(
      '- get invitations for this account (user)',
      () async {
        List<ActiveParticipationInvitation> invitations =
            await CANSParticipationService()
                .getActiveParticipationInvitations();
        invitations.forEach((invitation) => print(invitation));
        assert(invitations.length > 0);
        // print(_encode(invitations));
      },
      skip: false,
    );

    test(
      '- get participant data',
      () async {
        ParticipationReference participation =
            CANSParticipationService().participation(testDeploymentId);

        ParticipantData data = await participation.getParticipantData();
        print(_encode(data));
        assert(data != null);
      },
      skip: false,
    );

    test(
      '- set participant data',
      () async {
        ParticipationReference participation =
            CANSParticipationService().participation(testDeploymentId);

        ParticipantData data_1 = ParticipantData(
          studyDeploymentId: testDeploymentId,
          data: {'name': 'Ole Pedersen'},
        );

        print(_encode(data_1));

        ParticipantData data_2 = await participation.setParticipantData(
          'dk.cachet.carp.input.name',
          data_1,
        );
        print(_encode(data_2));

        // expect();

        // ParticipantData data = await participation.getParticipantData();
        // print(_encode(data));
        // assert(data != null);
      },
      skip: false,
    );
  });

  group("Deployment - using DeploymentReference", () {
    test('- get deployment status', () async {
      StudyDeploymentStatus status =
          await CANSDeploymentService().deployment().getStatus();
      print(_encode(status.toJson()));
      print(status);
      print(status.masterDeviceStatus.device);
      print(_encode(status));
      expect(status.studyDeploymentId, testDeploymentId);
    }, skip: false);

    test('- register device', () async {
      DeploymentReference reference =
          CANSDeploymentService().deployment(testDeploymentId);
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
          CANSDeploymentService().deployment(testDeploymentId);
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
          CANSDeploymentService().deployment(testDeploymentId);
      StudyDeploymentStatus status_1 = await reference.getStatus();
      MasterDeviceDeployment deployment = await reference.get();
      StudyDeploymentStatus status_2 = await reference.success();
      print(deployment);
      print(status_2);
      expect(status_1.studyDeploymentId, status_2.studyDeploymentId);
      expect(status_2.studyDeploymentId, testDeploymentId);
    }, skip: false);

    test('- unregister device', () async {
      DeploymentReference reference =
          CANSDeploymentService().deployment(testDeploymentId);
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

  group("Deployment - using CANSDeploymentService()", () {
    test('- get deployment status', () async {
      StudyDeploymentStatus status = await CANSDeploymentService()
          .getStudyDeploymentStatus(testDeploymentId);
      print(_encode(status.toJson()));
      print(status);
      print(status.masterDeviceStatus.device);
      print(_encode(status));
      expect(status.studyDeploymentId, testDeploymentId);
    }, skip: false);

    test('- register device', () async {
      StudyDeploymentStatus status = await CANSDeploymentService()
          .getStudyDeploymentStatus(testDeploymentId);
      print(status);
      expect(status.masterDeviceStatus.device, isNotNull);
      print(status.masterDeviceStatus.device);
      status = await CANSDeploymentService().registerDevice(testDeploymentId,
          status.masterDeviceStatus.device.roleName, DeviceRegistration());
      print(status);
      expect(status.studyDeploymentId, testDeploymentId);
    }, skip: false);

    test('- get master device deployment', () async {
      StudyDeploymentStatus status = await CANSDeploymentService()
          .getStudyDeploymentStatus(testDeploymentId);
      print(status);
      expect(status.masterDeviceStatus.device, isNotNull);
      print(status.masterDeviceStatus.device);
      MasterDeviceDeployment deployment =
          await CANSDeploymentService().getDeviceDeploymentFor(
        testDeploymentId,
        status.masterDeviceStatus.device.roleName,
      );
      print(deployment);
      deployment.tasks.forEach((task) {
        print(task);
        task?.measures?.forEach(print);
      });
      expect(deployment.configuration.deviceId, isNotNull);
    }, skip: false);

    test('- deployment success', () async {
      StudyDeploymentStatus status_1 = await CANSDeploymentService()
          .getStudyDeploymentStatus(testDeploymentId);
      print(status_1);
      expect(status_1.masterDeviceStatus.device, isNotNull);
      print(status_1.masterDeviceStatus.device);
      MasterDeviceDeployment deployment =
          await CANSDeploymentService().getDeviceDeploymentFor(
        testDeploymentId,
        status_1.masterDeviceStatus.device.roleName,
      );
      print(deployment);

      StudyDeploymentStatus status_2 =
          await CANSDeploymentService().deploymentSuccessfulFor(
        testDeploymentId,
        status_1.masterDeviceStatus.device.roleName,
        deployment.lastUpdateDate,
      );
      print(status_2);
      expect(status_1.studyDeploymentId, status_2.studyDeploymentId);
      expect(status_2.studyDeploymentId, testDeploymentId);
    });

    test('- unregister device', () async {
      DeploymentReference reference =
          CANSDeploymentService().deployment(testDeploymentId);
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
}
