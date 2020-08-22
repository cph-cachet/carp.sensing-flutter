/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of apps;

/// Holds a list of names of apps installed on the device.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class AppsDatum extends CARPDatum {
  static const DataFormat CARP_DATA_FORMAT =
      DataFormat(NameSpace.CARP, AppsSamplingPackage.APPS);

  DataFormat get format => CARP_DATA_FORMAT;

  /// List of names on installed apps.
  List<String> installedApps;

  AppsDatum() : super();

  factory AppsDatum.fromJson(Map<String, dynamic> json) =>
      _$AppsDatumFromJson(json);

  Map<String, dynamic> toJson() => _$AppsDatumToJson(this);

  String toString() {
    String s = super.toString() + ' [';
    installedApps.forEach((appName) => s += '$appName,');
    s += ']';
    return s;
  }
}

/// Holds a Map of names of apps and their corresponding usage in seconds.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class AppUsageDatum extends CARPDatum {
  static const DataFormat CARP_DATA_FORMAT =
      DataFormat(NameSpace.CARP, AppsSamplingPackage.APP_USAGE);

  DataFormat get format => CARP_DATA_FORMAT;

  DateTime start, end;

  Map<String, dynamic> usage;

  AppUsageDatum() : super();

  factory AppUsageDatum.fromJson(Map<String, dynamic> json) =>
      _$AppUsageDatumFromJson(json);

  Map<String, double> toJson() => _$AppUsageDatumToJson(this);

  String toString() =>
      super.toString() +
      ', $start, end: $end, usage: $usage';
}
