part of mobile_sensing_app;

class CarpBackend {
  static const String PROD_URI = "https://cans.cachet.dk:443";
  // static const String STAGING_URI = "https://cans.cachet.dk:443/stage"; // The staging server
  // static const String TEST_URI = "https://cans.cachet.dk:443/test"; // The testing server
  // static const String DEV_URI = "https://cans.cachet.dk:443/dev"; // The development server
  static const String CLIENT_ID = "carp";
  static const String CLIENT_SECRET = "carp";

  static CarpBackend _instance = CarpBackend._();
  CarpBackend._() : super();

  factory CarpBackend() => _instance;

  CarpApp _app;

  CarpApp get app => _app;

  Future initialize() async {
    Settings().debugLevel = DebugLevel.DEBUG;
    _app = CarpApp(
      name: "CANS Production @ DTU",
      uri: Uri.parse(uri),
      oauth: OAuthEndPoint(clientID: CLIENT_ID, clientSecret: CLIENT_SECRET),
    );

    // configure and authenticate
    CarpService().configure(app);
    await CarpService().authenticate(username: username, password: password);

    info('$runtimeType initialized');
  }
}
