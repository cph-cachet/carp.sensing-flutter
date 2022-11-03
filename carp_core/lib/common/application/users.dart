/*
 * Copyright 2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_core_common;

/// Describes a participant playing a [role] in a study, and whether this
/// role [isOptional].
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class ParticipantRole {
  String role;
  bool isOptional;
  ParticipantRole(this.role, this.isOptional);

  factory ParticipantRole.fromJson(Map<String, dynamic> json) =>
      _$ParticipantRoleFromJson(json);
  Map<String, dynamic> toJson() => _$ParticipantRoleToJson(this);
}

/// Describes a participant [attribute] that pertains to all or specified
/// participants in a study.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class ExpectedParticipantData {
  ParticipantAttribute? attribute;

  /// Determines whether the attribute can be set by all participants in the study
  /// (one field for all), or an individual attribute can be set by each of
  /// the specified [AssignedTo.Roles] (one field per role).
  AssignedTo assignedTo = AssignedTo();

  ExpectedParticipantData(this.attribute, this.assignedTo);

  factory ExpectedParticipantData.fromJson(Map<String, dynamic> json) =>
      _$ExpectedParticipantDataFromJson(json);
  Map<String, dynamic> toJson() => _$ExpectedParticipantDataToJson(this);
}

/// Describes expected data to be input by users related to one or multiple
/// participants in a study.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class ParticipantAttribute {
  /// Uniquely identifies the type of data represented by this participant
  /// attribute.
  DataType? inputDataType;

  ParticipantAttribute(this.inputDataType);

  factory ParticipantAttribute.fromJson(Map<String, dynamic> json) =>
      _$ParticipantAttributeFromJson(json);
  Map<String, dynamic> toJson() => _$ParticipantAttributeToJson(this);
}

/// Determines which participant roles to assign to something.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class AssignedTo {
  /// Assign this to the specified [roleNames] in the study protocol.
  /// If empty,  assign this to all participants in the study protocol.
  Set<String> roleNames = {};

  AssignedTo();

  factory AssignedTo.fromJson(Map<String, dynamic> json) =>
      _$AssignedToFromJson(json);
  Map<String, dynamic> toJson() => _$AssignedToToJson(this);
}
