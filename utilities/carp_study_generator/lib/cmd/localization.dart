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

    for (var element in locales) {
      String locale = element.toString();
      Map<String, dynamic> upLocalizations = json.decode(getLocaleJson(locale));

      print("Uploading localization for locale: '$locale' to CARP.");
      bool success = await CarpResourceManager()
          .setLocalizations(Locale(locale), upLocalizations);

      if (success) {
        print('Upload successful - # elements: ${upLocalizations.length}');

        print("Downloading localization for locale: '$locale' from CARP.");
        Map<String, dynamic> downLocalizations =
            await CarpResourceManager().getLocalizations(Locale(locale));

        (downLocalizations != null)
            ? print(
                'Download successful - # elements: ${downLocalizations.length}')
            : print('Download returned null - something went wrong.');
      } else {
        print('Upload not successful - something went wrong.');
      }
    }
  }
}
