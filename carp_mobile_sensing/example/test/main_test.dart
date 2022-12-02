import 'dart:convert';
import 'dart:io';
import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:carp_serializable/carp_serializable.dart';

import 'package:test/test.dart';

import '../lib/main.dart';

void main() {
  late SmartphoneStudyProtocol primaryProtocol;

  setUp(() async {
    CarpMobileSensing();
    primaryProtocol = await LocalStudyProtocolManager().getStudyProtocol('');
  });

  test('SmartphoneStudyProtocol -> JSON', () async {
    print(primaryProtocol.applicationData);
    print(toJsonString(primaryProtocol));
    expect(primaryProtocol.ownerId, 'AB');
  });

  test(
      'SmartphoneStudyProtocol -> JSON -> SmartphoneStudyProtocol :: deep assert',
      () async {
    print(toJsonString(primaryProtocol));
    final studyJson = toJsonString(primaryProtocol);

    SmartphoneStudyProtocol protocolFromJson = SmartphoneStudyProtocol.fromJson(
        json.decode(studyJson) as Map<String, dynamic>);
    print(toJsonString(protocolFromJson));
    expect(toJsonString(protocolFromJson), equals(studyJson));
  });

  // test('JSON File -> SmartphoneStudyProtocol', () async {
  //   // Read the study protocol from json file
  //   String plainJson = File('test/json/study_protocol.json').readAsStringSync();

  //   SmartphoneStudyProtocol protocol = SmartphoneStudyProtocol.fromJson(
  //       json.decode(plainJson) as Map<String, dynamic>);

  //   expect(protocol.ownerId, primaryProtocol.ownerId);
  //   expect(protocol.primaryDevices.first.roleName,
  //       SmartphoneDeploymentService().thisPhone.roleName);
  //   print(toJsonString(protocol));
  // });

  test('SmartphoneDeployment -> JSON', () async {
    var deployment = SmartphoneDeployment.fromSmartphoneStudyProtocol(
      studyDeploymentId: '1234',
      primaryDeviceRoleName: 'phone',
      protocol: primaryProtocol,
    );

    print(toJsonString(deployment));
    // expect(deployment.deviceConfiguration.roleName, 'phone');
    // expect(deployment.connectedDevices.length, 1);
    // expect(deployment.triggers.length, 6);
    // expect(deployment.triggers.keys.first, '0');
    // expect(deployment.tasks.length, 5);
    // expect(deployment.taskControls.length, 6);
    // expect(deployment.dataEndPoint?.type, DataEndPointTypes.SQLITE);
    // expect(deployment.expectedParticipantData.length, 1);
    // expect(deployment.getApplicationData('uiTheme'), 'black');
  });
}
