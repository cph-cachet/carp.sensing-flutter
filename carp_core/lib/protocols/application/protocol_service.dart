/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of carp_core_protocols;

/// Application service which allows managing (multiple versions of)
/// [StudyProtocol]s.
abstract class ProtocolService {
  /// Add the specified study [protocol].
  ///
  /// [versionTag] is an optional label used to identify this first version of
  /// the [protocol]. Timestamp of initial creation by default.
  Future<void> add(StudyProtocol protocol, [String? versionTag]);

  /// Add a new version for the specified study [protocol], of which a previous
  /// version with the same owner and name is already stored.
  ///
  /// [versionTag] is an optional unique label used to identify this specific
  /// version of the [protocol]. The current date/time by default.
  Future<void> addVersion(StudyProtocol protocol, [String? versionTag]);

  /// Replace the expected participant data for the study protocol with the
  /// specified [protocolId] and [versionTag] with [expectedParticipantData].
  ///
  /// Returns the updated [StudyProtocol].
  Future<StudyProtocol> updateParticipantDataConfiguration(
    StudyProtocolId protocolId,
    String versionTag,
    List<ParticipantAttribute> expectedParticipantData,
  );

  /// Return the [StudyProtocol] with the specified [protocolId],
  ///
  /// [versionTag] is the tag of the specific version of the protocol to return.
  /// The latest version is returned when not specified.
  Future<StudyProtocol> getBy(StudyProtocolId protocolId, [String? versionTag]);

  /// Find all [StudyProtocol]'s owned by the owner with [ownerId].
  ///
  /// Returns the last version of each [StudyProtocol] owned by the requested owner,
  /// or an empty list when none are found.
  Future<List<StudyProtocol>> getAllFor(String ownerId);

  /// Returns all stored versions for the protocol with the specified [protocolId].
  Future<List<ProtocolVersion>> getVersionHistoryFor(
      StudyProtocolId protocolId);
}

/// Factory methods to create a [StudyProtocol] according to predefined templates.
abstract class ProtocolFactoryService {
  /// Create a study protocol to be deployed to a single device which has its
  /// own way of describing study protocols that deviates from the CARP core
  /// study protocol model.
  ///
  /// The [customProtocol] is stored in a single [CustomProtocolTask] which in
  /// the CARP study protocol model is described as being triggered at the start
  /// of the study for a [CustomProtocolDevice] with role name "Custom device".
  Future<StudyProtocol> createCustomProtocol(
    String ownerId,
    String name,
    String description,
    String customProtocol,
  );
}
