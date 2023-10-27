import 'package:carp_serializable/carp_serializable.dart';
import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:carp_webservices/carp_auth/carp_auth.dart';
import 'package:carp_webservices/carp_services/carp_services.dart';
import 'package:test/test.dart';

import 'credentials.dart';
import 'mock_authentication_service.dart';

void main() {
  CarpApp app;
  CarpUser? mockUser;

  /// Setup CARP and authenticate.
  /// Runs once before all tests.
  setUpAll(() async {
    Settings().debugLevel = DebugLevel.debug;

    // Initialization of serialization
    CarpMobileSensing();

    app = MockAuthenticationService().app;
    CarpService().configure(app);

    CarpUser mockUser = await MockAuthenticationService().authenticate(
      username: username,
      password: password,
    );
    CarpService().currentUser = mockUser;


    CarpParticipationService().configureFrom(CarpService());
    CarpDeploymentService().configureFrom(CarpService());
  });

  /// Close connection to CARP.
  /// Runs once after all tests.
  tearDownAll(() {});

  group("Base services", () {
    test('- authentication', () async {
      print('CarpService : ${CarpService().app}');
      print(" - signed in as: $mockUser");
      //expect(user.accountId, testParticipantId);
    }, skip: false);

    test('- device ID', () async {
      String id = CarpDeploymentService().deployment().registeredDeviceId;
      print('Registered Device ID : $id');
    }, skip: false);
  });

  group("Participation", () {
    test(
      '- get invitations for this user',
      () async {
        List<ActiveParticipationInvitation> invitations =
            await CarpParticipationService()
                .getActiveParticipationInvitations();
        for (var invitation in invitations) {
          print(invitation);
        }
        expect(invitations, isNotNull);
        print(toJsonString(invitations));
      },
      skip: false,
    );

    test(
      '- get participant data',
      () async {
        ParticipationReference participation =
            CarpParticipationService().participation(testDeploymentId);

        ParticipantData data = await participation.getParticipantData();
        print(toJsonString(data));
      },
      skip: false,
    );

    test(
      '- set participant data',
      () async {
        ParticipationReference participation =
            CarpParticipationService().participation(testDeploymentId);

        ParticipantData data = await participation.setParticipantData(
          {SexInput.type: SexInput(value: Sex.Male)},
          'Participant',
        );
        print(toJsonString(data));

        // expect();

        // ParticipantData data = await participation.getParticipantData();
        // print(toJsonString(data));
        // assert(data != null);
      },
      skip: false,
    );
  });

  group("Deployment - using DeploymentReference", () {
    test('- get deployment status', () async {
      final status = await CarpDeploymentService().deployment().getStatus();
      print(toJsonString(status));
      expect(status.studyDeploymentId, testDeploymentId);
    });

    test('- register device', () async {
      final reference = CarpDeploymentService().deployment(testDeploymentId);
      var status = await reference.getStatus();
      print(status);

      expect(status.primaryDeviceStatus!.device, isNotNull);
      print(status.primaryDeviceStatus!.device);
      var newStatus = await reference.registerPrimaryDevice();
      print(newStatus);
      expect(newStatus.studyDeploymentId, testDeploymentId);
    }, skip: false);

    test('- get primary device deployment', () async {
      final reference = CarpDeploymentService().deployment(testDeploymentId);
      final status = await reference.getStatus();
      print(status);
      expect(status.primaryDeviceStatus!.device, isNotNull);
      print(status.primaryDeviceStatus!.device);

      PrimaryDeviceDeployment deployment = await reference.get();
      print(toJsonString(deployment));
      expect(deployment.registration.deviceId, isNotNull);
    }, skip: false);

    test('- deployment success', () async {
      final reference = CarpDeploymentService().deployment(testDeploymentId);
      final status_1 = await reference.getStatus();
      print(toJsonString(status_1));

      final deployment = await reference.get();
      final status_2 = await reference.deployed();
      print(toJsonString(deployment));
      print(toJsonString(status_2));
      expect(status_1.studyDeploymentId, status_2.studyDeploymentId);
      expect(status_2.studyDeploymentId, testDeploymentId);
    }, skip: false);

    test('- unregister device', () async {
      final reference = CarpDeploymentService().deployment(testDeploymentId);
      var status = await reference.getStatus();
      print(status);
      expect(status.primaryDeviceStatus!.device, isNotNull);
      print(status.primaryDeviceStatus!.device);
      status = await reference.unRegisterDevice(
          deviceRoleName: status.primaryDeviceStatus!.device.roleName);
      print(status);
      expect(status.studyDeploymentId, testDeploymentId);
    }, skip: false);
  }, skip: true);

  group("Deployment - using CarpDeploymentService", () {
    test('- get deployment status', () async {
      StudyDeploymentStatus status = await CarpDeploymentService()
          .getStudyDeploymentStatus(testDeploymentId);
      print(toJsonString(status.toJson()));
      print(status);
      print(status.primaryDeviceStatus!.device);
      print(toJsonString(status));
      expect(status.studyDeploymentId, testDeploymentId);
    }, skip: false);

    test('- register device', () async {
      StudyDeploymentStatus status = await CarpDeploymentService()
          .getStudyDeploymentStatus(testDeploymentId);
      print(status);
      expect(status.primaryDeviceStatus!.device, isNotNull);
      print(status.primaryDeviceStatus!.device);
      status = await CarpDeploymentService().registerDevice(
          testDeploymentId,
          status.primaryDeviceStatus!.device.roleName,
          DefaultDeviceRegistration(deviceDisplayName: 'Samsung A10'));
      print(status);
      expect(status.studyDeploymentId, testDeploymentId);
    }, skip: false);

    test('- get primary device deployment', () async {
      StudyDeploymentStatus status = await CarpDeploymentService()
          .getStudyDeploymentStatus(testDeploymentId);
      print(status);
      expect(status.primaryDeviceStatus!.device, isNotNull);
      print(status.primaryDeviceStatus!.device);
      PrimaryDeviceDeployment deployment =
          await CarpDeploymentService().getDeviceDeploymentFor(
        testDeploymentId,
        status.primaryDeviceStatus!.device.roleName,
      );
      print(deployment);
      for (var task in deployment.tasks) {
        print(task);
        task.measures?.forEach(print);
      }
      expect(deployment.registration.deviceId, isNotNull);
    }, skip: false);

    test('- device deployed', () async {
      StudyDeploymentStatus status_1 = await CarpDeploymentService()
          .getStudyDeploymentStatus(testDeploymentId);
      print(status_1);
      expect(status_1.primaryDeviceStatus!.device, isNotNull);
      print(status_1.primaryDeviceStatus!.device);
      PrimaryDeviceDeployment deployment =
          await CarpDeploymentService().getDeviceDeploymentFor(
        testDeploymentId,
        status_1.primaryDeviceStatus!.device.roleName,
      );
      print(deployment);

      StudyDeploymentStatus status_2 =
          await CarpDeploymentService().deviceDeployed(
        testDeploymentId,
        status_1.primaryDeviceStatus!.device.roleName,
        deployment.lastUpdatedOn,
      );
      print(status_2);
      expect(status_1.studyDeploymentId, status_2.studyDeploymentId);
      expect(status_2.studyDeploymentId, testDeploymentId);
    });

    test('- unregister device', () async {
      DeploymentReference reference =
          CarpDeploymentService().deployment(testDeploymentId);
      StudyDeploymentStatus status = await reference.getStatus();
      print(status);
      expect(status.primaryDeviceStatus!.device, isNotNull);
      print(status.primaryDeviceStatus!.device);
      status = await reference.unRegisterDevice(
          deviceRoleName: status.primaryDeviceStatus!.device.roleName);
      print(status);
      expect(status.studyDeploymentId, testDeploymentId);
    }, skip: false);
  }, skip: true);
}
