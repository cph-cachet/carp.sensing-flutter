part of carp_study_generator;

/// The interface for all CARP Commands.
abstract class Command {
  /// Execute this command.
  Future execute();
}

/// An abstract class for all CARP Commands.
abstract class AbstractCommand implements Command {
  static var _yaml;

  String get uri => _yaml['server']['uri'].toString();
  String get clientId => _yaml['server']['client_id'].toString();
  String get clientSecret => _yaml['server']['client_secret'].toString();
  String get username => _yaml['server']['username'].toString();
  String get password => _yaml['server']['password'].toString();

  String get protocolFilename => _yaml['protocol']['filename'].toString();
  String get consentFilename => _yaml['consent']['filename'].toString();

  List<dynamic> get locales => _yaml['localization']['locales'];

  String get ownerId => CarpService().currentUser.accountId;

  @mustCallSuper
  AbstractCommand() {
    // create two dummy objects to register json deserialization functions
    RPTask('ignored');
    CAMSStudyProtocol();

    if (_yaml == null) {
      _yaml = loadYaml(File('carp/carp.yaml').readAsStringSync());
    }
    // register the sampling packages
    // this is used to be able to deserialize the json protocol
    SamplingPackageRegistry().register(AppsSamplingPackage());
    SamplingPackageRegistry().register(CommunicationSamplingPackage());
    SamplingPackageRegistry().register(ContextSamplingPackage());
    SamplingPackageRegistry().register(AudioSamplingPackage());
    SamplingPackageRegistry().register(ESenseSamplingPackage());
    SamplingPackageRegistry().register(SurveySamplingPackage());
    SamplingPackageRegistry().register(HealthSamplingPackage());
  }

  /// The configuration of the CARP server app.
  CarpApp get app => new CarpApp(
        name: "CARP server at '$uri'",
        uri: Uri.parse(uri),
        oauth: OAuthEndPoint(clientID: clientId, clientSecret: clientSecret),
      );

  /// Authenticate at the CARP server.
  Future authenticate() async {
    CarpService().configure(app);
    print('Authenticating to the CARP Server...');
    await CarpService().authenticate(username: username, password: password);
    print("Authenticated as user: '$username'");
    CANSProtocolService().configureFrom(CarpService());
  }
}
