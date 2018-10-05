/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

import 'dart:async';
import 'package:carp_sensing/carp_sensing.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:carp_backend/carp_backend.dart';

class CARPBackend implements AuthenticationManager, DataManager, StudyManager {
  // TODO: These static URIs are not pretty -- needs to be configured somehow...
//  static const String clientID = "webui";
//  static const String clientSecret = "webuisecret";
//  static const String CARP_auth_uri = "https://sandbox.carp.cachet.dk/auth-service/auth/oauth/token";
//  static const String CARP_datapoint_uri = "https://sandbox.carp.cachet.dk/data-service/api/dataPoint";
  static const String CARP_deployment_uri = "https://sandbox.carp.cachet.dk/data-service/api/dataPoint";

  String password;
  String username;
  Study study;

  OAuthEndPoint authEndPoint;
  DataEndPoint dataEndPoint;

  OAuthToken _token;
  @override
  OAuthToken get token {
    return _token;
  }

  CARPBackend(this.authEndPoint, this.dataEndPoint);

  @override
  Future<OAuthToken> authenticate(String _username, String _password) async {
    if (authEndPoint == null) return null;

    username = _username;
    password = _password;

    final clientID = authEndPoint.clientID;
    final clientSecret = authEndPoint.clientSecret;
    final authHeaderUTF8 = utf8.encode("$clientID:$clientSecret");
    final authHeaderBase64 = base64.encode(authHeaderUTF8);

    final loginHeader = {
      "Authorization": "Basic $authHeaderBase64",
      "Content-Type": "application/x-www-form-urlencoded",
      "Accept": "application/json"
    };

    final loginBody = {
      "client_secret": "$clientSecret",
      "grant_type": "password",
      "scope": "read",
      "username": "$username",
      "password": "$password"
    };

    var response = await http.post(
      Uri.encodeFull(authEndPoint.uri.toString()),
      headers: loginHeader,
      body: loginBody,
    );

    String responseFromServer = response.body;
    Map<String, String> responseJSON = json.decode(responseFromServer);
    _token = new OAuthToken.fromJson(responseJSON);

    return _token;
  }

  @override
  Future<Study> getStudy(String studyId) async {
    study = new Study(studyId, username);

    if (token != null) {
      String accessToken = token.accessToken;
      String url = "$CARP_deployment_uri?access_token=$accessToken";

      http.Response response = await http.get(Uri.encodeFull(url), headers: {"Content-Type": "application/json"});

      String responseString = response.body;

      study = new Study(studyId, username);
    }
    return study;
  }

  @override
  Future initialize(Study study) {
    this.study = study;
  }

  @override
  Future<String> uploadData(Datum data) async {
    CARPDataPoint _cdp = new CARPDataPoint.fromDatum(study.id, study.userId, data);

    final String accessToken = token.accessToken;
    //final String carp_datapoint_uri = dataEndPoint.uri.toString();
    final String carp_datapoint_uri = CARP_deployment_uri;
    String url = "$carp_datapoint_uri?access_token=$accessToken";

    var response =
        await http.post(Uri.encodeFull(url), headers: {"Content-Type": "application/json"}, body: json.encode(_cdp));

    String message = response.body.trim();
    return message;
  }

  @override
  Future close() {
    return null;
  }
}
