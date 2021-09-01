part of carp_study_generator;

class CreateStudyProtocolCommand extends AbstractCommand {
  String? _protocolJson;
  StudyProtocol? _protocol;

  CreateStudyProtocolCommand() : super();

  String get protocolJson {
    if (_protocolJson == null) {
      print('Reading the study protocol from file: $protocolPath');
      _protocolJson = File(protocolPath).readAsStringSync();
    }
    return _protocolJson!;
  }

  StudyProtocol get protocol {
    if (_protocol == null) {
      print('Checking that this is a valid CAMS Study Protocol');
      _protocol = StudyProtocol.fromJson(
          json.decode(protocolJson) as Map<String, dynamic>);
    }
    return _protocol!;
  }

  StudyProtocol get customProtocol {
    // This doesn't work -- see issue #44 (https://github.com/cph-cachet/carp.webservices-docker/issues/44)
    //
    // print('Getting custom protocol template from CARP Server');
    // StudyProtocol customProtocol =
    //     await CANSProtocolService().createCustomProtocol(
    //   ownerId,
    //   protocol.name,
    //   protocol.description,
    //   protocolJson,
    // );

    // therefore, we create a custom protocol "by hand"
    var customDevice = CustomProtocolDevice(roleName: 'Custom device');

    StudyProtocol customProtocol = StudyProtocol(
        ownerId: ownerId!,
        name: protocol.name,
        description: protocol.description);
    // make sure that the custom protocol also have the right owner id
    protocol.ownerId = ownerId!;
    customProtocol.addMasterDevice(customDevice);
    customProtocol.addTriggeredTask(
        ElapsedTimeTrigger(
            sourceDeviceRoleName: customDevice.roleName,
            elapsedTime: Duration(seconds: 0)),
        CustomProtocolTask(
            name: 'Custom device task', studyProtocol: toJsonString(protocol)),
        customDevice);

    return customProtocol;
  }

  @override
  Future execute() async {
    await authenticate();

    print("Uploading custom protocol, name: '${protocol.name}'");
    await CANSProtocolService().add(customProtocol);
    print('Upload successful!');
  }
}
