part of carp_study_generator;

class StudyProtocolCommand extends AbstractCommand {
  String _protocolJson;
  CAMSStudyProtocol _protocol;

  String get protocolJson {
    if (_protocolJson == null) {
      print('Reading the study protocol from file: $protocolFilename');
      _protocolJson = File(protocolFilename).readAsStringSync();
    }
    return _protocolJson;
  }

  CAMSStudyProtocol get protocol {
    if (_protocol == null) {
      print('Checking that this is a valid CAMS Study Protocol');
      _protocol = CAMSStudyProtocol.fromJson(
          json.decode(protocolJson) as Map<String, dynamic>);
    }
    return _protocol;
  }

  @override
  Future<void> execute() async {
    await authenticate();

    print('Getting custom protocol template from CARP Server');
    StudyProtocol customProtocol =
        await CANSProtocolService().createCustomProtocol(
      ownerId,
      protocol.name,
      protocol.description,
      protocolJson,
    );

    print("Uploading custom protocol, name: '${protocol.name}'");
    await CANSProtocolService().add(customProtocol);
    print('Upload successful!');
  }
}
