/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_auth;

/// Represents a CARP user.
class CarpUser {
  /// Unique CARP username
  String username;

  /// Unique CARP ID
  String uid;

  /// CARP password
  String password;

  /// The user's email
  String email;

  /// Printer-friendly full user name
  String displayName;

  /// Mobile phone number
  String phoneNumber;

  OAuthToken _token;

  /// The OAuth 2.0 [OAuthToken] for this user, once authenticated to CARP
  OAuthToken get token => _token;

  CarpUser(this.username, {this.uid, this.password, this.displayName, this.phoneNumber});

  /// Set or update the authenticated OAuth token for this user.
  void authenticated(OAuthToken token) => _token = token;

  /// Returns true if the user is logged in; that is, has a valid token.
  bool get isAuthenticated => (_token != null);

  /// Returns true if the user's email is verified.
  bool get isEmailVerified => ((username != null) && (_token != null));

  /// Obtains the OAuth token for the current user, forcing a [refresh] if desired.
  Future<OAuthToken> getOAuthToken({bool refresh = false}) async {
    if (CarpService.instance == null)
      throw new CarpServiceException("CARP Service not initialized. Call 'CarpService.configure()' first.");

    // check if we need to refresh the token.
    if ((_token == null) || _token.hasExpired || refresh) {
      _token = await CarpService.instance.refresh();
    }

    return _token;
  }

  /// Sign out the current user.
  Future<void> signOut() async {
    //TODO - implement sign out on the CARP Web Service
    _token = null;
  }

  /// Manually refreshes the data of the current user (e.g., [displayName], [phoneNumber], etc.)
  /// from the CARP web service.
  ///
  /// TODO - not implemented, since there is currently no CARP endpoint for users.
  Future<void> reload() async {}

  /// Deletes the user record from the CARP web service.
  ///
  /// TODO - not implemented, since there is currently no CARP endpoint for users.
  Future<void> delete() async {}

  @override
  String toString() {
    return 'CARP User: $username - $displayName<$email>[$uid]';
  }
}
