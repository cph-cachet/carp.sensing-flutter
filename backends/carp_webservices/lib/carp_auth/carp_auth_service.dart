part of 'carp_auth.dart';

class CarpAuthService extends CarpAuthBaseService {
  static final CarpAuthService _instance = CarpAuthService._();
  CarpAuthService._();

  /// Returns the singleton default instance of the [CarpAuthService].
  /// Before this instance can be used, it must be configured using the
  /// [configure] method.
  factory CarpAuthService() => _instance;
  CarpAuthService.instance() : this._();

  /// Is a user authenticated?
  /// If `true`, the authenticated user is [currentUser].
  bool get authenticated => (_currentUser != null);

  late OidcUserManager _manager;
  OidcUserManager get manager => _manager;

  @override
  CarpAuthProperties get authProperties => nonNullAble(_authProperties);

  @override
  CarpUser get currentUser => nonNullAble(_currentUser);
  set currentUser(CarpUser? user) => _currentUser = user;

  final StreamController<AuthEvent> _authEventController =
      StreamController.broadcast();

  /// Notifies about changes to the user's authentication state (such as sign-in
  /// or sign-out) as defined in [AuthEvent].
  Stream<AuthEvent> get authStateChanges =>
      _authEventController.stream.asBroadcastStream();

  /// The URI for the authenticated endpoint for this [CarpService].
  Uri get authEndpointUri => authProperties.authURL;

  @override
  Future<void> configure(CarpAuthProperties authProperties) async {
    _manager = OidcUserManager.lazy(
      discoveryDocumentUri: OidcUtils.getOpenIdConfigWellKnownUri(
        Uri.parse(authProperties.discoveryURL.toString()),
      ),
      clientCredentials: OidcClientAuthentication.none(
        clientId: authProperties.clientId,
      ),
      store: OidcDefaultStore(),
      settings: OidcUserManagerSettings(
        redirectUri: Uri.parse(authProperties.redirectURI.toString()),
        scope: ['openid', 'offline_access'],
        postLogoutRedirectUri: Uri.parse(
            (authProperties.logoutRedirectURI ?? authProperties.redirectURI)
                .toString()),
        options: const OidcPlatformSpecificOptions(
          web: OidcPlatformSpecificOptions_Web(
            navigationMode:
                OidcPlatformSpecificOptions_Web_NavigationMode.newPage,
          ),
        ),
      ),
    );

    await initManager();
  }

  Future<void> initManager() async {
    await _manager.init();

    _manager.userChanges().listen((user) {
      if (user != null) {
        _currentUser = getCurrentUserProfile(user);
        _authEventController.add(AuthEvent.authenticated);
      }
    });
  }

  /// Authenticate to this CARP service, that opens the authentication page
  /// of the Identity Server using a secure web view from the OS.
  ///
  /// The discovery URL in the [app] is used to find the Identity Server.
  ///
  /// Returns the signed in user (with an [OAuthToken] access token), if successful.
  /// Throws a [CarpServiceException] if not successful.
  Future<CarpUser> authenticate() async {
    if (!_manager.didInit) {
      await initManager();
    }

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
  /// The discovery URL in the [app] is used to find the Identity Server.
  ///
  /// Returns the signed in user (with an [OAuthToken] access token), if successful.
  /// Throws a [CarpServiceException] if not successful.
  Future<CarpUser> authenticateWithUsernamePassword({
    required String username,
    required String password,
  }) async {
    if (!_manager.didInit) {
      await initManager();
    }

    final OidcUser? response = await manager.loginPassword(
      username: username,
      password: password,
    );

    if (response != null) {
      _currentUser = getCurrentUserProfile(response);
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
  ///
  /// This method is typically used when the access token has expired, and a new
  /// access token is needed to access the CARP web service. The refresh token
  /// expiration date is [OAuthToken.expiresAt] which has type [DateTime].
  ///
  /// Returns the signed in user (with a new [OAuthToken] access token), if successful.
  /// Throws a [CarpServiceException] if not successful.
  Future<CarpUser> refresh() async {
    if (!_manager.didInit) {
      await initManager();
    }

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

  /// Log out from this CARP service
  ///
  /// Opens a web view to clear cookies and end the session on the Identity Server.
  ///
  /// Use this if you used [authenticate] to authenticate.
  Future<void> logout() async {
    if (!_manager.didInit) {
      await initManager();
    }

    await manager.logout();
    _authEventController.add(AuthEvent.unauthenticated);
    _currentUser = null;
  }

  /// Log out of this [CarpService], by clearing the current user.
  ///
  /// Use this if you used [authenticateWithUsernamePassword] to authenticate,
  /// or when you want to log out without opening a web browser
  Future<void> logoutNoContext() async {
    await manager.forgetUser();
    _authEventController.add(AuthEvent.unauthenticated);
    _currentUser = null;
  }

  // --------------------------------------------------------------------------
  // USERS
  // --------------------------------------------------------------------------

  /// Gets the CARP profile of the current user from the JWT token
  CarpUser getCurrentUserProfile(OidcUser response) {
    var jwt = JwtDecoder.decode(response.token.accessToken!);
    return CarpUser.fromJWT(jwt, response.token);
  }

  /// Makes sure that the [CarpApp] or [CarpUser] is configured, by throwing a
  /// [CarpServiceException] if they are null.
  /// Otherwise, returns the non-null value.
  T nonNullAble<T>(T? argument) {
    if (argument == null && argument is CarpApp) {
      throw CarpServiceException(
          message:
              "CARP Service not initialized. Call 'CarpAuthService().configure()' first.");
    } else if (argument == null && argument is CarpUser) {
      throw CarpServiceException(
          message:
              "CARP User not authenticated. Call 'CarpAuthService().authenticate()' first.");
    } else {
      return argument!;
    }
  }
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
