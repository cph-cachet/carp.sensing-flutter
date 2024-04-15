import 'package:carp_webservices/carp_auth/carp_auth.dart';
import 'package:carp_webservices/carp_services/carp_services.dart';
import 'credentials.dart';

class CarpProperties {
  static final CarpProperties _instance = CarpProperties();

  factory CarpProperties() => _instance;

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

  late CarpAuthProperties authProperties = CarpAuthProperties(
    authURL: uri,
    clientId: 'carp-webservices-dart',
    redirectURI: Uri.base,
    discoveryURL: Uri.base,
  );

  late CarpApp mockCarpApp = CarpApp(
    name: "CAWS @ DigitalOcean [DEV]",
    uri: uri.replace(pathSegments: []),
    studyDeploymentId: testDeploymentId,
    studyId: testStudyId,
  );

  CarpApp get app => mockCarpApp;
}
