/*
 * Copyright 2018-2020 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_auth;

/// Represents a CARP user.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class CarpUser {
  /// Unique CARP username
  String username;

  /// Unique CARP ID
  int id;

  /// The CARP account id.
  String accountId;

  /// Is this user activated in any studies?
  bool isActivated;

  /// The user's email
  String email;

  /// User's first name
  String firstName;

  /// User's last name
  String lastName;

  /// Mobile phone number
  String phone;

  /// Department of the the user (e.g. CACHET)
  String department;

  /// Organization of the the user (e.g. DTU)
  String organization;

  /// Timestamp for agreeing to the informed consent
  DateTime termsAgreed;

  /// Timestamp for the creation of this user.
  DateTime created;

  /// The list of roles that this user has in CARP.
  List<String> role = List<String>();

  /// The OAuth 2.0 [OAuthToken] for this user, once authenticated to CARP
  OAuthToken token;

  CarpUser({
    @required this.username,
    this.id,
    this.accountId,
    this.firstName,
    this.lastName,
    this.phone,
    this.email,
    this.department,
    this.organization,
  }) {
    accountId ??= Uuid().v4();
  }

  /// Set or update the authenticated [OAuthToken] token for this user.
  void authenticated(OAuthToken token) => this.token = token;

  /// Returns true if the user is logged in; that is, has a valid token.
  bool get isAuthenticated => (token != null);

  /// Returns true if the user's email is verified.
  bool get isEmailVerified => ((username != null) && (token != null));

  /// Obtains the OAuth token for the current user, forcing a [refresh] i
  /// f desired.
  Future<OAuthToken> getOAuthToken({bool refresh = false}) async {
    if (CarpService.instance == null)
      throw new CarpServiceException(
          message:
              "CARP Service not initialized. Call 'CarpService.configure()' first.");
    if (token == null)
      throw new CarpServiceException(
          message:
              "OAuth token is null. Call 'CarpService.authenticate()' first.");

    // check if we need to refresh the token.
    if (token.hasExpired || refresh) {
      this.token = await CarpService.instance.refresh();
    }

    return token;
  }

  /// Sign out the current user.
  Future<void> signOut() async {
    //TODO - implement sign out on the CARP Web Service
    token = null;
  }

  /// Manually refreshes the data of the current user (e.g., [fullName],
  /// [telephone], etc.) from the CARP web service.
  Future<void> reload() async {
    if (CarpService.instance == null)
      throw new CarpServiceException(
          message:
              "CARP Service not initialized. Call 'CarpService.configure()' first.");

    CarpService.instance.getCurrentUserProfile();
  }

  /// Deletes the user record from the CARP web service.
  ///
  /// TODO - not implemented, since there is currently no CARP endpoint for users.
  Future<void> delete() async {}

  factory CarpUser.fromJson(Map<String, dynamic> json) =>
      _$CarpUserFromJson(json);
  Map<String, dynamic> toJson() => _$CarpUserToJson(this);

  String toString() =>
      'CARP User: $username [$id] - $firstName $lastName [account id: $accountId]';
}
