part of carp_study_generator;

class StudyProtocolCommand implements Command {
  static final String helpText = "HELP!";
  @override
  void execute() {
    print(helpText);
  }

  @override
  void help() {
    // TODO: implement help
  }
}
