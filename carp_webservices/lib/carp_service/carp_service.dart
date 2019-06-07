/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

library carp_services;

import 'package:meta/meta.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'dart:io';
import 'package:carp_webservices/carp_auth/carp_auth.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'dart:math';
import 'package:json_annotation/json_annotation.dart';

part 'carp_datapoint.dart';
part 'carp_app.dart';
part 'datapoint_reference.dart';
part 'file_reference.dart';
part 'document_reference.dart';
part 'carp_tasks.dart';
part 'push_id_generator.dart';
part 'carp_service.g.dart';

String _encode(Object object) => const JsonEncoder.withIndent(' ').convert(object);

/// Provide access to the CARP web services endpoint.
///
/// The (current) assumption is that each Flutter app (using this library) will only connect
/// to one CARP web service backend. Therefore this is a singleton and should be used like:
///
/// ```
/// await CarpService.configure(myApp);
/// CarpUser user = await CarpService.instance.authenticate(username: "user@dtu.dk", password: "password");
/// ```
class CarpService {
  static CarpService _instance;

  CarpService._(this._app) : assert(_app != null);

  CarpApp _app;
  CarpUser _currentUser;

  /// The CARP app associated with the CARP Web Service.
  CarpApp get app => _app;

  /// Gets the current user.
  CarpUser get currentUser {
    return _currentUser;
  }

  /// Returns the singleton default instance of the [CarpService].
  /// Before this instance can be used, it must be configured using the [configure] method.
  static CarpService get instance => _instance;

  /// Configure the default instance of the [CarpService].
  static Future<CarpService> configure(CarpApp app) async {
    _instance = new CarpService._(app);
    return _instance;
  }

  /// Authenticate to this CARP web service using username and password.
  ///
  /// Return the signed in user (with an [OAuthToken] access token), if successful.
  /// Throws a [CarpServiceException] if not successful.
  Future<CarpUser> authenticate({
    @required String username,
    @required String password,
  }) async {
    assert(username != null);
    assert(password != null);

    _currentUser = new CarpUser(username, password: password);
    OAuthToken _token = await refresh();
    return _currentUser..authenticated(_token);
  }

  /// Authenticate to this CARP web service using username and a previously stored [OAuthToken] access token.
  ///
  /// This method can be used to re-authenticate  a user if the token (and username) is known locally on the phone.
  /// Useful for keeping the token locally on the phone between starting/stopping the app.
  ///
  /// Return the signed in user.
  Future<CarpUser> authenticateWithToken({
    @required String username,
    @required OAuthToken token,
  }) async {
    assert(username != null);
    assert(token != null);

    _currentUser = new CarpUser(username);
    return _currentUser..authenticated(token);
  }

  /// Get a new (refreshed) access token for the current user.
  Future<OAuthToken> refresh() async {
    if (_app == null)
      throw new CarpServiceException("CARP Service not initialized. Call 'CarpService.configure()' first.");

    print('refreshing token...');

    final clientID = _app.oauth.clientID;
    final clientSecret = _app.oauth.clientSecret;
    final authHeaderUTF8 = utf8.encode("$clientID:$clientSecret");
    final authHeaderBase64 = base64.encode(authHeaderUTF8);

    final loginHeader = {
      "Authorization": "Basic $authHeaderBase64",
      "Content-Type": "application/x-www-form-urlencoded",
      "Accept": "application/json"
    };

    // right now we use the stored username and password to get a new token
    // but - we should use a real 'refresh token" endpoint in the CARP server for this
    // TODO - reimplement refresh token once CARP endpoint is available.
    final loginBody = {
      "client_id": "$clientID",
      "client_secret": "$clientSecret",
      "grant_type": "password",
      "scope": "read",
      "username": "${_currentUser.username}",
      "password": "${_currentUser.password}"
    };

    final String url = "${_app.uri.toString()}${_app.oauth.path.toString()}";
    http.Response response = await http.post(
      Uri.encodeFull(url),
      headers: loginHeader,
      body: loginBody,
    );

    int httpStatusCode = response.statusCode;
    Map<String, dynamic> responseJSON = json.decode(response.body);

    switch (httpStatusCode) {
      case 200:
        {
          return new OAuthToken.fromMap(responseJSON);
        }
      default:
        // All other cases are treated as an error.
        // TODO - later we can handle more HTTP status codes here.
        {
          final String error = responseJSON["error"];
          final String description = responseJSON["error_description"];
          throw CarpServiceException(error,
              description: description, httpStatus: HTTPStatus(httpStatusCode, response.reasonPhrase));
        }
    }
  }

  /// Asynchronously gets the CARP profile of the current user.
  Future<CarpUser> getCurrentUserProfile() async {
    // TODO - implement fetching user profile from CARP server.
    return _currentUser;
  }

  /// Sign out the current user.
  Future<void> signOut() async {
    _currentUser.signOut();
  }

  // Create a new CARP user using email and password.
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

  /// Creates a new [FileStorageReference] initialized at the current CarpService storage location.
  /// [id] can be omitted if a local file is not uploaded yet.
  FileStorageReference getFileStorageReference([int id]) => FileStorageReference._(this, id);

  /// Gets a [DocumentReference] for the specified unique id.
  DocumentReference documentById(int id) {
    assert(id != null);
    return DocumentReference._id(this, id);
  }

  /// Gets a [DocumentReference] for the specified CARP Service path.
  DocumentReference document(String path) {
    assert(path != null);
    return DocumentReference._path(this, path);
  }

  /// Gets a [CollectionReference] for the current CARP Service path.
  CollectionReference collection(String path) {
    assert(path != null);
    return CollectionReference._(this, path);
  }
}

/// Abstract CARP web service references.
abstract class CarpReference {
  CarpService service;

  CarpReference._(this.service) : assert(service != null);

  Future<Map<String, String>> get headers async {
    assert(service != null);
    CarpUser user = service.currentUser;
    assert(user != null);
    final OAuthToken token = await user.getOAuthToken();

    final Map<String, String> _header = {
      "Content-Type": "application/json",
      "Authorization": "bearer ${token.accessToken}",
      "cache-control": "no-cache"
    };

    return _header;
  }
}

/// Exception for CARP REST/HTTP service communication.
class CarpServiceException implements Exception {
  String message;
  String description;
  HTTPStatus httpStatus;

  CarpServiceException(this.message, {this.description, this.httpStatus});

  @override
  String toString() {
    return "CarpServiceException: ${httpStatus?.httpResponseCode} - $message; $description";
  }
}

/// Implements HTTP Response Code and associated Reason Phrase.
/// See https://en.wikipedia.org/wiki/List_of_HTTP_status_codes
class HTTPStatus {
  int httpResponseCode;
  String httpReasonPhrase;

  HTTPStatus(this.httpResponseCode, this.httpReasonPhrase);

  String toString() => "$httpResponseCode - $httpReasonPhrase";
}
