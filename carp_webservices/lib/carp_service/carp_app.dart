/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of carp_service;

/// Represents a CARP web app endpoint.
class CarpApp {
  /// The CARP study for this app.
  Study study;

  /// The name of this app.
  String name;

  /// URI of the CARP web service
  Uri uri;

  // The OAuth 2.0 endpoint.
  OAuthEndPoint oauth;

  CarpApp({
    @required this.study,
    @required this.name,
    @required this.uri,
    @required this.oauth,
  }) {
    assert(study != null);
    assert(name != null);
    assert(uri != null);
    assert(oauth != null);
    assert(oauth.clientID != null);
    assert(oauth.clientSecret != null);
  }

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() => '$CarpApp($name)';
}
