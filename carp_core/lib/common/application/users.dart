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
  ParticipantRole(this.role, [this.isOptional = false]);

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
  late AssignedTo assignedTo;

  ExpectedParticipantData({required this.attribute, AssignedTo? assignedTo}) {
    this.assignedTo = assignedTo ?? AssignedTo(roleNames: {'Participant'});
  }

  factory ExpectedParticipantData.fromJson(Map<String, dynamic> json) =>
      _$ExpectedParticipantDataFromJson(json);
  Map<String, dynamic> toJson() => _$ExpectedParticipantDataToJson(this);
}

/// Describes expected data to be input by users related to one or multiple
/// participants in a study.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class ParticipantAttribute extends Serializable {
  /// Uniquely identifies the type of data represented by this participant
  /// attribute.
  String inputDataType;

  ParticipantAttribute({required this.inputDataType}) : super();

  @override
  Function get fromJsonFunction => _$ParticipantAttributeFromJson;
  factory ParticipantAttribute.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as ParticipantAttribute;
  @override
  Map<String, dynamic> toJson() => _$ParticipantAttributeToJson(this);
  @override
  String get jsonType =>
      'dk.cachet.carp.common.application.users.ParticipantAttribute.DefaultParticipantAttribute';
}

/// Determines which participant roles to assign to something.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class AssignedTo extends Serializable {
  /// Assign this to the specified [roleNames] in the study protocol.
  /// If empty, assign this to all participants in the study protocol.
  Set<String> roleNames = {};

  AssignedTo({this.roleNames = const {}}) : super();

  /// Assign to all participants in the study protocol.
  AssignedTo.all() : this();

  @override
  Function get fromJsonFunction => _$AssignedToFromJson;
  factory AssignedTo.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as AssignedTo;
  @override
  Map<String, dynamic> toJson() => _$AssignedToToJson(this);

  @override
  String get jsonType =>
      'dk.cachet.carp.common.application.users.AssignedTo.Roles';
}
