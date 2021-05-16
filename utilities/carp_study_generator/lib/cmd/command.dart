part of carp_study_generator;

/// The interface for all CARP Commands.
abstract class Command {
  /// Execute this command.
  Future<void> execute();
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
    if (_yaml == null) {
      _yaml = loadYaml(File('carp/carp.yaml').readAsStringSync());
      // print(json.encode(_yaml));
    }
  }

  CarpApp get app => new CarpApp(
        name: "CARP server at '$uri'",
        uri: Uri.parse(uri),
        oauth: OAuthEndPoint(clientID: clientId, clientSecret: clientSecret),
      );

  Future authenticate() async {
    CarpService().configure(app);
    print('Authenticating to the CARP Server...');
    await CarpService().authenticate(username: username, password: password);
    print("Authenticated as user: '$username'");
    CANSProtocolService().configureFrom(CarpService());
  }
}
