/*
 * Copyright 2020 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of carp_services;

/// The HTTP Retry method.
final HTTPRetry httpr = HTTPRetry();

/// A class wrapping all HTTP operations (GET, POST, PUT, DELETE) in a retry manner.
///
/// In case of network problems ([SocketException] or [TimeoutException]), this method will retry
/// the HTTP operation N=15 times, with an increasing delay time as 2^(N+1) * 5 secs (20, 40, , ..., 10,240).
/// I.e., maximum retry time is ca. three hours.
class HTTPRetry {
  /// Sends an generic HTTP [MultipartRequest] with the given headers to the given URL,
  /// which can be a [Uri] or a [String].
  Future<http.StreamedResponse> send(http.MultipartRequest request) async => await retry(
        () => request.send().timeout(Duration(seconds: 5)),
        delayFactor: Duration(seconds: 5),
        maxAttempts: 15,
        retryIf: (e) => e is SocketException || e is TimeoutException,
        onRetry: (e) => print('${e.runtimeType} - Retrying to SEND ${request.url}'),
      );

  /// Sends an HTTP GET request with the given headers to the given URL, which can
  /// be a [Uri] or a [String].
  Future<http.Response> get(url, {Map<String, String> headers}) async => await retry(
        () => http
            .get(
              Uri.encodeFull(url),
              headers: headers,
            )
            .timeout(Duration(seconds: 5)),
        delayFactor: Duration(seconds: 5),
        maxAttempts: 15,
        retryIf: (e) => e is SocketException || e is TimeoutException,
        onRetry: (e) => print('${e.runtimeType} - Retrying to GET $url'),
      );

  /// Sends an HTTP POST request with the given headers and body to the given URL,
  /// which can be a [Uri] or a [String].
  Future<http.Response> post(url, {Map<String, String> headers, body, Encoding encoding}) async {
    // calling the http POST method using the retry approach
    final http.Response response = await retry(
      () => http
          .post(
            Uri.encodeFull(url),
            headers: headers,
            body: body,
            encoding: encoding,
          )
          .timeout(Duration(seconds: 5)),
      delayFactor: Duration(seconds: 5),
      maxAttempts: 15,
      retryIf: (e) => e is SocketException || e is TimeoutException,
      onRetry: (e) => print('${e.runtimeType} - Retrying to POST $url'),
    );
    return response;
  }

  /// Sends an HTTP PUT request with the given headers and body to the given URL,
  /// which can be a [Uri] or a [String].
  Future<http.Response> put(url, {Map<String, String> headers, body, Encoding encoding}) async {
    // calling the http PUT method using the retry approach
    final http.Response response = await retry(
      () => http
          .put(
            Uri.encodeFull(url),
            headers: headers,
            body: body,
            encoding: encoding,
          )
          .timeout(Duration(seconds: 5)),
      delayFactor: Duration(seconds: 5),
      maxAttempts: 15,
      retryIf: (e) => e is SocketException || e is TimeoutException,
      onRetry: (e) => print('${e.runtimeType} - Retrying to PUT $url'),
    );
    return response;
  }

  /// Sends an HTTP DELETE request with the given headers to the given URL, which
  /// can be a [Uri] or a [String].
  Future<http.Response> delete(url, {Map<String, String> headers}) async {
    // calling the http DELETE method using the retry approach
    final http.Response response = await retry(
      () => http
          .delete(
            Uri.encodeFull(url),
            headers: headers,
          )
          .timeout(Duration(seconds: 5)),
      delayFactor: Duration(seconds: 5),
      maxAttempts: 15,
      retryIf: (e) => e is SocketException || e is TimeoutException,
      onRetry: (e) => print('${e.runtimeType} - Retrying to DELETE $url'),
    );
    return response;
  }
}
