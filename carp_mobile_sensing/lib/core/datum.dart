/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of core;

/// A base (abstract) class for a single unit of sensed information.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class Datum {
  /// The [DataFormat] of this [Datum].
  DataFormat get format => DataFormat.UNKNOWN;

  Datum() : super();

  factory Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);
  Map<String, dynamic> toJson() => _$DatumToJson(this);
}

/// A [Datum] which conforms to the [DataFormat].
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class CARPDatum extends Datum {
  static const DataFormat CARP_DATA_FORMAT = DataFormat(NameSpace.CARP, DataType.NONE);
  DataFormat get format => CARP_DATA_FORMAT;

  /// Unique identifier for the current Datum, unique across all data generated.
  String id;

  /// The UTC timestamp for generating this data on the device.
  DateTime timestamp;

  CARPDatum({bool multiDatum = false}) : super() {
    timestamp = new DateTime.now().toUtc();

    if (!multiDatum) {
      id = new Uuid().v1(); // Generates a time-based version 1 UUID.
    }
  }

  factory CARPDatum.fromJson(Map<String, dynamic> json) => _$CARPDatumFromJson(json);
  Map<String, dynamic> toJson() => _$CARPDatumToJson(this);
}

/// A very simple [Datum] that only holds a string datum object.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class StringDatum extends CARPDatum {
  static const DataFormat CARP_DATA_FORMAT = DataFormat(NameSpace.CARP, DataType.STRING);
  DataFormat get format => CARP_DATA_FORMAT;

  String str;

  StringDatum({this.str}) : super();

  factory StringDatum.fromJson(Map<String, dynamic> json) => _$StringDatumFromJson(json);
  Map<String, dynamic> toJson() => _$StringDatumToJson(this);
}

/// A generic [Datum] that holds a map of key, value string objects.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class MapDatum extends CARPDatum {
  static const DataFormat CARP_DATA_FORMAT = DataFormat(NameSpace.CARP, DataType.MAP);
  DataFormat get format => CARP_DATA_FORMAT;

  Map<String, String> map;

  MapDatum({this.map}) : super();

  factory MapDatum.fromJson(Map<String, dynamic> json) => _$MapDatumFromJson(json);
  Map<String, dynamic> toJson() => _$MapDatumToJson(this);
}

/// A [Datum] object holding a Error, i.e. that the probe / sensor returned some
/// sort of error, which is reported back.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class ErrorDatum extends CARPDatum {
  static const DataFormat CARP_DATA_FORMAT = DataFormat(NameSpace.CARP, DataType.ERROR);
  DataFormat get format => CARP_DATA_FORMAT;

  /// The original error message returned from the probe, if available.
  String message;

  ErrorDatum({this.message}) : super();

  factory ErrorDatum.fromJson(Map<String, dynamic> json) => _$ErrorDatumFromJson(json);
  Map<String, dynamic> toJson() => _$ErrorDatumToJson(this);
}

/// A [Datum] object holding multiple [Datum]s of the same type.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class MultiDatum extends CARPDatum {
  /// The list of [Datum]s, i.e. the data.
  List<Datum> data = new List<Datum>();

  /// Add a [Datum] to the list.
  void addDatum(Datum datum) {
    data.add(datum);
  }

  MultiDatum() : super();

  DataFormat get format => (data.length > 0) ? data.first.format : DataFormat.UNKNOWN;

  factory MultiDatum.fromJson(Map<String, dynamic> json) => _$MultiDatumFromJson(json);
  Map<String, dynamic> toJson() => _$MultiDatumToJson(this);

  String toString() => "${this.runtimeType}: {format: ${format}, size: ${data.length}}";
}

/// Specifies the data format of a [Datum].
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class DataFormat {
  static const DataFormat UNKNOWN = DataFormat(NameSpace.UNKNOWN, "unknown");

  /// The data format namespace. See [NameSpace].
  final String namepace;

  /// The name of this data format.
  final String name;

  const DataFormat(this.namepace, this.name) : super();
  factory DataFormat.fromDataType(MeasureType type) => DataFormat(type.namespace, type.name);

  factory DataFormat.fromJson(Map<String, dynamic> json) => _$DataFormatFromJson(json);
  Map<String, dynamic> toJson() => _$DataFormatToJson(this);

  String toString() => "$namepace.$name";
}

/// Enumeration of data format types.
///
/// Currently know data format types include:
/// * `csv`  : Comma-separated values
/// * `json` : JSON
/// * `omh`  : Open mHealth
class DataFormatType {
  static const String CSV = "csv";
  static const String JSON = "json";
  static const String OMH = "omh";
}

/// Enumeration of namespaces.
///
/// Namespaces are used both in specification of [MeasureType] and in [DataFormat].
///
/// Currently know namespaces include:
/// * `omh`  : Open mHealth
/// * `carp` : CACHET Research Platform (CARP)
class NameSpace {
  static const String UNKNOWN = "unknown";
  static const String OMH = "omh";
  static const String CARP = "carp";
}

/// Enumeration of data types used in [MeasureType].
class DataType {
  static const String NONE = "none";
  static const String EXECUTOR = "executor";
  static const String STRING = "string";
  static const String MAP = "map";
  static const String ERROR = "error";
  static const String MEMORY = "memory";
  static const String DEVICE = "device";
  static const String PEDOMETER = "pedometer";
  static const String ACCELEROMETER = "accelerometer";
  static const String GYROSCOPE = "gyroscope";
  static const String BATTERY = "battery";
  static const String BLUETOOTH = "bluetooth";
  static const String AUDIO = "audio";
  static const String NOISE = "noise";
  static const String LOCATION = "location";
  static const String CONNECTIVITY = "connectivity";
  static const String LIGHT = "light";
  static const String APPS = "apps";
  static const String APP_USAGE = "app_usage";
  static const String TEXT_MESSAGE_LOG = "text-message-log";
  static const String TEXT_MESSAGE = "text-message";
  static const String SCREEN = "screen";
  static const String PHONE_LOG = "phone_log";
  static const String ACTIVITY = "activity";
  static const String APPLE_HEALTHKIT = "apple-healthkit";
  static const String GOOGLE_FIT = "google-fit";
  static const String WEATHER = "weather";

  static List<String> get all => [
        DataType.MEMORY,
        DataType.DEVICE,
        DataType.PEDOMETER,
        DataType.ACCELEROMETER,
        DataType.GYROSCOPE,
        DataType.BATTERY,
        DataType.BLUETOOTH,
        DataType.AUDIO,
        DataType.NOISE,
        DataType.LOCATION,
        DataType.CONNECTIVITY,
        DataType.LIGHT,
        DataType.APPS,
        DataType.APP_USAGE,
        DataType.TEXT_MESSAGE_LOG,
        DataType.TEXT_MESSAGE,
        DataType.SCREEN,
        DataType.PHONE_LOG,
        DataType.ACTIVITY,
        DataType.APPLE_HEALTHKIT,
        DataType.GOOGLE_FIT,
        DataType.WEATHER
      ];
}
