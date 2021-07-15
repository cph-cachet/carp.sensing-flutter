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
  String get type => DataEndPointTypes.FILE;

  late FileDataEndPoint _fileDataEndPoint;
  String? _filename;
  File? _file;
  IOSink? _sink;
  bool _initialized = false;
  int _flushingSink = 0;

  Future initialize(
    String studyDeploymentId,
    DataEndPoint dataEndPoint,
    Stream<DataPoint> data,
  ) async {
    assert(dataEndPoint is FileDataEndPoint);
    await super.initialize(studyDeploymentId, dataEndPoint, data);

    _fileDataEndPoint = dataEndPoint as FileDataEndPoint;

    assert(
        Settings().dataPath != null,
        'The file path for storing data is null - '
        "call 'await Settings().init()' before using this $runtimeType.");

    if (_fileDataEndPoint.encrypt) {
      assert(_fileDataEndPoint.publicKey != null,
          'A public key is required if files are to be encrypted.');
      assert(_fileDataEndPoint.publicKey!.isNotEmpty,
          'A non-empty public key is required if files are to be encrypted.');
    }

    // Initializing the the local study directory and file
    await file;
    await sink;

    info('Initializing FileDataManager...');
    info('Data file path : ${Settings().dataPath}');
    info('Buffer size    : ${_fileDataEndPoint.bufferSize.toString()} bytes');
  }

  void onDataPoint(DataPoint dataPoint) => write(dataPoint);

  void onError(Object? error) =>
      write(DataPoint.fromData(ErrorDatum(error.toString()))
        ..carpHeader.dataFormat = DataFormat.fromString(CAMSDataType.ERROR));

  void onDone() => close();

  /// Current path and filename according to this format:
  ///
  ///   `carp/data/<studyDeploymentId>/carp-data-yyyy-mm-dd-hh-mm-ss-ms.json.zip`
  ///
  /// where the date is in UTC format / zulu time.
  Future<String> get filename async {
    if (_filename == null) {
      final created = DateTime.now()
          .toUtc()
          .toString()
          .replaceAll(RegExp(r':'), '-')
          .replaceAll(RegExp(r' '), '-')
          .replaceAll(RegExp(r'\.'), '-');

      _filename = '${Settings().dataPath}/carp-data-$created.json';
    }
    return _filename!;
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
    return _file!;
  }

  /// The currently used [IOSink].
  Future<IOSink> get sink async {
    if (_sink == null) {
      // open the file's sink for writing in append mode
      _sink = (await file).openWrite(mode: FileMode.append);
      // since this file will contain a list of json objects, write a '['
      _sink!.write('[\n');
      _initialized = true;
    }
    return _sink!;
  }

  /// Writes a JSON encoded [Datum] to the file
  Future<bool> write(DataPoint dataPoint) async {
    // Check if the sink is ready for writing...
    if (!_initialized) {
      info('File sink not ready -- delaying for 2 sec...');
      return Future.delayed(const Duration(seconds: 2), () => write(dataPoint));
    }

    final json = jsonEncode(dataPoint);

    await sink.then((_s) async {
      try {
        _s.write(json);
        _s.write('\n,\n'); // write a ',' to separate json objects in the list
        debug(
            'Writing data point to file - type: ${dataPoint.carpHeader.dataFormat}');

        await file.then((_f) async {
          await _f.length().then((len) {
            if (len > _fileDataEndPoint.bufferSize) {
              flush(_f, _s);
            }
          });
        });
      } catch (err) {
        warning('Error writing to file - $err');
        _initialized = false;
        return write(dataPoint);
      }
    });

    return true;
  }

  /// Flushes data to the file, compress, encrypt, and close it.
  void flush(File? flushFile, IOSink? flushSink) {
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

    final _jsonFilePath = flushFile!.path;
    var _finalFilePath = _jsonFilePath;

    info("Written JSON to file '$_jsonFilePath'. Closing it.");
    // write the closing json ']'
    flushSink!.write('{}]\n');

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
