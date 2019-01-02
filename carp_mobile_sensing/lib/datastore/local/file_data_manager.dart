/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of datastore;

/// Stores [Datum] json objects as plain-text on the device's local storage media.
/// Supports compression (zip) and encryption.
///
/// The path and filename format is
///
///   `carp/data/<study_id>/carp-data-yyyy-mm-dd-hh-mm-ss-ms.json.zip`
///
class FileDataManager extends AbstractDataManager {
  /// The path to use on the device for storing CARP files.
  static final String CARP_FILE_PATH = 'carp/data';

  FileDataEndPoint _fileDataEndPoint;
  String _path;
  String _filename;
  File _file;
  IOSink _sink;
  bool _initialized = false;
  int _flushingSink = 0;

  List<FileDataManagerListener> _listener = new List<FileDataManagerListener>();
  void addFileDataManagerListener(FileDataManagerListener listener) {
    _listener.add(listener);
  }

  void removeFileDataManagerListener(FileDataManagerListener listener) {
    _listener.remove(listener);
  }

  Future notifyAllListeners(FileDataManagerEvent event) async {
    for (FileDataManagerListener l in _listener) {
      await l.notify(event);
    }
  }

  @override
  Future initialize(Study study, Stream<Datum> events) async {
    super.initialize(study, events);
    assert(study.dataEndPoint is FileDataEndPoint);
    _fileDataEndPoint = study.dataEndPoint as FileDataEndPoint;

    if (_fileDataEndPoint.encrypt) {
      assert(_fileDataEndPoint.publicKey != null);
      assert(_fileDataEndPoint.publicKey.length != 0);
    }

    // Initializing the the local study directory and file
    final _studyPath = await studyPath;
    await file;
    await sink;

    print('Initializig FileDataManager...');
    print(' study file path : $_studyPath');
    print(' buffer size     : ${_fileDataEndPoint.bufferSize.toString()} bytes');
  }

  ///Returns the local study path on the device where files can be written.
  Future<String> get studyPath async {
    if (_path == null) {
      // get local working directory
      final localApplicationDir = await getApplicationDocumentsDirectory();
      // create a sub-directory for this study named as the study ID
      final directory =
          await Directory('${localApplicationDir.path}/$CARP_FILE_PATH/${study.id}').create(recursive: true);
      _path = directory.path;
    }
    return _path;
  }

  Future<String> get filename async {
    if (_filename == null) {
      final path = await studyPath;
      final created = DateTime.now()
          .toString()
          .replaceAll(new RegExp(r":"), "-")
          .replaceAll(new RegExp(r" "), "-")
          .replaceAll(new RegExp(r"\."), "-");

      _filename = '$path/carp-data-$created.json';
    }
    return _filename;
  }

  /// The current file being written to.
  Future<File> get file async {
    if (_file == null) {
      final path = await filename;
      _file = File(path);
      print("Creating file '$path'");
      notifyAllListeners(new FileDataManagerEvent(FileEvent.created, path));
    }
    return _file;
  }

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
  Future<bool> uploadData(Datum data) async {
    // Check if the sink is ready for writing...
    if (!_initialized) {
      print("File sink not ready -- delaying for 1 sec...");
      return Future.delayed(const Duration(seconds: 1), () => uploadData(data));
    }

    CARPDataPoint _header = new CARPDataPoint.fromDatum(study.id, study.userId, data);
    final json_string = jsonEncode(_header);

    sink.then((_s) {
      _s.write(json_string);
      // write a ',' to separate json objects in the list
      _s.write('\n,\n');
      print("Writing to file : ${data.toString()}");

      file.then((_f) {
        _f.length().then((len) {
          if (len > _fileDataEndPoint.bufferSize) {
            flush(_f, _s);
          }
        });
      });
    });

    return true;
  }

  /// Flushes data to the file, compress, encrypt, and close it.
  void flush(File flush_file, IOSink flush_sink) {
    // if we're already flushing this file/sink, then do nothing.
    if (flush_sink.hashCode == _flushingSink) return;

    _flushingSink = flush_sink.hashCode;

    // Reset the file (setting it and its name and sink to null), so a new file (and sink) can be created.
    _initialized = false;
    _filename = null;
    _file = null;
    _sink = null;
    // Start creating a new sink (and file) to be used in parallel to flushing this file.
    sink.then((value) {});

    final String _jsonFilePath = flush_file.path;
    String _finalFilePath = _jsonFilePath;

    print("Written JSON  to file '$_jsonFilePath'. Closing and zipping it.");
    // write the closing json ']'
    flush_sink.write(']\n');

    // once finished closing the file, then zip and encrypt it
    flush_sink.close().then((value) {
      if (_fileDataEndPoint.zip) {
        // create a new zip file and add the JSON file to this zip file
        final encoder = new ZipFileEncoder();
        final json_file = new File(_jsonFilePath);
        _finalFilePath = '$_jsonFilePath.zip';
        encoder.create(_finalFilePath);
        encoder.addFile(json_file);
        encoder.close();

        // once the file is zipped to a new zip file, delete the old JSON file
        json_file.delete();
      }

      // encrypt the zip file
      if (_fileDataEndPoint.encrypt) {
        //TODO : implement encryption
        // if the encrypted file gets another name, remember to update _jsonFilePath
      }

      notifyAllListeners(new FileDataManagerEvent(FileEvent.closed, _finalFilePath));
    });
  }

  Future close() async {
    //old_flush();

    file.then((_f) {
      sink.then((_s) {
        flush(_f, _s);
      });
    });
  }

  String toString() {
    return "FileDataManager";
  }

  void onData(Datum datum) => uploadData(datum);

  void onDone() {}

  void onError(error) {}
}

/// A Listener that can listen on [FileDataManagerEvent]s from a [FileDataManager].
abstract class FileDataManagerListener {
  Future notify(FileDataManagerEvent event);
}

class FileDataManagerEvent {
  /// The event type, see [FileEvent].
  FileEvent event;

  /// The full path and filename for the file.
  String path;

  FileDataManagerEvent(this.event, this.path);
}

enum FileEvent { created, closed }
