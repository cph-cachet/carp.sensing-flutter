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
  CarpService.instance() : this._();

  late OidcUserManager _manager;
  OidcUserManager get manager => _manager;

  @override
  void configure(CarpApp app) {
    super.configure(app);

    _manager = OidcUserManager.lazy(
      discoveryDocumentUri: OidcUtils.getOpenIdConfigWellKnownUri(
        Uri.parse(app.discoveryURL.toString()),
      ),
      clientCredentials: OidcClientAuthentication.none(
        clientId: app.clientId,
      ),
      store: OidcDefaultStore(),
      settings: OidcUserManagerSettings(
        redirectUri: Uri.parse(app.redirectURI.toString()),
        scope: ['openid'],
        prompt: ['login'],
        options: const OidcPlatformSpecificOptions(
          ios: OidcPlatformSpecificOptions_AppAuth_IosMacos(
            preferEphemeralSession: true,
          ),
          web: OidcPlatformSpecificOptions_Web(
            navigationMode:
                OidcPlatformSpecificOptions_Web_NavigationMode.newPage,
          ),
        ),
      ),
    );

    _manager.init();

    _manager.userChanges().listen((user) {
      print('current user $user');
      if (user == null) {
        _currentUser = null;
        _authEventController.add(AuthEvent.unauthenticated);
      } else {
        _currentUser = getCurrentUserProfile(user);
        _authEventController.add(AuthEvent.authenticated);
      }
    });
  }

  // RPC is not used in the CarpService endpoints which are named differently.
  @override
  String get rpcEndpointName => throw UnimplementedError();

  // --------------------------------------------------------------------------
  // AUTHENTICATION
  // --------------------------------------------------------------------------

  /// The URI for the authenticated endpoint for this [CarpService].
  Uri get authEndpointUri => app.authURL;

  /// Is a user authenticated?
  /// If `true`, the authenticated user is [currentUser].
  bool get authenticated => (_currentUser != null);

  @override
  CarpApp get app => nonNullAble(_app);

  @override
  CarpUser get currentUser => nonNullAble(_currentUser);
  set currentUser(CarpUser? user) => _currentUser = user;

  final StreamController<AuthEvent> _authEventController =
      StreamController.broadcast();

  /// Notifies about changes to the user's authentication state (such as sign-in
  /// or sign-out) as defined in [AuthEvent].
  Stream<AuthEvent> get authStateChanges =>
      _authEventController.stream.asBroadcastStream();

  /// Makes sure that the [CarpApp] or [CarpUser] is configured, by throwing a
  /// [CarpServiceException] if they are null.
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

  /// Authenticate to this CARP service using a [BuildContext], that opens the
  /// authentication page of the Identity Server using a secure web view from the OS.
  ///
  /// The discovery URL in the [app] is used to find the Identity Server.
  ///
  /// Returns the signed in user (with an [OAuthToken] access token), if successful.
  /// Throws a [CarpServiceException] if not successful.
  Future<CarpUser> authenticate() async {
    OidcUser? response = await manager.loginAuthorizationCodeFlow();

    if (response != null) {
      _currentUser = getCurrentUserProfile(response);
      currentUser.authenticated(OAuthToken.fromTokenResponse(response.token));
      _authEventController.add(AuthEvent.authenticated);
      return currentUser;
    }

    // All other cases are treated as a failed attempt and throws an error
    _authEventController.add(AuthEvent.failed);
    _currentUser = null;

    // auth error response from CARP is in the form
    throw CarpServiceException(
      httpStatus: HTTPStatus(401),
      message: 'Authentication failed.',
    );
  }

  /// Authenticate to this CARP service using a [username] and [password].
  ///
  /// This method needs a [BuildContext] to authenticate but it does not open
  /// a web view. Use this if you want to create your own authentication page.
  ///
  /// The discovery URL in the [app] is used to find the Identity Server.
  ///
  /// Returns the signed in user (with an [OAuthToken] access token), if successful.
  /// Throws a [CarpServiceException] if not successful.
  // Future<CarpUser> authenticateWithUsernamePassword({
  //   required String username,
  //   required String password,
  // }) async {
  //   final TokenResponse? response = await appAuth.token(
  //     TokenRequest(
  //       app.clientId,
  //       "${app.redirectURI}",
  //       clientSecret: app.clientSecret ?? '',
  //       discoveryUrl: "${app.discoveryURL}",
  //       grantType: 'password',
  //       additionalParameters: Map.fromEntries([
  //         MapEntry('username', username),
  //         MapEntry('password', password),
  //       ]),
  //     ),
  //   );

  //   if (response != null) {
  //     currentUser.authenticated(OAuthToken.fromTokenResponse(response));
  //     _authEventController.add(AuthEvent.refreshed);
  //     return currentUser;
  //   }

  //   // All other cases are treated as a failed attempt and throws an error
  //   _authEventController.add(AuthEvent.failed);
  //   _currentUser = null;

  //   // auth error response from CARP is on the form
  //   //      {error: invalid_grant, error_description: Bad credentials}
  //   throw CarpServiceException(
  //     httpStatus: HTTPStatus(401),
  //     message: 'Authentication failed.',
  //   );
  // }

  /// Authenticate to this CARP service using a [username] and [password].
  ///
  /// This method is used only if neither [authenticate] nor
  /// [authenticateWithUsernamePassword] works for you, i.e. you do not have
  /// access to a [BuildContext].
  ///
  /// This method uses a POST request to the Identity Server to get an access token.
  /// The discovery URL in the [app] is used to find the Identity Server.
  ///
  /// Returns the signed in user (with an [OAuthToken] access token), if successful.
  /// Throws a [CarpServiceException] if not successful.
  // Future<CarpUser> authenticateWithUsernamePasswordNoContext({
  //   required String username,
  //   required String password,
  // }) async {
  //   final url = app.authURL.replace(pathSegments: [
  //     ...app.authURL.pathSegments,
  //     'protocol',
  //     'openid-connect',
  //     'token',
  //   ]);
  //   final body = {
  //     'client_id': app.clientId,
  //     'client_secret': app.clientSecret ?? '',
  //     'username': username,
  //     'password': password,
  //     'grant_type': 'password',
  //   };
  //   final headers = {
  //     'Content-Type': 'application/x-www-form-urlencoded',
  //   };

  //   final response = await http.post(url, body: body, headers: headers);

  //   final jsonResponse = json.decode(response.body);
  //   final tokenResponse =
  //       _convertToTokenResponse(jsonResponse as Map<String, dynamic>);
  //   CarpUser user = getCurrentUserProfile(tokenResponse);
  //   user.authenticated(OAuthToken.fromTokenResponse(tokenResponse));

  //   currentUser = user;

  //   return user;
  // }

  /// Authenticate to this CARP Service using a [OAuthToken] access token
  /// and a [CarpUser].
  /// This method is typically used to re-authenticate a user based on a previously
  /// granted access token, for example when the app is restarted.
  ///
  /// This does not require a [BuildContext] and does not open a web view.
  /// It does not require an internet connection either.
  ///
  /// Returns the [CarpUser] with the [OAuthToken] access token.
  CarpUser authenticateWithToken({
    required CarpUser user,
    required OAuthToken token,
  }) {
    user.authenticated(token);
    _currentUser = user;
    _authEventController.add(AuthEvent.authenticated);
    return user;
  }

  /// Get a new access token for the current user based on the
  /// previously granted refresh token, using the Identity Server discovery URL.
  ///
  /// This method is typically used when the access token has expired, and a new
  /// access token is needed to access the CARP web service. The refresh token
  /// expiration date is [OAuthToken.expiresAt] which has type [DateTime].
  ///
  /// Returns the signed in user (with a new [OAuthToken] access token), if successful.
  /// Throws a [CarpServiceException] if not successful.
  Future<CarpUser> refresh() async {
    final OidcUser? response = await manager.refreshToken();

    if (response != null) {
      currentUser = getCurrentUserProfile(response);
      currentUser.authenticated(OAuthToken.fromTokenResponse(response.token));
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

  /// Get a new access token for the current user based on the
  /// previously granted refresh token, using the Identity Server discovery URL.
  /// Need to have run any of the authenticate functions first.
  ///
  /// This method is used only if the [refresh] method does not work for you,
  /// i.e. you do not have access to a [BuildContext].
  /// Use this if you used [authenticateWithUsernamePasswordNoContext] to authenticate.
  ///
  /// This method uses a POST request to the Identity Server to get an access token.
  /// The discovery URL is used to find the Identity Server.
  ///
  /// This method is typically used when the access token has expired, and a new
  /// access token is needed to access the CARP web service. The refresh token
  /// expiration date is [OAuthToken.expiresAt], as a [DateTime].
  ///
  /// Returns the signed in user (with a new [OAuthToken] access token), if successful.
  /// Throws a [CarpServiceException] if not successful.
  // Future<CarpUser> refreshNoContext() async {
  //   final url = app.authURL.replace(pathSegments: [
  //     ...app.authURL.pathSegments,
  //     'protocol',
  //     'openid-connect',
  //     'token',
  //   ]);

  //   final body = {
  //     'client_id': app.clientId,
  //     'client_secret': app.clientSecret ?? '',
  //     'grant_type': 'refresh_token',
  //     'refresh_token': currentUser.token!.refreshToken,
  //   };
  //   final headers = {
  //     'Content-Type': 'application/x-www-form-urlencoded',
  //   };

  //   final response = await http.post(url, body: body, headers: headers);

  //   final jsonResponse = json.decode(response.body);
  //   final tokenResponse =
  //       _convertToTokenResponse(jsonResponse as Map<String, dynamic>);
  //   CarpUser user = getCurrentUserProfile(tokenResponse);
  //   user.authenticated(OAuthToken.fromTokenResponse(tokenResponse));

  //   currentUser = user;

  //   return user;
  // }

  /// Log out from this CARP service using a [BuildContext], that opens a
  /// web view to clear cookies and end the session on the Identity Server.
  ///
  /// Use this if you used [authenticate] to authenticate.
  ///
  /// The discovery URL in the [app] is used to find the Identity Server.
  Future<void> logout() async {
    if (Platform.isAndroid) {
      await manager.logout();
    }
    await manager.forgetUser();
    _authEventController.add(AuthEvent.unauthenticated);
    _currentUser = null;
  }

  /// Log out of this [CarpService], by clearing the current user.
  ///
  /// This method is used only if the [logout] method does not work for you,
  /// i.e. you do not have access to a [BuildContext].
  ///
  /// Use this if you used [authenticateWithUsernamePassword]
  /// or [authenticateWithUsernamePasswordNoContext] to authenticate.
  // Future<void> logoutNoContext() async => currentUser = null;

  // TokenResponse _convertToTokenResponse(Map<String, dynamic> json) {
  //   return AuthorizationTokenResponse(
  //     json['access_token'] as String,
  //     json['refresh_token'] as String,
  //     // Expires in is in seconds, but the DateTime expects milliseconds.
  //     DateTime.now().add(
  //       Duration(seconds: json['expires_in'] as int),
  //     ),
  //     json['session_state'] as String,
  //     json['token_type'] as String,
  //     (json['scope'] as String).split(' '),
  //     null,
  //     null,
  //   );
  // }

  /// -------------------------------------------------------------------------
  /// Deprecated authentication methods
  /// --------------------------------------------------------------------------

  @Deprecated(
      'Use authenticate() in (almost) all authentication instances instead.')
  Future<CarpUser> authenticateWithRefreshToken(String refreshToken) =>
      authenticate();

  @Deprecated('''Not possible anymore. Needs to be done on the Identity Server.
      When authenticating, the user can get a new password on the Identity Server login page.''')
  Future<String> sendForgottenPasswordEmail() => throw UnimplementedError();

  @Deprecated('Use authenticate() instead.')
  Future<CarpUser> authenticateWithDialog() => authenticate();

  // --------------------------------------------------------------------------
  // USERS
  // --------------------------------------------------------------------------

  /// Gets the CARP profile of the current user from the JWT token
  CarpUser getCurrentUserProfile(OidcUser response) {
    var jwt = JwtDecoder.decode(response.token.accessToken!);
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
