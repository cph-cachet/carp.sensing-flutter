/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_auth;

/// Holds information of a token issued by an OAuth authorization endpoint.
class OAuthToken {
  final String _accessToken;
  final String _refreshToken;
  final String _tokenType;
  final int _expiresIn;
  final String _scope;

  /// The date the access token was issued.
  final DateTime issuedDate = new DateTime.now();

  /// Constructor
  OAuthToken(this._accessToken, this._refreshToken, this._tokenType, this._expiresIn, this._scope);

  /// Factory taking a Map.
  OAuthToken.fromMap(Map<String, dynamic> map)
      : _accessToken = map['access_token'],
        _refreshToken = map['refresh_token'],
        _tokenType = map['token_type'],
        _expiresIn = map['expires_in'],
        _scope = map['scope'];

  /// Calculate the date of expiration for the access token.
  /// If access token has expired, the refresh token should be used
  /// in order to acquire a new access token.
  DateTime get accessTokenExpiryDate {
    Duration durationLeft = new Duration(seconds: _expiresIn);
    DateTime expiryDate = issuedDate.add(durationLeft);
    return expiryDate;
  }

  /// The OAuth access token
  String get accessToken => _accessToken;

  /// The OAuth refresh token
  String get refreshToken => _refreshToken;

  String get tokenType => _tokenType;

  /// Scope of this token:
  /// - read
  /// - read write
  /// - TODO : anything else?
  String get scope => _scope;

  String get tokenInfo => "Access Token: $_accessToken, "
      "Refresh Token: $_refreshToken, "
      "Expiry date: $accessTokenExpiryDate";
}

/// A [OAuthEndPoint] specify an OAuth 2.0 endpoint.
class OAuthEndPoint {
  /// The OAuth 2.0 client id.
  String clientID;

  /// The OAuth 2.0 client secret.
  String clientSecret;

  /// Path of the authentication endpoint.
  ///
  /// Default is `/oauth/token`
  String path = "/oauth/token";

  OAuthEndPoint({this.clientID, this.clientSecret, this.path = "/oauth/token"});
}
