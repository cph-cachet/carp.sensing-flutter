part of carp_study_generator;

class LocalizationCommand extends AbstractCommand {
  LocalizationCommand() : super();

  String getLocaleJson(String locale) {
    print("Reading the locale for: '$locale'");
    return File('$localizationPath$locale.json').readAsStringSync();
  }

  @override
  Future execute() async {
    await authenticate();

    locales.forEach((element) async {
      String locale = element.toString();
      Map<String, dynamic> localizations = json.decode(getLocaleJson(locale));

      print("Uploading localization for locale: '$locale' to CARP.");
      await CarpResourceManager()
          .setLocalizations(Locale(locale), localizations);
      print('Upload successful!');
    });
  }
}
