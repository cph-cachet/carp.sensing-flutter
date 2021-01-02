/*
 * Copyright 2018-2020 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

library carp_services;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:carp_webservices/carp_auth/carp_auth.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:retry/retry.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../carp_domain/carp_domain.dart';

part 'carp_app.dart';
part 'carp_datapoint.dart';
part 'carp_service.g.dart';
part 'carp_tasks.dart';
part 'consent_document.dart';
part 'datapoint_reference.dart';
part 'deployment_reference.dart';
part 'document_reference.dart';
part 'file_reference.dart';
part 'http_retry.dart';
part 'push_id_generator.dart';
part 'authentication_form.dart';
part 'authentication_dialog.dart';
part 'invitations_dialog.dart';

String _encode(Object object) =>
    const JsonEncoder.withIndent(' ').convert(object);

/// Provide access to the CARP web services endpoint.
///
/// The (current) assumption is that each Flutter app (using this library) will only connect
/// to one CARP web service backend. Therefore this is a singleton and should be used like:
///
/// ```dart
///   CarpService().configure(myApp);
///   CarpUser user = await CarpService().authenticate(username: "user@dtu.dk", password: "password");
/// ```
class CarpService {
  static CarpService _instance = CarpService._();
  CarpApp _app;
  CarpUser _currentUser;

  CarpService._() {
    registerFromJsonFunctions();
  }

  /// Returns the singleton default instance of the [CarpService].
  /// Before this instance can be used, it must be configured using the [configure] method.
  factory CarpService() => _instance;

  /// The CARP app associated with the CARP Web Service.
  CarpApp get app => _app;

  /// Gets the current user.
  /// Returns `null` if no user is authenticated.
  CarpUser get currentUser => _currentUser;

  /// Has this service been configured?
  bool get isConfigured => (_app != null);

  /// Configure the default instance of the [CarpService].
  void configure(CarpApp app) async {
    assert(app != null);
    this._app = app;
  }

  // ---------------------------------------------------------------------------------------------------------
  // AUTHENTICATION
  // ---------------------------------------------------------------------------------------------------------

  String get _authHeaderBase64 => base64
      .encode(utf8.encode("${_app.oauth.clientID}:${_app.oauth.clientSecret}"));

  /// The URI for the authenticated endpoint for this [CarpService].
  String get authEndpointUri =>
      "${_app.uri.toString()}${_app.oauth.path.toString()}";

  /// The HTTP header for the authentication requests.
  Map<String, String> get _authenticationHeader => {
        "Authorization": "Basic $_authHeaderBase64",
        "Content-Type": "application/x-www-form-urlencoded",
        "Accept": "application/json"
      };

  /// Is a user authenticated?
  /// If `true`, the authenticated user is [currentUser].
  bool get authenticated => (_currentUser != null);

  StreamController<AuthEvent> _authEventController = StreamController();

  /// Notifies about changes to the user's authentication state (such as sign-in or
  /// sign-out) as defined in [AuthEvent].
  Stream<AuthEvent> get authStateChanges =>
      _authEventController.stream.asBroadcastStream();

  /// Authenticate to this CARP service using a [username] and [password].
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
      throw CarpServiceException(
          message:
              "CARP Service not initialized. Call 'CarpService().configure()' first.");

    _currentUser = new CarpUser(username: username);

    final loginBody = {
      "client_id": "${_app.oauth.clientID}",
      "client_secret": "${_app.oauth.clientSecret}",
      "grant_type": "password",
      "scope": "read",
      "username": "$username",
      "password": "$password"
    };

    final http.Response response = await httpr.post(
      Uri.encodeFull(authEndpointUri),
      headers: _authenticationHeader,
      body: loginBody,
    );

    int httpStatusCode = response.statusCode;
    Map<String, dynamic> responseJson = json.decode(response.body);

    if (httpStatusCode == HttpStatus.ok) {
      _currentUser.authenticated(OAuthToken.fromMap(responseJson));
      await getCurrentUserProfile();
      _authEventController.add(AuthEvent.authenticated);
      return _currentUser;
    }

    // All other cases are treated as an error.
    throw CarpServiceException(
      httpStatus: HTTPStatus(httpStatusCode, response.reasonPhrase),
      message: responseJson["error_description"],
    );
  }

  /// Authenticate to this CARP web service using username and a previously
  /// stored [OAuthToken] access token.
  ///
  /// This method can be used to re-authenticate  a user if the token (and username)
  /// is known locally on the phone.
  /// Useful for keeping the token locally on the phone between starting/stopping
  /// the app.
  ///
  /// Return the signed in user.
  Future<CarpUser> authenticateWithToken({
    @required String username,
    @required OAuthToken token,
  }) async {
    assert(username != null);
    assert(token != null);

    _currentUser = CarpUser(username: username)..authenticated(token);

    // Refresh the token - it might have expired since it was saved.
    await refresh();

    await getCurrentUserProfile();
    _authEventController.add(AuthEvent.authenticated);
    return _currentUser;
  }

  // /// Authenticate to this CARP service by showing a form for the user to enter
  // /// his/her username and password.
  // /// Also allow the user to reset the password.
  // ///
  // /// The [context] is required in order to show the login page in the right context.
  // /// If the [username] is provide, this is shown as default in the form.
  // ///
  // /// In contrast to the other authentication methods, this method does **not**
  // /// throws a [CarpServiceException] if authentication is not successful.
  // /// Instead it shown a message to the user (in a snackbar).
  // Future authenticateWithForm(
  //   BuildContext context, {
  //   String username,
  // }) async {
  //   if (_app == null)
  //     throw CarpServiceException(
  //         message:
  //             "CARP Service not initialized. Call 'CarpService().configure()' first.");

  //   Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //           builder: (_) => CarpAuthenticationForm(
  //                 username: username,
  //               )));
  // }

  /// Authenticate to this CARP service by showing a modal dialog form for the
  /// user to enter his/her username and password.
  ///
  /// The [context] is required in order to show the login page in the right context.
  /// If the [username] is provide, this is shown as default in the form.
  ///
  /// In contrast to the other authentication methods, this method does **not**
  /// throws a [CarpServiceException] if authentication is not successful.
  /// Instead the dialog is kept open until authentication is successful, or
  /// closed manually by the user.
  Future authenticateWithDialog(
    BuildContext context, {
    String username,
  }) async {
    if (_app == null)
      throw CarpServiceException(
          message:
              "CARP Service not initialized. Call 'CarpService().configure()' first.");

    await AuthenticationDialog().build(context, username: username).show();
  }

  /// Get a new access token for the current user based on the
  /// previously granted refresh token.
  Future<OAuthToken> refresh() async {
    if (_app == null)
      throw new CarpServiceException(
          message:
              "CARP Service not initialized. Call 'CarpService().configure()' first.");

    // --data "refresh_token=my-refresh-token&grant_type=refresh_token"
    final loginBody = {
      "refresh_token": "${_currentUser.token.refreshToken}",
      "grant_type": "refresh_token"
    };

    final http.Response response = await httpr.post(
      Uri.encodeFull(authEndpointUri),
      headers: _authenticationHeader,
      body: loginBody,
    );

    int httpStatusCode = response.statusCode;
    Map<String, dynamic> responseJson = json.decode(response.body);

    if (httpStatusCode == HttpStatus.ok) {
      OAuthToken refreshedToken = OAuthToken.fromMap(responseJson);
      _currentUser.authenticated(refreshedToken);
      _authEventController.add(AuthEvent.refreshed);
      return refreshedToken;
    }

    // All other cases are treated as an error.
    throw CarpServiceException(
      httpStatus: HTTPStatus(httpStatusCode, response.reasonPhrase),
      message: responseJson["error_description"],
    );
  }

  /// The URL for sending email about a forgotten password.
  String get forgottenPasswordEmail =>
      "${_app.uri.toString()}/api/users/forgotten-password/send";

  /// Triggers the CARP backend to send a password-reset email to the given
  /// email address, which must correspond to an existing user of the current [app].
  /// Return the email, returned from CARP if successful.
  ///
  /// Throws a [CarpServiceException] if not successful.
  Future<String> sendForgottenPasswordEmail({
    @required String email,
  }) async {
    if (_app == null)
      throw new CarpServiceException(
          message:
              "CARP Service not initialized. Call 'CarpService().configure()' first.");
    assert(email != null);
    final String _body = '{	"emailAddress": "$email" }';
    final http.Response response = await httpr.post(
      Uri.encodeFull(authEndpointUri),
      headers: _authenticationHeader,
      body: _body,
    );

    int httpStatusCode = response.statusCode;
    Map<String, dynamic> responseJson = json.decode(response.body);

    if (httpStatusCode == HttpStatus.ok) {
      _authEventController.add(AuthEvent.reset);
      return responseJson['emailAddress'];
    }

    // All other cases are treated as an error.
    throw CarpServiceException(
      httpStatus: HTTPStatus(httpStatusCode, response.reasonPhrase),
      message: responseJson["error_description"],
    );
  }

  // ---------------------------------------------------------------------------------------------------------
  // USERS
  // ---------------------------------------------------------------------------------------------------------

  /// The URL for the current user end point for this [CarpService].
  String get currentUserEndpointUri =>
      "${_app.uri.toString()}/api/users/current";

  /// The URL for the user endpoint for this [CarpService].
  String get userEndpointUri => "${_app.uri.toString()}/api/users";

  /// The headers for any authenticated HTTP REST call to this [CarpService].
  Map<String, String> get headers {
    if (_currentUser.token == null)
      throw new CarpServiceException(
          message:
              "OAuth token is null. Call 'CarpService().authenticate()' first.");

    return {
      "Content-Type": "application/json",
      "Authorization": "bearer ${_currentUser.token.accessToken}",
      "cache-control": "no-cache"
    };
  }

  Map<String, String> getUserBody(String accountId, String password,
          String firstName, String lastName) =>
      {
        "accountId": accountId,
        "password": password,
        "firstName": firstName ?? "",
        "lastName": lastName ?? "",
      };

  /// Asynchronously gets the CARP profile of the current user.
  Future<CarpUser> getCurrentUserProfile() async {
    http.Response response = await httpr
        .get(Uri.encodeFull('$userEndpointUri/current'), headers: headers);
    int httpStatusCode = response.statusCode;
    Map<String, dynamic> responseJson = json.decode(response.body);

    if (httpStatusCode == HttpStatus.ok) {
      return _currentUser
        ..id = responseJson['id']
        ..accountId = responseJson['accountId']
        ..isActivated = responseJson['isActivated'] as bool
        ..firstName = responseJson['firstName']
        ..lastName = responseJson['lastName'];
    }

    // All other cases are treated as an error.
    throw CarpServiceException(
      httpStatus: HTTPStatus(httpStatusCode, response.reasonPhrase),
      message: responseJson["error_description"],
    );
  }

  /// Change the password of the current user.
  ///
  /// Return the signed in user (with an [OAuthToken] access token), if successful.
  /// Throws a [CarpServiceException] if not successful.
  Future<CarpUser> changePassword({
    @required String currentPassword,
    @required String newPassword,
  }) async {
    assert(newPassword != null && newPassword.length > 0,
        'A new password cannot be null or empty.');
    assert(currentUser != null,
        'Must authenticate before password can be changed.');

    final http.Response response = await httpr.put(
      Uri.encodeFull('$userEndpointUri/password'),
      headers: headers,
      body: '{"oldPassword":"$currentPassword","newPassword":"$newPassword"}',
    );

    if (response.statusCode == HttpStatus.ok) {
      // on success, CARP return nothing (empty string)
      return _currentUser;
    }

    // All other cases are treated as an error.
    Map<String, dynamic> responseJson = json.decode(response.body);
    throw CarpServiceException(
      httpStatus: HTTPStatus(response.statusCode, response.reasonPhrase),
      message: responseJson["message"],
    );
  }

  /// Sign out the current user.
  Future signOut() async {
    _currentUser.signOut();
    _currentUser = null;
    _authEventController.add(AuthEvent.unauthenticated);
  }

  /// Create and register a new CARP user.
  ///
  /// This can only be done by an administrator and you need to be authenticated as
  /// such to use this endpoint.
  Future<CarpUser> createUser({
    @required String username,
    @required String password,
    String firstName,
    String lastName,
  }) async {
    assert(username != null);
    assert(password != null);

    final CarpUser newUser = new CarpUser(
      username: username,
      firstName: firstName,
      lastName: lastName,
    );

    http.Response response =
        await httpr.post(Uri.encodeFull('$userEndpointUri/register'),
            headers: headers,
            body: json.encode(getUserBody(
              newUser.accountId,
              password,
              newUser.firstName,
              newUser.lastName,
            )));

    int httpStatusCode = response.statusCode;
    Map<String, dynamic> responseJson = json.decode(response.body);

    if ((httpStatusCode == HttpStatus.ok) ||
        (httpStatusCode == HttpStatus.created)) return newUser..reload();

    // All other cases are treated as an error.
    throw CarpServiceException(
      httpStatus: HTTPStatus(httpStatusCode, response.reasonPhrase),
      message: responseJson["message"],
    );
  }

  // ---------------------------------------------------------------------------------------------------------
  // CONSENT DOCUMENT
  // ---------------------------------------------------------------------------------------------------------

  /// The URL for the consent document end point for this [CarpService].
  String get consentDocumentEndpointUri =>
      "${_app.uri.toString()}/api/deployments/${_app.studyDeploymentId}/consent-documents";

  /// Create a new consent document.
  /// Returns the created [ConsentDocument] if the document is uploaded correctly.
  Future<ConsentDocument> createConsentDocument(
      Map<String, dynamic> document) async {
    assert(document != null);

    // POST the document to the CARP web service
    http.Response response = await http.post(
        Uri.encodeFull(consentDocumentEndpointUri),
        headers: headers,
        body: json.encode(document));

    int httpStatusCode = response.statusCode;
    Map<String, dynamic> responseJson = json.decode(response.body);

    if ((httpStatusCode == HttpStatus.ok) ||
        (httpStatusCode == HttpStatus.created))
      return ConsentDocument._(responseJson);

    // All other cases are treated as an error.
    throw CarpServiceException(
      httpStatus: HTTPStatus(httpStatusCode, response.reasonPhrase),
      message: responseJson["message"],
    );
  }

  /// Asynchronously gets a [ConsentDocument].
  Future<ConsentDocument> getConsentDocument(int id) async {
    String url = "$consentDocumentEndpointUri/$id";

    // GET the consent document from the CARP web service
    http.Response response =
        await httpr.get(Uri.encodeFull(url), headers: headers);

    int httpStatusCode = response.statusCode;
    Map<String, dynamic> responseJson = json.decode(response.body);

    if (httpStatusCode == HttpStatus.ok) return ConsentDocument._(responseJson);

    // All other cases are treated as an error.
    Map<String, dynamic> errorResponseJson = json.decode(response.body);
    throw CarpServiceException(
      httpStatus: HTTPStatus(httpStatusCode, response.reasonPhrase),
      message: errorResponseJson["message"],
    );
  }

  // ---------------------------------------------------------------------------------------------------------
  // DATA POINT & FILES & DOCUMENTS & COLLECTIONS
  // ---------------------------------------------------------------------------------------------------------

  /// Creates a new [DataPointReference] initialized at the current
  /// CarpService storage location.
  DataPointReference getDataPointReference() => DataPointReference._(this);

  /// Creates a new [FileStorageReference] initialized at the current CarpService storage location.
  /// [id] can be omitted if a local file is not uploaded yet.
  FileStorageReference getFileStorageReference([int id]) =>
      FileStorageReference._(this, id);

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
  String get documentEndpointUri =>
      "${_app.uri.toString()}/api/studies/${_app.study.id}/documents";

  /// Get a list documents from a query.
  Future<List<DocumentSnapshot>> documentsByQuery(String query) async {
    // GET the list of documents in this collection from the CARP web service
    http.Response response = await httpr.get(
        Uri.encodeFull('$documentEndpointUri?query=$query'),
        headers: headers);
    int httpStatusCode = response.statusCode;

    if (httpStatusCode == HttpStatus.ok) {
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
    throw CarpServiceException(
      httpStatus: HTTPStatus(httpStatusCode, response.reasonPhrase),
      message: responseJson["message"],
    );
  }

  /// Gets a [CollectionReference] for the current CARP Service path.
  CollectionReference collection(String path) {
    assert(path != null);
    return CollectionReference._(this, path);
  }

  // ---------------------------------------------------------------------------------------------------------
  // DEPLOYMENTS
  // ---------------------------------------------------------------------------------------------------------

  /// The URL for the deployment RPC endpoint.
  ///
  /// {{PROTOCOL}}://{{SERVER_HOST}}:{{SERVER_PORT}}/api/deployments/all
  String get deploymentRPCEndpointUri =>
      "${app.uri.toString()}/api/deployments/all";

  /// Gets a [DeploymentReference] for a [studyDeploymentId].
  /// If the [studyDeploymentId] is not provided, the study deployment id
  /// specified in the [CarpApp] is used.
  DeploymentReference deployment([String studyDeploymentId]) =>
      DeploymentReference._(this, studyDeploymentId);

  /// Get the list of active participation invitations for an [accountId].
  /// This will return all deployments that this account (user) is invited to.
  ///
  /// Note that the [accountId] is the unique CARP account id (and not the
  /// username).
  /// If [accountId] is not specified, then the account id of the currently
  /// authenticated [CarpUser] is used.
  Future<List<ActiveParticipationInvitation>> invitations(
      [String accountId]) async {
    accountId ??= currentUser.accountId;
    final String body =
        _encode(GetActiveParticipationInvitations(accountId).toJson());

    //print('REQUEST: $deploymentRPCEndpointUri\n$body');
    http.Response response = await httpr.post(
        Uri.encodeFull(deploymentRPCEndpointUri),
        headers: headers,
        body: body);
    //print('RESPONSE: ${response.statusCode}\n${response.body}');

    if (response.statusCode == HttpStatus.ok) {
      List<dynamic> items = json.decode(response.body);
      List<ActiveParticipationInvitation> invitations = [];
      items.forEach((item) =>
          invitations.add(ActiveParticipationInvitation.fromJson(item)));

      return invitations;
    }

    // All other cases are treated as an error.
    Map<String, dynamic> responseJson = json.decode(response.body);
    throw CarpServiceException(
      httpStatus: HTTPStatus(response.statusCode, response.reasonPhrase),
      message: responseJson["message"],
    );
  }

  /// Get the study id for the current user based on an invitation from CARP.
  ///
  /// Returns `null` if the user has no invitations.
  ///
  /// If the user is invited to more than one study and [showInvitations] is `true`,
  /// a user-interface dialog for selecting amongs the invitations is shown.
  /// If not, the study id of the first invitation is returned.
  ///
  /// Throws a [CarpServiceException] if not successful.
  Future<String> getStudyIdByInvitation(
    BuildContext context, {
    bool showInvitations = true,
  }) async {
    if (!CarpService().isConfigured)
      throw CarpServiceException(
          message:
              "CARP Service not initialized. Call 'CarpService().configure()' first.");

    if (!CarpService().authenticated)
      throw CarpServiceException(
          message:
              "The current user is not authenticated to CARP. Call 'CarpService().authenticate...()' first.");

    List<ActiveParticipationInvitation> invitations =
        await CarpService().invitations();

    if (invitations.isEmpty) return null;
    if (invitations.length == 1 || !showInvitations)
      return invitations[0].studyDeploymentId;

    InvitationsDialog dialog = InvitationsDialog();
    await dialog.build(context, invitations).show();
    return dialog.studyDeploymentId;
  }
}

/// Authentication state change events.
enum AuthEvent {
  /// The user has successfull been authenticated (signed in).
  authenticated,

  /// The user has been unauthenticated (signed out).
  unauthenticated,

  /// The user's token has successfully been refreshed.
  refreshed,

  /// A password reset email has been send to the user.
  reset,
}

/// Abstract CARP web service references.
abstract class CarpReference {
  CarpService service;

  CarpReference._(this.service) {
    assert(service != null, 'A valid CARP service must be provided.');
  }

  Future<Map<String, String>> get headers async {
    assert(service != null);
    CarpUser user = service.currentUser;
    assert(user != null);
    final OAuthToken token = await user.getOAuthToken();

    return {
      "Content-Type": "application/json",
      "Authorization": "bearer ${token.accessToken}",
      "cache-control": "no-cache"
    };
  }
}

/// Exception for CARP REST/HTTP service communication.
class CarpServiceException implements Exception {
  HTTPStatus httpStatus;
  String message;

  CarpServiceException({this.httpStatus, this.message});

  String toString() =>
      "CarpServiceException: ${(httpStatus != null) ? httpStatus.toString() + " - " : ""} ${message ?? ""}";
}

/// Implements HTTP Response Code and associated Reason Phrase.
/// See https://en.wikipedia.org/wiki/List_of_HTTP_status_codes
class HTTPStatus {
  /// Mapping of the most common HTTP status code to text.
  /// See https://en.wikipedia.org/wiki/List_of_HTTP_status_codes
  static const Map<String, String> httpStatusPhrases = {
    "100": "Continue",
    "200": "OK",
    "201": "Created",
    "202": "Accepted",
    "300": "Multiple Choices",
    "301": "Moved Permanently",
    "400": "Bad Request",
    "401": "Unauthorized",
    "402": "Payment Required",
    "403": "Forbidden",
    "404": "Not Found",
    "405": "Method Not Allowed",
    "408": "Request Timeout",
    "409": "Conflict",
    "410": "Gone",
    "500": "Internal Server Error",
    "501": "Not Implemented",
    "502": "Bad Gateway",
    "503": "Service Unavailable",
    "504": "Gateway Timeout",
    "505": "HTTP Version Not Supported",
  };

  int httpResponseCode;
  String httpReasonPhrase;

  HTTPStatus(this.httpResponseCode, [String httpPhrase]) {
    if ((httpPhrase == null) || (httpPhrase.length == 0))
      this.httpReasonPhrase = httpStatusPhrases[httpResponseCode.toString()];
  }

  String toString() => "$httpResponseCode $httpReasonPhrase";
}
