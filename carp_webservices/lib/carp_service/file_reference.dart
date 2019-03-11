/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of carp_services;

/// Provide a file endpoint reference to a CARP web service. Used to:
/// - upload a local [File] to the CARP server
/// - download a CARP file to a local [File]
/// - get a [CarpFileResponse] file object from the CARP sever
/// - get all file object as a list of [CarpFileResponse]s from the CARP sever
/// - delete a file at CARP
class FileStorageReference extends CarpReference {
  /// The CARP server-side ID of this file.
  ///
  /// -1 if unknown or referencing a file not uploaded yet.
  int id = -1;

  FileStorageReference._(CarpService service, [this.id]) : super._(service);

  /// The URL for the file end point for this [FileStorageReference].
  String get fileEndpointUri => "${service.app.uri.toString()}/api/studies/${service.app.study.id}/files";

  /// Asynchronously uploads a file to the currently specified
  /// [FileStorageReference], with optional [metadata].
  FileUploadTask upload(File file, [Map<String, String> metadata]) {
    assert(file != null);
    final FileUploadTask task = FileUploadTask._(this, file, metadata);
    task._start();
    return task;
  }

  /// Asynchronously downloads the object at this [FileStorageReference] to a specified local file.
  FileDownloadTask download(File file) {
    assert(file != null);
    assert(id > 0);
    final FileDownloadTask task = FileDownloadTask._(this, file);
    task._start();
    return task;
  }

  /// Get the file object at the server for this [FileStorageReference].
  Future<CarpFileResponse> get() async {
    assert(id > 0);
    final String url = "$fileEndpointUri/$id";
    final restHeaders = await headers;

    http.Response response = await http.get(Uri.encodeFull(url), headers: restHeaders);
    int httpStatusCode = response.statusCode;
    Map<String, dynamic> map = json.decode(response.body);

    switch (httpStatusCode) {
      case 200:
        {
          return CarpFileResponse._(this, map);
        }
      default:
        // All other cases are treated as an error.
        {
          final String error = map["error"];
          final String description = map["error_description"];
          throw CarpServiceException(error,
              description: description, httpStatus: HTTPStatus(httpStatusCode, response.reasonPhrase));
        }
    }
  }

  /// Get all file objects for the [Study] in this [FileStorageReference].
  Future<List<CarpFileResponse>> getAll() async {
    final String url = "$fileEndpointUri";
    final restHeaders = await headers;

    http.Response response = await http.get(Uri.encodeFull(url), headers: restHeaders);
    int httpStatusCode = response.statusCode;
    List<dynamic> list = json.decode(response.body);

    switch (httpStatusCode) {
      case 200:
        {
          List<CarpFileResponse> fileList = new List<CarpFileResponse>();
          list.forEach((element) {
            fileList.add(CarpFileResponse._(this, element));
          });
          return fileList;
        }
      default:
        // All other cases are treated as an error.
        {
          Map<String, dynamic> map = json.decode(response.body);
          final String error = map["error"];
          final String description = map["error_description"];
          throw CarpServiceException(error,
              description: description, httpStatus: HTTPStatus(httpStatusCode, response.reasonPhrase));
        }
    }
  }

  /// Deletes the file at this [FileStorageReference].
  Future<int> delete() async {
    assert(id > 0);
    final String url = "$fileEndpointUri/$id";
    final restHeaders = await headers;

    http.Response response = await http.delete(Uri.encodeFull(url), headers: restHeaders);
    int httpStatusCode = response.statusCode;

    switch (httpStatusCode) {
      case 200:
      case 204:
        {
          return httpStatusCode;
        }
      default:
        // All other cases are treated as an error.
        {
          Map<String, dynamic> map = json.decode(response.body);
          final String error = map["error"];
          final String description = map["error_description"];
          throw CarpServiceException(error,
              description: description, httpStatus: HTTPStatus(httpStatusCode, response.reasonPhrase));
        }
    }
  }
}

// TODO - This [FileMetadata] class is not used currently -- only a 'flat' Map is used.
/// Metadata for a [FileStorageReference]. Metadata stores default attributes such as
/// size and content type. Also allow for storing custom metadata.
class FileMetadata {
  FileMetadata({
    this.cacheControl,
    this.contentDisposition,
    this.contentEncoding,
    this.contentLanguage,
    this.contentType,
    Map<String, String> customMetadata,
  })  : carpServiceName = null,
        path = null,
        name = null,
        sizeBytes = null,
        creationTimeMillis = null,
        updatedTimeMillis = null,
        md5Hash = null,
        customMetadata = customMetadata == null ? null : Map<String, String>.unmodifiable(customMetadata);

  FileMetadata._fromMap(Map<dynamic, dynamic> map)
      : carpServiceName = map['carpServiceName'],
        path = map['path'],
        name = map['name'],
        sizeBytes = map['sizeBytes'],
        creationTimeMillis = map['creationTimeMillis'],
        updatedTimeMillis = map['updatedTimeMillis'],
        md5Hash = map['md5Hash'],
        cacheControl = map['cacheControl'],
        contentDisposition = map['contentDisposition'],
        contentLanguage = map['contentLanguage'],
        contentType = map['contentType'],
        contentEncoding = map['contentEncoding'],
        customMetadata = map['customMetadata'] == null
            ? null
            : Map<String, String>.unmodifiable(map['customMetadata'].cast<String, String>());

  /// The owning CARP Web Service name the [FileStorageReference].
  final String carpServiceName;

  /// The path of the [FileStorageReference] object.
  final String path;

  /// A simple name of the [FileStorageReference] object.
  final String name;

  /// The stored Size in bytes of the [FileStorageReference] object.
  final int sizeBytes;

  /// The time the [FileStorageReference] was created in milliseconds since the epoch.
  final int creationTimeMillis;

  /// The time the [FileStorageReference] was last updated in milliseconds since the epoch.
  final int updatedTimeMillis;

  /// The MD5Hash of the [FileStorageReference] object.
  final String md5Hash;

  /// The Cache Control setting of the [FileStorageReference].
  final String cacheControl;

  /// The content disposition of the [FileStorageReference].
  final String contentDisposition;

  /// The content encoding for the [FileStorageReference].
  final String contentEncoding;

  /// The content language for the StorageReference, specified as a 2-letter
  /// lowercase language code defined by ISO 639-1.
  final String contentLanguage;

  /// The content type (MIME type) of the [FileStorageReference].
  final String contentType;

  /// An unmodifiable map with custom metadata for the [FileStorageReference].
  final Map<String, String> customMetadata;
}
