/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of carp_service;

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
  Future<http.Response> _start() {
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
  FileMetadata metadata;
  File file;

  FileUploadTask._(FileStorageReference reference, this.file, [this.metadata]) : super._(reference);

  /// Start the the upload/download/delete task.
  Future<http.Response> _start() {
    super._start();
    //TODO - implement this...
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
    //TODO - implement this...
  }
}

class FileDownloadTask extends CarpServiceTask {
  /// The file on the local device which this task is downloading to.
  /// The file has to be created before starting the download.
  File file;

  FileDownloadTask._(FileStorageReference reference, this.file) : super._(reference);

  /// Start the the upload/download/delete task.
  Future<http.Response> _start() {
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

class FileDeleteTask extends CarpServiceTask {
  String path;

  FileDeleteTask._(FileStorageReference reference) : super._(reference);

  /// Start the the delete task.
  Future<http.Response> _start() {
    super._start();
    //TODO - implement this...
  }

  /// Pause the delete task
  void pause() {
    super.pause();
    //TODO - implement this...
  }

  /// Resume the delete task
  void resume() {
    super.resume();
    //TODO - implement this...
  }

  /// Cancel the delete task
  void cancel() {
    super.cancel();
    //TODO - implement this...
  }
}
