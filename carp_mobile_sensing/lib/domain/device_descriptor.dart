/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of domain;

/// An online service which works as a "software device" in a protocol.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class OnlineService extends DeviceConfiguration {
  OnlineService({
    required super.roleName,
    super.isOptional,
    super.supportedDataTypes,
  });
  @override
  Function get fromJsonFunction => _$OnlineServiceFromJson;

  factory OnlineService.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as OnlineService;

  @override
  Map<String, dynamic> toJson() => _$OnlineServiceToJson(this);
}
