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
  test(' -> JSON', () async {});
}
