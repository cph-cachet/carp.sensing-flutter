import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:carp_webservices/carp_services/carp_services.dart';
import 'package:test/test.dart';

void main() {
  CarpApp app = CarpApp(
    name: "name",
    uri: Uri(
        scheme: 'https', host: 'carp.computerome.dk', pathSegments: ['dev']),
    authURL: Uri(
      scheme: 'https',
      host: 'carp.computerome.dk',
      pathSegments: ['auth', 'dev', 'realms', 'Carp'],
    ),
    clientId: 'carp-webservices-dart',
    redirectURI: Uri(
      scheme: 'https',
      host: 'carp.computerome.dk',
      pathSegments: ['callback', 'wahtever'],
    ),
    discoveryURL: Uri(
      scheme: 'https',
      host: 'carp.computerome.dk',
      pathSegments: [
        'auth',
        'dev',
        'realms',
        'Carp',
        '.well-known',
        'openid-configuration'
      ],
    ),
  );

  group('description', () {
    test('should ...', () {
      CarpService().configure(app);
      CarpService().authenticate();
    });
  });
}
