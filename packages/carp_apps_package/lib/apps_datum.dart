/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of carp_apps_package;

/// Holds a list of names of apps installed on the device.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class AppsDatum extends CARPDatum {
  static const DataFormat CARP_DATA_FORMAT = DataFormat(NameSpace.CARP, AppsSamplingPackage.APPS);
  DataFormat get format => CARP_DATA_FORMAT;

  /// List of names on installed apps.
  List<String> installedApps;

  AppsDatum() : super();

  factory AppsDatum.fromJson(Map<String, dynamic> json) => _$AppsDatumFromJson(json);
  Map<String, dynamic> toJson() => _$AppsDatumToJson(this);
  String toString() => super.toString() + ', installedApps: $installedApps';
}

/// Holds a map of names of apps and their corresponding usage in seconds.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class AppUsageDatum extends CARPDatum {
  static const DataFormat CARP_DATA_FORMAT = DataFormat(NameSpace.CARP, AppsSamplingPackage.APP_USAGE);
  DataFormat get format => CARP_DATA_FORMAT;

  DateTime start, end;

  /// A map of names of apps and their usage in seconds.
  Map<String, int> usage;

  AppUsageDatum() : super();

  factory AppUsageDatum.fromJson(Map<String, dynamic> json) => _$AppUsageDatumFromJson(json);
  Map<String, dynamic> toJson() => _$AppUsageDatumToJson(this);
  String toString() => super.toString() + ', start: $start, end: $end, usage: $usage';
}
