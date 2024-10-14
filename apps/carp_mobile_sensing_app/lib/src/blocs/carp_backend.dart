part of '../../main.dart';

/// Handling communication to the CARP Web Services infrastructure.
///
/// Works as a singleton, and can be accessed by `CarpBackend()`.
class CarpBackend {
  static const String HOST_URI = "carp.computerome.dk";

  /// The URIs of the CARP Web Service (CAWS) host for each [DeploymentMode].
  static const Map<DeploymentMode, String> uris = {
    DeploymentMode.dev: 'dev.carp.dk',
    DeploymentMode.test: 'test.carp.dk',
    DeploymentMode.production: 'carp.computerome.dk',
  };

  static final CarpBackend _instance = CarpBackend._();
  CarpBackend._() : super();
  factory CarpBackend() => _instance;

  /// The signed in user
  CarpUser? get user => CarpAuthService().currentUser;

  /// The username of the signed in user.
  String? get username => CarpAuthService().currentUser.username;

  /// The URI of the CAWS server - depending on deployment mode.
  Uri get uri => Uri(
        scheme: 'https',
        host: uris[bloc.deploymentMode],
      );

  /// The URI of the CAWS authentication service.
  ///
  /// Of the form:
  ///    https://dev.carp.dk/auth/realms/Carp/
  Uri get authUri => Uri(
        scheme: 'https',
        host: uris[bloc.deploymentMode],
        pathSegments: [
          'auth',
          'realms',
          'Carp',
        ],
      );

  /// The CAWS app configuration.
  late final CarpApp _app = CarpApp(name: "CAWS @ DTU", uri: uri);

  CarpApp get app => _app;

  /// The authentication configuration
  CarpAuthProperties get authProperties => CarpAuthProperties(
        authURL: uri,
        clientId: 'studies-app',
        redirectURI: Uri.parse('carp-studies-auth://auth'),
        // For authentication at CAWS the path is '/auth/realms/Carp'
        discoveryURL: uri.replace(pathSegments: [
          'auth',
          'realms',
          'Carp',
        ]),
      );

  Future<void> initialize() async {
    await CarpAuthService().configure(authProperties);
    CarpService().configure(app);

    // register CARP as a data backend where data can be uploaded
    DataManagerRegistry().register(CarpDataManagerFactory());

    info('$runtimeType initialized');
  }

  /// Authenticate to the CAWS host.
  Future<CarpUser> authenticate() async {
    var user = await CarpAuthService().authenticate();

    // Configure the participation service in order to get the invitations
    CarpParticipationService().configureFrom(CarpService());

    return user;
  }

  /// Get the study invitation.
  Future<void> getStudyInvitation(BuildContext context) async {
    ActiveParticipationInvitation? invitation =
        await CarpParticipationService().getStudyInvitation(context);
    debug('CAWS Study Invitation: $invitation');

    if (invitation != null) {
      bloc.study = SmartphoneStudy.fromInvitation(invitation);

      info('Invitation received - '
          'study id: ${invitation.studyId}, '
          'deployment id: ${invitation.studyDeploymentId}, '
          'role name: ${invitation.deviceRoleName}');
    }
  }
}
