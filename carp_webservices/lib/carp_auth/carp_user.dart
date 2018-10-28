/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_auth;

/// Represents a CARP user.
class CarpUser {
  String email;
  String uid;
  String password;
  String displayName;
  String phoneNumber;
  OAuthToken _token;

  CarpUser(this.email, {this.uid, this.password, this.displayName, this.phoneNumber});

  /// Set or update the authenticated OAuth token for this user.
  void authenticated(OAuthToken token) {
    _token = token;
  }

  // Returns true if the user is logged in; that is, has a valid token.
  bool get isAuthenticated => (_token != null);

  /// Returns true if the user's email is verified.
  bool get isEmailVerified => ((email != null) && (_token != null));

  /// Obtains the OAuth token for the current user, forcing a [refresh] if desired.
  Future<OAuthToken> getOAuthToken({bool refresh = false}) async {
    if (CarpService.instance == null)
      throw new CarpServiceException("CARP Service not initialized. Call 'CarpService.configure()' first.");

    // check if we need to refresh the token.
    // TODO - should look at the expire as well.
    if ((refresh) || (_token == null)) {
      //TODO - refresh the token.
    }

    return _token;
  }

  /// Sign out the current user.
  Future<void> signOut() async {
    //TODO - implement sign out on the CARP Service
    _token = null;
  }

  /// Manually refreshes the data of the current user (for example, attached
  /// providers, display name, and so on) from the CARP web service.
  ///
  /// TODO - not implemented, since there is currently no CARP endpoint for users.
  Future<void> reload() async {}

  /// Deletes the user record from the CARP web service.
  ///
  /// TODO - not implemented, since there is currently no CARP endpoint for users.
  Future<void> delete() async {}

  @override
  String toString() {
    return 'CarpUser: $displayName<$email>[$uid]';
  }
}
