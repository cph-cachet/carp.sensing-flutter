part of mobile_sensing_app;

/// Handling communication to the [CarpService].
class CarpBackend {
  static const String HOST_URI = "carp.computerome.dk";
  // static const String PROD_URI = "https://cans.cachet.dk";
  // static const String STAGING_URI = "https://cans.cachet.dk/stage";
  // static const String TEST_URI = "https://cans.cachet.dk/test";
  // static const String DEV_URI = "https://cans.cachet.dk/dev";
  // static const String CLIENT_ID = "carp";
  // static const String CLIENT_SECRET = "carp";

  static const Map<DeploymentMode, String> uris = {
    DeploymentMode.development: 'dev',
    DeploymentMode.staging: 'stage',
    DeploymentMode.production: '',
  };

  static final CarpBackend _instance = CarpBackend._();
  CarpApp? _app;

  CarpBackend._() : super();
  factory CarpBackend() => _instance;

  /// The signed in user
  CarpUser? get user => CarpService().currentUser;

  /// The username of the signed in user.
  String? get username => CarpService().currentUser.username;

  // String get uri => uris[bloc.deploymentMode] ?? PROD_URI;

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
    // _app = CarpApp(
    //   name: 'CAWS -${bloc.deploymentMode.name}',
    //   uri: Uri.parse(uri),
    //   oauth: OAuthEndPoint(clientID: CLIENT_ID, clientSecret: CLIENT_SECRET),
    // );

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

    // configure and authenticate
    CarpService().configure(app!);

    // register CARP as a data backend where data can be uploaded
    DataManagerRegistry().register(CarpDataManagerFactory());

    info('$runtimeType initialized');
  }

  /// Authenticate to the CAWS host.
  Future<CarpUser> authenticate() async {
    var response = await CarpService().authenticate();

    // username = response.username;
    // oauthToken = response.token;

    CarpParticipationService().configureFrom(CarpService());

    return response;
  }

  /// Authenticate the user using the username / password dialogue.
  // Future<void> authenticate(BuildContext context, {String? username}) async {
  //   info('Authenticating user...');
  //   await CarpService().authenticateWithDialog(context, username: username);
  //   info('User authenticated - user: $user');

  //   // configure the participation service in order to get the invitations
  //   CarpParticipationService().configureFrom(CarpService());
  // }

  /// Get the study invitation.
  Future<void> getStudyInvitation(BuildContext context) async {
    ActiveParticipationInvitation? invitation =
        await CarpParticipationService().getStudyInvitation(context);
    debug('CAWS Study Invitation: $invitation');

    bloc.studyId = invitation?.studyId;
    bloc.studyDeploymentId = invitation?.studyDeploymentId;
    bloc.deviceRolename = invitation?.assignedDevices?.first.device.roleName;
    info('Invitation received - '
        'study id: ${bloc.studyId}, '
        'deployment id: ${bloc.studyDeploymentId}, '
        'role name: ${bloc.deviceRolename}');
  }
}
