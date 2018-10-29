/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

library carp_service;

import 'package:meta/meta.dart';
import 'package:carp_webservices/carp_auth/carp_auth.dart';
import 'dart:async';
import 'package:carp_mobile_sensing/domain/domain.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

part 'carp_app.dart';
part 'datapoint_reference.dart';
part 'file_reference.dart';
part 'collection_reference.dart';
part 'carp_tasks.dart';

/// Provide access to the CARP web service endpoint.
///
/// The (current) assumption is that each Flutter app (using this library) will only connect
/// to one CARP web service backend. Therefore this is a singleton and should be used like:
/// ```
/// await CarpService.configure(myApp);
/// CarpUser user = await CarpService.instance.signInWithEmailAndPassword("user@dtu.dk","password");
/// ```
class CarpService {
  static CarpService _instance;

  CarpApp _app;

  /// The CARP app associated with the CARP Web Service.
  CarpApp get app => _app;

  /// Get the current user.
  CarpUser _currentUser;

  CarpService._(this._app) : assert(_app != null);

  /// Returns the singleton default instance of the [CarpService].
  /// Before this instance can be used, it must be configured using the [configure()] method.
  static CarpService get instance => _instance;

  /// Configure the default instance of the [CarpService].
  static Future<CarpService> configure(CarpApp app) async {
    _instance = new CarpService._(app);
    return _instance;
  }

  /// Sign in to this CARP web service using email and password.
  ///
  /// Return the signed in user (with an access token) if successful.
  /// Throws a [CarpServiceException] if not successful.
  Future<CarpUser> signInWithEmailAndPassword({
    @required String email,
    @required String password,
  }) async {
    assert(email != null);
    assert(password != null);

    if (_app == null)
      throw new CarpServiceException("CARP Service not initialized. Call 'CarpService.configure()' first.");

    final clientID = _app.oauth.clientID;
    final clientSecret = _app.oauth.clientSecret;
    final authHeaderUTF8 = utf8.encode("$clientID:$clientSecret");
    final authHeaderBase64 = base64.encode(authHeaderUTF8);

    final loginHeader = {
      "Authorization": "Basic $authHeaderBase64",
      "Content-Type": "application/x-www-form-urlencoded",
      "Accept": "application/json"
    };

    final loginBody = {
      "client_id": "$clientID",
      "client_secret": "$clientSecret",
      "grant_type": "password",
      "scope": "read",
      "username": "$email",
      "password": "$password"
    };

    final String url = "${_app.uri.toString()}${_app.oauth.path.toString()}";
    http.Response response = await http.post(
      Uri.encodeFull(url),
      headers: loginHeader,
      body: loginBody,
    );

    _currentUser = new CarpUser(email, password: password);

    int httpStatusCode = response.statusCode;
    Map<String, dynamic> responseJSON = json.decode(response.body);

    switch (httpStatusCode) {
      case 200:
        {
          _currentUser.authenticated(new OAuthToken.fromJson(responseJSON));
          return _currentUser;
        }
      default:
        // All other cases are treated as an error.
        // TODO - later we can handle more HTTP status codes here.
        {
          final String error = responseJSON["error"];
          final String description = responseJSON["error_description"];
          throw CarpServiceException(error, code: httpStatusCode.toString(), description: description);
        }
    }
  }

  /// Asynchronously gets current user, or `null` if there is none.
  Future<CarpUser> get currentUser async {
    return _currentUser;
  }

  /// Sign out the current user.
  Future<void> signOut() async {
    _currentUser.signOut();
  }

  // Create a new CARP user with using email and password.
  Future<CarpUser> createUserWithEmailAndPassword({
    @required String email,
    @required String password,
  }) async {
    assert(email != null);
    assert(password != null);

    //TODO - implement CARP service end point for this.
    final CarpUser newUser = new CarpUser(email, password: password);
    return newUser;
  }

  /// Creates a new [DataPointReference] initialized at the current
  /// CarpService storage location.
  DataPointReference getDataPointReference() => DataPointReference._(this);

  /// Creates a new [FileStorageReference] initialized at the current
  /// CarpService storage location.
  FileStorageReference getFileStorageReference(String path) {
    assert(path != null);
    return FileStorageReference._(this, path);
  }

  /// Gets a [CollectionReference] for the current CARP Service path.
  CollectionReference collection(String path) {
    assert(path != null);
    return CollectionReference._(this, path);
  }
}

/// Abstract for CARP web service references.
abstract class CarpReference {
  CarpService service;

  CarpReference._(this.service);
}

/// Exception for CARP web service communication.
class CarpServiceException implements Exception {
  String code;
  String message;
  String description;

  CarpServiceException(this.message, {this.code, this.description});

  @override
  String toString() {
    return "CarpServiceException: {code: $code, message: $message, description: $description}";
  }
}
