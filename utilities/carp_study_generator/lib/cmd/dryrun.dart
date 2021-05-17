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
  Future execute() async {
    int issues = 0;
    try {
      CarpService().configure(app);
      await CarpService().authenticate(username: username, password: password);
      print('\x1B[32m[✓]\x1B[0m Authenticating - username: $username');
    } catch (error) {
      print('\x1B[31m[!]\x1B[0m Authenticating - $error');
      issues++;
    }

    String protocolJson;
    try {
      protocolJson = File(protocolFilename).readAsStringSync();
      print('\x1B[32m[✓]\x1B[0m Protocol load - filename: $protocolFilename');
    } catch (error) {
      print('\x1B[31m[!]\x1B[0m Protocol load - $error');
      print(' - $error');
      issues++;
    }
    try {
      CAMSStudyProtocol protocol = CAMSStudyProtocol
          .fromJson(json.decode(protocolJson) as Map<String, dynamic>);
      print('\x1B[32m[✓]\x1B[0m Protocol parse - name: ${protocol.name}');
    } catch (error) {
      print(
          '\x1B[31m[!]\x1B[0m Protocol parse - ${error.toString().substring(0, error.toString().indexOf('\n'))}');
      issues++;
    }

    String consentJson;
    try {
      consentJson = File(consentFilename).readAsStringSync();
      print('\x1B[32m[✓]\x1B[0m Consent load - filename: $consentFilename');
    } catch (error) {
      print('\x1B[31m[!]\x1B[0m Consent load - $error');
      issues++;
    }
    try {
      RPOrderedTask.fromJson(json.decode(consentJson) as Map<String, dynamic>);
      print('\x1B[32m[✓]\x1B[0m Consent parse');
    } catch (error) {
      print(
          '\x1B[31m[!]\x1B[0m Consent parse - ${error.toString().substring(0, error.toString().indexOf('\n'))}');
      issues++;
    }

    try {
      locales.forEach((element) {
        String locale = element.toString();
        String localeJson = File('carp/lang/$locale.json').readAsStringSync();
        json.decode(localeJson);
        print('\x1B[32m[✓]\x1B[0m Locale - $element');
      });
    } catch (error) {
      print('\x1B[31m[!]\x1B[0m Locale - $error');
      issues++;
    }

    print(
        '${(issues == 0) ? '\x1B[32m • \x1B[0m No' : '\x1B[31m • \x1B[0m $issues'} issues found!');
  }
}
