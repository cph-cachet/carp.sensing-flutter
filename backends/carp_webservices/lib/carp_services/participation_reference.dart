/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of carp_services;

/// Provide a participation endpoint reference to a CARP web service.
///
/// According to CARP core, the protocol for using the
/// [deployment sub-system](https://github.com/cph-cachet/carp.core-kotlin/blob/develop/docs/carp-deployment.md) is:
///
///   - [getParticipantData()] - get participation data from this deployment.
///   - [setParticipantData()] - set participation data in this deployment
class ParticipationReference extends CarpReference {
  String _studyDeploymentId;

  /// The CARP study deployment ID.
  String get studyDeploymentId =>
      _studyDeploymentId ?? service.app.studyDeploymentId;

  ParticipationReference._(CarpService service, this._studyDeploymentId)
      : super._(service);

  /// A generic RPC request to the CARP Server.
  Future<Map<String, dynamic>> _rpc(ParticipationServiceRequest request) async {
    final restHeaders = await headers;
    final String body = _encode(request.toJson());

    print('REQUEST: ${service.participationRPCEndpointUri}\n$body');
    http.Response response = await httpr.post(
        Uri.encodeFull(service.participationRPCEndpointUri),
        headers: restHeaders,
        body: body);
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

  /// Get currently set data for all expected participant data in this study
  /// deployment with [studyDeploymentId].
  /// Data which is not set equals null.
  Future<ParticipantData> getParticipantData() async {
    ParticipantData data = ParticipantData.fromJson(
        await _rpc(GetParticipantData(studyDeploymentId)));
    return data;
  }

  /// Set participant [data] for the given [inputDataType] in thsis study deployment.
  /// Returns all data for the specified study deployment, including the newly set data.
  Future<ParticipantData> setParticipantData(
      String inputDataType, ParticipantData data) async {
    ParticipantData newData = ParticipantData.fromJson(
        await _rpc(SetParticipantData(studyDeploymentId, inputDataType, data)));
    return newData;
  }
}
