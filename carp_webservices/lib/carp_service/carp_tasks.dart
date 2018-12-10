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
  FileStorageReference reference;
  TaskStateType _state = TaskStateType.idle;

  bool isCanceled = false;
  bool isComplete = false;
  bool isInProgress = true;
  bool isSuccessful = false;

  CarpServiceTask._(this.reference);

  TaskStateType get state => _state;

  void _resetState() {
    isCanceled = false;
    isComplete = false;
    isInProgress = false;
    isSuccessful = false;
    _state = TaskStateType.idle;
  }

  /// Start this task.
  Future<void> _start() {
    _state = TaskStateType.working;
  }

  /// Cancel this task
  void cancel() {
    _state = TaskStateType.canceled;
  }
}

class FileUploadTask extends CarpServiceTask {
  /// The file to upload.
  File file;

  /// Metadata for the file.
  Map<String, String> metadata;

  FileUploadTask._(FileStorageReference reference, this.file, [metadata]) : super._(reference) {
    this.metadata = metadata == null ? new Map<String, String>() : metadata;
  }

  /// Returns the [CarpFileResponse] when completed
  Completer<CarpFileResponse> _completer = Completer<CarpFileResponse>();
  Future<CarpFileResponse> get onComplete => _completer.future;

  /// Start the the upload task.
  Future<CarpFileResponse> _start() async {
    super._start();
    final String url = "${reference.fileEndpointUri}";
    Map<String, String> rest_headers = await reference.headers;

    var request = new http.MultipartRequest("POST", Uri.parse(url));
    request.headers['Authorization'] = rest_headers['Authorization'];
    request.headers['Content-Type'] = 'multipart/form-data';
    request.headers['cache-control'] = 'no-cache';

    // add file-specific metadata
    metadata['filename'] = file.path;
    metadata['size'] = (await file.length()).toString();
    // TODO -- there is an error if we submit metadata to the CARP server. Responds with "415 - Unsupported Media Type"
    //request.fields['metadata'] = json.encode(metadata);
    print('metadata : ' + json.encode(metadata));

    request.files.add(new http.MultipartFile.fromBytes('file', file != null ? file.readAsBytesSync() : new List<int>(),
        filename: file != null ? file.path : '', contentType: MediaType('image', 'jpg')));

    request.send().then((response) {
      response.stream.toStringStream().first.then((body) {
        final int httpStatusCode = response.statusCode;
        final Map<String, dynamic> map = json.decode(body);

        // save the id generated from the server
        reference.id = map["id"];

        switch (httpStatusCode) {
          // CARP web service returns "201 Created" when a file is uploaded / created on the server.
          case 200:
          case 201:
            {
              _state = TaskStateType.success;
              _completer.complete(CarpFileResponse._(reference, map));
              break;
            }
          default:
            // All other cases are treated as an error.
            {
              _state = TaskStateType.failure;
              final String error = map["error"];
              final String description = map["error_description"];
              final HTTPStatus status = HTTPStatus(httpStatusCode, response.reasonPhrase);
              _completer.completeError(status);
              throw CarpServiceException(error, description: description, httpStatus: status);
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

class FileDownloadTask extends CarpServiceTask {
  /// The file on the local device which this task is downloading to.
  /// The file has to be created before starting the download.
  File file;

  FileDownloadTask._(FileStorageReference reference, this.file) : super._(reference);

  /// Returns the HTTP status code when completed
  Completer<int> _completer = Completer<int>();
  Future<int> get onComplete => _completer.future;

  /// Start the the download task. Returns the HTTP status code (200 for successful download).
  Future<int> _start() async {
    super._start();
    final String url = '${reference.fileEndpointUri}/${reference.id}/download';
    Map<String, String> rest_headers = await reference.headers;
    rest_headers['Content-Type'] = 'application/x-www-form-urlencoded';

    http.get(Uri.encodeFull(url), headers: rest_headers).then((response) {
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
            final String error = map["error"];
            final String description = map["error_description"];
            final HTTPStatus status = HTTPStatus(httpStatusCode, response.reasonPhrase);
            _completer.completeError(httpStatusCode);
            throw CarpServiceException(error, description: description, httpStatus: status);
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

class CarpFileResponse {
  CarpFileResponse._(this.ref, this.map)
      : id = map['id'],
        storageName = map['storage_name'],
        originalName = map['original_name'],
        metadata = map['metadata'] != null ? json.decode(map['metadata']) : null,
        createdByUserId = map['created_by_user_id'],
        // TODO - are we sure we want the entire JSON tree for a creator in the response?
        //creator = map['creator'] != null ? json.decode(map['creator']) : null,
        creator = null,
        createdAt = DateTime.parse(map['created_at']),
        updatedAt = DateTime.parse(map['updated_at']),
        studyId = map['study_id'],
        study = null;
  // TODO - same problem as above -- the response contains the entire study protocol....
  //study = map['study'] != null ? json.decode(map['study']) : null;

  final Map<dynamic, dynamic> map;
  final FileStorageReference ref;
  final int id;
  final String storageName;
  final String originalName;
  final Map<String, String> metadata;
  final int createdByUserId;
  final String creator;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int studyId;
  final Study study;

  String toString() => json.encode(map);
}
