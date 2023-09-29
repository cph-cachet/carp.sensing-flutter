/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of carp_services;

/// Represents a CARP web service app endpoint.
class CarpApp {
  /// The name of this app. The name has to be unique.
  final String name;

  /// URI of the CARP web service
  final Uri uri;

  /// The OAuth endpoint for this app.
  final Uri authURL;

  /// OAuth client id
  final String clientId;

  /// Redirect URI for OAuth
  final Uri redirectURI;

  /// Discovery URI for OAuth
  final Uri discoveryURL;

  /// The CARP study id for this app.
  String? studyId;

  /// The CARP study deployment id of this app.
  String? studyDeploymentId;

  /// Create a [CarpApp] which know how to access a CARP backend.
  ///
  /// [name], [uri], and [oauth] are required parameters in order to identify,
  /// address, and authenticate this client.
  ///
  /// A [studyDeploymentId] and a [study] may be specified, if known at the
  /// creation time.
  CarpApp({
    required this.name,
    required this.uri,
    required this.authURL,
    required this.clientId,
    required this.redirectURI,
    required this.discoveryURL,
    this.studyDeploymentId,
    this.studyId,
  });

  @override
  int get hashCode => name.hashCode;

  @override
  bool operator ==(other) => name == other;

  @override
  String toString() =>
      'CarpApp - name: $name, uri: $uri, studyDeploymentId: $studyDeploymentId, studyId: $studyId';
}
