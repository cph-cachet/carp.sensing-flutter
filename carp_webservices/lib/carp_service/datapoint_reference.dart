/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of carp_services;

/// Provide a data endpoint reference to a CARP web service. Used to:
/// - post [CARPDataPoint]s
/// - get [CARPDataPoint]s
/// - delete [CARPDataPoint]s
class DataPointReference extends CarpReference {
  DataPointReference._(CarpService service) : super._(service);

  /// The URL for the data end point for this [DataPointReference].
  String get dataEndpointUri => "${service.app.uri.toString()}/api/studies/${service.app.study.id}/data-points";

  /// Upload a [CARPDataPoint] to the CARP backend using HTTP POST.
  ///
  /// Returns the server-generated ID for this data point.
  Future<int> postDataPoint(CARPDataPoint data) async {
    final String url = "$dataEndpointUri";
    final restHeaders = await headers;

    http.Response response = await http.post(Uri.encodeFull(url), headers: restHeaders, body: json.encode(data));

    int httpStatusCode = response.statusCode;
    Map<String, dynamic> responseJSON = json.decode(response.body);

    //print(" body : ${response.body}");

    switch (httpStatusCode) {
      case 200:
      case 201:
        {
          return responseJSON["id"];
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

  /// Batch upload a file with [CARPDataPoint]s to the CARP backend using HTTP POST.
  ///
  /// A file can be created using a [FileDataManager] in `carp_mobile_sensing`.
  /// Note that the file should be raw JSON, and hence not zipped.
  ///
  /// Returns if successful. Throws an [CarpServiceException] if not.
  Future<void> batchPostDataPoint(File file) async {
    assert(file != null);
    final String url = "$dataEndpointUri/batch";
    final restHeaders = await headers;

    var request = new http.MultipartRequest("POST", Uri.parse(url));
    request.headers['Authorization'] = restHeaders['Authorization'];
    request.headers['Content-Type'] = 'multipart/form-data';
    request.headers['cache-control'] = 'no-cache';

    request.files.add(new http.MultipartFile.fromBytes('file', file != null ? file.readAsBytesSync() : new List<int>(),
        filename: file != null ? file.path : '', contentType: MediaType('application', 'json')));

    request.send().then((response) {
      final int httpStatusCode = response.statusCode;

      switch (httpStatusCode) {
        // CARP web service returns "200 OK" or "201 Created" when a file is uploaded to the server.
        case 200:
        case 201:
          {
            return;
          }
        default:
          {
            response.stream.toStringStream().first.then((body) {
              final Map<String, dynamic> map = json.decode(body);
              final String error = map["error"];
              final String description = map["error_description"];
              final HTTPStatus status = HTTPStatus(httpStatusCode, response.reasonPhrase);
              throw CarpServiceException(error, description: description, httpStatus: status);
            });
          }
      }
    });
  }

  /// Get a [CARPDataPoint] from the CARP backend using HTTP GET
  Future<CARPDataPoint> getDataPoint(int id) async {
    String url = "$dataEndpointUri/$id";
    final restHeaders = await headers;

    // GET the data point from the CARP web service
    http.Response response = await http.get(Uri.encodeFull(url), headers: restHeaders);

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
          throw CarpServiceException(error,
              description: description, httpStatus: HTTPStatus(httpStatusCode, response.reasonPhrase));
        }
    }
  }

  /// Delete a [CARPDataPoint] from the CARP backend using HTTP DELETE
  Future<void> deleteDataPoint(int id) async {
    String url = "$dataEndpointUri/$id";
    final restHeaders = await headers;

    // DELETE the data point
    http.Response response = await http.delete(Uri.encodeFull(url), headers: restHeaders);

    int httpStatusCode = response.statusCode;
    switch (httpStatusCode) {
      case 200:
        {
          return;
        }
      default:
        // All other cases are treated as an error.
        // TODO - later we can handle more HTTP status codes here.
        {
          final Map<String, dynamic> responseJSON = json.decode(response.body);
          final String error = responseJSON["error"];
          final String description = responseJSON["error_description"];
          throw CarpServiceException(error,
              description: description, httpStatus: HTTPStatus(httpStatusCode, response.reasonPhrase));
        }
    }
  }
}
