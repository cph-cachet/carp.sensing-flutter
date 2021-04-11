/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of managers;

/// Stores [Datum] json objects on the device's local storage media.
/// Supports compression (zip) and encryption.
///
/// The path and filename format is
///
///   `carp/data/<study_deployment_id>/carp-data-yyyy-mm-dd-hh-mm-ss-ms.json.zip`
///
class FileDataManager extends AbstractDataManager {
  /// The path to use on the device for storing CARP data files.
  static const String CARP_FILE_PATH = 'carp/data';

  String get type => DataEndPointTypes.FILE;

  FileDataEndPoint _fileDataEndPoint;
  String _path;
  String _filename;
  File _file;
  IOSink _sink;
  bool _initialized = false;
  int _flushingSink = 0;

  Future initialize(
    CAMSMasterDeviceDeployment deployment,
    Stream<DataPoint> data,
  ) async {
    await super.initialize(deployment, data);
    assert(deployment.dataEndPoint is FileDataEndPoint);

    _fileDataEndPoint = dataEndPoint as FileDataEndPoint;

    if (_fileDataEndPoint.encrypt) {
      assert(_fileDataEndPoint.publicKey != null);
      assert(_fileDataEndPoint.publicKey.isNotEmpty);
    }

    // Initializing the the local study directory and file
    final _studyPath = await studyPath;
    await file;
    await sink;

    info('Initializing FileDataManager...');
    info('Study file path : $_studyPath');
    info('Buffer size : ${_fileDataEndPoint.bufferSize.toString()} bytes');
  }

  void onDataPoint(DataPoint dataPoint) => write(dataPoint);

  void onError(Object error) => write(DataPoint(
      DataPointHeader(
          studyId: deployment.studyId,
          userId: deployment.userId,
          dataFormat: DataFormat.fromString(CAMSDataType.ERROR)),
      ErrorDatum(error.toString())));

  void onDone() => close();

  ///Returns the local study path on the device where files can be written.
  Future<String> get studyPath async {
    if (_path == null) {
      // get local working directory
      final localApplicationDir = await getApplicationDocumentsDirectory();
      // create a sub-directory for this study named as the study ID
      final directory = await Directory(
              '${localApplicationDir.path}/$CARP_FILE_PATH/${deployment.studyDeploymentId}')
          .create(recursive: true);
      _path = directory.path;
    }
    return _path;
  }

  /// Current path and filename according to this format:
  ///
  ///   `carp/data/<studyDeploymentId>/carp-data-yyyy-mm-dd-hh-mm-ss-ms.json.zip`
  ///
  Future<String> get filename async {
    if (_filename == null) {
      final path = await studyPath;
      final created = DateTime.now()
          .toString()
          .replaceAll(RegExp(r':'), '-')
          .replaceAll(RegExp(r' '), '-')
          .replaceAll(RegExp(r'\.'), '-');

      _filename = '$path/carp-data-$created.json';
    }
    return _filename;
  }

  /// The current file being written to.
  Future<File> get file async {
    if (_file == null) {
      final path = await filename;
      _file = File(path);
      info("Creating file '$path'");
      addEvent(
          FileDataManagerEvent(FileDataManagerEventTypes.FILE_CREATED, path));
    }
    return _file;
  }

  /// The currently used [IOSink].
  Future<IOSink> get sink async {
    if (_sink == null) {
      // open the file's sink for writing in append mode
      _sink = (await file).openWrite(mode: FileMode.append);
      // since this file will contain a list of json objects, write a '['
      _sink.write('[\n');
      _initialized = true;
    }
    return _sink;
  }

  /// Writes a JSON encoded [Datum] to the file
  Future<bool> write(DataPoint dataPoint) async {
    // Check if the sink is ready for writing...
    if (!_initialized) {
      info('File sink not ready -- delaying for 2 sec...');
      return Future.delayed(const Duration(seconds: 2), () => write(dataPoint));
    }

    final json = jsonEncode(dataPoint);

    await sink.then((_s) {
      try {
        _s.write(json);
        _s.write('\n,\n'); // write a ',' to separate json objects in the list
        debug(
            'Writing data point to file - type: ${dataPoint.carpHeader.dataFormat}');

        file.then((_f) {
          _f.length().then((len) {
            if (len > _fileDataEndPoint.bufferSize) {
              flush(_f, _s);
            }
          });
        });
      } catch (err) {
        debug(err);
        _initialized = false;
        return write(dataPoint);
      }
    });

    return true;
  }

  /// Flushes data to the file, compress, encrypt, and close it.
  void flush(File flushFile, IOSink flushSink) {
    // if we're already flushing this file/sink, then do nothing.
    if (flushSink.hashCode == _flushingSink) return;

    _flushingSink = flushSink.hashCode;

    // Reset the file (setting it and its name and sink to null),
    // so a new file (and sink) can be created.
    _sink = null;
    _initialized = false;
    _filename = null;
    _file = null;
    // Start creating a new sink (and file) to be used in parallel
    // to flushing this file.
    sink.then((value) {});

    final _jsonFilePath = flushFile.path;
    var _finalFilePath = _jsonFilePath;

    info("Written JSON to file '$_jsonFilePath'. Closing it.");
    // write the closing json ']'
    flushSink.write('{}]\n');

    // once finished closing the file, then zip and encrypt it
    flushSink.close().then((value) {
      if (_fileDataEndPoint.zip) {
        // create a new zip file and add the JSON file to this zip file
        final encoder = ZipFileEncoder();
        final jsonFile = File(_jsonFilePath);
        _finalFilePath = '$_jsonFilePath.zip';
        encoder.create(_finalFilePath);
        encoder.addFile(jsonFile);
        encoder.close();

        // once the file is zipped to a new zip file, delete the old JSON file
        jsonFile.delete();
      }

      // encrypt the zip file
      if (_fileDataEndPoint.encrypt) {
        //TODO : implement encryption
        // if the encrypted file gets another name, remember to
        // update _jsonFilePath
        addEvent(FileDataManagerEvent(
            FileDataManagerEventTypes.FILE_ENCRYPTED, _finalFilePath));
      }

      addEvent(FileDataManagerEvent(
          FileDataManagerEventTypes.FILE_CLOSED, _finalFilePath));
    });
  }

  Future close() async {
    _initialized = false;
    await file.then((_f) {
      sink.then((_s) {
        flush(_f, _s);
      });
    });
    await super.close();
  }

  String toString() => 'FileDataManager';
}

/// A status event for this file data manager.
/// See [FileDataManagerEventTypes] for a list of possible event types.
class FileDataManagerEvent extends DataManagerEvent {
  /// The full path and filename for the file.
  String path;

  /// Create a new [FileDataManagerEvent].
  FileDataManagerEvent(String type, this.path) : super(type);

  String toString() => 'FileDataManagerEvent - type: $type, path: $path';
}

/// An enumeration of file data manager event types
class FileDataManagerEventTypes extends DataManagerEventTypes {
  /// FILE CREATED event
  static const String FILE_CREATED = 'file_created';

  /// FILE CLOSED event
  static const String FILE_CLOSED = 'file_closed';

  /// FILE DELETE event
  static const String FILE_DELETED = 'file_deleted';

  /// FILE ENCRYPTED event
  static const String FILE_ENCRYPTED = 'file_encrypted';
}
