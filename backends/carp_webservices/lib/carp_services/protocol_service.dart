/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_services;

/// A [ProtocolService] that talks to the CARP Nervous System (CANS), i.e.,
/// the CARP backend server(s).
class CANSProtocolService extends CarpBaseService
    implements ProtocolService, ProtocolFactoryService {
  static CANSProtocolService _instance = CANSProtocolService._();

  CANSProtocolService._();

  /// Returns the singleton default instance of the [CANSProtocolService].
  /// Before this instance can be used, it must be configured using the [configure] method.
  factory CANSProtocolService() => _instance;

  @override
  String get rpcEndpointName => "protocol-service";

  @override
  Future add(StudyProtocol? protocol, [String? versionTag]) async =>
      StudyProtocol.fromJson(await (_rpc(Add(protocol, versionTag)) as FutureOr<Map<String, dynamic>>));

  @override
  Future addVersion(StudyProtocol? protocol, [String? versionTag]) async =>
      StudyProtocol.fromJson(await (_rpc(AddVersion(protocol, versionTag)) as FutureOr<Map<String, dynamic>>));

  /// Find all [StudyProtocol]'s owned by the owner with [ownerId].
  /// In the CARP web service, the [ownerId] is the logged in user's [accountId].
  ///
  /// Returns the last version of each [StudyProtocol] owned by the requested owner,
  /// or an empty list when none are found.
  @override
  Future<List<StudyProtocol>> getAllFor(String? ownerId) async {
    Map<String, dynamic> response = await (_rpc(GetAllFor(ownerId)) as FutureOr<Map<String, dynamic>>);
    List<dynamic> items = response['items'];
    return items.map((item) => StudyProtocol.fromJson(item)).toList();
  }

  @override
  Future<StudyProtocol> getBy(StudyProtocolId protocolId,
          [String? versionTag]) async =>
      StudyProtocol.fromJson(await (_rpc(GetBy(protocolId, versionTag)) as FutureOr<Map<String, dynamic>>));

  @override
  Future<List<ProtocolVersion>> getVersionHistoryFor(
      StudyProtocolId protocolId) async {
    Map<String, dynamic> responseJson =
        await (_rpc(GetVersionHistoryFor(protocolId)) as FutureOr<Map<String, dynamic>>);
    List<dynamic> items = responseJson['items'];
    return items.map((item) => ProtocolVersion.fromJson(item)).toList();
  }

  @override
  Future<StudyProtocol> updateParticipantDataConfiguration(
          StudyProtocolId protocolId,
          String versionTag,
          List<ParticipantAttribute> expectedParticipantData) async =>
      StudyProtocol.fromJson(await (_rpc(UpdateParticipantDataConfiguration(
        protocolId,
        versionTag,
        expectedParticipantData,
      )) as FutureOr<Map<String, dynamic>>));

  @override
  Future<StudyProtocol> createCustomProtocol(String? ownerId, String? name,
          String description, String customProtocol) async =>
      StudyProtocol.fromJson(await (_rpc(
          CreateCustomProtocol(ownerId, name, description, customProtocol),
          'protocol-factory-service') as FutureOr<Map<String, dynamic>>));
}
