part of carp_study_generator;

class HelpCommand implements Command {
  static final String helpText =
      "Manage your CARP Mobile Sensing (CAMS) Study.\n\n"
      "Usage: flutter test carp/<command>\n\n"
      "Available commands:\n"
      "  help \t\t Prints this help message.\n"
      "  dryrun \t Makes a dryrun testing access to the CARP server, and the protocol, consent, and localizations.\n"
      "  create \t Create a study protocol based on a json file and uploads it to the CARP server.\n"
      "  update \t Update an existing study protocol based on a json file and uploads it to the CARP server as a new version.\n"
      "  consent \t Create an informed consent based on a json file and uploads it to the CARP server.\n"
      "  localization \t Create localization support based on the files '<locale>.json' and upload them to the CARP server.\n"
      "\n";

  HelpCommand() : super();

  @override
  Future execute() async => print(helpText);
}
