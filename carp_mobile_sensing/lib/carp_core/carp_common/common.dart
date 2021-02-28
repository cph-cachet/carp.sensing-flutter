/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_core;

/// Time as specified in carp.core as a value in 'microseconds'.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class CarpTime {
  CarpTime() : super();

  int microseconds;

  factory CarpTime.fromJson(Map<String, dynamic> json) =>
      _$CarpTimeFromJson(json);
  Map<String, dynamic> toJson() => _$CarpTimeToJson(this);

  String toString() => '$runtimeType - microseconds: $microseconds';
}
