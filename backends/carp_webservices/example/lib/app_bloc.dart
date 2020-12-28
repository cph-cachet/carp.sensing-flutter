part of carp_webservices_example_app;

class AppBLoC {
  final String uri = "https://cans.cachet.dk:443"; // CANS PROD

  CarpApp _app;
  CarpApp get app => _app;

  Future init() async {
    _app = CarpApp(
      name: 'carp_webservices_example_app',
      uri: Uri.parse(uri),
      oauth: OAuthEndPoint(clientID: 'carp', clientSecret: 'carp'),
    );

    CarpService().configure(app);
  }

  void dispose() async {}

  Future<CarpUser> authenticate(BuildContext context,
          {String username}) async =>
      await CarpService().authenticateWithForm(
        context,
        username: username,
      );
}

final bloc = AppBLoC();
