import 'dart:convert';
import 'dart:io';
import 'package:test/test.dart';

import '../carp_core.dart';

String _encode(Object object) =>
    const JsonEncoder.withIndent(' ').convert(object);

void main() {
  setUp(() {});

  test('DeploymentServiceRequest -> JSON', () async {
    print(_encode(DeploymentServiceRequest('1234')));
  });

  test('GetActiveParticipationInvitations -> JSON', () async {
    print(_encode(GetActiveParticipationInvitations('jakba@dtu.dk')));
  });
  test('GetStudyDeploymentStatus -> JSON', () async {
    print(_encode(GetStudyDeploymentStatus('1234')));
  });
  test('RegisterDevice -> JSON', () async {
    print(_encode(RegisterDevice('1234', 'phone', DeviceRegistration())));
  });
  test('UnregisterDevice -> JSON', () async {
    print(_encode(UnregisterDevice('1234', 'phone')));
  });
  test('GetDeviceDeploymentFor -> JSON', () async {
    print(_encode(GetDeviceDeploymentFor('1234', 'phone')));
  });
  test('DeploymentSuccessful -> JSON', () async {
    print(_encode(DeploymentSuccessful('1234', 'phone', DateTime.now())));
  });
  test(' -> JSON', () async {});
  test('JSON -> ActiveParticipationInvitation', () async {
    String plainJson = File(
            'lib/carp_core/test/json_files/active_participation_invitation.json')
        .readAsStringSync();

    ActiveParticipationInvitation invitation =
        ActiveParticipationInvitation.fromJson(
            json.decode(plainJson) as Map<String, dynamic>);
    expect(invitation.participation.id, '3cf97adf-4cdf-4211-b344-67946934b657');
    print(_encode(invitation));
  });
  test('JSON -> ActiveParticipationInvitation CANS', () async {
    String plainJson = File(
            'lib/carp_core/test/json_files/active_participation_invitation_cans.json')
        .readAsStringSync();

    ActiveParticipationInvitation invitation =
        ActiveParticipationInvitation.fromJson(
            json.decode(plainJson) as Map<String, dynamic>);
    expect(invitation.invitation.applicationData,
        '294a5748-d8fa-4617-b475-99c6980032c8');
    print(_encode(invitation));
  });
  test('JSON -> MasterDeviceDeployment', () async {
    String plainJson =
        File('lib/carp_core/test/json_files/master_device_deployment.json')
            .readAsStringSync();

    MasterDeviceDeployment deployment = MasterDeviceDeployment.fromJson(
        json.decode(plainJson) as Map<String, dynamic>);
    expect(deployment.deviceDescriptor.roleName, 'phone');
    print(_encode(deployment));
  });
  test('JSON -> ParticipantData', () async {
    String plainJson =
        File('lib/carp_core/test/json_files/participant_data.json')
            .readAsStringSync();

    ParticipantData data = ParticipantData.fromJson(
        json.decode(plainJson) as Map<String, dynamic>);
    expect(data.data['dk.cachet.carp.input.sex'], 'Male');
    print(_encode(data));
  });
  test('JSON -> StudyDeploymentStatus', () async {
    String plainJson =
        File('lib/carp_core/test/json_files/study_deployment_status.json')
            .readAsStringSync();

    StudyDeploymentStatus status = StudyDeploymentStatus.fromJson(
        json.decode(plainJson) as Map<String, dynamic>);
    expect(status.studyDeploymentId, 'b1575ac0-1289-4eeb-9048-a3681ad93ff8');
    expect(status.status, StudyDeploymentStatusTypes.Invited);
    print(_encode(status));
  });
  test('JSON -> StudyDeploymentStatus CANS', () async {
    String plainJson =
        File('lib/carp_core/test/json_files/study_deployment_status_cans.json')
            .readAsStringSync();

    StudyDeploymentStatus status = StudyDeploymentStatus.fromJson(
        json.decode(plainJson) as Map<String, dynamic>);
    expect(status.studyDeploymentId, 'ae8076a3-7170-4bcf-b66c-64639a7a9eee');
    expect(status.status, StudyDeploymentStatusTypes.DeployingDevices);
    print(_encode(status));
  });
  test('JSON -> ', () async {});
}
