import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:test/test.dart';

import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:carp_webservices/carp_auth/carp_auth.dart';
import 'package:carp_webservices/carp_services/carp_services.dart';
import 'package:carp_backend/carp_backend.dart';
import 'package:research_package/model.dart';

// import the context, eSense & audio sampling package
// this is used to be able to deserialize the downloaded protocol
// in the 'get study protocol' test
//
// import 'package:carp_esense_package/esense.dart';
// import 'package:carp_audio_package/audio.dart';
// import 'package:carp_context_package/context.dart';

import 'credentials.dart';

String _encode(Object? object) =>
    const JsonEncoder.withIndent(' ').convert(object);

void main() {
  CarpApp app;
  late CarpUser user;
  CarpStudyProtocolManager manager = CarpStudyProtocolManager();

  // make sure that the json functions are loaded
  DomainJsonFactory();

  // register the context, eSense & audio sampling package
  // this is used to be able to deserialize the downloaded protocol
  // in the 'get study protocol' test
  // SamplingPackageRegistry().register(ContextSamplingPackage());
  // SamplingPackageRegistry().register(ESenseSamplingPackage());
  // SamplingPackageRegistry().register(AudioSamplingPackage());

  /// Setup CARP and authenticate.
  /// Runs once before all tests.
  setUpAll(() async {
    Settings().saveAppTaskQueue = false;

    StudyProtocol(ownerId: 'user@dtu.dk', name: 'ignored'); // ...

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

    // configure the other services needed
    CarpParticipationService().configureFrom(CarpService());
    CarpDeploymentService().configureFrom(CarpService());
  });

  /// Close connection to CARP.
  /// Runs once after all tests.
  tearDownAll(() {});

  group("Deployment", () {
    test('- authentication', () async {
      print('CarpService : ${CarpService().app}');
      print(" - signed in as: $user");
      expect(user.accountId, accountId);
    });

    test('- get invitations for this account (user)', () async {
      List<ActiveParticipationInvitation> invitations =
          await CarpParticipationService().getActiveParticipationInvitations();
      invitations.forEach((invitation) => print(invitation));
      //assert(invitations.length > 0);
    }, skip: false);

    test('- get deployment status', () async {
      CarpService().app!.studyDeploymentId = testDeploymentId;

      StudyDeploymentStatus status =
          await CarpDeploymentService().deployment().getStatus();
      print(_encode(status.toJson()));
      print(status);
      print(status.masterDeviceStatus!.device);
      expect(status.studyDeploymentId, testDeploymentId);
    }, skip: false);

    test('- register device', () async {
      DeploymentReference reference =
          CarpDeploymentService().deployment(testDeploymentId);
      StudyDeploymentStatus status = await reference.getStatus();
      print(status);
      expect(status.masterDeviceStatus!.device, isNotNull);
      print(status.masterDeviceStatus!.device);
      status = await reference.registerDevice(
          deviceRoleName: status.masterDeviceStatus!.device.roleName);
      print(status);
      expect(status.studyDeploymentId, testDeploymentId);
    }, skip: false);

    test('- get master device deployment', () async {
      DeploymentReference reference =
          CarpDeploymentService().deployment(testDeploymentId);
      StudyDeploymentStatus status = await reference.getStatus();
      print(status);
      expect(status.masterDeviceStatus!.device, isNotNull);
      print(status.masterDeviceStatus!.device);
      MasterDeviceDeployment deployment = await reference.get();
      print(deployment);
      deployment.tasks.forEach((task) {
        print(task);
        task.measures.forEach(print);
      });
      expect(deployment.configuration.deviceId, isNotNull);
    }, skip: false);

    test('- deployment success', () async {
      DeploymentReference reference =
          CarpDeploymentService().deployment(testDeploymentId);
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
          CarpDeploymentService().deployment(testDeploymentId);
      StudyDeploymentStatus status = await reference.getStatus();
      print(status);
      expect(status.masterDeviceStatus!.device, isNotNull);
      print(status.masterDeviceStatus!.device);
      status = await reference.unRegisterDevice(
          deviceRoleName: status.masterDeviceStatus!.device.roleName);
      print(status);
      expect(status.studyDeploymentId, testDeploymentId);
    }, skip: false);
  }, skip: true);

  group("Study Protocol Manager", () {
    test('- get study protocol', () async {
      SmartphoneStudyProtocol study =
          await manager.getStudyProtocol(testDeploymentId);
      print('study: $study');
      print(_encode(study));
    }, skip: false);
  });

  group("CARP Deployment Service", () {
    test('- get deployment status', () async {
      StudyDeploymentStatus? status = await CustomProtocolDeploymentService()
          .getStudyDeploymentStatus(testDeploymentId);

      print(status);
      print(_encode(status.toJson()));
      print(status.masterDeviceStatus?.device);
      expect(status.studyDeploymentId, testDeploymentId);
    }, skip: false);

    test('- get master device deployment', () async {
      StudyDeploymentStatus? status = await CustomProtocolDeploymentService()
          .getStudyDeploymentStatus(testDeploymentId);

      print(status);
      expect(status.masterDeviceStatus!.device, isNotNull);
      print(status.masterDeviceStatus!.device);
      MasterDeviceDeployment deployment =
          await CarpDeploymentService().getDeviceDeploymentFor(
        status.studyDeploymentId,
        status.masterDeviceStatus!.device.roleName,
      );
      print(deployment);
      deployment.tasks.forEach((task) {
        print(task);
        task.measures.forEach(print);
      });
      expect(deployment.configuration.deviceId, isNotNull);
    }, skip: false);
  });

  group("Informed Consent", () {
    test('- get', () async {
      RPOrderedTask? informedConsent =
          await CarpResourceManager().getInformedConsent(refresh: true);

      print(_encode(informedConsent));
    });

    test('- set', () async {
      RPOrderedTask anotherInformedConsent =
          RPOrderedTask(identifier: '12', steps: [
        RPInstructionStep(
          identifier: "1",
          title: "Welcome!",
          text: "Welcome to this study!",
        ),
        RPCompletionStep(
            identifier: "2",
            title: "Thank You!",
            text: "We saved your consent document - VIII"),
      ]);

      bool success = await CarpResourceManager()
          .setInformedConsent(anotherInformedConsent);
      print('updated: $success');
      RPOrderedTask? informedConsent =
          await CarpResourceManager().getInformedConsent(refresh: true);

      print(_encode(informedConsent));
    });

    test('- delete', () async {
      bool success = await CarpResourceManager().deleteInformedConsent();
      print('deleted: $success');
    });
  });

  group("Localizations", () {
    Locale locale = Locale('en');

    test('- get', () async {
      Map<String, String>? localizations =
          await CarpResourceManager().getLocalizations(
        locale,
        refresh: true,
        cache: false,
      );

      print(_encode(localizations));
    });

    test('- set', () async {
      Map<String, String> daLocalizations = {
        'Hi': 'Hej',
        'Bye': 'Farvel',
      };

      bool success =
          await CarpResourceManager().setLocalizations(locale, daLocalizations);
      print('updated: $success');

      Map<String, String>? localizations =
          await CarpResourceManager().getLocalizations(locale);
      expect(localizations, localizations);
      print(_encode(localizations));
    });

    test('- delete', () async {
      bool success = await CarpResourceManager().deleteLocalizations(locale);
      print('deleted: $success');
    });
  });

  group("Documents & Collections", () {
    test('- get by id', () async {
      DocumentSnapshot? doc = await CarpService().documentById(167).get();
      print(doc);
    });

    test('- get by collection', () async {
      CollectionReference ref =
          await CarpService().collection('localizations').get();
      print((ref));
    });

    test(' - get document by path', () async {
      DocumentSnapshot? doc =
          await CarpService().document('localizations/da').get();
      print((doc));
    });

    test(' - get all documents', () async {
      List<DocumentSnapshot> documents = await CarpService().documents();

      print('Found ${documents.length} document(s)');
      documents.forEach((document) => print(' - $document'));
    });

    test(' - delete old document', () async {
      DocumentReference doc = CarpService().documentById(167);
      doc.delete();
    });
  });
}
