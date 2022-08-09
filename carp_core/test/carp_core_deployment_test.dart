import 'dart:convert';
import 'dart:io';
import 'package:test/test.dart';
import 'package:carp_core/carp_core.dart';
import 'package:carp_serializable/carp_serializable.dart';

void main() {
  setUp(() {
    Core();
  });

  test('GetActiveParticipationInvitations -> JSON', () async {
    print(toJsonString(GetActiveParticipationInvitations('jakba@dtu.dk')));
  });
  test('GetStudyDeploymentStatus -> JSON', () async {
    print(toJsonString(GetStudyDeploymentStatus('1234')));
  });
  test('RegisterDevice -> JSON', () async {
    print(toJsonString(RegisterDevice('1234', 'phone', DeviceRegistration())));
  });
  test('UnregisterDevice -> JSON', () async {
    print(toJsonString(UnregisterDevice('1234', 'phone')));
  });
  test('GetDeviceDeploymentFor -> JSON', () async {
    print(toJsonString(GetDeviceDeploymentFor('1234', 'phone')));
  });
  test('DeploymentSuccessful -> JSON', () async {
    print(toJsonString(DeploymentSuccessful('1234', 'phone', DateTime.now())));
  });
  test('JSON -> ActiveParticipationInvitation', () async {
    String plainJson = File('test/json/active_participation_invitation.json')
        .readAsStringSync();

    ActiveParticipationInvitation invitation =
        ActiveParticipationInvitation.fromJson(
            json.decode(plainJson) as Map<String, dynamic>);
    expect(invitation.participation.id, '3cf97adf-4cdf-4211-b344-67946934b657');
    print(toJsonString(invitation));
  });
  test('JSON -> ActiveParticipationInvitation CANS', () async {
    String plainJson =
        File('test/json/active_participation_invitation_cans.json')
            .readAsStringSync();

    ActiveParticipationInvitation invitation =
        ActiveParticipationInvitation.fromJson(
            json.decode(plainJson) as Map<String, dynamic>);
    expect(invitation.invitation.applicationData,
        '294a5748-d8fa-4617-b475-99c6980032c8');
    print(toJsonString(invitation));
  });
  test('JSON -> MasterDeviceDeployment', () async {
    String plainJson =
        File('test/json/master_device_deployment.json').readAsStringSync();

    MasterDeviceDeployment deployment = MasterDeviceDeployment.fromJson(
        json.decode(plainJson) as Map<String, dynamic>);
    expect(deployment.deviceDescriptor.roleName, 'phone');
    print(toJsonString(deployment));
  });
  test('JSON -> ParticipantData', () async {
    String plainJson =
        File('test/json/participant_data.json').readAsStringSync();

    ParticipantData data = ParticipantData.fromJson(
        json.decode(plainJson) as Map<String, dynamic>);
    expect(data.data['dk.cachet.carp.input.sex'], 'Male');
    print(toJsonString(data));
  });
  test('JSON -> StudyDeploymentStatus', () async {
    String plainJson =
        File('test/json/study_deployment_status.json').readAsStringSync();

    StudyDeploymentStatus status = StudyDeploymentStatus.fromJson(
        json.decode(plainJson) as Map<String, dynamic>);
    expect(status.studyDeploymentId, 'b1575ac0-1289-4eeb-9048-a3681ad93ff8');
    expect(status.status, StudyDeploymentStatusTypes.Invited);
    print(toJsonString(status));
  });

  test('JSON -> StudyDeploymentStatus CANS', () async {
    String plainJson =
        File('test/json/study_deployment_status_cans.json').readAsStringSync();

    StudyDeploymentStatus status = StudyDeploymentStatus.fromJson(
        json.decode(plainJson) as Map<String, dynamic>);
    print(toJsonString(status));

    expect(status.studyDeploymentId, 'ae8076a3-7170-4bcf-b66c-64639a7a9eee');
    expect(status.status, StudyDeploymentStatusTypes.DeployingDevices);
    expect(status.devicesStatus[0].device.roleName, 'Stub master device');
    expect(status.devicesStatus[0].status,
        DeviceDeploymentStatusTypes.Unregistered);
    expect(status.devicesStatus[1].device.roleName, 'Stub device');
    expect(status.devicesStatus[1].status,
        DeviceDeploymentStatusTypes.Unregistered);
  });

  test('JSON -> StudyDeploymentStatus Successful', () async {
    String plainJson = File('test/json/study_deployment_status_successful.json')
        .readAsStringSync();

    StudyDeploymentStatus status = StudyDeploymentStatus.fromJson(
        json.decode(plainJson) as Map<String, dynamic>);
    expect(status.studyDeploymentId, 'd396c31b-dabc-4fc7-b5fd-97031fc1de4c');
    expect(status.status, StudyDeploymentStatusTypes.DeploymentReady);
    print(toJsonString(status));
  });
  test('JSON -> ', () async {});
}
