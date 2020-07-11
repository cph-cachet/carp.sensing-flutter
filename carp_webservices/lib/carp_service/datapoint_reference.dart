/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of carp_services;

/// Provide a data endpoint reference to a CARP web service. Used to:
/// - post [CARPDataPoint]s
/// - get a [CARPDataPoint]s
/// - query for [CARPDataPoint]s
/// - delete [CARPDataPoint]s
class DataPointReference extends CarpReference {
  DataPointReference._(CarpService service) : super._(service);

  /// The URL for the data end point for this [DataPointReference].
  String get dataEndpointUri =>
      "${service.app.uri.toString()}/api/deployments/${service.app.study.id}/data-points";

  /// Upload a [CARPDataPoint] to the CARP backend using HTTP POST.
  ///
  /// Returns the server-generated ID for this data point.
  Future<int> postDataPoint(CARPDataPoint data) async {
    final String url = "$dataEndpointUri";
    final restHeaders = await headers;

    // POST the data point to the CARP web service
    http.Response response = await httpr.post(Uri.encodeFull(url),
        headers: restHeaders, body: json.encode(data));

    int httpStatusCode = response.statusCode;
    Map<String, dynamic> responseJson = json.decode(response.body);

    if ((httpStatusCode == 200) || (httpStatusCode == 201))
      return responseJson["id"];

    // All other cases are treated as an error.
    throw CarpServiceException(responseJson["error"],
        description: responseJson["error_description"],
        httpStatus: HTTPStatus(httpStatusCode, response.reasonPhrase));
  }

  /// Batch upload a file with [CARPDataPoint]s to the CARP backend using HTTP POST.
  ///
  /// A file can be created using a [FileDataManager] in `carp_mobile_sensing`.
  /// Note that the file should be raw JSON, and hence _not_ zipped.
  ///
  /// Returns when successful. Throws an [CarpServiceException] if not.
  Future<void> batchPostDataPoint(File file) async {
    assert(file != null);
    final String url = "$dataEndpointUri/batch";
    final restHeaders = await headers;

    var request = http.MultipartRequest("POST", Uri.parse(url));
    request.headers['Authorization'] = restHeaders['Authorization'];
    request.headers['Content-Type'] = 'multipart/form-data';
    request.headers['cache-control'] = 'no-cache';

    request.files.add(http.MultipartFile.fromBytes(
        'file', file != null ? file.readAsBytesSync() : List<int>(),
        filename: file != null ? file.path : '',
        contentType: MediaType('application', 'json')));

    // sending the request using the retry approach
    httpr.send(request).then((response) async {
      final int httpStatusCode = response.statusCode;

      if ((httpStatusCode == 200) || (httpStatusCode == 201))
        return; // CARP web service returns "200 OK" or "201 Created" when a file is uploaded to the server.

      // everything else is an exception
      response.stream.toStringStream().first.then((body) {
        final Map<String, dynamic> map = json.decode(body);
        final String error = map["error"];
        final String description = map["error_description"];
        final HTTPStatus status =
            HTTPStatus(httpStatusCode, response.reasonPhrase);
        throw CarpServiceException(error,
            description: description, httpStatus: status);
      });
    });
  }

  /// Get a [CARPDataPoint] from the CARP backend using HTTP GET
  Future<CARPDataPoint> getDataPoint(int id) async {
    String url = "$dataEndpointUri/$id";
    final restHeaders = await headers;

    // GET the data point from the CARP web service
    http.Response response =
        await httpr.get(Uri.encodeFull(url), headers: restHeaders);

    int httpStatusCode = response.statusCode;
    Map<String, dynamic> responseJson = json.decode(response.body);

    if (httpStatusCode == 200) return CARPDataPoint.fromJson(responseJson);

    // All other cases are treated as an error.
    throw CarpServiceException(responseJson["error"],
        description: responseJson["error_description"],
        httpStatus: HTTPStatus(httpStatusCode, response.reasonPhrase));
  }

  /// Get all [CARPDataPoint]s for this study.
  ///
  /// Be careful using this method - this might potential return an enormous amount of data.
  Future<List<CARPDataPoint>> getAllDataPoint() async => queryDataPoint('');

  /// Query for [CARPDataPoint]s from the CARP backend using HTTP GET.
  ///
  /// The [query] string can be build by querying data point _fields_ using _logical operations_.
  ///
  /// Query fields can be any field in a data point JSON, including nested fields. Examples include:
  ///
  ///  * Data point fields such as `id`, `study_id` and `created_at`.
  ///  * Header fields such as `carp_header.start_time`, `carp_header.user_id`, and `carp_header.data_format.name`
  ///  * Body fields such as `carp_body.latitude` or `carp_body.connectivity_status`
  ///
  /// Note that field names are nested using the dot-notation.
  ///
  /// The logical operations include:
  ///
  ///   * Logical AND : `;`
  ///   * Logical OR : `,`
  ///   * Equal to : `==`
  ///
  /// Comparison operations include.
  ///
  ///   * Not equal to : `!=`
  ///   * Less than : `<`
  ///   * Less than or equal to : `<=`
  ///   * Greater than operator : `>`
  ///   * Greater than or equal to : `>=`
  ///   * In : `=in=`
  ///   * Not in : `=out=`
  ///
  /// Examples of query strings include:
  ///
  /// Get all data-points between 2018-05-27T13:28:07 and 2019-05-29T08:55:26
  ///   * `carp_header.created_at>2018-05-27T13:28:07Z;carp_header.created_at<2019-05-29T08:55:26Z`
  ///
  /// Get all where the user id is 1 or 2
  ///   * `carp_header.user_id==1,2`
  ///
  ///
  /// Below is an example of a data point in JSON to see the different fields.
  ///
  /// ````
  /// {
  ///   "id": 24481799,
  ///   "study_id": 2,
  ///   "created_by_user_id": 2,
  ///   "created_at": "2019-06-19T09:50:44.245Z",
  ///   "updated_at": "2019-06-19T09:50:44.245Z",
  ///   "carp_header": {
  ///     "study_id": "8",
  ///     "user_id": "user@dtu.dk",
  ///     "data_format": {
  ///       "name": "location",
  ///       "namepace": "carp"
  ///     },
  ///     "trigger_id": "task1",
  ///     "device_role_name": "Patient's phone",
  ///     "upload_time": "2019-06-19T09:50:43.551Z",
  ///     "start_time": "2018-11-08T15:30:40.721748Z",
  ///     "end_time": "2019-06-19T09:50:43.551Z"
  ///   },
  ///   "carp_body": {
  ///     "altitude": 43.3,
  ///     "device_info": {},
  ///     "classname": "LocationDatum",
  ///     "latitude": 23454.345,
  ///     "accuracy": 12.4,
  ///     "speed_accuracy": 12.3,
  ///     "id": "3fdd1760-bd30-11e8-e209-ef7ee8358d2f",
  ///     "speed": 2.3,
  ///     "timestamp": "2018-11-08T15:30:40.721748Z",
  ///     "longitude": 23.4
  ///   }
  ///  }
  /// ````
  ///
  Future<List<CARPDataPoint>> queryDataPoint(String query) async {
    assert(query != null, 'A query string must be specified.');
    String url =
        (query.length == 0) ? dataEndpointUri : "$dataEndpointUri?query=$query";
    print('url : $url');
    final restHeaders = await headers;

    // GET the data points from the CARP web service
    // TODO - for some reason the CARP web service don't like encoded url's....
    //http.Response response = await httpr.get(Uri.encodeFull(url), headers: restHeaders);
    http.Response response = await httpr.get(url, headers: restHeaders);

    int httpStatusCode = response.statusCode;

    if (httpStatusCode == 200) {
      List<dynamic> list = json.decode(response.body);
      List<CARPDataPoint> datapoints = new List<CARPDataPoint>();
      for (var item in list) {
        datapoints.add(CARPDataPoint.fromJson(item));
      }
      return datapoints;
    }
    // All other cases are treated as an error.
    Map<String, dynamic> responseJson = json.decode(response.body);
    throw CarpServiceException(responseJson["error"],
        description: responseJson["error_description"],
        httpStatus: HTTPStatus(httpStatusCode, response.reasonPhrase));
  }

  /// Delete a [CARPDataPoint] from the CARP backend using HTTP DELETE
  Future<void> deleteDataPoint(int id) async {
    String url = "$dataEndpointUri/$id";
    final restHeaders = await headers;

    // DELETE the data point
    http.Response response =
        await httpr.delete(Uri.encodeFull(url), headers: restHeaders);
    final int httpStatusCode = response.statusCode;

    if (httpStatusCode == 200) return;

    // All other cases are treated as an error.
    final Map<String, dynamic> responseJson = json.decode(response.body);
    throw CarpServiceException(responseJson["error"],
        description: responseJson["error_description"],
        httpStatus: HTTPStatus(httpStatusCode, response.reasonPhrase));
  }
}
