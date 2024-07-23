part of 'carp_auth.dart';

class CarpOidcUserManager extends OidcUserManager {
  CarpOidcUserManager(
      {required super.discoveryDocument,
      required super.clientCredentials,
      required super.store,
      required super.settings});

  CarpOidcUserManager.lazy({
    required super.discoveryDocumentUri,
    required super.clientCredentials,
    required super.store,
    required super.settings,
    super.httpClient,
    super.keyStore,
  }) : super.lazy();

  Future<OidcUser?> handleAuthorizeResponseFromMagicLink({
    required String url,
  }) async {
    final resp = await OidcEndpoints.parseAuthorizeResponse(
      responseUri: Uri.parse(url),
    );

    return await handleSuccessfulAuthResponse(
      response: resp,
      grantType: resp.code == null
          ? OidcConstants_GrantType.implicit
          : OidcConstants_GrantType.authorizationCode,
      metadata: discoveryDocument,
    );
  }
}
