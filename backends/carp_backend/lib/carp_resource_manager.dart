/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_backend;

/// Handles different types of CAMS-specific resources.
///
/// This includes:
///
///  * Retrive and store [StudyDescription]s.
///  * Retrieve and store informed consent definitions as [RPOrderedTask] json
///    definitions at the CARP backend.
///  * Retrive and store langunage localization mappings.
///
abstract class ResourceManager {
  Future initialize() async {}

  // --------------------------------------------------------------------------
  // STUDY DESCRIPTION
  // --------------------------------------------------------------------------

  /// The latest downloaded study description.
  ///
  /// `null` if no consent has been downloaded yet. Use the [getInformedConsent]
  /// method to get the informed consent document from CARP.
  StudyDescription? get studyDescription;

  /// Get the description for this study.
  ///
  /// If there is no description, `null` is returned.
  Future<StudyDescription?> getStudyDescription();

  /// Set the informed consent to be used for this study.
  Future<bool> setStudyDescription(StudyDescription description);

  /// Delete the informed consent for this study.
  ///
  /// Returns `true` if delete is successful, `false` otherwise.
  Future<bool> deleteStudyDescription();

  // --------------------------------------------------------------------------
  // INFORMED CONSENT
  // --------------------------------------------------------------------------

  /// The latest downloaded informed consent document.
  ///
  /// `null` if no consent has been downloaded yet. Use the [getInformedConsent]
  /// method to get the informed consent document from CARP.
  RPOrderedTask? get informedConsent;

  /// Get the informed consent to be shown for this study.
  ///
  /// This method return a [RPOrderedTask] which is an ordered list of [RPStep]
  /// which are shown to the user as the informed consent flow.
  /// See [research_package](https://pub.dev/packages/research_package) for a
  /// description on how to create an informed consent in the research package
  /// domain model.
  ///
  /// If there is no informed consent, `null` is returned.
  Future<RPOrderedTask?> getInformedConsent();

  /// Set the informed consent to be used for this study.
  Future<bool> setInformedConsent(RPOrderedTask informedConsent);

  /// Delete the informed consent for this study.
  ///
  /// Returns `true` if delete is successful, `false` otherwise.
  Future<bool> deleteInformedConsent();

  // --------------------------------------------------------------------------
  // LOCALIZATION
  // --------------------------------------------------------------------------

  /// Get localization mapping as json for the specified [locale].
  ///
  /// Locale json is named according to the [locale] languageCode.
  /// For example, the Danish translation is named `da`
  ///
  /// If there is no language resouce, `null` is returned.
  Future<Map<String, String>?> getLocalizations(Locale locale);

  /// Set localization mapping for the specified [locale].
  ///
  /// Locale json is named according to the [locale] languageCode.
  /// For example, the Danish translation is named `da`
  ///
  /// Returns `true` if successful, `false` otherwise.
  Future<bool> setLocalizations(
      Locale locale, Map<String, dynamic> localizations);

  /// Delete the localization for the [locale].
  ///
  /// Returns `true` if successful, `false` otherwise.
  Future<bool> deleteLocalizations(Locale locale);
}

/// Handles different types of CAMS-specific resources at the CARP service.
///
/// This includes:
///
///  * Retrieve and store informed consent definitions as [RPOrderedTask] json
///    definitions at the CARP backend.
///  * Retrive and store langunage localization mappings.
///
class CarpResourceManager implements ResourceManager {
  static final CarpResourceManager _instance = CarpResourceManager._();
  factory CarpResourceManager() => _instance;

  CarpResourceManager._() {
    // to initialize json serialization for RP classes
    RPOrderedTask(identifier: '', steps: []);
  }

  @override
  Future initialize() async {}

  // --------------------------------------------------------------------------
  // STUDY DESCRIPTION
  // --------------------------------------------------------------------------

  /// The path for the informed consent document at the CARP server
  static const String STUDY_DESCRIPTION_PATH = 'resources/description';

  @override
  StudyDescription? studyDescription;

  @override
  Future<StudyDescription?> getStudyDescription() async {
    assert(CarpService().isConfigured,
        "CARP Service has not been configured - call 'CarpService().configure()' first.");
    assert(CarpService().currentUser != null,
        "No user is authenticated - call 'CarpService().authenticate()' first.");

    info('Getting study description from path : $STUDY_DESCRIPTION_PATH');

    DocumentSnapshot? document =
        await CarpService().document(STUDY_DESCRIPTION_PATH).get();
    info('Informed consent downloaded : $document');

    if (document != null) {
      studyDescription = StudyDescription.fromJson(document.data);
    }
    return studyDescription;
  }

  @override
  Future<bool> setStudyDescription(StudyDescription description) async {
    assert(CarpService().isConfigured,
        "CARP Service has not been configured - call 'CarpService().configure()' first.");
    assert(CarpService().currentUser != null,
        "No user is authenticated - call 'CarpService().authenticate()' first.");

    info('Uploading study description to path : $STUDY_DESCRIPTION_PATH');

    this.studyDescription = description;
    DocumentReference reference =
        CarpService().document(STUDY_DESCRIPTION_PATH);
    await reference.get();
    await reference.setData(description.toJson());

    return true;
  }

  @override
  Future<bool> deleteStudyDescription() async {
    assert(CarpService().isConfigured,
        "CARP Service has not been configured - call 'CarpService().configure()' first.");
    assert(CarpService().currentUser != null,
        "No user is authenticated - call 'CarpService().authenticate()' first.");
    info('Deleting study description from path : $STUDY_DESCRIPTION_PATH');

    DocumentReference reference =
        CarpService().document(STUDY_DESCRIPTION_PATH);
    await reference.delete();
    DocumentSnapshot? document =
        await CarpService().document(STUDY_DESCRIPTION_PATH).get();

    return (document == null);
  }

  // --------------------------------------------------------------------------
  // INFORMED CONSENT
  // --------------------------------------------------------------------------

  /// The path for the informed consent document at the CARP server
  static const String INFORMED_CONSENT_PATH = 'resources/informed_consent';

  @override
  RPOrderedTask? informedConsent;

  @override
  Future<RPOrderedTask?> getInformedConsent() async {
    assert(CarpService().isConfigured,
        "CARP Service has not been configured - call 'CarpService().configure()' first.");
    assert(CarpService().currentUser != null,
        "No user is authenticated - call 'CarpService().authenticate()' first.");

    info(
        'Getting informed consent document from path : $INFORMED_CONSENT_PATH');

    // initialize json serialization for RP classes
    RPOrderedTask(identifier: '', steps: []);
    DocumentSnapshot? document =
        await CarpService().document(INFORMED_CONSENT_PATH).get();
    info('Informed consent downloaded : $document');

    if (document != null) {
      informedConsent = RPOrderedTask.fromJson(document.data);
    }
    return informedConsent;
  }

  @override
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
    await reference.setData(informedConsent.toJson());

    return true;
  }

  @override
  Future<bool> deleteInformedConsent() async {
    assert(CarpService().isConfigured,
        "CARP Service has not been configured - call 'CarpService().configure()' first.");
    assert(CarpService().currentUser != null,
        "No user is authenticated - call 'CarpService().authenticate()' first.");
    info('Deleting informed consent document at path : $INFORMED_CONSENT_PATH');

    DocumentReference reference = CarpService().document(INFORMED_CONSENT_PATH);
    await reference.delete();
    DocumentSnapshot? document =
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

  @override
  Future<Map<String, String>?> getLocalizations(Locale locale) async {
    assert(CarpService().isConfigured,
        "CARP Service has not been configured - call 'CarpService().configure()' first.");
    assert(CarpService().currentUser != null,
        "No user is authenticated - call 'CarpService().authenticate()' first.");

    info('Getting language locale from path : ${getLocalizationsPath(locale)}');
    DocumentSnapshot? document =
        await CarpService().document(getLocalizationsPath(locale)).get();

    if (document != null)
      return document.data.map((key, value) => MapEntry(key, value.toString()));
    else
      return null;
  }

  @override
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
    await reference.setData(localizations);

    return true;
  }

  @override
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
    DocumentSnapshot? document =
        await CarpService().document(getLocalizationsPath(locale)).get();

    return (document == null);
  }
}
