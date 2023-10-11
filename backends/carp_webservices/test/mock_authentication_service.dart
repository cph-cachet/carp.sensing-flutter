import 'dart:async';
import 'dart:convert';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:http/http.dart' as http;

import 'package:carp_webservices/carp_auth/carp_auth.dart';
import 'package:carp_webservices/carp_services/carp_services.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mockito/mockito.dart';

class MockAuthenticationService {
  static final MockAuthenticationService _instance =
      MockAuthenticationService._();
  MockAuthenticationService._();

  factory MockAuthenticationService() => _instance;

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

  bool get authenticated => _currentUser != null;

  CarpUser? _currentUser;

  late CarpApp mockCarpApp = CarpApp(
    name: "CAWS @ DTU",
    uri: uri.replace(pathSegments: ['dev']),
    authURL: uri,
    clientId: 'carp-webservices-dart',
    redirectURI: Uri.base,
    discoveryURL: Uri.base,
  );

  CarpApp get app => mockCarpApp;

  CarpUser get currentUser => _currentUser!;

  Future<CarpUser> authenticate({
    String? username,
    String? password,
  }) async {
    final url = uri.replace(pathSegments: [
      ...uri.pathSegments,
      'protocol',
      'openid-connect',
      'token',
    ]);
    final body = {
      'client_id': app.clientId,
      'username': username,
      'password': password,
      'grant_type': 'password',
    };
    final headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    final response = await http.post(url, body: body, headers: headers);

    // Json to map the response
    final jsonResponse = json.decode(response.body);
    final tokenResponse = convertToAuthorizationTokenResponse(
        jsonResponse as Map<String, dynamic>);
    CarpUser user = getCurrentUserProfile(tokenResponse);
    user.authenticated(OAuthToken.fromTokenResponse(tokenResponse));

    _currentUser = user;

    return user;
  }

  Future<CarpUser> refresh({
    String? username,
    String? password,
  }) async {
    final url = uri.replace(pathSegments: [
      ...uri.pathSegments,
      'protocol',
      'openid-connect',
      'token',
    ]);

    final body = {
      'client_id': app.clientId,
      'username': username,
      'password': password,
      'grant_type': 'refresh_token',
      'refresh_token': currentUser.token!.refreshToken,
    };
    final headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    final response = await http.post(url, body: body, headers: headers);

    // Json to map the response
    final jsonResponse = json.decode(response.body);
    final tokenResponse = convertToAuthorizationTokenResponse(
        jsonResponse as Map<String, dynamic>);
    CarpUser user = getCurrentUserProfile(tokenResponse);
    user.authenticated(OAuthToken.fromTokenResponse(tokenResponse));

    _currentUser = user;

    return user;
  }

  /// Logout from CARP
  Future<void> logout() async {
    _currentUser = null;
  }

  AuthorizationTokenResponse convertToAuthorizationTokenResponse(
      Map<String, dynamic> json) {
    return AuthorizationTokenResponse(
      json['access_token'] as String,
      json['refresh_token'] as String,
      // Expires in is in seconds, but the DateTime expects milliseconds.
      DateTime.now().add(
        Duration(seconds: json['expires_in'] as int),
      ),
      json['session_state'] as String,
      json['token_type'] as String,
      (json['scope'] as String).split(' '),
      null,
      null,
    );
  }

  /// Gets the CARP profile of the current user from the JWT token
  CarpUser getCurrentUserProfile(TokenResponse response) {
    var jwt = JwtDecoder.decode(response.accessToken!);
    return CarpUser.fromJWT(jwt);
  }
}
