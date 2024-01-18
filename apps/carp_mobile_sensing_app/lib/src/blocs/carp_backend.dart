part of mobile_sensing_app;

/// Handling communication to the CARP Web Services infrastructure.
///
/// Works as a singleton, and can be accessed by `CarpBackend()`.
class CarpBackend {
  static const String HOST_URI = "carp.computerome.dk";

  static const Map<DeploymentMode, String> uris = {
    DeploymentMode.development: 'dev',
    DeploymentMode.staging: 'stage',
    DeploymentMode.production: '',
  };

  static final CarpBackend _instance = CarpBackend._();
  CarpBackend._() : super();
  factory CarpBackend() => _instance;

  CarpApp? _app;

  /// The signed in user
  CarpUser? get user => CarpService().currentUser;

  /// The username of the signed in user.
  String? get username => CarpService().currentUser.username;

  /// The URI of the CANS server - depending on deployment mode.
  Uri get uri => Uri(
        scheme: 'https',
        host: HOST_URI,
        pathSegments: [
          'auth',
          uris[bloc.deploymentMode]!,
          'realms',
          'Carp',
        ],
      );

  CarpApp? get app => _app;

  Future<void> initialize() async {
    _app = CarpApp(
      name: 'CAWS -${bloc.deploymentMode.name}',
      uri: uri.replace(pathSegments: [uris[bloc.deploymentMode]!]),
      authURL: uri,
      clientId: 'carp-webservices-dart',
      redirectURI: Uri.parse('carp-studies-auth://auth'),
      discoveryURL: uri.replace(pathSegments: [
        ...uri.pathSegments,
        '.well-known',
        'openid-configuration'
      ]),
    );

    CarpService().configure(app!);

    // register CARP as a data backend where data can be uploaded
    DataManagerRegistry().register(CarpDataManagerFactory());

    info('$runtimeType initialized');
  }

  /// Authenticate to the CAWS host.
  Future<CarpUser> authenticate() async {
    var response = await CarpService().authenticate();

    // Configure the participation service in order to get the invitations
    CarpParticipationService().configureFrom(CarpService());

    return response;
  }

  /// Get the study invitation.
  Future<void> getStudyInvitation(BuildContext context) async {
    ActiveParticipationInvitation? invitation =
        await CarpParticipationService().getStudyInvitation(context);
    debug('CAWS Study Invitation: $invitation');

    bloc.studyId = invitation?.studyId;
    bloc.studyDeploymentId = invitation?.studyDeploymentId;
    bloc.deviceRoleName = invitation?.assignedDevices?.first.device.roleName;
    info('Invitation received - '
        'study id: ${bloc.studyId}, '
        'deployment id: ${bloc.studyDeploymentId}, '
        'role name: ${bloc.deviceRoleName}');
  }
}
