/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_core_protocols;

@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class DeviceConnection extends Serializable {
  String roleName;
  String connectedToRoleName;

  DeviceConnection([this.roleName, this.connectedToRoleName]) : super();
  Function get fromJsonFunction => _$DeviceConnectionFromJson;
  factory DeviceConnection.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json);
  Map<String, dynamic> toJson() => _$DeviceConnectionToJson(this);
  String get jsonType =>
      'dk.cachet.carp.protocols.application.StudyProtocolSnapshot.$runtimeType';
}
