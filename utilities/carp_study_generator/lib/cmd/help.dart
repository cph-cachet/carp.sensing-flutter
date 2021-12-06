part of carp_study_generator;

class HelpCommand implements Command {
  static final String helpText =
      "Manage your CARP Mobile Sensing (CAMS) Study.\n\n"
      "Usage: flutter test carp/<command>\n\n"
      "Available commands:\n"
      "  help \t\t\t Prints this help message.\n"
      "  dryrun \t\t Makes a dryrun testing access to the CARP server the correctness of the json resources.\n"
      "  create \t\t Create a study protocol based on a json file and uploads it to the CARP server.\n"
      "  update \t\t Update an existing study protocol as a new version.\n"
      "  consent \t\t Create an informed consent based on a json file and uploads it to the CARP server.\n"
      "  localization \t\t Upload the localization files to the CARP server.\n"
      "  message \t\t Upload the list of messages to the CARP server.\n"
      "  message-delete-all \t Delete all messages on the CARP server.\n"
      "\n";

  HelpCommand() : super();

  @override
  Future execute() async => print(helpText);
}
