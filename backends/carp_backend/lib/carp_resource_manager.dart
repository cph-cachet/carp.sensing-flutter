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
///  * Retrieve and store informed consent definitions as [RPOrderedTask] json
///    definitions at the CARP backend.
///  * Retrive and store langunage localization mappings.
///
abstract class ResourceManager {
  Future initialize() async {}

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
///  * Retrive and store [StudyDescription]s.
///  * Retrieve and store informed consent definitions as [RPOrderedTask] json
///    definitions at the CARP backend.
///  * Retrive and store langunage localization mappings.
///
/// Supports local caching of these resources locally on the phone.
class CarpResourceManager implements ResourceManager {
  /// The base path for resources - both on the CARP server and locally on the phone
  static const String RESOURCE_PATH = 'resources';

  /// The path for the language documents at the CARP server.
  /// Each language locale has its own document
  static const String LOCALIZATION_PATH = 'localizations';

  static final CarpResourceManager _instance = CarpResourceManager._();
  factory CarpResourceManager() => _instance;

  CarpResourceManager._() {
    // make sure that the json functions are loaded
    DomainJsonFactory();

    // to initialize json serialization for RP classes
    RPOrderedTask(identifier: '', steps: []);
  }

  // --------------------------------------------------------------------------

  String? _cacheResourcePath;

  final Map<Type, String> _resourceNames = {
    RPOrderedTask: 'informed_consent',
  };

  void _assertCarpService() {
    assert(CarpService().isConfigured,
        "CARP Service has not been configured - call 'CarpService().configure()' first.");
    assert(CarpService().currentUser != null,
        "No user is authenticated - call 'CarpService().authenticate()' first.");
  }

  /// The path for the [resource] at the CARP server
  String _getResourcePath(Type resource) =>
      '$RESOURCE_PATH/${_resourceNames[resource]}';

  /// The full path and filename of the local cache of the [resource]
  Future<String> _cacheFilename(Type resource) async {
    if (_cacheResourcePath == null) {
      final directory = await Directory(
              '${await Settings().deploymentBasePath}/$RESOURCE_PATH')
          .create(recursive: true);
      _cacheResourcePath = directory.path;
    }
    return '$_cacheResourcePath/${_resourceNames[resource]}.json';
  }

  Future<Map<String, dynamic>?> _getResource(
    Type resource, {
    bool refresh = false,
  }) async {
    info("Getting resource of type '$resource', refresh: $refresh.");

    Map<String, dynamic>? result;

    // first try to get local cache
    if (!refresh) {
      try {
        String jsonString =
            File(await _cacheFilename(resource)).readAsStringSync();
        result = json.decode(jsonString) as Map<String, dynamic>;
      } catch (exception) {
        warning("Failed to read cache of type '$resource' - $exception");
      }
    }

    // if no local cache (or refresh is true)
    if (result == null) {
      _assertCarpService();

      DocumentSnapshot? document =
          await CarpService().document(_getResourcePath(resource)).get();
      info('Resource downloaded : $document');

      result = (document != null) ? document.data : null;

      if (result != null) {
        info("Saving '$resource' to local cache.");
        try {
          final json = jsonEncode(result);
          File(await _cacheFilename(resource)).writeAsStringSync(json);
        } catch (exception) {
          warning("Failed to save local cache for '$resource' - $exception");
        }
      }
    }

    return result;
  }

  Future<bool> _setResource(Serializable resource) async {
    _assertCarpService();
    info("Uploading resource: $resource");

    DocumentReference reference =
        CarpService().document(_getResourcePath(resource.runtimeType));
    await reference.get();
    await reference.setData(resource.toJson());

    return true;
  }

  Future<bool> _deleteResource(Type resource) async {
    _assertCarpService();
    info("Deleting resource of type '$resource'.");

    DocumentReference reference =
        CarpService().document(_getResourcePath(resource));
    await reference.delete();
    DocumentSnapshot? document =
        await CarpService().document(_getResourcePath(resource)).get();

    // also trying to delete local cached version
    try {
      File(await _cacheFilename(resource)).deleteSync();
    } catch (exception) {
      warning("Failed to delete local cache for '$resource' - $exception");
    }

    return (document == null);
  }

  @override
  Future initialize() async {}

  // --------------------------------------------------------------------------
  // INFORMED CONSENT
  // --------------------------------------------------------------------------

  @override
  RPOrderedTask? informedConsent;

  @override
  Future<RPOrderedTask?> getInformedConsent({bool refresh = false}) async {
    // initialize json serialization for RP classes
    RPOrderedTask(identifier: '', steps: []);
    Map<String, dynamic>? json =
        await _getResource(RPOrderedTask, refresh: refresh);

    return informedConsent =
        (json != null) ? RPOrderedTask.fromJson(json) : null;
  }

  @override
  Future<bool> setInformedConsent(RPOrderedTask informedConsent) async {
    this.informedConsent = informedConsent;
    return await _setResource(informedConsent);
  }

  @override
  Future<bool> deleteInformedConsent() async =>
      await _deleteResource(RPOrderedTask);

  // --------------------------------------------------------------------------
  // LOCALIZATION
  // --------------------------------------------------------------------------

  String? _cacheLocalizationPath;

  /// The path for the [locale] at the CARP server
  String _getLocalizationsPath(Locale locale) =>
      '$LOCALIZATION_PATH/${locale.languageCode}';

  /// The full path and filename of the local cache of the [locale]
  Future<String> _cacheLocalizationFilename(Locale locale) async {
    if (_cacheLocalizationPath == null) {
      final directory = await Directory(
              '${await Settings().deploymentBasePath}/$LOCALIZATION_PATH')
          .create(recursive: true);
      _cacheLocalizationPath = directory.path;
    }
    return '$_cacheLocalizationPath/${locale.languageCode}.json';
  }

  @override
  Future<Map<String, String>?> getLocalizations(
    Locale locale, {
    bool refresh = false,
    bool cache = true,
  }) async {
    Map<String, dynamic>? result;

    // first try to get local cache
    if (!refresh) {
      try {
        String filename = await _cacheLocalizationFilename(locale);
        info('Getting language locale from cache : $filename');
        String jsonString = File(filename).readAsStringSync();
        result = json.decode(jsonString) as Map<String, dynamic>;
      } catch (exception) {
        warning(
            "Failed to read localization from cache of type '$locale' - $exception");
      }
    }

    // if no local cache (or refresh is true)
    if (result == null) {
      _assertCarpService();

      info('Getting language locale from server. '
          'study_id: ${CarpService().app?.studyId}, '
          'path: ${_getLocalizationsPath(locale)}');
      DocumentSnapshot? document =
          await CarpService().document(_getLocalizationsPath(locale)).get();

      info('Localization downloaded : $document');

      // result = (document != null) ? document.data : null;
      result = document?.data;

      if (cache && result != null) {
        info("Saving localiztion for '$locale' to local cache.");
        try {
          final json = jsonEncode(result);
          File(await _cacheLocalizationFilename(locale))
              .writeAsStringSync(json);
        } catch (exception) {
          warning("Failed to save local cache for '$locale' - $exception");
        }
      }
    }

    return (result != null)
        ? result.map((key, value) => MapEntry(key, value.toString()))
        : null;
  }

  @override
  Future<bool> setLocalizations(
      Locale locale, Map<String, dynamic> localizations) async {
    _assertCarpService();
    info(
        'Setting language locale from path : ${_getLocalizationsPath(locale)}');

    DocumentReference reference =
        CarpService().document(_getLocalizationsPath(locale));
    await reference.get(); //check if this already exists
    await reference.setData(localizations);

    return true;
  }

  @override
  Future<bool> deleteLocalizations(Locale locale) async {
    _assertCarpService();
    info(
        'Deleting language locale from path : ${_getLocalizationsPath(locale)}');

    DocumentReference reference =
        CarpService().document(_getLocalizationsPath(locale));
    await reference.delete();
    DocumentSnapshot? document =
        await CarpService().document(_getLocalizationsPath(locale)).get();

    // also trying to delete local cached version
    try {
      File(await _cacheLocalizationFilename(locale)).deleteSync();
    } catch (exception) {
      warning(
          "Failed to delete local cache of localization for '$locale' - $exception");
    }

    return (document == null);
  }
}
