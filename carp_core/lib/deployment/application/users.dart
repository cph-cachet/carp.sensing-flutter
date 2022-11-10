/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_core_deployment;

/// Uniquely identifies the participation of an account in a study deployment.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class Participation {
  /// The CARP study deployment ID.
  String studyDeploymentId;

  /// Unique id for this participation.
  String participantId;

  AssignedTo assignedRoles;

  Participation(this.studyDeploymentId, this.participantId, this.assignedRoles)
      : super();

  factory Participation.fromJson(Map<String, dynamic> json) =>
      _$ParticipationFromJson(json);
  Map<String, dynamic> toJson() => _$ParticipationToJson(this);

  @override
  String toString() =>
      '${super.toString()}, id: $participantId, studyDeploymentId: $studyDeploymentId';
}

/// A description of a study, shared with participants once they are invited to a study.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class StudyInvitation {
  /// A descriptive name for the study to be shown to participants.
  String name;

  /// A description of the study clarifying to participants what it is about.
  String description;

  /// Application-specific data to be shared with clients when they are invited
  /// to a study.
  ///
  /// This can be used by infrastructures or concrete applications which require
  /// exchanging additional data between the study and client subsystems,
  /// outside of scope or not yet supported by CARP core.
  String? applicationData;

  StudyInvitation(this.name, this.description) : super();

  factory StudyInvitation.fromJson(Map<String, dynamic> json) =>
      _$StudyInvitationFromJson(json);
  Map<String, dynamic> toJson() => _$StudyInvitationToJson(this);

  @override
  String toString() =>
      '$runtimeType - name: $name, description: $description, applicationData: $applicationData';
}

/// An [invitation] to participate in an active study deployment using the
/// [assignedDevices].
/// Some of the devices which the participant is invited to might already be
/// registered. If the participant wants to use a different device, they will
/// need to unregister the existing device first.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class ActiveParticipationInvitation {
  Participation participation;
  StudyInvitation invitation;
  List<AssignedPrimaryDevice>? assignedDevices;

  /// The CARP study ID.
  String? get studyId => invitation.applicationData;

  /// The CARP study deployment ID.
  String? get studyDeploymentId => participation.studyDeploymentId;

  ActiveParticipationInvitation(this.participation, this.invitation) : super();

  factory ActiveParticipationInvitation.fromJson(Map<String, dynamic> json) =>
      _$ActiveParticipationInvitationFromJson(json);
  Map<String, dynamic> toJson() => _$ActiveParticipationInvitationToJson(this);

  @override
  String toString() =>
      '$runtimeType - participation: $participation, invitation: $invitation, devices size: ${assignedDevices!.length}';
}

/// Provides information on the status of a participant in a study deployment.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class ParticipantStatus {
  String participantId;
  AssignedTo assignedParticipantRoles;
  Set<String> assignedPrimaryDeviceRoleNames;

  ParticipantStatus(this.participantId, this.assignedParticipantRoles,
      this.assignedPrimaryDeviceRoleNames)
      : super();
  factory ParticipantStatus.fromJson(Map<String, dynamic> json) =>
      _$ParticipantStatusFromJson(json);
  Map<String, dynamic> toJson() => _$ParticipantStatusToJson(this);
}
