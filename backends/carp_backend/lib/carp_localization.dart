part of carp_backend;

/// A Localization implementation that support loading localization from the
/// CARP web service.
class CarpLocalizations {
  final Locale locale;

  CarpLocalizations(this.locale);

  static CarpLocalizations of(BuildContext context) {
    return Localizations.of<CarpLocalizations>(context, CarpLocalizations);
  }

  Map<String, String> _localizedStrings;

  Future load() async {
    _localizedStrings = await ResourceManager().getLocalizations(locale);
    if (_localizedStrings == null)
      warning('Could not load localizations for locale: $locale');
  }

  /// Translate the [text] based on this [locale].
  /// This method will be called from every widget which needs a localized text
  String translate(String text) {
    if (_localizedStrings[text] == null)
      warning("Translation of '$text' not found");
    return _localizedStrings[text];
  }

  // Static member to have a simple access to the delegate from the MaterialApp
  static const LocalizationsDelegate<CarpLocalizations> delegate =
      _CarpLocalizationsDelegate();
}

class _CarpLocalizationsDelegate
    extends LocalizationsDelegate<CarpLocalizations> {
  // This delegate instance will never change (it doesn't even have fields!)
  // It can provide a constant constructor.
  const _CarpLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      (ResourceManager().getLocalizations(locale) != null);

  @override
  Future<CarpLocalizations> load(Locale locale) async {
    CarpLocalizations localizations = new CarpLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_CarpLocalizationsDelegate old) => false;
}
