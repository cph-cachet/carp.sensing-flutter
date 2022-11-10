import 'dart:convert';
import 'dart:io';
import 'package:test/test.dart';
import 'package:carp_core/carp_core.dart';
import 'package:carp_serializable/carp_serializable.dart';

void main() {
  const String path = 'test/json/carp.core-kotlin/rpc';

  setUp(() {
    Core();
  });

  group('Protocol Service', () {
    test('Add - Request', () async {
      String rpcString =
          File('$path/protocols/ProtocolService/add.json').readAsStringSync();

      var expected =
          Add.fromJson(json.decode(rpcString) as Map<String, dynamic>);

      String plainJson =
          File('test/json/carp.core-kotlin/protocols/study_protocol.json')
              .readAsStringSync();
      StudyProtocol protocol = StudyProtocol.fromJson(
          json.decode(plainJson) as Map<String, dynamic>);
      var request = Add(protocol, 'Version 1');

      print(toJsonString(request));
      expect(toJsonString(expected), toJsonString(request));
    });

    test('Add - Response', () async {
      String plainJson =
          File('$path/protocols/ProtocolService/add-response.json')
              .readAsStringSync();
      // the response is empty
      print(toJsonString(plainJson));
    });

    test('AddVersion - Request', () async {
      String rpcString = File('$path/protocols/ProtocolService/addVersion.json')
          .readAsStringSync();

      var expected =
          AddVersion.fromJson(json.decode(rpcString) as Map<String, dynamic>);

      String plainJson =
          File('test/json/carp.core-kotlin/protocols/study_protocol.json')
              .readAsStringSync();
      StudyProtocol protocol = StudyProtocol.fromJson(
          json.decode(plainJson) as Map<String, dynamic>);

      // the name and the version number is updated
      protocol.name = 'Walking/biking study';
      var request = AddVersion(protocol, 'Version 2: new name');

      print(toJsonString(request));
      expect(toJsonString(expected), toJsonString(request));
    });

    test('AddVersion - Response', () async {
      String plainJson =
          File('$path/protocols/ProtocolService/addVersion-response.json')
              .readAsStringSync();
      // the response is empty
      print(toJsonString(plainJson));
    });

    test('UpdateParticipantDataConfiguration - Request', () async {
      String rpcString = File(
              '$path/protocols/ProtocolService/updateParticipantDataConfiguration.json')
          .readAsStringSync();

      var expected = UpdateParticipantDataConfiguration.fromJson(
          json.decode(rpcString) as Map<String, dynamic>);

      var request = UpdateParticipantDataConfiguration(
        '25fe92a5-0d52-4e37-8d05-31f347d72d3d',
        'Version 3: ask participant data',
        [
          ExpectedParticipantData(
            ParticipantAttribute(inputDataType: 'dk.cachet.carp.input.sex'),
            AssignedTo(roleNames: {'Participant'}),
          ),
        ],
      );

      print(toJsonString(request));
      expect(toJsonString(expected), toJsonString(request));
    });

    test('UpdateParticipantDataConfiguration - Response', () async {
      String plainJson = File(
              '$path/protocols/ProtocolService/updateParticipantDataConfiguration-response.json')
          .readAsStringSync();

      StudyProtocol protocol = StudyProtocol.fromJson(
          json.decode(plainJson) as Map<String, dynamic>);

      print(toJsonString(protocol));
      expect(protocol.id, '25fe92a5-0d52-4e37-8d05-31f347d72d3d');
      expect(protocol.name, 'Nonmotorized transport study');
    });

    test('GetBy - Request', () async {
      String rpcString =
          File('$path/protocols/ProtocolService/getBy.json').readAsStringSync();

      var expected =
          GetBy.fromJson(json.decode(rpcString) as Map<String, dynamic>);

      var request = GetBy(
        '25fe92a5-0d52-4e37-8d05-31f347d72d3d',
        'Version 1',
      );

      print(toJsonString(request));
      expect(toJsonString(expected), toJsonString(request));
    });

    test('GetBy - Response', () async {
      String plainJson =
          File('$path/protocols/ProtocolService/getBy-response.json')
              .readAsStringSync();

      StudyProtocol protocol = StudyProtocol.fromJson(
          json.decode(plainJson) as Map<String, dynamic>);

      print(toJsonString(protocol));
      expect(protocol.id, '25fe92a5-0d52-4e37-8d05-31f347d72d3d');
      expect(protocol.name, 'Nonmotorized transport study');
    });

    test('GetAllForOwner - Request', () async {
      String rpcString =
          File('$path/protocols/ProtocolService/getAllForOwner.json')
              .readAsStringSync();

      var expected = GetAllForOwner.fromJson(
          json.decode(rpcString) as Map<String, dynamic>);

      var request = GetAllForOwner('491f03fc-964b-4783-86a6-a528bbfe4e94');

      print(toJsonString(request));
      expect(toJsonString(expected), toJsonString(request));
    });

    test('GetAllForOwner - Response', () async {
      String plainJson =
          File('$path/protocols/ProtocolService/getAllForOwner-response.json')
              .readAsStringSync();

      var list = json.decode(plainJson) as List<dynamic>;
      var protocol = StudyProtocol.fromJson(list[0] as Map<String, dynamic>);

      print(toJsonString(protocol));
      expect(protocol.id, '25fe92a5-0d52-4e37-8d05-31f347d72d3d');
      expect(protocol.name, 'Nonmotorized transport study');
    });

    test('GetVersionHistoryFor - Request', () async {
      String rpcString =
          File('$path/protocols/ProtocolService/getVersionHistoryFor.json')
              .readAsStringSync();

      var expected = GetVersionHistoryFor.fromJson(
          json.decode(rpcString) as Map<String, dynamic>);

      var request =
          GetVersionHistoryFor('25fe92a5-0d52-4e37-8d05-31f347d72d3d');

      print(toJsonString(request));
      expect(toJsonString(expected), toJsonString(request));
    });

    test('GetVersionHistoryFor - Response', () async {
      String plainJson = File(
              '$path/protocols/ProtocolService/getVersionHistoryFor-response.json')
          .readAsStringSync();

      var list = json.decode(plainJson) as List<dynamic>;
      print(toJsonString(list));

      var version = ProtocolVersion.fromJson(list[0] as Map<String, dynamic>);
      expect(version.tag, 'Version 1');
      expect(version.date, DateTime.tryParse('2022-01-18T10:56:59Z'));
    });
  });

  group('ProtocolFactory Service', () {
    test('CreateCustomProtocol - Request', () async {
      String rpcString = File(
              '$path/protocols/ProtocolFactoryService/createCustomProtocol.json')
          .readAsStringSync();

      var expected = CreateCustomProtocol.fromJson(
          json.decode(rpcString) as Map<String, dynamic>);

      var request = CreateCustomProtocol(
        '491f03fc-964b-4783-86a6-a528bbfe4e94',
        'Fictional Company study',
        "Collect heartrate and GPS using Fictional Company's software.",
        '{\"collect-data\": \"heartrate, gps\"}',
      );

      print(toJsonString(request));
      expect(toJsonString(expected), toJsonString(request));
    });

    test('CreateCustomProtocol - Response', () async {
      String plainJson = File(
              '$path/protocols/ProtocolFactoryService/createCustomProtocol-response.json')
          .readAsStringSync();

      StudyProtocol protocol = StudyProtocol.fromJson(
          json.decode(plainJson) as Map<String, dynamic>);

      print(toJsonString(protocol));
      expect(protocol.id, '4d8c75c7-9604-48fa-8f9b-5ed3e4bd5df8');
      expect(protocol.name, 'Fictional Company study');
    });
  });
  group('DataStream Service', () {
    test('AppendToDataStreams - Request', () async {
      String rpcString =
          File('$path/protocols/DataStreamService/appendToDataStreams.json')
              .readAsStringSync();

      var expected = AppendToDataStreams.fromJson(
          json.decode(rpcString) as Map<String, dynamic>);

      var request = AppendToDataStreams(
        'c9cc5317-48da-45f2-958e-58bc07f34681',
        [],
      );

      print(toJsonString(request));
      expect(toJsonString(expected), toJsonString(request));
    });

    test('AppendToDataStreams - Response', () async {
      String plainJson = File(
              '$path/protocols/DataStreamService/appendToDataStreams-response.json')
          .readAsStringSync();

      StudyProtocol protocol = StudyProtocol.fromJson(
          json.decode(plainJson) as Map<String, dynamic>);

      print(toJsonString(protocol));
      expect(protocol.id, '4d8c75c7-9604-48fa-8f9b-5ed3e4bd5df8');
      expect(protocol.name, 'Fictional Company study');
    });

    test('Data Stream', () async {
      String plainJson = File('$path/data/datastream.json').readAsStringSync();

      List<dynamic> stream = json.decode(plainJson) as List<dynamic>;

      expect(stream.length, 1);
      // expect(stream.first, isA<DataStreamBatch>);
      print(toJsonString(stream));
    });
  });

  group('Participation Service', () {
    test('GetActiveParticipationInvitations - Request', () async {
      String rpcString = File(
              '$path/deployments/ParticipationService/getActiveParticipationInvitations.json')
          .readAsStringSync();

      var expected = GetActiveParticipationInvitations.fromJson(
          json.decode(rpcString) as Map<String, dynamic>);
      var request = GetActiveParticipationInvitations(
          'ca60cb7f-de18-44b6-baf9-3c8e6a73005a');

      expect(expected.toJson(), request.toJson());
      print(toJsonString(request));
    });

    test('GetActiveParticipationInvitations - Response', () async {
      String plainJson = File(
              '$path/deployments/ParticipationService/getActiveParticipationInvitations-response.json')
          .readAsStringSync();

      ActiveParticipationInvitation invitation =
          ActiveParticipationInvitation.fromJson(
              json.decode(plainJson) as Map<String, dynamic>);
      expect(invitation.participation.participantId,
          '32880e82-01c9-40cf-a6ed-17ff3348f251');
      print(toJsonString(invitation));
    });

    test('GetParticipantData - Request', () async {
      String rpc =
          File('$path/deployments/ParticipationService/getParticipantData.json')
              .readAsStringSync();

      var expected =
          GetParticipantData.fromJson(json.decode(rpc) as Map<String, dynamic>);
      var request = GetParticipantData('c9cc5317-48da-45f2-958e-58bc07f34681');

      expect(expected.toJson(), request.toJson());
      print(toJsonString(request));
    });

    test('GetParticipantData - Response', () async {
      String response = File(
              '$path/deployments/ParticipationService/getParticipantData-response.json')
          .readAsStringSync();

      ParticipantData data = ParticipantData.fromJson(
          json.decode(response) as Map<String, dynamic>);
      expect(data.roles.first.roleName, "Participant");
      print(toJsonString(data));
    });

    test('GetParticipantDataList - Request', () async {
      String rpc = File(
              '$path/deployments/ParticipationService/getParticipantDataList.json')
          .readAsStringSync();

      var expected = GetParticipantDataList.fromJson(
          json.decode(rpc) as Map<String, dynamic>);
      var request =
          GetParticipantDataList(['c9cc5317-48da-45f2-958e-58bc07f34681']);

      expect(expected.toJson(), request.toJson());
      print(toJsonString(request));
    });

    test('GetParticipantDataList - Response', () async {
      String response = File(
              '$path/deployments/ParticipationService/getParticipantDataList-response.json')
          .readAsStringSync();
      var list = json.decode(response) as List<dynamic>;

      expect(list.length, 1);
      print(toJsonString(list));
    });

    test('SetParticipantData - Request', () async {
      String rpcString =
          File('$path/deployments/ParticipationService/setParticipantData.json')
              .readAsStringSync();

      var request = SetParticipantData(
        'c9cc5317-48da-45f2-958e-58bc07f34681',
        'Participant',
        {SexCustomInput.SEX_INPUT_TYPE_NAME: SexCustomInput(Sex.Male)},
      );

      var expected = SetParticipantData.fromJson(
          json.decode(rpcString) as Map<String, dynamic>);
      print(toJsonString(expected));

      // for some strange reason, this doesn't work here?????
      // expect(expected.toJson(), request.toJson());
      expect(toJsonString(expected), toJsonString(request));
    });

    test('SetParticipantData - Response', () async {
      String response = File(
              '$path/deployments/ParticipationService/setParticipantData-response.json')
          .readAsStringSync();

      ParticipantData data = ParticipantData.fromJson(
          json.decode(response) as Map<String, dynamic>);
      expect(data.roles.first.roleName, "Participant");
      print(toJsonString(data));
    });
  });

  group('Deployment Service', () {
    test('GetStudyDeploymentStatus - Request', () async {
      String rpcString = File(
              '$path/deployments/DeploymentService/getStudyDeploymentStatus.json')
          .readAsStringSync();

      var expected = GetStudyDeploymentStatus.fromJson(
          json.decode(rpcString) as Map<String, dynamic>);
      var request =
          GetStudyDeploymentStatus('c9cc5317-48da-45f2-958e-58bc07f34681');

      expect(expected.toJson(), request.toJson());
      print(toJsonString(request));
    });

    test('GetStudyDeploymentStatus - Response', () async {
      String plainJson = File(
              '$path/deployments/DeploymentService/getStudyDeploymentStatus-response.json')
          .readAsStringSync();

      StudyDeploymentStatus status = StudyDeploymentStatus.fromJson(
          json.decode(plainJson) as Map<String, dynamic>);
      expect(status.studyDeploymentId, 'c9cc5317-48da-45f2-958e-58bc07f34681');
      expect(status.status, StudyDeploymentStatusTypes.Invited);
      print(toJsonString(status));
    });
    test('RegisterDevice - Request', () async {
      String rpcString =
          File('$path/deployments/DeploymentService/registerDevice.json')
              .readAsStringSync();

      var expected = RegisterDevice.fromJson(
          json.decode(rpcString) as Map<String, dynamic>);

      var request = RegisterDevice(
          'c9cc5317-48da-45f2-958e-58bc07f34681',
          "Participant's phone",
          DefaultDeviceRegistration(
            deviceId: 'fc7b41b0-e9e2-4b5d-8c3d-5119b556a3f0',
            registrationCreatedOn: DateTime.tryParse('2022-01-18T13:55:10Z'),
          ));
      print(toJsonString(request));

      // expect(expected.toJson(), request.toJson());
      expect(toJsonString(expected), toJsonString(request));
    });

    test('RegisterDevice - Response', () async {
      String plainJson = File(
              '$path/deployments/DeploymentService/registerDevice-response.json')
          .readAsStringSync();

      StudyDeploymentStatus status = StudyDeploymentStatus.fromJson(
          json.decode(plainJson) as Map<String, dynamic>);
      expect(status.studyDeploymentId, 'c9cc5317-48da-45f2-958e-58bc07f34681');
      expect(status.status, StudyDeploymentStatusTypes.DeployingDevices);
      print(toJsonString(status));
    });

    test('UnregisterDevice - Request', () async {
      String rpcString =
          File('$path/deployments/DeploymentService/unregisterDevice.json')
              .readAsStringSync();

      var expected = UnregisterDevice.fromJson(
          json.decode(rpcString) as Map<String, dynamic>);

      var request = UnregisterDevice(
        'c9cc5317-48da-45f2-958e-58bc07f34681',
        "Participant's phone",
      );
      print(toJsonString(request));

      // expect(expected.toJson(), request.toJson());
      expect(toJsonString(expected), toJsonString(request));
    });

    test('UnregisterDevice - Response', () async {
      String plainJson = File(
              '$path/deployments/DeploymentService/unregisterDevice-response.json')
          .readAsStringSync();

      StudyDeploymentStatus status = StudyDeploymentStatus.fromJson(
          json.decode(plainJson) as Map<String, dynamic>);
      expect(status.studyDeploymentId, 'c9cc5317-48da-45f2-958e-58bc07f34681');
      expect(status.status, StudyDeploymentStatusTypes.Invited);
      print(toJsonString(status));
    });

    test('GetDeviceDeploymentFor - Request', () async {
      String rpcString = File(
              '$path/deployments/DeploymentService/getDeviceDeploymentFor.json')
          .readAsStringSync();

      var expected = GetDeviceDeploymentFor.fromJson(
          json.decode(rpcString) as Map<String, dynamic>);

      var request = GetDeviceDeploymentFor(
        'c9cc5317-48da-45f2-958e-58bc07f34681',
        "Participant's phone",
      );
      print(toJsonString(request));

      // expect(expected.toJson(), request.toJson());
      expect(toJsonString(expected), toJsonString(request));
    });

    test('GetDeviceDeploymentFor - Response', () async {
      String plainJson = File(
              '$path/deployments/DeploymentService/getDeviceDeploymentFor-response.json')
          .readAsStringSync();

      PrimaryDeviceDeployment deployment = PrimaryDeviceDeployment.fromJson(
          json.decode(plainJson) as Map<String, dynamic>);

      expect(deployment.deviceConfiguration.isPrimaryDevice, true);
      expect(deployment.deviceConfiguration.roleName, "Participant's phone");
      print(toJsonString(deployment));
    });
    test('DeviceDeployed - Request', () async {
      String rpcString =
          File('$path/deployments/DeploymentService/deviceDeployed.json')
              .readAsStringSync();

      var expected = DeviceDeployed.fromJson(
          json.decode(rpcString) as Map<String, dynamic>);

      var request = DeviceDeployed(
        'c9cc5317-48da-45f2-958e-58bc07f34681',
        "Participant's phone",
        DateTime.tryParse('2022-01-18T13:55:10Z')!,
      );
      print(toJsonString(request));

      // expect(expected.toJson(), request.toJson());
      expect(toJsonString(expected), toJsonString(request));
    });

    test('DeviceDeployed - Response', () async {
      String plainJson = File(
              '$path/deployments/DeploymentService/deviceDeployed-response.json')
          .readAsStringSync();

      StudyDeploymentStatus status = StudyDeploymentStatus.fromJson(
          json.decode(plainJson) as Map<String, dynamic>);
      expect(status.studyDeploymentId, 'c9cc5317-48da-45f2-958e-58bc07f34681');
      expect(status.status, StudyDeploymentStatusTypes.Invited);
      print(toJsonString(status));
    });
  });
}
