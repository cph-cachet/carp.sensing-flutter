/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of carp_services;

enum TaskStateType {
  idle,
  working,
  canceled,
  success,
  failure,
}

abstract class CarpServiceTask {
  CarpServiceTask._(this.reference);

  FileStorageReference reference;
  TaskStateType _state = TaskStateType.idle;
  TaskStateType get state => _state;

  /// Start this task.
  void _start() {
    _state = TaskStateType.working;
  }

  /// Cancel this task
  void cancel() {
    _state = TaskStateType.canceled;
  }
}

/// A task supporting asynchronous upload of a file.
class FileUploadTask extends CarpServiceTask {
  /// The file to upload.
  File file;

  /// The file name
  String get name => file.path.split('/').last;

  /// Metadata for the file.
  late Map<String, String> metadata;

  FileUploadTask._(FileStorageReference reference, this.file, [metadata])
      : super._(reference) {
    this.metadata = (metadata == null) ? {} : metadata;
  }

  /// Returns the [CarpFileResponse] when completed
  Completer<CarpFileResponse> _completer = Completer<CarpFileResponse>();
  Future<CarpFileResponse> get onComplete => _completer.future;

  /// Start the the upload task.
  Future<CarpFileResponse> _start() async {
    super._start();
    final String url = "${reference.fileEndpointUri}";

    Map<String, String> headers = reference.headers;

    var request = new http.MultipartRequest("POST", Uri.parse(url));
    request.headers['Authorization'] = headers['Authorization']!;
    request.headers['Content-Type'] = 'multipart/form-data';
    request.headers['cache-control'] = 'no-cache';

    // add file-specific metadata
    metadata['filename'] = name;
    metadata['size'] = (await file.length()).toString();
    request.fields['metadata'] = json.encode(metadata);

    request.files.add(MultipartFileRecreatable.fromFileSync(file.path));

    print('files # : ${request.files.length}');

    httpr.send(request).then((http.StreamedResponse response) {
      response.stream.toStringStream().first.then((body) {
        final int httpStatusCode = response.statusCode;
        print("httpStatusCode: $httpStatusCode");
        print("response:\n$response");
        print("body:\n$body");
        final Map<String, dynamic> map = json.decode(body);

        switch (httpStatusCode) {
          // CARP web service returns "201 Created" when a file is created on the server.
          case 200:
          case 201:
            {
              // save the id generated from the server
              reference.id = map["id"];
              _state = TaskStateType.success;
              _completer.complete(CarpFileResponse._(map));
              break;
            }
          default:
            // All other cases are treated as an error.
            {
              _state = TaskStateType.failure;
              final HTTPStatus status =
                  HTTPStatus(httpStatusCode, response.reasonPhrase);
              _completer.completeError(status);
              throw CarpServiceException(
                httpStatus: status,
                message: map["message"],
                path: map["path"],
              );
            }
        }
      });
    });

    return _completer.future;
  }

  /// Cancel the upload task
  void cancel() {
    super.cancel();
    _completer.completeError("canceled");
  }
}

/// A task supporting asynchronous download of a file.
class FileDownloadTask extends CarpServiceTask {
  /// The file on the local device which this task is downloading to.
  /// The file has to be created before starting the download.
  File file;

  FileDownloadTask._(FileStorageReference reference, this.file)
      : super._(reference);

  Completer<int> _completer = Completer<int>();

  /// Returns the HTTP status code when completed
  Future<int> get onComplete => _completer.future;

  /// Start the the download task.
  /// Returns the HTTP status code (200 for successful download).
  Future<int> _start() async {
    super._start();
    final String url = '${reference.fileEndpointUri}/${reference.id}/download';
    Map<String, String> headers = reference.headers;
    headers['Content-Type'] = 'application/x-www-form-urlencoded';

    httpr.get(Uri.encodeFull(url), headers: headers).then((response) {
      final int httpStatusCode = response.statusCode;

      switch (httpStatusCode) {
        case 200:
          {
            _state = TaskStateType.success;
            file.writeAsBytes(response.bodyBytes);
            _completer.complete(httpStatusCode);
            break;
          }
        default:
          // All other cases are treated as an error.
          {
            _state = TaskStateType.failure;
            final Map<String, dynamic> map = json.decode(response.body);
            final HTTPStatus status =
                HTTPStatus(httpStatusCode, response.reasonPhrase);
            _completer.completeError(httpStatusCode);
            throw CarpServiceException(
              httpStatus: status,
              message: map["message"],
              path: map["path"],
            );
          }
      }
    });

    return _completer.future;
  }

  /// Cancel the download task
  void cancel() {
    super.cancel();
    _completer.completeError(408); // 408 Request Timeout
  }
}

/// A file object as retrieved from the CARP server.
class CarpFileResponse {
  CarpFileResponse._(this.map)
      : id = map['id'],
        storageName = map['storage_name'],
        originalName = map['original_name'],
        metadata = map['metadata'] != null ? map['metadata'] : {},
        studyId = map['study_id'],
        createdBy = map['created_by'],
        createdAt = DateTime.parse(map['created_at']),
        updatedBy = map['updated_by'],
        updatedAt = DateTime.parse(map['updated_at']);

  final Map<dynamic, dynamic> map;
  final int id;
  final String storageName;
  final String originalName;
  final Map<String, dynamic> metadata;
  final String studyId;
  final String createdBy;
  final DateTime createdAt;
  final String updatedBy;
  final DateTime updatedAt;

  String toString() => json.encode(map);
}
