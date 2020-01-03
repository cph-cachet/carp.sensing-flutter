/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of data_managers;

/// Stores [Datum] json objects as plain-text on the device's local storage media.
/// Supports compression (zip) and encryption.
///
/// The path and filename format is
///
///   `carp/data/<study_id>/carp-data-yyyy-mm-dd-hh-mm-ss-ms.json.zip`
///
class FileDataManager extends AbstractDataManager {
  /// The path to use on the device for storing CARP files.
  static const String CARP_FILE_PATH = 'carp/data';

  String get type => DataEndPointTypes.FILE;

  FileDataEndPoint _fileDataEndPoint;
  String _path;
  String _filename;
  File _file;
  IOSink _sink;
  bool _initialized = false;
  int _flushingSink = 0;

  Future initialize(Study study, Stream<Datum> data) async {
    assert(study.dataEndPoint is FileDataEndPoint);
    super.initialize(study, data);

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

  void onDatum(Datum datum) => write(datum);

  void onDone() => close();

  void onError(error) {}

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
      addEvent(FileDataManagerEvent(FileDataManagerEventTypes.file_created, path));
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
  Future<bool> write(Datum data) async {
    // Check if the sink is ready for writing...
    if (!_initialized) {
      print("File sink not ready -- delaying for 2 sec...");
      return Future.delayed(const Duration(seconds: 2), () => write(data));
    }

    final DataPoint _datapoint = DataPoint.fromDatum(study.id, study.userId, data);
    final json = jsonEncode(_datapoint);

    sink.then((_s) {
      _s.write(json);
      _s.write('\n,\n'); // write a ',' to separate json objects in the list
      //print("Writing to file : ${data.toString()}");

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
  void flush(File flushFile, IOSink flushSink) {
    // if we're already flushing this file/sink, then do nothing.
    if (flushSink.hashCode == _flushingSink) return;

    _flushingSink = flushSink.hashCode;

    // Reset the file (setting it and its name and sink to null), so a new file (and sink) can be created.
    _sink = null;
    _initialized = false;
    _filename = null;
    _file = null;
    // Start creating a new sink (and file) to be used in parallel to flushing this file.
    sink.then((value) {});

    final String _jsonFilePath = flushFile.path;
    String _finalFilePath = _jsonFilePath;

    print("Written JSON to file '$_jsonFilePath'. Closing it.");
    // write the closing json ']'
    flushSink.write('{}]\n');

    // once finished closing the file, then zip and encrypt it
    flushSink.close().then((value) {
      if (_fileDataEndPoint.zip) {
        // create a new zip file and add the JSON file to this zip file
        final encoder = new ZipFileEncoder();
        final jsonFile = new File(_jsonFilePath);
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
        // if the encrypted file gets another name, remember to update _jsonFilePath
        addEvent(FileDataManagerEvent(FileDataManagerEventTypes.file_encrypted, _finalFilePath));
      }

      addEvent(FileDataManagerEvent(FileDataManagerEventTypes.file_closed, _finalFilePath));
    });
  }

  Future close() async {
    file.then((_f) {
      sink.then((_s) {
        flush(_f, _s);
      });
    });
    super.close();
  }

  String toString() => "FileDataManager";
}

/// Specify an endpoint where a file-based [DataManager] can store JSON data as files on the local device.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class FileDataEndPoint extends DataEndPoint {
  /// The buffer size of the raw JSON file in bytes.
  ///
  /// All Probed data will be written to a JSON file until the buffer is filled, at which time
  /// the file will be zipped. There is not a single-best [bufferSize] value.
  /// If data are collected at high rates, a higher value will be best to minimize
  /// zip operations. If data are collected at low rates, a lower value will be best
  /// to minimize the likelihood of data loss when the app is killed or crashes.
  /// Default size is 500 KB.
  int bufferSize = 500 * 1000;

  /// Is data to be compressed (zipped) before storing in a file. True as default.
  ///
  /// If zipped, the JSON file will be reduced to 1/5 of its size.
  /// For example, the 500 KB buffer typically is reduced to ~100 KB.
  bool zip = true;

  ///Is data to be encrypted before storing. False as default.
  ///
  /// Support only one-way encryption using a public key.
  bool encrypt = false;

  /// If [encrypt] is true, this should hold the public key in a RSA KPI encryption of data.
  String publicKey;

  /// Creates a [FileDataEndPoint].
  ///
  /// [type] is defined in [DataEndPointTypes]. Is typically of type [DataEndPointType.FILE]
  /// but specialized file types can be specified.
  FileDataEndPoint({String type, this.bufferSize, this.zip, this.encrypt, this.publicKey})
      : super(type ?? DataEndPointTypes.FILE);

  static Function get fromJsonFunction => _$FileDataEndPointFromJson;
  factory FileDataEndPoint.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory.fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$FileDataEndPointToJson(this);

  String toString() =>
      'FILE - buffer ${(bufferSize / 1000).round()} KB${zip ? ', zipped' : ''}${encrypt ? ', encrypted' : ''}';
}

/// A status event for this file data manager.
/// See [FileDataManagerEventTypes] for a list of possible event types.
class FileDataManagerEvent extends DataManagerEvent {
  /// The full path and filename for the file.
  String path;

  FileDataManagerEvent(String type, this.path) : super(type);

  String toString() => 'FileDataManagerEvent - type: $type, path: $path';
}

/// An enumeration of file data manager event types
class FileDataManagerEventTypes extends DataManagerEventTypes {
  static const String file_created = 'file_created';
  static const String file_closed = 'file_closed';
  static const String file_deleted = 'file_deleted';
  static const String file_encrypted = 'file_encrypted';
}
