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
part 'consent_document.dart';

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

  // ---------------------------------------------------------------------------------------------------------
  // AUTHENTICATION
  // ---------------------------------------------------------------------------------------------------------

  String get _authHeaderBase64 => base64.encode(utf8.encode("${_app.oauth.clientID}:${_app.oauth.clientSecret}"));

  /// The HTTP header for the authentication requests.
  Map<String, String> get authenticationHeader => {
        "Authorization": "Basic $_authHeaderBase64",
        "Content-Type": "application/x-www-form-urlencoded",
        "Accept": "application/json"
      };

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

    if (_app == null)
      throw new CarpServiceException("CARP Service not initialized. Call 'CarpService.configure()' first.");

    _currentUser = new CarpUser(username);

    final loginBody = {
      "client_id": "${_app.oauth.clientID}",
      "client_secret": "${_app.oauth.clientSecret}",
      "grant_type": "password",
      "scope": "read",
      "username": "$username",
      "password": "$password"
    };

    final String url = "${_app.uri.toString()}${_app.oauth.path.toString()}";
    http.Response response = await http.post(
      Uri.encodeFull(url),
      headers: authenticationHeader,
      body: loginBody,
    );

    int httpStatusCode = response.statusCode;
    Map<String, dynamic> responseJSON = json.decode(response.body);

//    print('response code: $httpStatusCode');
//    print(_encode(responseJSON));

    if (httpStatusCode == 200) {
      _currentUser.authenticated(OAuthToken.fromMap(responseJSON));
      return await getCurrentUserProfile();
    }

    // All other cases are treated as an error.
    throw CarpServiceException(responseJSON["error"],
        description: responseJSON["error_description"], httpStatus: HTTPStatus(httpStatusCode, response.reasonPhrase));
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

    // --data "refresh_token=my-refresh-token&grant_type=refresh_token"
    final loginBody = {"refresh_token": "${_currentUser.token.refreshToken}", "grant_type": "refresh_token"};

    final String url = "${_app.uri.toString()}${_app.oauth.path.toString()}";
    http.Response response = await http.post(
      Uri.encodeFull(url),
      headers: authenticationHeader,
      body: loginBody,
    );

    int httpStatusCode = response.statusCode;
    Map<String, dynamic> responseJSON = json.decode(response.body);

    if (httpStatusCode == 200) return new OAuthToken.fromMap(responseJSON);

    // All other cases are treated as an error.
    throw CarpServiceException(responseJSON["error"],
        description: responseJSON["error_description"], httpStatus: HTTPStatus(httpStatusCode, response.reasonPhrase));
  }

  // ---------------------------------------------------------------------------------------------------------
  // USERS
  // ---------------------------------------------------------------------------------------------------------

  /// The URL for the authenticated user end point for this [CarpService].
  String get authUserEndpointUri => "${_app.uri.toString()}/api/auth/user";

  /// The URL for the user end point for this [CarpService].
  String get userEndpointUri => "${_app.uri.toString()}/api/users";

  /// The headers for any authenticated HTTP REST call to this [CarpService].
  Map<String, String> get headers {
    return {
      "Content-Type": "application/json",
      "Authorization": "bearer ${_currentUser.token.accessToken}",
      "cache-control": "no-cache"
    };
  }

  Map<String, String> getUserBody(String email, String password, String fullName) => {
        "email": email,
        "password": password,
        "password_confirm": password,
        "full_name": fullName ?? "",
        "study_id": _app.study.id
      };

  /// Asynchronously gets the CARP profile of the current user.
  Future<CarpUser> getCurrentUserProfile() async {
    // GET the user from the CARP web service
    http.Response response = await http.get(Uri.encodeFull(authUserEndpointUri), headers: headers);
    int httpStatusCode = response.statusCode;
    Map<String, dynamic> responseJson = json.decode(response.body);

    if (httpStatusCode == 200) {
      return _currentUser
        ..id = responseJson['id']
        ..email = responseJson['email']
        ..fullName = responseJson['full_name']
        ..telephone = responseJson['telephone']
        ..department = responseJson['department']
        ..organization = responseJson['organization']
        ..termsAgreed = DateTime.parse(responseJson['terms_agreed'])
        ..created = DateTime.parse(responseJson['created_at']);
    }

    // All other cases are treated as an error.
    throw CarpServiceException(responseJson["error"],
        description: responseJson["error_description"], httpStatus: HTTPStatus(httpStatusCode, response.reasonPhrase));
  }

  /// Sign out the current user.
  Future<void> signOut() async {
    _currentUser.signOut();
  }

  /// Create a new CARP user.
  ///
  /// This can only be done by an administrator and you need to be authenticated as
  /// such to use this endpoint.
  ///
  /// If you want add a participant to this study, use the [createParticipantByInvite].
  /// If you want add a researcher to this study, use the [createResearcherByInvite].
  Future<CarpUser> createUser(String email, String password, {String fullName}) async {
    assert(email != null);
    assert(password != null);

    final CarpUser newUser = new CarpUser(email, password: password, fullName: fullName, email: email);

    http.Response response = await http.post(Uri.encodeFull(userEndpointUri),
        headers: headers, body: json.encode(getUserBody(email, password, fullName)));

    int httpStatusCode = response.statusCode;
    Map<String, dynamic> responseJson = json.decode(response.body);

    if ((httpStatusCode == 200) || (httpStatusCode == 201)) return newUser..reload();

    // All other cases are treated as an error.
    throw CarpServiceException(responseJson["error"],
        description: responseJson["message"], httpStatus: HTTPStatus(httpStatusCode, response.reasonPhrase));
  }

  /// Create and invite a new participant to this study.
  ///
  /// Users of this method must be authenticated (logged in) as a researcher to this study.
  Future<CarpUser> createParticipantByInvite(String email, String password, {String fullName}) async {
    assert(email != null);
    assert(password != null);
    final CarpUser newUser = new CarpUser(email, password: password, fullName: fullName, email: email);

    http.Response response = await http.post(Uri.encodeFull('$userEndpointUri/invite-participant'),
        headers: headers, body: json.encode(getUserBody(email, password, fullName)));

    int httpStatusCode = response.statusCode;
    Map<String, dynamic> responseJson = json.decode(response.body);

    if ((httpStatusCode == 200) || (httpStatusCode == 201)) return newUser..reload();

    // All other cases are treated as an error.
    throw CarpServiceException(responseJson["error"],
        description: responseJson["message"], httpStatus: HTTPStatus(httpStatusCode, response.reasonPhrase));
  }

  /// Create and invite a fellow researcher to this study.
  ///
  /// Users of this method must be authenticated (logged in) as a researcher to this study.
  Future<CarpUser> createResearcherByInvite(String email, String password, {String fullName}) async {
    assert(email != null);
    assert(password != null);
    final CarpUser newUser = new CarpUser(email, password: password, fullName: fullName, email: email);

    http.Response response = await http.post(Uri.encodeFull('$userEndpointUri/invite-researcher'),
        headers: headers, body: json.encode(getUserBody(email, password, fullName)));

    int httpStatusCode = response.statusCode;
    Map<String, dynamic> responseJson = json.decode(response.body);

    if ((httpStatusCode == 200) || (httpStatusCode == 201)) return newUser..reload();

    // All other cases are treated as an error.
    throw CarpServiceException(responseJson["error"],
        description: responseJson["message"], httpStatus: HTTPStatus(httpStatusCode, response.reasonPhrase));
  }

  // ---------------------------------------------------------------------------------------------------------
  // CONSENT DOCUMENT
  // ---------------------------------------------------------------------------------------------------------

  /// The URL for the consent document end point for this [CarpService].
  String get consentDocumentEndpointUri => "${_app.uri.toString()}/api/studies/${_app.study.id}/consent-documents";

  /// Create a new consent document.
  /// Returns the created [ConsentDocument] if the document is uploaded correctly.
  Future<ConsentDocument> createConsentDocument(Map<String, dynamic> document) async {
    assert(document != null);

    // POST the document to the CARP web service
    http.Response response =
        await http.post(Uri.encodeFull(consentDocumentEndpointUri), headers: headers, body: json.encode(document));

    int httpStatusCode = response.statusCode;
    Map<String, dynamic> responseJson = json.decode(response.body);

//    print('response code: $httpStatusCode');
//    print(_encode(responseJson));

    if ((httpStatusCode == 200) || (httpStatusCode == 201)) return ConsentDocument._(responseJson);

    // All other cases are treated as an error.
    throw CarpServiceException(responseJson["error"],
        description: responseJson["message"], httpStatus: HTTPStatus(httpStatusCode, response.reasonPhrase));
  }

  /// Asynchronously gets a [ConsentDocument].
  Future<ConsentDocument> getConsentDocument(int id) async {
    String url = "$consentDocumentEndpointUri/$id";

    // GET the consent document from the CARP web service
    http.Response response = await http.get(Uri.encodeFull(url), headers: headers);

    int httpStatusCode = response.statusCode;
    Map<String, dynamic> responseJson = json.decode(response.body);

    if (httpStatusCode == 200) return ConsentDocument._(responseJson);

    // All other cases are treated as an error.
    Map<String, dynamic> errorResponseJson = json.decode(response.body);
    throw CarpServiceException(errorResponseJson["error"],
        description: errorResponseJson["error_description"],
        httpStatus: HTTPStatus(httpStatusCode, response.reasonPhrase));
  }

  // ---------------------------------------------------------------------------------------------------------
  // DATA POINT & FILES & DOCUMENTS & COLLECTIONS
  // ---------------------------------------------------------------------------------------------------------

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

  /// The URL for the document end point for this [CarpService].
  String get documentEndpointUri => "${_app.uri.toString()}/api/studies/${_app.study.id}/documents";

  /// Get a list documents from a query.
  Future<List<DocumentSnapshot>> documentsByQuery(String query) async {
    // GET the list of documents in this collection from the CARP web service
    http.Response response = await http.get(Uri.encodeFull('$documentEndpointUri?query=$query'), headers: headers);
    int httpStatusCode = response.statusCode;

    if (httpStatusCode == 200) {
      List<dynamic> documentsJson = json.decode(response.body);
      List<DocumentSnapshot> documents = new List<DocumentSnapshot>();
      for (var item in documentsJson) {
        Map<String, dynamic> documentJson = item;
        String key = documentJson["name"];
        documents.add(DocumentSnapshot._("$key", documentJson));
      }
      return documents;
    }

    // All other cases are treated as an error.
    Map<String, dynamic> responseJson = json.decode(response.body);
    throw CarpServiceException(responseJson["error"],
        description: responseJson["message"], httpStatus: HTTPStatus(httpStatusCode, response.reasonPhrase));
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
