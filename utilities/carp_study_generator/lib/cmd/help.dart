part of carp_study_generator;

class HelpCommand extends AbstractCommand {
  static final String helpText =
      "Manage your CARP Mobile Sensing (CAMS) Study.\n\n"
      "Usage: flutter test carp/<command>\n\n"
      "Available commands:\n"
      "  help \t\t Prints this help message.\n"
      // "  create \t Create the configuration files for a CAMS study.\n"
      "  dryrun \t Makes a dryrun testing access to the CARP server, and the protocol, consent, and localizations.\n"
      "  protocol \t Create a study protocol based on the file 'protocol.json' and uploads it to the CARP server.\n"
      "  consent \t Create an informed consent based on the file 'consent.json' and uploads it to the CARP server.\n"
      "  localization \t Create localization support based on the files '<locale>.json' and upload them to the CARP server.\n"
      "\n";

  HelpCommand() : super();

  @override
  Future execute() async => print(helpText);
}
