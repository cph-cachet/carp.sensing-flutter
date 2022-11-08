import 'dart:convert';
import 'dart:io';
import 'package:test/test.dart';
import 'package:carp_core/carp_core.dart';
import 'package:carp_serializable/carp_serializable.dart';

void main() {
  late StudyProtocol protocol;

  setUp(() {
    Core();
  });

  test('StudyProtocol', () async {
    String plainJson =
        File('test/json/carp.core-kotlin/protocols/study_protocol.json')
            .readAsStringSync();

    StudyProtocol protocol =
        StudyProtocol.fromJson(json.decode(plainJson) as Map<String, dynamic>);

    expect(protocol.id, '25fe92a5-0d52-4e37-8d05-31f347d72d3d');
    expect(protocol.primaryDevices.first.roleName, "Participant's phone");
    print(toJsonString(protocol));
  });

  test('Custom StudyProtocol', () async {
    String plainJson =
        File('test/json/carp.core-kotlin/protocols/custom_study_protocol.json')
            .readAsStringSync();

    StudyProtocol protocol =
        StudyProtocol.fromJson(json.decode(plainJson) as Map<String, dynamic>);

    expect(protocol.ownerId, '491f03fc-964b-4783-86a6-a528bbfe4e94');
    expect(protocol.primaryDevices.first.roleName, 'Custom device');
    print(toJsonString(protocol));
  });

  test('Primary Device Deployment', () async {
    String plainJson = File(
            'test/json/carp.core-kotlin/deployments/primary_device_deployment.json')
        .readAsStringSync();

    PrimaryDeviceDeployment deployment = PrimaryDeviceDeployment.fromJson(
        json.decode(plainJson) as Map<String, dynamic>);

    expect(deployment.deviceConfiguration.isPrimaryDevice, true);
    expect(deployment.deviceConfiguration.roleName, "Participant's phone");
    print(toJsonString(deployment));
  });
}
