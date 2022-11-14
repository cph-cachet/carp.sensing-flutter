/*
 * Copyright 2018-2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of domain;

/// A base (abstract) class for a single unit of sensed information.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class Datum extends Data {
  /// The [DataFormat] of this type of [Datum].
  @override
  @JsonKey(ignore: true)
  DataType get format => DataType.fromString(CAMSDataType.DATUM);

  /// An identifier for this [Datum], unique across all data generated.
  /// If this datum is part of a [MultiDatum], then this id is null.
  String? id;

  /// The UTC timestamp when this data was generated on the device.
  late DateTime timestamp;

  /// Create a datum.
  ///
  /// If [multiDatum] is true, then multiple [Datum] objects are stored in a
  /// list with the same [id] and header.
  Datum({bool multiDatum = false}) : super() {
    timestamp = DateTime.now().toUtc();
    // only add an id to single datums - not to each multi-datum
    id = (!multiDatum) ? Uuid().v1() : null;
  }

  bool equivalentTo(ConditionalEvent? event) => false;

  /// Create a [Datum] from a JSON map.
  factory Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);

  /// Return a JSON encoding of this datum.
  @override
  Map<String, dynamic> toJson() => _$DatumToJson(this);

  @override
  String toString() =>
      '$runtimeType - format: $format, id: $id, timestamp: $timestamp';
}

// /// A simple [Datum] that only holds a string datum object.
// @JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
// class StringDatum extends Datum {
//   @override
//   @JsonKey(ignore: true)
//   DataType get format => DataType.fromString(CAMSDataType.STRING);

//   /// The string data for this Datum.
//   String str;

//   /// Create a [StringDatum] based on a simple string data item.
//   StringDatum(this.str) : super();

//   /// Create a [StringDatum] from a JSON map.
//   factory StringDatum.fromJson(Map<String, dynamic> json) =>
//       _$StringDatumFromJson(json);
//   @override
//   Map<String, dynamic> toJson() => _$StringDatumToJson(this);

//   @override
//   String toString() => '${super.toString()}, str: $str';
// }

// /// A generic [Datum] that holds a map of key, value string objects.
// @JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
// class MapDatum extends Datum {
//   @override
//   @JsonKey(ignore: true)
//   DataType get format => DataType.fromString(CAMSDataType.MAP);

//   /// The data map.
//   Map<String, String> map;

//   /// Create a [MapDatum] from a map of string => string.
//   MapDatum(this.map) : super();

//   /// Create a [MapDatum] from a JSON map.
//   factory MapDatum.fromJson(Map<String, dynamic> json) =>
//       _$MapDatumFromJson(json);
//   @override
//   Map<String, dynamic> toJson() => _$MapDatumToJson(this);
// }

// /// A [Datum] object holding a Error, i.e. that the probe / sensor returned some
// /// sort of error, which is reported back.
// @JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
// class ErrorDatum extends Datum {
//   @override
//   @JsonKey(ignore: true)
//   DataType get format => DataType.fromString(CAMSDataType.ERROR);

//   /// The original error message returned from the probe, if available.
//   String message;

//   /// Create a [ErrorDatum] from an error message.
//   ErrorDatum(this.message) : super();

//   /// Create a [ErrorDatum] from a JSON map.
//   factory ErrorDatum.fromJson(Map<String, dynamic> json) =>
//       _$ErrorDatumFromJson(json);
//   @override
//   Map<String, dynamic> toJson() => _$ErrorDatumToJson(this);

//   @override
//   String toString() => '${super.toString()}, message: $message';
// }

// /// A [Datum] object holding a link to a file.
// @JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
// class FileDatum extends Datum {
//   @override
//   @JsonKey(ignore: true)
//   DataType get format => DataType.fromString(CAMSDataType.FILE);

//   /// The local path to the attached file on the phone where it is sampled.
//   /// This is used by e.g. a data manager to get and manage the file on
//   /// the phone.
//   @JsonKey(ignore: true)
//   String? path;

//   /// The name to the attached file.
//   String filename;

//   /// Should this file be uploaded together with the [Datum] description.
//   /// Default is [true].
//   bool upload = true;

//   /// Metadata for this file as a map of string key-value pairs.
//   Map<String, String>? metadata = <String, String>{};

//   /// Create a new [FileDatum] based the file path and whether it is
//   /// to be uploaded or not.
//   FileDatum({required this.filename, this.upload = true}) : super();

//   /// Create a [FileDatum] from a JSON map.
//   factory FileDatum.fromJson(Map<String, dynamic> json) =>
//       _$FileDatumFromJson(json);
//   @override
//   Map<String, dynamic> toJson() => _$FileDatumToJson(this);

//   @override
//   String toString() =>
//       '${super.toString()}, filename: $filename, upload: $upload';
// }

// /// A [Datum] object holding multiple [Datum]s of the same type.
// @JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
// class MultiDatum extends Datum {
//   /// The list of [Datum]s, i.e. the data.
//   List<Datum> data = [];

//   /// Add a [Datum] to the list.
//   void addDatum(Datum datum) => data.add(datum);

//   /// Create an empty [MultiDatum].
//   MultiDatum() : super();

//   @override
//   @JsonKey(ignore: true)
//   DataType get format => (data.isNotEmpty)
//       ? data.first.format
//       : DataType.fromString(CAMSDataType.UNKNOWN);

//   /// Create a [MultiDatum] from a JSON map.
//   factory MultiDatum.fromJson(Map<String, dynamic> json) =>
//       _$MultiDatumFromJson(json);

//   /// Serialize this object to JSON.
//   @override
//   Map<String, dynamic> toJson() => _$MultiDatumToJson(this);

//   @override
//   String toString() => '${super.toString()}, size: ${data.length}';
// }

// /// Enumeration of data types used in [DataType] and [DataFormat].
// class CAMSDataType {
//   static const String UNKNOWN = 'dk.cachet.carp.unknown';
//   static const String DATUM = 'dk.cachet.carp.datum';
//   static const String STRING = 'dk.cachet.carp.string';
//   static const String MAP = 'dk.cachet.carp.map';
//   static const String ERROR = 'dk.cachet.carp.error';
//   static const String EXECUTOR = 'dk.cachet.carp.executor';
//   static const String FILE = 'dk.cachet.carp.file';

//   static final List<String> _allTypes = [];

//   /// Add a list of data types (as String) to the list of available data types.
//   static void add(List<String> types) => _allTypes.addAll(types);

//   /// Get a list of all available data types.
//   static List<String> get all => _allTypes;
// }
