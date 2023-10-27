import 'dart:async';

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
  }) {
    assert(username != null && password != null);
    return authenticateWithUsernamePasswordNoContext(
        username: username!, password: password!);
  }

  @override
  Future<CarpUser> refresh({
    String? username,
    String? password,
  }) =>
      refreshNoContext();

  /// Logout from CARP
  @override
  Future<void> logout() async {
    currentUser = null;
  }
}
