/*
 * Copyright 2018-2020 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_services;

/// Abstract CARP web service references.
abstract class CarpReference {
  CarpBaseService service;

  CarpReference._(this.service) {
    assert(service != null, 'A valid CARP service must be provided.');
  }

  Map<String, String> get headers => service.headers;

  // Future<Map<String, String>> get headers async {
  //   assert(service != null);
  //   CarpUser user = service.currentUser;
  //   assert(user != null);
  //   final OAuthToken token = await user.getOAuthToken();

  //   return {
  //     "Content-Type": "application/json",
  //     "Authorization": "bearer ${token.accessToken}",
  //     "cache-control": "no-cache"
  //   };
  // }
}

abstract class RPCCarpReference extends CarpReference {
  RPCCarpReference._(CarpBaseService service) : super._(service);

  /// The URL for this reference's endpoint at CARP.
  ///
  /// Typically on the form:
  /// `{{PROTOCOL}}://{{SERVER_HOST}}:{{SERVER_PORT}}/api/...`
  String get rpcEndpointUri;

  /// A generic RPC request to the CARP Server.
  Future<Map<String, dynamic>> _rpc(ServiceRequest request) async {
    final String body = _encode(request.toJson());

    print('REQUEST: $rpcEndpointUri\n$body');
    http.Response response = await httpr.post(Uri.encodeFull(rpcEndpointUri),
        headers: headers, body: body);
    int httpStatusCode = response.statusCode;
    String responseBody = response.body;
    print('RESPONSE: $httpStatusCode\n$responseBody');

    // check if this is a json list, and if so turn it into a json map with one item called 'items'
    if (responseBody.startsWith('[')) {
      responseBody = '{"items":$responseBody}';
    }

    Map<String, dynamic> responseJson = json.decode(responseBody);

    if (httpStatusCode == HttpStatus.ok) {
      return responseJson;
    }

    // All other cases are treated as an error.
    throw CarpServiceException(
      httpStatus: HTTPStatus(httpStatusCode, response.reasonPhrase),
      message: responseJson["message"],
    );
  }
}
