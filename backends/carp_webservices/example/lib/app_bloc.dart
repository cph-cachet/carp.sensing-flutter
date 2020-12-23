part of carp_webservices_example_app;

// CANS PROD

class AppBLoC {
  final String uri = "https://cans.cachet.dk:443";
  CarpApp _app;
  CarpApp get app => _app;

  Future<void> init() async {
    _app = CarpApp(
      name: 'carp_webservices_example_app',
      uri: Uri.parse(uri),
      oauth: OAuthEndPoint(clientID: 'carp', clientSecret: 'carp'),
    );

    CarpService().configure(app);
  }

  Future<CarpUser> authenticate(String username) async =>
      await CarpService().authenticateWithForm(
        username: username,
      );
}

final bloc = AppBLoC();
