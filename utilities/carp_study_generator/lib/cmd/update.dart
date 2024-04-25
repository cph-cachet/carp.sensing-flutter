part of '../carp_study_generator.dart';

class UpdateStudyProtocolCommand extends CreateStudyProtocolCommand {
  UpdateStudyProtocolCommand() : super();

  @override
  Future<void> execute() async {
    await authenticate();

    print("Updating protocol: $protocol");
    await CarpProtocolService().addVersion(protocol);
    print('Update successful!');
  }
}
