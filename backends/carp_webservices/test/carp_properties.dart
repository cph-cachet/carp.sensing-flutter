import 'package:carp_webservices/carp_auth/carp_auth.dart';
import 'package:carp_webservices/carp_services/carp_services.dart';
import 'credentials.dart';

class CarpProperties {
  static final CarpProperties _instance = CarpProperties._();
  CarpProperties._();

  factory CarpProperties() => _instance;
  CarpProperties.instance() : this._();

  Uri get uri => Uri(
        scheme: 'https',
        host: 'dev.carp.dk',
        pathSegments: [
          'auth',
          'realms',
          'Carp',
        ],
      );

  CarpAuthProperties get authProperties => CarpAuthProperties(
        authURL: uri,
        clientId: 'studies-app',
        redirectURI: Uri.parse('carp-studies-auth://auth'),
        discoveryURL: uri.replace(pathSegments: [
          ...uri.pathSegments,
        ]),
      );

  CarpApp get app => CarpApp(
        name: "CAWS @ DigitalOcean [DEV]",
        uri: uri.replace(pathSegments: []),
        studyDeploymentId: testDeploymentId,
        studyId: testStudyId,
      );
}
