part of mobile_sensing_app;

/// Handling communication to the [CarpService].
class CarpBackend {
  static const String PROD_URI = "https://cans.cachet.dk";
  static const String STAGING_URI = "https://cans.cachet.dk/stage";
  static const String TEST_URI = "https://cans.cachet.dk/test";
  static const String DEV_URI = "https://cans.cachet.dk/dev";
  static const String CLIENT_ID = "carp";
  static const String CLIENT_SECRET = "carp";

  final Map<DeploymentMode, String> uris = {
    DeploymentMode.production: PROD_URI,
    DeploymentMode.staging: STAGING_URI,
    DeploymentMode.development: DEV_URI,
  };

  static final CarpBackend _instance = CarpBackend._();
  CarpApp? _app;

  CarpBackend._() : super();
  factory CarpBackend() => _instance;

  /// The signed in user
  CarpUser? get user => CarpService().currentUser;

  /// The username of the signed in user.
  String? get username => CarpService().currentUser?.username;

  String get uri => uris[bloc.deploymentMode] ?? PROD_URI;

  CarpApp? get app => _app;

  Future<void> initialize() async {
    _app = CarpApp(
      name: 'CAWS -${bloc.deploymentMode.name}',
      uri: Uri.parse(uri),
      oauth: OAuthEndPoint(clientID: CLIENT_ID, clientSecret: CLIENT_SECRET),
    );

    // configure and authenticate
    CarpService().configure(app!);

    // register CARP as a data backend where data can be uploaded
    DataManagerRegistry().register(CarpDataManagerFactory());

    info('$runtimeType initialized');
  }

  /// Authenticate the user using the username / password dialogue.
  Future<void> authenticate(BuildContext context, {String? username}) async {
    info('Authenticating user...');
    await CarpService().authenticateWithDialog(context, username: username);
    info('User authenticated - user: $user');

    // configure the participation service in order to get the invitations
    CarpParticipationService().configureFrom(CarpService());
  }

  /// Get the study invitation.
  Future<void> getStudyInvitation(BuildContext context) async {
    ActiveParticipationInvitation? invitation =
        await CarpParticipationService().getStudyInvitation(context);
    debug('CARP Study Invitation: $invitation');

    bloc.studyDeploymentId = invitation?.studyDeploymentId;
    info('Deployment ID from invitation: ${bloc.studyDeploymentId}');
  }
}
