/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_backend;

/// Handles different types of CAMS-specific resources at the CARP service.
///
/// This includes:
///
///  * Retrieve and store informed consent definitions as [RPOrderedTask] json
///    definitions at the CARP backend.
///  * Retrive and store langunage localization mappings.
///
class CarpResourceManager {
  static final CarpResourceManager _instance = CarpResourceManager._();
  factory CarpResourceManager() => _instance;

  CarpResourceManager._() {
    RPOrderedTask('', []); // to initialize json serialization for RP classes
  }

  Future initialize() async {}

  // --------------------------------------------------------------------------
  // INFORMED CONSENT
  // --------------------------------------------------------------------------

  /// The path for the informed consent document at the CARP server
  static const String INFORMED_CONSENT_PATH = 'resources/informed_consent';

  /// The latest downloaded informed consent document.
  ///
  /// `null` if no consent has been downloaded yet. Use the [getInformedConsent] t
  /// method to get the informed consent document from CARP.
  RPOrderedTask informedConsent;

  /// Get the informed consent to be shown for this study.
  ///
  /// This method return a [RPOrderedTask] which is an ordered list of [RPStep]
  /// which are shown to the user as the informed consent flow.
  /// See [research_package](https://pub.dev/packages/research_package) for a
  /// description on how to create an informed consent in the research package
  /// domain model.
  ///
  /// If there is no informed consent json file on the CARP server, `null` is
  /// returned.
  Future<RPOrderedTask> getInformedConsent() async {
    assert(CarpService().isConfigured,
        "CARP Service has not been configured - call 'CarpService().configure()' first.");
    assert(CarpService().currentUser != null,
        "No user is authenticated - call 'CarpService().authenticate()' first.");

    info(
        'Getting informed consent document from path : $INFORMED_CONSENT_PATH');

    RPOrderedTask('', []); // to initialize json serialization for RP classes
    DocumentSnapshot document =
        await CarpService().document(INFORMED_CONSENT_PATH).get();
    info('Informed consent downloaded : $document');

    if (document != null) {
      informedConsent = RPOrderedTask.fromJson(document.data);
    }
    return informedConsent;
  }

  /// Set the informed consent to be used for this study.
  ///
  /// This method will upload the informed consent as a file to CARP using the
  /// [INFORMED_CONSENT_FILE_NAME] file name.
  ///
  /// Returns `true` if upload is successful, `false` otherwise.
  Future<bool> setInformedConsent(RPOrderedTask informedConsent) async {
    assert(CarpService().isConfigured,
        "CARP Service has not been configured - call 'CarpService().configure()' first.");
    assert(CarpService().currentUser != null,
        "No user is authenticated - call 'CarpService().authenticate()' first.");
    info(
        'Uploading informed consent document to path : $INFORMED_CONSENT_PATH');

    this.informedConsent = informedConsent;
    DocumentReference reference = CarpService().document(INFORMED_CONSENT_PATH);
    await reference.get();
    DocumentSnapshot document =
        await reference.setData(informedConsent.toJson());

    return (document != null);
  }

  /// Delete the informed consent for this study.
  ///
  /// Returns `true` if delete is successful, `false` otherwise.
  Future<bool> deleteInformedConsent() async {
    assert(CarpService().isConfigured,
        "CARP Service has not been configured - call 'CarpService().configure()' first.");
    assert(CarpService().currentUser != null,
        "No user is authenticated - call 'CarpService().authenticate()' first.");
    info('Deleting informed consent document at path : $INFORMED_CONSENT_PATH');

    DocumentReference reference = CarpService().document(INFORMED_CONSENT_PATH);
    await reference.delete();
    DocumentSnapshot document =
        await CarpService().document(INFORMED_CONSENT_PATH).get();

    return (document == null);
  }

  // --------------------------------------------------------------------------
  // LOCALIZATION
  // --------------------------------------------------------------------------

  /// The path for the language documents at the CARP server.
  /// Each language locale has its own document
  static const String LOCALIZATION_CONSENT_PATH = 'localizations/';

  String getLocalizationsPath(Locale locale) =>
      '$LOCALIZATION_CONSENT_PATH${locale.languageCode}';

  /// Get localization mapping as json for the specified [locale].
  ///
  /// Locale json is named according to the [locale] languageCode.
  /// For example, the Danish translation is named `da`
  ///
  /// If there is no language resouce on the CARP server, `null` is
  /// returned.
  Future<Map<String, String>> getLocalizations(Locale locale) async {
    assert(CarpService().isConfigured,
        "CARP Service has not been configured - call 'CarpService().configure()' first.");
    assert(CarpService().currentUser != null,
        "No user is authenticated - call 'CarpService().authenticate()' first.");

    info('Getting language locale from path : ${getLocalizationsPath(locale)}');
    DocumentSnapshot document =
        await CarpService().document(getLocalizationsPath(locale)).get();

    if (document != null)
      return document.data
          ?.map((key, value) => MapEntry(key, value.toString()));

    return null;
  }

  /// Set localization mapping for the specified [locale].
  ///
  /// Locale json is named according to the [locale] languageCode.
  /// For example, the Danish translation is named `da`
  ///
  /// Returns `true` if upload is successful, `false` otherwise.
  Future<bool> setLocalizations(
      Locale locale, Map<String, dynamic> localizations) async {
    assert(CarpService().isConfigured,
        "CARP Service has not been configured - call 'CarpService().configure()' first.");
    assert(CarpService().currentUser != null,
        "No user is authenticated - call 'CarpService().authenticate()' first.");

    info('Setting language locale from path : ${getLocalizationsPath(locale)}');

    DocumentReference reference =
        CarpService().document(getLocalizationsPath(locale));
    await reference.get(); //check if this already exists
    DocumentSnapshot document = await reference.setData(localizations);

    return (document != null);
  }

  /// Delete the localization for the [locale].
  ///
  /// Returns `true` if delete is successful, `false` otherwise.
  Future<bool> deleteLocalizations(Locale locale) async {
    assert(CarpService().isConfigured,
        "CARP Service has not been configured - call 'CarpService().configure()' first.");
    assert(CarpService().currentUser != null,
        "No user is authenticated - call 'CarpService().authenticate()' first.");
    info(
        'Deleting language locale from path : ${getLocalizationsPath(locale)}');

    DocumentReference reference =
        CarpService().document(getLocalizationsPath(locale));
    await reference.delete();
    DocumentSnapshot document =
        await CarpService().document(getLocalizationsPath(locale)).get();

    return (document == null);
  }
}
