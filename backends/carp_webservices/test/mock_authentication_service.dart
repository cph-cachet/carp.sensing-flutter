import 'dart:async';

import 'package:carp_webservices/carp_auth/carp_auth.dart';
import 'package:carp_webservices/carp_services/carp_services.dart';
import 'credentials.dart';

class MockAuthenticationService extends CarpAuthService {
  static final MockAuthenticationService _instance =
      MockAuthenticationService._();
  MockAuthenticationService._() : super.instance();

  factory MockAuthenticationService() => _instance;

  /// The URI of the CANS server - depending on deployment mode.
  Uri uri = Uri(
    scheme: 'https',
    host: 'dev.carp.dk',
    pathSegments: [
      'auth',
      'realms',
      'Carp',
    ],
  );

  late CarpApp mockCarpApp = CarpApp(
    name: "CAWS @ DigitalOcean [DEV]",
    uri: uri.replace(pathSegments: []),
    studyDeploymentId: testDeploymentId,
    studyId: testStudyId,
  );

  CarpApp get app => mockCarpApp;

  @override
  Future<CarpUser> authenticate({
    String? username,
    String? password,
  }) {
    assert(username != null && password != null);
    return CarpAuthService().authenticateWithUsernamePassword(
        username: username!, password: password!);
  }
}
