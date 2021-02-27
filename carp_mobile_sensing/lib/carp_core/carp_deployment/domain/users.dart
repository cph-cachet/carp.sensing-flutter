/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_core_domain;

/// Uniquely identifies the participation of an account in a study deployment.
class Participation {
  String studyDeploymentId;
  String id;
}

/// A description of a study, shared with participants once they are invited
/// to a study.
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
  String applicationData;
}

/// An [invitation] to participate in an active study deployment using the
/// [assignedDevices].
/// Some of the devices which the participant is invited to might already be
/// registered. If the participant wants to use a different device, they will
/// need to unregister the existing device first.
class ActiveParticipationInvitation {
  Participation participation;
  StudyInvitation invitation;
  Set<AssignedMasterDevice> assignedDevices;
}

/// Master [device] and its current [registration] assigned to participants as
/// part of a [ParticipantGroup].
class AssignedMasterDevice {
  MasterDeviceDescriptor device;
  DeviceRegistration registration;
}

/// Set [data] for all expected participant data in the study deployment
/// with [studyDeploymentId].
/// Data which is not set equals null.
class ParticipantData {
  String studyDeploymentId;
  Map<DataType, Data> data;
}
