/*
 * Copyright 2018-2020 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_auth;

/// Represents a CARP Web Service (CAWS) account and user.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class CarpUser {
  /// Unique CARP username
  String username;

  /// Unique CARP ID
  String id;

  /// The user's email
  String email;

  /// User's first name
  String firstName;

  /// User's last name
  String lastName;

  /// The list of roles that this user has in CARP.
  List<dynamic> roles = [];

  /// The OAuth 2.0 [OAuthToken] for this user, once authenticated to CARP.
  /// Is `null` if user is not authenticated.
  OAuthToken? token;

  CarpUser({
    required this.username,
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.roles,
    this.token,
  });

  /// Set or update the authenticated [OAuthToken] token for this user.
  void authenticated(OAuthToken token) => this.token = token;

  /// Returns true if the user is logged in; that is, has a valid token.
  bool get isAuthenticated => (token != null);

  /// Returns true if the user's email is verified.
  bool get isEmailVerified => (token != null);

  /// Sign out the current user.
  Future<void> signOut() async {
    token = null;
  }

  factory CarpUser.fromJWT(Map<String, dynamic> jwt) {
    return CarpUser(
      username: jwt['preferred_username'] as String,
      id: jwt['sub'] as String,
      firstName: jwt['given_name'] as String,
      lastName: jwt['family_name'] as String,
      email: jwt['email'] as String,
      roles: jwt['realm_access']['roles'] as List<dynamic>,
    );
  }

  factory CarpUser.fromJson(Map<String, dynamic> json) =>
      _$CarpUserFromJson(json);
  Map<String, dynamic> toJson() => _$CarpUserToJson(this);

  @Deprecated('Use id instead')
  String get accountId => id;

  @override
  String toString() =>
      'CARP User: $username [$id] - $firstName $lastName [account id: $id]';
}
