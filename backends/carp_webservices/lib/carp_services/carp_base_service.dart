/*
 * Copyright 2018-2020 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_services;

/// An abstract base service class for all CARP Services:
///  * [CarpService]
///  * [DeploymentService]
///  * [ProtocolService]
///  * [ParticipationService]
///
abstract class CarpBaseService {
  CarpApp? _app;
  CarpUser? _currentUser;
  String? _endpointName;

  /// The CARP app associated with the CARP Web Service.
  /// Returns `null` if this service has not yet been configured via the
  /// [configure] method.
  CarpApp? get app => _app;

  /// Has this service been configured?
  bool get isConfigured => (_app != null);

  /// Configure the this instance of a Carp Service.
  void configure(CarpApp app) {
    this._app = app;
  }

  /// Configure from another [service] which has already been configured
  /// and potentially authenticated.
  void configureFrom(CarpBaseService service) {
    this._app = service._app;
    this._currentUser = service._currentUser;
  }

  /// Gets the current user.
  /// Returns `null` if no user is authenticated.
  CarpUser? get currentUser => _currentUser;

  /// The endpoint name for this service at CARP.
  String get rpcEndpointName;

  /// The URL for this service's endpoint at CARP.
  ///
  /// Typically on the form:
  /// `{{PROTOCOL}}://{{SERVER_HOST}}:{{SERVER_PORT}}/api/...`
  String get rpcEndpointUri => "${app!.uri.toString()}/api/$_endpointName";

  /// The headers for any authenticated HTTP REST call to a [CarpBaseService].
  Map<String, String> get headers {
    if (CarpService().currentUser!.token == null)
      throw new CarpServiceException(
          message:
              "OAuth token is null. Call 'CarpService().authenticate()' first.");

    return {
      "Content-Type": "application/json",
      "Authorization":
          "bearer ${CarpService().currentUser!.token!.accessToken}",
      "cache-control": "no-cache"
    };
  }

  /// A generic RPC [request] to the [endpointName] service endpoint at the
  /// CARP Server.
  ///
  /// If [endpointName] is not specified, the default [rpcEndpointName] is used.
  ///
  /// Returns a json map, mapping a key (String) to a json object (dynamic).
  /// If the request returns a list (i.e,. a `[...]` json format), this
  /// list is mapped to a json key/value map with only one object called `items`.
  /// This would look like:
  ///
  /// ```json
  /// {
  ///   items: [
  ///     item_1,
  ///     item_2,
  ///     ...
  ///   ]
  /// }
  /// ```
  Future<Map<String, dynamic>> _rpc(
    ServiceRequest request, [
    String? endpointName,
  ]) async {
    final String body = toJsonString(request.toJson());
    _endpointName = endpointName ?? rpcEndpointName;

    debug('REQUEST: $rpcEndpointUri\n$body');
    http.Response response = await httpr.post(Uri.encodeFull(rpcEndpointUri),
        headers: headers, body: body);
    int httpStatusCode = response.statusCode;
    String responseBody = response.body;
    debug('RESPONSE: $httpStatusCode\n$responseBody');
    // debug(
    //     'RESPONSE: $httpStatusCode\n${toJsonString(json.decode(responseBody))}');

    // check if this is a json list or an empty string
    // if so turn it into a valid json map
    if (responseBody.startsWith('[')) responseBody = '{"items":$responseBody}';
    if (responseBody.isEmpty) responseBody = '{}';

    Map<String, dynamic> responseJson = json.decode(responseBody);

    if (httpStatusCode == HttpStatus.ok || httpStatusCode == HttpStatus.created)
      return responseJson;

    // All other cases are treated as an error.
    throw CarpServiceException(
      httpStatus: HTTPStatus(httpStatusCode),
      message: responseJson["message"],
      path: responseJson["path"],
    );
  }
}
