/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_backend;

/// Implementation of [InformedConsentManager], [LocalizationManager], and
/// [MessageManager] in the CARP service.
///
/// Also supports local caching of these resources locally on the phone
/// (except for messages, which is assumed to be handled by the app).
class CarpResourceManager
    implements InformedConsentManager, LocalizationManager, MessageManager {
  /// The base path for resources - both on the CARP server and locally on the phone
  static const String RESOURCE_PATH = 'resources';

  /// The base path for messages - both on the CARP server and locally on the phone
  static const String MESSAGES_PATH = 'messages';

  /// The path for the language documents at the CARP server.
  /// Each language locale has its own document
  static const String LOCALIZATION_PATH = 'localizations';

  static final CarpResourceManager _instance = CarpResourceManager._();
  factory CarpResourceManager() => _instance;

  CarpResourceManager._() {
    // Initialization of serialization
    CarpMobileSensing();
    ResearchPackage();
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
      final directory =
          await Directory('${await Settings().carpBasePath}/$RESOURCE_PATH')
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

  // --------------------------------------------------------------------------
  // INITIALIZATION
  // --------------------------------------------------------------------------

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
    ResearchPackage();
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
      final directory =
          await Directory('${await Settings().carpBasePath}/$LOCALIZATION_PATH')
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

      result = document?.data;

      if (cache && result != null) {
        info("Saving localization for '$locale' to local cache.");
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

  // --------------------------------------------------------------------------
  // MESSAGES
  // --------------------------------------------------------------------------

  int? _messagesCollectionId;

  /// The query for use for getting the message from the CARP server
  String _getMessagesQuery(DateTime start, DateTime end) =>
      // 'query=collection_id==$_messagesCollectionId;updated_at>${start.toUtc()};updated_at<${end.toUtc()}';
      'collection_id==$_messagesCollectionId';

  @override
  Future<Message?> getMessage(String messageId) async {
    _assertCarpService();
    DocumentSnapshot? message =
        await CarpService().document('$MESSAGES_PATH/$messageId').get();
    return (message != null) ? Message.fromJson(message.data) : null;
  }

  @override
  Future<List<Message>> getMessages({
    DateTime? start,
    DateTime? end,
    int? count = 20,
  }) async {
    _assertCarpService();
    start ??=
        DateTime.fromMillisecondsSinceEpoch(0); // this is a looooooong time ago
    end ??= DateTime.now();

    // TODO - The query interface does not work - change back when issue is fixed
    // // first get the collection ID for the messages, if not know already
    // if (_messagesCollectionId == null) {
    //   _messagesCollectionId =
    //       (await CarpService().collection(MESSAGES_PATH).get()).id;
    // }
    // info('Getting messages from CARP server. '
    //     'study_id: ${CarpService().app?.studyId}, '
    //     'query: ${_getMessagesQuery(start, end)}');
    // List<DocumentSnapshot> messages =
    //     await CarpService().documentsByQuery(_getMessagesQuery(start, end));

    List<DocumentSnapshot> messages =
        await CarpService().collection(MESSAGES_PATH).documents;

    info('Messages downloaded - # : ${messages.length}');

    return messages
        .map((message) => Message.fromJson(message.data))
        .toList()
        .sublist(0, (count! < messages.length) ? count : messages.length);
  }

  @override
  Future<void> setMessage(Message message) async {
    _assertCarpService();
    await CarpService()
        .collection(MESSAGES_PATH)
        .document(message.id)
        .setData(message.toJson());
  }

  @override
  Future<void> deleteMessage(String messageId) async {
    _assertCarpService();
    await CarpService().collection(MESSAGES_PATH).document(messageId).delete();
  }

  @override
  Future<void> deleteAllMessages() async {
    _assertCarpService();
    List<DocumentSnapshot> documents =
        await CarpService().collection(MESSAGES_PATH).documents;
    for (var document in documents) {
      await CarpService()
          .collection(MESSAGES_PATH)
          .document(document.name)
          .delete();
    }
  }
}
