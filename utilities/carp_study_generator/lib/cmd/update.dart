part of carp_study_generator;

class UpdateStudyProtocolCommand extends CreateStudyProtocolCommand {
  UpdateStudyProtocolCommand() : super();

  @override
  Future execute() async {
    await authenticate();

    print("Updating custom protocol, name: '${protocol.name}'");
    await CANSProtocolService().addVersion(customProtocol);
    print('Update successful!');
  }
}
