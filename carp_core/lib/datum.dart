/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of carp_core;

/// A base (abstract) class for a single unit of sensed information.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class Datum extends Serializable {
  static CARPDataFormat CARP_DATA_FORMAT = new CARPDataFormat(NameSpace.UNKNOWN_NAMESPACE, "unknown");

  Datum() : super();

  factory Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);
  Map<String, dynamic> toJson() => _$DatumToJson(this);

  /// Return the [CARPDataFormat] for this datum.
  CARPDataFormat getCARPDataFormat() => CARP_DATA_FORMAT;
}

/// A [Datum] which conforms to the [CARPDataFormat].
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class CARPDatum extends Datum {
  static CARPDataFormat CARP_DATA_FORMAT = new CARPDataFormat(NameSpace.CARP_NAMESPACE, Measure.GENERIC_MEASURE);

  /// Unique identifier for the current Datum, unique across all data generated.
  String id;

  /// The UTC timestamp for generating this data on the device.
  DateTime timestamp;

  /// Basic information about the device from which this [Datum] was collected.
  DeviceInfo deviceInfo;

  CARPDatum({bool multiDatum = false}) {
    timestamp = new DateTime.now().toUtc();

    if (!multiDatum) {
      id = new Uuid().v1(); // Generates a time-based version 1 UUID.
      deviceInfo = new DeviceInfo(Device.platform, Device.deviceID,
          deviceName: Device.deviceName,
          deviceModel: Device.deviceModel,
          deviceManufacturer: Device.deviceManufacturer,
          operatingSystem: Device.operatingSystem,
          hardware: Device.hardware);
    }
  }

  factory CARPDatum.fromJson(Map<String, dynamic> json) => _$CARPDatumFromJson(json);
  Map<String, dynamic> toJson() => _$CARPDatumToJson(this);

  CARPDataFormat getCARPDataFormat() => CARP_DATA_FORMAT;
}

/// Holds basic information about the mobile device from where the data is collected.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class DeviceInfo {
  ///The platform type from which this Datum was collected.
  /// * `Android`
  /// * `IOS`
  String platform;

  /// An identifier that is unique to the particular device which this [Datum] was collected.
  /// Note that this ID will change if the user performs a factory reset on their device.
  String deviceId;

  /// The hardware type from which this [Datum] was collected (e.g. 'iPhone7,1' for iPhone 6 Plus).
  String hardware;

  /// Device name as specified by the OS.
  String deviceName;

  /// Device manufacturer as specified by the OS.
  String deviceManufacturer;

  /// Device model as specified by the OS.
  String deviceModel;

  /// Device OS as specified by the OS.
  String operatingSystem;

  DeviceInfo(this.platform, this.deviceId,
      {this.deviceName, this.deviceModel, this.deviceManufacturer, this.operatingSystem, this.hardware});

  factory DeviceInfo.fromJson(Map<String, dynamic> json) => _$DeviceInfoFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceInfoToJson(this);
}

/// A very simple [Datum] that only holds a string datum object.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class StringDatum extends CARPDatum {
  static CARPDataFormat CARP_DATA_FORMAT = new CARPDataFormat(NameSpace.CARP_NAMESPACE, Measure.STRING_MEASURE);

  String data;

  StringDatum({this.data}) : super();

  factory StringDatum.fromJson(Map<String, dynamic> json) => _$StringDatumFromJson(json);

  Map<String, dynamic> toJson() => _$StringDatumToJson(this);
}

/// A [Datum] object holding a Error, i.e. that the probe / sensor returned some
/// sort of error, which is reported back.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class ErrorDatum extends CARPDatum {
  static CARPDataFormat CARP_DATA_FORMAT = new CARPDataFormat(NameSpace.CARP_NAMESPACE, Measure.ERROR_MEASURE);

  /// The original error message returned from the probe, if available.
  String errorMessage;

  ErrorDatum(this.errorMessage) : super();

  factory ErrorDatum.fromJson(Map<String, dynamic> json) => _$ErrorDatumFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorDatumToJson(this);
}

/// A [Datum] object holding multiple [Datum]s of the same type.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class MultiDatum extends CARPDatum {
  List<Datum> datums = new List<Datum>();

  void addDatum(Datum datum) {
    datums.add(datum);
  }

  MultiDatum() : super();

  factory MultiDatum.fromJson(Map<String, dynamic> json) => _$MultiDatumFromJson(json);
  Map<String, dynamic> toJson() => _$MultiDatumToJson(this);

  @override
  CARPDataFormat getCARPDataFormat() => (datums.length == 0) ? CARPDataFormat.unknown() : datums[0].getCARPDataFormat();

  String toString() => "MultiDatum: {format: ${getCARPDataFormat().toString()}, size: ${datums.length}}";
}
