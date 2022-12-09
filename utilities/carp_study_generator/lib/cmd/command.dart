part of carp_study_generator;

/// The interface for all CARP Commands.
abstract class Command {
  /// Execute this command.
  Future execute();
}

/// An abstract class for all CARP Commands.
abstract class AbstractCommand implements Command {
  static var _yaml;
  CarpApp? _app;

  String? get uri => _yaml['server']['uri'];
  String get clientId => _yaml['server']['client_id'].toString();
  String get clientSecret => _yaml['server']['client_secret'].toString();
  String get username => _yaml['server']['username'].toString();
  String get password => _yaml['server']['password'].toString();

  String? get studyId => _yaml['study']['study_id'];
  // String? get studyDeploymentId => _yaml['study']['study_deployment_id'];

  String get protocolPath => _yaml['protocol']['path'].toString();
  String get consentPath => _yaml['consent']['path'].toString();

  String get messagesPath => _yaml['message']['path'].toString();
  List<dynamic> get messageIds => _yaml['message']['messages'];

  String get localizationPath => _yaml['localization']['path'].toString();
  List<dynamic> get locales => _yaml['localization']['locales'];

  String get ownerId => CarpService().currentUser?.accountId ?? 'unknown';

  @mustCallSuper
  AbstractCommand() {
    WidgetsFlutterBinding.ensureInitialized();

    // Settings().debugLevel = DebugLevel.DEBUG;

    // Initialization of serialization
    CarpMobileSensing();
    CarpDataManager();
    ResearchPackage();
    CognitionPackage();

    // make sure not to mess with CAMS
    Settings().saveAppTaskQueue = false;

    if (_yaml == null) {
      _yaml = loadYaml(File('carp/carpspec.yaml').readAsStringSync());
    }
    // register the sampling packages
    // this is used to be able to deserialize the json protocol
    SamplingPackageRegistry().register(AppsSamplingPackage());
    // SamplingPackageRegistry().register(CommunicationSamplingPackage());
    SamplingPackageRegistry().register(ContextSamplingPackage());
    SamplingPackageRegistry().register(MediaSamplingPackage());
    SamplingPackageRegistry().register(SurveySamplingPackage());
    SamplingPackageRegistry().register(HealthSamplingPackage());
    SamplingPackageRegistry().register(ESenseSamplingPackage());
    SamplingPackageRegistry().register(PolarSamplingPackage());
  }

  /// The configuration of the CARP server app.
  CarpApp get app {
    if (_app == null) {
      if (uri == null) throw Exception("No URI is provided");
      if (!Uri.parse(uri!).isAbsolute)
        throw Exception("Not a valid URI - '$uri'");
      try {
        if (studyId == null) throw Exception("A study ID must be provided");
        if (studyId!.length == 0)
          throw Exception("The study ID cannot be empty - '$studyId'");
      } catch (e) {
        throw Exception("A valid study ID is not provided");
      }

      _app = CarpApp(
        name: "CARP server at '$uri'",
        uri: Uri.parse(uri!),
        oauth: OAuthEndPoint(clientID: clientId, clientSecret: clientSecret),
        studyId: studyId,
        // studyDeploymentId: studyDeploymentId,
      );
    }
    return _app!;
  }

  /// Authenticate at the CARP server.
  Future authenticate() async {
    print('CARP app: $app');
    CarpService().configure(app);
    print('Authenticating to the CARP Server...');
    await CarpService().authenticate(username: username, password: password);
    print("Authenticated as user: '$username'");
    CANSProtocolService().configureFrom(CarpService());
  }
}
