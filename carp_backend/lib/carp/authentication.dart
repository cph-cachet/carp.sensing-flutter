/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

import 'dart:async';
import 'package:carp_sensing/carp_sensing.dart';

/**
 * The [AuthenticationManager] class is responsible for authenticating
 * users, using the CARP oAuth endpoint. The endpoint requires some credentials
 * and responds with an oAuth token if the credentials are correct.
 *
 */
abstract class AuthenticationManager {
  OAuthToken get token;
  String get username;
  String get password;

  Future<OAuthToken> authenticate(String username, String password);
}

/// A [OAuthEndPoint] specify an OAuth 2.0 endpoint where a [AuthenticationManager] can authenticate.
class OAuthEndPoint {
  //static const String clientSecret = "webuisecret";
  //static const String clientID = "webui";
  //static const String CARP_auth_uri = "https://sandbox.carp.cachet.dk/auth-service/auth/oauth/token";

  String clientID;
  String clientSecret;
  Uri uri;

  OAuthEndPoint(this.clientID, this.clientSecret, this.uri);
}

/// The [OAuthToken] class is responsible holding information of a token
/// issued by an OAuth authorization endpoint.
class OAuthToken {
  final String _accessToken, _refreshToken;
  final int _expiresIn;

  /// The date the access token was issued.
  final DateTime issuedDate = new DateTime.now();

  /// Constructor
  OAuthToken(this._accessToken, this._refreshToken, this._expiresIn);

  /// JSON Constructor
  OAuthToken.fromJson(Map<String, dynamic> json)
      : _accessToken = json['access_token'],
        _refreshToken = json['refresh_token'],
        _expiresIn = json['expires_in'];

  /// Calculate the date of expiration for the access token.
  /// If access token has expired, the refresh token should be used
  /// in order to acquire a new access token.
  DateTime get accessTokenExpiryDate {
    Duration durationLeft = new Duration(seconds: _expiresIn);
    DateTime expiryDate = issuedDate.add(durationLeft);
    return expiryDate;
  }

  String get accessToken => _accessToken;

  String get refreshToken => _refreshToken;

  String get tokenInfo => "Access Token: $_accessToken, "
      "Refresh Token: $_refreshToken, "
      "Expiry date: $accessTokenExpiryDate";
}

/**
 * The [User] class is responsible for storing user data.
 *
 */
class User {
  final String _username, _password;
  OAuthToken _oAuthToken;

  User(this._username, this._password, this._oAuthToken);

  String get username => _username;

  String get password => _password;

  OAuthToken get oAuthToken => _oAuthToken;

  OAuthToken set(oAuthToken) => _oAuthToken = oAuthToken;

  String get userInfo {
    var tokenInfo = oAuthToken.tokenInfo;
    return "Username: $_username, Password: $_password, OAuth Token: [$tokenInfo]";
  }
}
