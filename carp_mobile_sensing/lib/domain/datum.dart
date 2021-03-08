/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of domain;

/// A base (abstract) class for a single unit of sensed information.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class Datum extends Data {
  /// The [DataFormat] of this type of [Datum].
  static const DataFormat CARP_DATA_FORMAT =
      DataFormat(NameSpace.CARP, CAMSDataType.NONE);

  DataFormat get format => CARP_DATA_FORMAT;

  /// Unique identifier for the current Datum, unique across all data generated.
  String id;

  /// The UTC timestamp when this data was generated on the device.
  DateTime timestamp;

  /// Create a datum.
  ///
  /// If [multiDatum] is true, then multiple [Datum] objects are stored in a
  /// list with the same header.
  Datum({bool multiDatum = false}) : super() {
    timestamp = DateTime.now().toUtc();
    if (!multiDatum) {
      id = Uuid().v1(); // Generates a time-based version 1 UUID.
    }
  }

  /// Create a [Datum] from a JSON map.
  factory Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);

  /// Return a JSON encoding of this datum.
  Map<String, dynamic> toJson() => _$DatumToJson(this);

  String toString() =>
      '$runtimeType - format: $format, id: $id, timestamp: $timestamp';
}

/// A very simple [Datum] that only holds a string datum object.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class StringDatum extends Datum {
  /// The [DataFormat] of this type of [Datum].
  static const DataFormat CARP_DATA_FORMAT =
      DataFormat(NameSpace.CARP, CAMSDataType.STRING);
  DataFormat get format => CARP_DATA_FORMAT;

  /// The string data for this Datum.
  String str;

  /// Create a [StringDatum] based on a simple string data item.
  StringDatum([this.str]) : super();

  /// Create a [StringDatum] from a JSON map.
  factory StringDatum.fromJson(Map<String, dynamic> json) =>
      _$StringDatumFromJson(json);
  Map<String, dynamic> toJson() => _$StringDatumToJson(this);

  String toString() => '${super.toString()}, str: $str';
}

/// A generic [Datum] that holds a map of key, value string objects.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class MapDatum extends Datum {
  /// The [DataFormat] of this type of [Datum].
  static const DataFormat CARP_DATA_FORMAT =
      DataFormat(NameSpace.CARP, CAMSDataType.MAP);
  DataFormat get format => CARP_DATA_FORMAT;

  /// The data map.
  Map<String, String> map;

  /// Create a [MapDatum] from a map of string => string.
  MapDatum([this.map]) : super();

  /// Create a [MapDatum] from a JSON map.
  factory MapDatum.fromJson(Map<String, dynamic> json) =>
      _$MapDatumFromJson(json);
  Map<String, dynamic> toJson() => _$MapDatumToJson(this);
}

/// A [Datum] object holding a Error, i.e. that the probe / sensor returned some
/// sort of error, which is reported back.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class ErrorDatum extends Datum {
  /// The [DataFormat] of this type of [Datum].
  static const DataFormat CARP_DATA_FORMAT =
      DataFormat(NameSpace.CARP, CAMSDataType.ERROR);
  DataFormat get format => CARP_DATA_FORMAT;

  /// The original error message returned from the probe, if available.
  String message;

  /// Create a [ErrorDatum] from an error message.
  ErrorDatum([this.message]) : super();

  /// Create a [ErrorDatum] from a JSON map.
  factory ErrorDatum.fromJson(Map<String, dynamic> json) =>
      _$ErrorDatumFromJson(json);
  Map<String, dynamic> toJson() => _$ErrorDatumToJson(this);

  String toString() => '${super.toString()}, message: $message';
}

/// A [Datum] object holding a link to a file.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class FileDatum extends Datum {
  /// The [DataFormat] of this type of [Datum].
  static const DataFormat CARP_DATA_FORMAT =
      DataFormat(NameSpace.CARP, CAMSDataType.FILE);
  DataFormat get format => CARP_DATA_FORMAT;

  /// The path to the attached file.
  String filename;

  /// Should this file be uploaded together with the [Datum] description.
  /// Default is [true].
  bool upload = true;

  /// Metadata for this file as a map of string key-value pairs.
  Map<String, String> metadata = <String, String>{};

  /// Create a new [FileDatum] based the file path and whether it is
  /// to be uploaded or not.
  FileDatum({this.filename, this.upload = true}) : super();

  /// Create a [FileDatum] from a JSON map.
  factory FileDatum.fromJson(Map<String, dynamic> json) =>
      _$FileDatumFromJson(json);
  Map<String, dynamic> toJson() => _$FileDatumToJson(this);

  String toString() =>
      '${super.toString()}, filename: $filename, upload: $upload';
}

/// A [Datum] object holding multiple [Datum]s of the same type.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class MultiDatum extends Datum {
  /// The list of [Datum]s, i.e. the data.
  List<Datum> data = [];

  /// Add a [Datum] to the list.
  void addDatum(Datum datum) => data.add(datum);

  /// Create an empty [MultiDatum].
  MultiDatum() : super();

  DataFormat get format =>
      (data.isNotEmpty) ? data.first.format : DataType.UNKNOWN;

  /// Create a [MultiDatum] from a JSON map.
  factory MultiDatum.fromJson(Map<String, dynamic> json) =>
      _$MultiDatumFromJson(json);

  /// Serialize this object to JSON.
  Map<String, dynamic> toJson() => _$MultiDatumToJson(this);

  String toString() => '${super.toString()}, size: ${data.length}';
}

// /// Specifies the data format of a [Datum].
// @JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
// class DataFormat {
//   /// The default "unknown" data format.
//   static const DataFormat UNKNOWN = DataFormat(NameSpace.UNKNOWN, 'unknown');

//   /// The data format namespace. See [NameSpace].
//   final String namespace;

//   /// The name of this data format.
//   final String name;

//   /// Create a new [DataFormat] based on a [namespace] and a [name].
//   const DataFormat(this.namespace, this.name) : super();

//   /// Create a [DataFormat] based on a [DataType].
//   factory DataFormat.fromDataType(DataType type) =>
//       DataFormat(type.namespace, type.name);

//   /// Create a [DataFormat] from a JSON map.
//   factory DataFormat.fromJson(Map<String, dynamic> json) =>
//       _$DataFormatFromJson(json);

//   /// Serialize this object to JSON.
//   Map<String, dynamic> toJson() => _$DataFormatToJson(this);

//   String toString() => '$namespace.$name';
// }

// /// Enumeration of data format types.
// ///
// /// Currently know data format types include:
// /// * `csv`  : Comma-separated values
// /// * `json` : JSON
// /// * `omh`  : Open mHealth
// class DataFormatType {
//   /// Comma-separated values
//   static const String CSV = 'csv';

//   /// JavaScript Object Notation (JSON)
//   static const String JSON = 'json';

//   /// Open mHealth (OMH)
//   static const String OMH = 'omh';
// }

// /// Enumeration of data type namespaces.
// ///
// /// Namespaces are used both in specification of [DataType]
// /// and in [DataFormat].
// ///
// /// Currently know namespaces include:
// /// * `omh`  : Open mHealth
// /// * `carp` : CACHET Research Platform (CARP)
// class NameSpace {
//   static const String UNKNOWN = 'unknown';
//   static const String OMH = 'omh';
//   static const String CARP = 'carp';
// }

/// Enumeration of data types used in [DataType].
class CAMSDataType {
  static const String UNKNOWN = 'unknown';
  static const String NONE = 'none';
  static const String EXECUTOR = 'executor';
  static const String STRING = 'string';
  static const String MAP = 'map';
  static const String ERROR = 'error';
  static const String FILE = 'file';

  static final List<String> _allTypes = [];

  /// Add a list of data types (as String) to the list of available data types.
  static void add(List<String> types) => _allTypes.addAll(types);

  /// Get a list of all available data types.
  static List<String> get all => _allTypes;
}
