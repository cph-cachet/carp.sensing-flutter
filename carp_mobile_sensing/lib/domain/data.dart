/*
 * Copyright 2018-2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of domain;

/// A [Data] object holding a link to a file.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class FileData extends Data {
  static const dataType = CAMSDataType.FILE_TYPE_NAME;

  /// The local path to the attached file on the phone where it is sampled.
  /// This is used by e.g. a data manager to get and manage the file on
  /// the phone.
  @JsonKey(includeFromJson: false, includeToJson: false)
  String? path;

  /// The name to the attached file.
  String filename;

  /// Should the file also be uploaded, or only this meta data?
  /// Default is true.
  bool upload = true;

  /// Metadata for this file as a map of string key-value pairs.
  Map<String, String>? metadata = <String, String>{};

  /// Create a new [FileData] based the file path and whether it is
  /// to be uploaded or not.
  FileData({required this.filename, this.upload = true}) : super();

  @override
  Function get fromJsonFunction => _$FileDataFromJson;
  factory FileData.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as FileData;
  @override
  Map<String, dynamic> toJson() => _$FileDataToJson(this);

  @override
  String toString() =>
      '${super.toString()}, filename: $filename, upload: $upload';
}

/// Reflects a heart beat data send every [frequency].
/// Useful for calculating sampling coverage over time.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class Coverage extends Data {
  static const dataType = '${CarpDataTypes.CARP_NAMESPACE}.coverage';

  /// The expected coverage frequency
  int frequency;

  Coverage({required this.frequency}) : super();

  @override
  Function get fromJsonFunction => _$CoverageFromJson;
  factory Coverage.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as Coverage;
  @override
  Map<String, dynamic> toJson() => _$CoverageToJson(this);
}
