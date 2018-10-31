/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of carp_service;

/// Provide a data endpoint reference to a CARP web service. Used to:
/// - post [CARPDataPoint]s
/// - get [CARPDataPoint]s
/// - delete [CARPDataPoint]s
class DataPointReference extends CarpReference {
  DataPointReference._(CarpService service) : super._(service);

  /// The URL for the data end point for this [DataPointReference].
  String get dataPointUri => "${service.app.uri.toString()}/api/studies/${service.app.study.id}/data-points";

  /// Upload a [CARPDataPoint] to the CARP backend using HTTP POST
  Future<http.Response> postDataPoint(CARPDataPoint data) async {
    final String url = "${dataPointUri}";
    final rest_headers = await headers;

    http.Response response = await http.post(Uri.encodeFull(url), headers: rest_headers, body: json.encode(data));

    return response;
  }

  /// Get a [CARPDataPoint] from the CARP backend using HTTP GET
  Future<CARPDataPoint> getDataPoint(String id) async {
    String url = "${dataPointUri}/$id";
    final rest_headers = await headers;

    // GET the data point from the CARP web service
    http.Response response = await http.get(Uri.encodeFull(url), headers: rest_headers);

    int httpStatusCode = response.statusCode;
    Map<String, dynamic> responseJSON = json.decode(response.body);

    switch (httpStatusCode) {
      case 200:
        {
          return CARPDataPoint.fromJson(responseJSON);
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

  /// Delete a [CARPDataPoint] from the CARP backend using HTTP DELETE
  Future<http.Response> deleteDataPoint(String id) async {
    String url = "${dataPointUri}/$id";
    final rest_headers = await headers;

    // DELETE the data point
    http.Response response = await http.delete(Uri.encodeFull(url), headers: rest_headers);

    return response;
  }
}
