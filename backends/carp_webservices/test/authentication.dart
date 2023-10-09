import 'dart:async';
import 'package:http/http.dart' as http;


import 'package:carp_webservices/carp_auth/carp_auth.dart';
import 'package:carp_webservices/carp_services/carp_services.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class MockAuthenticationService {
  /// The URI of the CANS server - depending on deployment mode.
  Uri uri = Uri(
    scheme: 'https',
    host: 'carp.computerome.dk',
    pathSegments: [
      'auth',
      'dev',
      'realms',
      'Carp',
    ],
  );
  late CarpApp app;
  CarpUser? currentUser;

  MockAuthenticationService() {
    app = CarpApp(
      name: "CAWS @ DTU",
      uri: uri.replace(pathSegments: ['dev']),
      authURL: uri,
      clientId: 'carp-webservices-dart',
      redirectURI: Uri.parse('carp-studies-auth://auth'),
      discoveryURL: uri.replace(pathSegments: [
        ...uri.pathSegments,
        '.well-known',
        'openid-configuration'
      ]),
    );
  }

  FlutterAppAuth appAuth = const FlutterAppAuth();

  /// Is a user authenticated?
  /// If `true`, the authenticated user is [currentUser].
  bool get authenticated => (currentUser != null);

  Future<CarpUser> authenticate({
    String? username,
    String? password,
  }) async {

    final url = Uri.parse(
        'http://carp.computerome.dk/auth/realms/Carp/protocol/openid-connect/token');
    final body = {
      'client_id': 'carp-webservices-dart',
      'username': 'test',
      'password': 'test',
      'grant_type': 'password',
    };
    final headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };

// Send the POST request and wait for the response
    final response = await http.post(url, body: body, headers: headers);

  }

  Future<CarpUser> refresh() async {
    final TokenResponse? response = await appAuth.token(
      TokenRequest(
        app.clientId,
        "${app.redirectURI}",
        discoveryUrl: "${app.discoveryURL}",
        refreshToken: currentUser!.token!.refreshToken,
      ),
    );

    if (response != null) {
      currentUser?.authenticated(OAuthToken.fromTokenResponse(response));
      return currentUser!;
    }

    // All other cases are treated as a failed attempt and throws an error
    currentUser = null;
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
        idTokenHint: currentUser!.token!.idToken,
        postLogoutRedirectUrl: "${app.logoutRedirectURI ?? app.redirectURI}",
      ),
    );

    currentUser = null;
  }

  Future<CarpUser> getCurrentUserProfile(
      AuthorizationTokenResponse response) async {
    var jwt = JwtDecoder.decode(response.accessToken.toString());
    return CarpUser.fromJWT(jwt);
  }
}
