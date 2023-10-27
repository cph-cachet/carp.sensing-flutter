import 'dart:async';
import 'dart:convert';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:http/http.dart' as http;

import 'package:carp_webservices/carp_auth/carp_auth.dart';
import 'package:carp_webservices/carp_services/carp_services.dart';
import 'credentials.dart';

class MockAuthenticationService extends CarpService {
  static final MockAuthenticationService _instance =
      MockAuthenticationService._();
  MockAuthenticationService._() : super.instance();

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

  late CarpApp mockCarpApp = CarpApp(
    name: "CAWS @ DTU",
    uri: uri.replace(pathSegments: ['dev']),
    authURL: uri,
    clientId: 'carp-webservices-dart',
    redirectURI: Uri.base,
    discoveryURL: Uri.base,
    studyDeploymentId: testDeploymentId,
    studyId: testStudyId,
  );

  @override
  CarpApp get app => mockCarpApp;

  @override
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
    final tokenResponse =
        convertToTokenResponse(jsonResponse as Map<String, dynamic>);
    CarpUser user = getCurrentUserProfile(tokenResponse);
    user.authenticated(OAuthToken.fromTokenResponse(tokenResponse));

    currentUser = user;

    return user;
  }

  @override
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
      if (username != null) 'username': username,
      if (password != null) 'password': password,
      'grant_type': 'refresh_token',
      'refresh_token': currentUser.token!.refreshToken,
    };
    final headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    final response = await http.post(url, body: body, headers: headers);

    // Json to map the response
    final jsonResponse = json.decode(response.body);
    final tokenResponse =
        convertToTokenResponse(jsonResponse as Map<String, dynamic>);
    CarpUser user = getCurrentUserProfile(tokenResponse);
    user.authenticated(OAuthToken.fromTokenResponse(tokenResponse));

    currentUser = user;

    return user;
  }

  /// Logout from CARP
  @override
  Future<void> logout() async {
    currentUser = null;
  }

  TokenResponse convertToTokenResponse(Map<String, dynamic> json) {
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
}
