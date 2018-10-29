/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of carp_service;

/// Provide a file endpoint reference to a CARP web service. Used to:
/// - upload a local [File] to CARP
/// - download a CARP file to a local [File]
/// - delete a file at CARP
class FileStorageReference extends CarpReference {
  String _path;

  FileStorageReference._(CarpService service, this._path) : super._(service);

  /// Returns the full path to this object, not including the CARP Web Service URI
  Future<String> getPath() async {
    return _path;
  }

  /// Asynchronously uploads a file to the currently specified
  /// [FileStorageReference], with optional [metadata].
  FileUploadTask putFile(File file, [FileMetadata metadata]) {
    assert(file != null);
    final FileUploadTask task = FileUploadTask._(this, file, metadata);
    task._start();
    return task;
  }

  /// Asynchronously downloads the object at this [FileStorageReference] to a
  /// specified system file.
  FileDownloadTask writeToFile(File file) {
    assert(file != null);
    final FileDownloadTask task = FileDownloadTask._(this, file);
    task._start();
    return task;
  }

  /// Asynchronously deletes the file at this [FileStorageReference].
  FileDeleteTask delete() {
    final FileDeleteTask task = FileDeleteTask._(this);
    task._start();
    return task;
  }
}

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
