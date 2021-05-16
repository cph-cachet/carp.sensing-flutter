part of carp_study_generator;

/// A [Command] that makes a dry run of the configuration of a CAMS study.
/// It checks the following:
///
///  * Is the specified CARP Server accessible
///  * Is authentication possible with the specified credentials
///  * Can the study protocol be loaded and parsed without errors
///  * Can the informed consent be loaded and parsed without errors
///  * Can the language locales be loaded and parsed without errors
///
class DryRunCommand extends AbstractCommand {
  StudyProtocolCommand protocolCommand = StudyProtocolCommand();
  ConsentCommand consentCommand = ConsentCommand();
  LocalizationCommand localizationCommand = LocalizationCommand();

  @override
  Future<void> execute() async {
    int issues = 0;
    print('\n#1 - AUTHENTICATION');
    try {
      await authenticate();
    } catch (error) {
      print('ERROR - $error');
      issues++;
    }

    print('\n#2 - PROTOCOL');
    try {
      protocolCommand.protocolJson;
    } catch (error) {
      print('ERROR - $error');
      issues++;
    }
    try {
      protocolCommand.protocol;
    } catch (error) {
      print('ERROR - $error');
      issues++;
    }

    print('\n#3 - INFORMED CONSENT');
    try {
      consentCommand.consentJson;
      consentCommand.informedConsent;
    } catch (error) {
      print('ERROR - $error');
      issues++;
    }

    print('\n#4 - LOCALIZATION');
    try {
      locales.forEach((element) async {
        String locale = element.toString();
        json.decode(localizationCommand.getLocaleJson(locale));
      });
    } catch (error) {
      print('ERROR - $error');
      issues++;
    }

    print('• ${(issues == 0) ? 'No' : issues.toString()} issues found!');
  }
}
