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
  paused,
  cancled,
  success,
  failure,
}

abstract class CarpServiceTask {
  FileStorageReference reference;
  TaskStateType _state = TaskStateType.idle;

  bool isCanceled = false;
  bool isComplete = false;
  bool isInProgress = true;
  bool isPaused = false;
  bool isSuccessful = false;

  CarpServiceTask._(this.reference);

  TaskStateType getState() => _state;

  void _resetState() {
    isCanceled = false;
    isComplete = false;
    isInProgress = false;
    isPaused = false;
    isSuccessful = false;
    _state = TaskStateType.idle;
  }

  /// Start this task.
  Future<void> _start() {
    _state = TaskStateType.working;
  }

  /// Pause this task
  void pause() {
    _state = TaskStateType.paused;
  }

  /// Resume this task
  void resume() {
    _state = TaskStateType.working;
  }

  /// Cancel this task
  void cancel() {
    _state = TaskStateType.cancled;
  }
}

class FileUploadTask extends CarpServiceTask {
  /// The file to upload.
  File file;

  /// Metadata for the file.
  Map<String, String> metadata;

  /// The server-side ID of this file.
  int get id => _id;
  int _id = -1;

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
    print('metadate : ' + json.encode(metadata));

    request.files.add(new http.MultipartFile.fromBytes('file', file != null ? file.readAsBytesSync() : new List<int>(),
        filename: file != null ? file.path : '', contentType: MediaType('image', 'jpg')));

    print("url : $url");
    print('request.headers : ${request.headers}');

    request.send().then((response) {
      print('file upload status : ${response.statusCode}');

      response.stream.toStringStream().first.then((body) {
        print('response data : $body');
        final int httpStatusCode = response.statusCode;
        final Map<String, dynamic> map = json.decode(body);

        // get the id generated from the server
        _id = map["id"];
        reference.id = _id;

        switch (httpStatusCode) {
          // CARP web service returns "201 Created" when a file is uploaded / created on the server.
          case 200:
          case 201:
            {
              _completer.complete(CarpFileResponse._(reference, map));
              break;
            }
          default:
            // All other cases are treated as an error.
            {
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

  /// Pause the upload task
  void pause() {
    super.pause();
    //TODO - implement this...
  }

  /// Resume the upload task
  void resume() {
    super.resume();
    //TODO - implement this...
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

  /// Returns a last snapshot when completed
  Completer<CarpFileResponse> _completer = Completer<CarpFileResponse>();
  Future<CarpFileResponse> get onComplete => _completer.future;

  /// Start the the download task.
  Future<CarpFileResponse> _start() {
    super._start();
    //TODO - implement this...
  }

  /// Pause the download task
  void pause() {
    super.pause();
    //TODO - implement this...
  }

  /// Resume the download task
  void resume() {
    super.resume();
    //TODO - implement this...
  }

  /// Cancel the download task
  void cancel() {
    super.cancel();
    //TODO - implement this...
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
