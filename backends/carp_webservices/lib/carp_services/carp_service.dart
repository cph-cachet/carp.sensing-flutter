/*
 * Copyright 2018-2020 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_services;

/// Provide access to a CARP web service endpoint.
///
/// The (current) assumption is that each Flutter app (using this library) will
/// only connect to one CARP web service backend.
/// Therefore a [CarpService] is a singleton and can be used like:
///
/// ```dart
///   CarpService().configure(myApp);
///   CarpUser user = await CarpService()
///     .authenticate(username: "user@dtu.dk", password: "password");
/// ```
class CarpService extends CarpBaseService {
  static final CarpService _instance = CarpService._();
  CarpService._();

  /// Returns the singleton default instance of the [CarpService].
  /// Before this instance can be used, it must be configured using the
  /// [configure] method.
  factory CarpService() => _instance;

  FlutterAppAuth appAuth = const FlutterAppAuth();

  @override
  // RPC is not used in the CarpService endpoints which are named differently.
  String get rpcEndpointName => throw UnimplementedError();

  // --------------------------------------------------------------------------
  // AUTHENTICATION
  // --------------------------------------------------------------------------

  /// The URI for the authenticated endpoint for this [CarpService].
  ///
  /// The fomat is `https://cans.cachet.dk/forgotten` for the production host
  /// and `https://cans.cachet.dk/portal/stage/forgotten` for the stage, test,
  /// and dev hosts.
  Uri get authEndpointUri => app.authURL;

  /// Is a user authenticated?
  /// If `true`, the authenticated user is [currentUser].
  bool get authenticated => (_currentUser != null);

  @override
  CarpApp get app => nonNullAble(_app);

  @override
  CarpUser get currentUser => nonNullAble(_currentUser);

  final StreamController<AuthEvent> _authEventController =
      StreamController.broadcast();

  /// Notifies about changes to the user's authentication state (such as sign-in or
  /// sign-out) as defined in [AuthEvent].
  Stream<AuthEvent> get authStateChanges =>
      _authEventController.stream.asBroadcastStream();

  /// Makes sure that the [CarpApp] or [CarpUser] is configured, by throwing a [CarpServiceException] if they are null.
  /// Otherwise, returns the non-null value.
  T nonNullAble<T>(T? argument) {
    if (argument == null && argument is CarpApp) {
      throw CarpServiceException(
          message:
              "CARP Service not initialized. Call 'CarpService().configure()' first.");
    } else if (argument == null && argument is CarpUser) {
      throw CarpServiceException(
          message:
              "CARP User not authenticated. Call 'CarpService().authenticate()' first.");
    } else {
      return argument!;
    }
  }

  Future<CarpUser> authenticate() async {
    final AuthorizationTokenResponse? response =
        await appAuth.authorizeAndExchangeCode(
      AuthorizationTokenRequest(
        app.clientId, "${app.redirectURI}",
        discoveryUrl: "${app.discoveryURL}",
        scopes: ['openid'], // To get an ID token
      ),
    );

    if (response != null) {
      _currentUser = getCurrentUserProfile(response);
      currentUser.authenticated(OAuthToken.fromTokenResponse(response));
      _authEventController.add(AuthEvent.authenticated);
      return currentUser;
    }

    // All other cases are treated as a failed attempt and throws an error
    _authEventController.add(AuthEvent.failed);
    _currentUser = null;

    // auth error response from CARP is on the form
    //      {error: invalid_grant, error_description: Bad credentials}
    throw CarpServiceException(
      httpStatus: HTTPStatus(401),
      message: 'Authentication failed.',
    );
  }

  Future<CarpUser> refresh() async {
    final TokenResponse? response = await appAuth.token(
      TokenRequest(
        app.clientId,
        "${app.redirectURI}",
        discoveryUrl: "${app.discoveryURL}",
        refreshToken: currentUser.token!.refreshToken,
      ),
    );

    if (response != null) {
      currentUser.authenticated(OAuthToken.fromTokenResponse(response));
      _authEventController.add(AuthEvent.refreshed);
      return currentUser;
    }

    // All other cases are treated as a failed attempt and throws an error
    _authEventController.add(AuthEvent.failed);
    _currentUser = null;

    // auth error response from CARP is on the form
    //      {error: invalid_grant, error_description: Bad credentials}
    throw CarpServiceException(
      httpStatus: HTTPStatus(401),
      message: 'Authentication failed.',
    );
  }

  /// Logout from CARP
  Future<void> logout() async {
    await appAuth.endSession(
      EndSessionRequest(
        discoveryUrl: "${app.discoveryURL}",
        idTokenHint: currentUser.token!.idToken,
        postLogoutRedirectUrl: "${app.logoutRedirectURI ?? app.redirectURI}",
      ),
    );

    _currentUser = null;
  }

  // --------------------------------------------------------------------------
  // USERS
  // --------------------------------------------------------------------------

  /// Gets the CARP profile of the current user from the JWT token
  CarpUser getCurrentUserProfile(TokenResponse response) {
    var jwt = JwtDecoder.decode(response.accessToken!);
    return CarpUser.fromJWT(jwt);
  }

  /// The headers for any authenticated HTTP REST call to this [CarpService].
  @override
  Map<String, String> get headers {
    if (currentUser.token == null) {
      throw CarpServiceException(
          message:
              "OAuth token is null. Call 'CarpService().authenticate()' first.");
    }

    return {
      "Content-Type": "application/json",
      "Authorization": "bearer ${currentUser.token!.accessToken}",
      "cache-control": "no-cache"
    };
  }

  // --------------------------------------------------------------------------
  // CONSENT DOCUMENT
  // --------------------------------------------------------------------------

  /// The URL for the consent document end point for this [CarpService].
  String get consentDocumentEndpointUri =>
      "${app.uri.toString()}/api/deployments/${app.studyDeploymentId}/consent-documents";

  /// Create a new (signed) consent document for this user.
  /// Returns the created [ConsentDocument] if the document is uploaded correctly.
  Future<ConsentDocument> createConsentDocument(
      Map<String, dynamic> document) async {
    // POST the document to the CARP web service
    http.Response response = await http.post(
        Uri.parse(Uri.encodeFull(consentDocumentEndpointUri)),
        headers: headers,
        body: json.encode(document));

    int httpStatusCode = response.statusCode;
    Map<String, dynamic> responseJson =
        json.decode(response.body) as Map<String, dynamic>;

    if ((httpStatusCode == HttpStatus.ok) ||
        (httpStatusCode == HttpStatus.created)) {
      return ConsentDocument._(responseJson);
    }

    // All other cases are treated as an error.
    throw CarpServiceException(
      httpStatus: HTTPStatus(httpStatusCode, response.reasonPhrase),
      message: responseJson["message"].toString(),
      path: responseJson["path"].toString(),
    );
  }

  /// Get a previously uploaded (signed) [ConsentDocument] based on its [id].
  Future<ConsentDocument> getConsentDocument(int id) async {
    String url = "$consentDocumentEndpointUri/$id";

    // GET the consent document from the CARP web service
    http.Response response =
        await httpr.get(Uri.encodeFull(url), headers: headers);

    int httpStatusCode = response.statusCode;
    Map<String, dynamic> responseJson =
        json.decode(response.body) as Map<String, dynamic>;

    if (httpStatusCode == HttpStatus.ok) return ConsentDocument._(responseJson);

    // All other cases are treated as an error.
    throw CarpServiceException(
      httpStatus: HTTPStatus(httpStatusCode, response.reasonPhrase),
      message: responseJson["message"].toString(),
      path: responseJson["path"].toString(),
    );
  }

  // --------------------------------------------------------------------------
  // DATA POINT
  // --------------------------------------------------------------------------

  /// Creates a new [DataPointReference] initialized at the current
  /// CarpService storage location.
  DataPointReference getDataPointReference() => DataPointReference._(this);

  // --------------------------------------------------------------------------
  // FILES
  // --------------------------------------------------------------------------

  /// The URL for the file end point for this [CarpService].
  String get fileEndpointUri =>
      "${app.uri.toString()}/api/studies/${app.studyId}/files";

  /// Get a [FileStorageReference] that reference a file at the current
  /// CarpService storage location.
  /// [id] can be omitted if a local file is not uploaded yet.
  FileStorageReference getFileStorageReference([int id = -1]) =>
      FileStorageReference._(this, id);

  /// Get a [FileStorageReference] that reference a file with the original name
  /// [name] at the current CarpService storage location.
  ///
  /// If more than one file with the same name exists, the first one is returned.
  /// If no files with that name exists, `null` is returned.
  Future<FileStorageReference?> getFileStorageReferenceByName(
      String name) async {
    final List<CarpFileResponse> files =
        await queryFiles('original_name==$name');

    return (files.isNotEmpty)
        ? FileStorageReference._(this, files[0].id)
        : null;
  }

  /// Get all file objects in the study.
  Future<List<CarpFileResponse>> getAllFiles() async => await queryFiles();

  /// Returns file objects in the study based on a [query].
  ///
  /// If [query] is omitted, all file objects are returned.
  Future<List<CarpFileResponse>> queryFiles([String? query]) async {
    final String url =
        (query != null) ? "$fileEndpointUri?query=$query" : fileEndpointUri;

    http.Response response =
        await httpr.get(Uri.encodeFull(url), headers: headers);
    int httpStatusCode = response.statusCode;

    print(response.body);

    switch (httpStatusCode) {
      case 200:
        {
          List<dynamic> list = json.decode(response.body) as List<dynamic>;
          List<CarpFileResponse> fileList = [];
          for (var element in list) {
            fileList.add(CarpFileResponse._(element as Map<String, dynamic>));
          }
          return fileList;
        }
      default:
        // All other cases are treated as an error.
        {
          Map<String, dynamic> responseJson =
              json.decode(response.body) as Map<String, dynamic>;
          throw CarpServiceException(
            httpStatus: HTTPStatus(httpStatusCode, response.reasonPhrase),
            message: responseJson["message"].toString(),
            path: responseJson["path"].toString(),
          );
        }
    }
  }

  // --------------------------------------------------------------------------
  // DOCUMENTS & COLLECTIONS
  // --------------------------------------------------------------------------

  /// Gets a [DocumentReference] for the specified unique id.
  DocumentReference documentById(int id) => DocumentReference._id(this, id);

  /// Gets a [DocumentReference] for the specified [path].
  DocumentReference document(String path) =>
      DocumentReference._path(this, path);

  /// The URL for the document end point for this [CarpService].
  String get documentEndpointUri =>
      "${app.uri.toString()}/api/studies/${app.studyId}/documents";

  /// Get a list documents based on a query.
  ///
  /// The [query] string uses the RSQL query language for RESTful APIs.
  /// See the [RSQL Documentation](https://developer.here.com/documentation/data-client-library/dev_guide/client/rsql.html).
  ///
  /// Can only be accessed by users who are authenticated as researchers.
  Future<List<DocumentSnapshot>> documentsByQuery(String query) async {
    // GET the list of documents in this collection from the CARP web service
    http.Response response = await httpr.get(
        Uri.encodeFull('$documentEndpointUri?query=$query'),
        headers: headers);
    int httpStatusCode = response.statusCode;

    if (httpStatusCode == HttpStatus.ok) {
      List<dynamic> documentsJson = json.decode(response.body) as List<dynamic>;
      List<DocumentSnapshot> documents = [];
      for (var item in documentsJson) {
        Map<String, dynamic> documentJson = item as Map<String, dynamic>;
        String key = documentJson["name"].toString();
        documents.add(DocumentSnapshot._(key, documentJson));
      }
      return documents;
    }

    // All other cases are treated as an error.
    Map<String, dynamic> responseJson =
        json.decode(response.body) as Map<String, dynamic>;
    throw CarpServiceException(
      httpStatus: HTTPStatus(httpStatusCode, response.reasonPhrase),
      message: responseJson["message"].toString(),
      path: responseJson["path"].toString(),
    );
  }

  /// Get all documents for this study.
  ///
  /// Can only be accessed by users who are authenticated as researchers.
  ///
  /// Note that this might return a very long list of documents and the
  /// request may time out.
  Future<List<DocumentSnapshot>> documents() async {
    http.Response response =
        await httpr.get(Uri.encodeFull(documentEndpointUri), headers: headers);
    int httpStatusCode = response.statusCode;

    if (httpStatusCode == HttpStatus.ok) {
      List<dynamic> documentsJson = json.decode(response.body) as List<dynamic>;
      List<DocumentSnapshot> documents = [];
      for (var item in documentsJson) {
        Map<String, dynamic> documentJson = item as Map<String, dynamic>;
        String key = documentJson["name"].toString();
        documents.add(DocumentSnapshot._(key, documentJson));
      }
      return documents;
    }

    // All other cases are treated as an error.
    Map<String, dynamic> responseJson =
        json.decode(response.body) as Map<String, dynamic>;
    throw CarpServiceException(
      httpStatus: HTTPStatus(httpStatusCode, response.reasonPhrase),
      message: responseJson["message"].toString(),
      path: responseJson["path"].toString(),
    );
  }

  /// Gets a [CollectionReference] for the specified [path].
  CollectionReference collection(String path) =>
      CollectionReference._(this, path);
}

/// Authentication state change events.
enum AuthEvent {
  /// The user has successfully been authenticated (signed in).
  authenticated,

  /// The user has been unauthenticated (signed out).
  unauthenticated,

  /// Authentication failed.
  failed,

  /// The user's token has successfully been refreshed.
  refreshed,

  /// A password reset email has been send to the user.
  reset,
}
