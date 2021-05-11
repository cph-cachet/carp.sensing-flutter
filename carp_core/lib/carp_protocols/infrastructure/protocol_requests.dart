/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of carp_core_protocols;

/// Serializable application service requests to [ProtocolService].
abstract class ProtocolServiceRequest extends ServiceRequest {
  final String _infrastructurePackageNamespace =
      'dk.cachet.carp.protocols.infrastructure';
  ProtocolServiceRequest() : super();
  String get jsonType =>
      '$_infrastructurePackageNamespace.ProtocolServiceRequest.$runtimeType';
}

@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: true)
class Add extends ProtocolServiceRequest {
  final StudyProtocol protocol;
  String versionTag;

  /// Create a new add request.
  /// If [versionTag] is `null` the version tag is current timestamp.
  Add(this.protocol, this.versionTag) : super() {
    versionTag ??= DateTime.now().toUtc().toString();
  }

  Function get fromJsonFunction => _$AddFromJson;
  factory Add.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json);
  Map<String, dynamic> toJson() => _$AddToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: true)
class AddVersion extends Add {
  AddVersion(StudyProtocol protocol, String versionTag)
      : super(protocol, versionTag);

  Function get fromJsonFunction => _$AddVersionFromJson;
  factory AddVersion.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json);
  Map<String, dynamic> toJson() => _$AddVersionToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: true)
class UpdateParticipantDataConfiguration extends ProtocolServiceRequest {
  final StudyProtocolId protocolId;
  final String versionTag;
  final List<ParticipantAttribute> expectedParticipantData;

  UpdateParticipantDataConfiguration(
      this.protocolId, this.versionTag, this.expectedParticipantData)
      : super();

  Function get fromJsonFunction => _$UpdateParticipantDataConfigurationFromJson;
  factory UpdateParticipantDataConfiguration.fromJson(
          Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json);
  Map<String, dynamic> toJson() =>
      _$UpdateParticipantDataConfigurationToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: true)
class GetBy extends ProtocolServiceRequest {
  final StudyProtocolId protocolId;

  @JsonKey(includeIfNull: false)
  final String versionTag;

  GetBy(this.protocolId, this.versionTag) : super();

  Function get fromJsonFunction => _$GetByFromJson;
  factory GetBy.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json);
  Map<String, dynamic> toJson() => _$GetByToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: true)
class GetAllFor extends ProtocolServiceRequest {
  final String ownerId;

  GetAllFor(this.ownerId) : super();

  Function get fromJsonFunction => _$GetAllForFromJson;
  factory GetAllFor.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json);
  Map<String, dynamic> toJson() => _$GetAllForToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: true)
class GetVersionHistoryFor extends ProtocolServiceRequest {
  final StudyProtocolId protocolId;

  GetVersionHistoryFor(this.protocolId) : super();

  Function get fromJsonFunction => _$GetVersionHistoryForFromJson;
  factory GetVersionHistoryFor.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json);
  Map<String, dynamic> toJson() => _$GetVersionHistoryForToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: true)
class CreateCustomProtocol extends ProtocolServiceRequest {
  final String ownerId;
  final String name;
  final String description;
  final String customProtocol;

  CreateCustomProtocol(
      this.ownerId, this.name, this.description, this.customProtocol)
      : super();

  String get jsonType =>
      '$_infrastructurePackageNamespace.ProtocolFactoryServiceRequest.$runtimeType';

  Function get fromJsonFunction => _$CreateCustomProtocolFromJson;
  factory CreateCustomProtocol.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json);
  Map<String, dynamic> toJson() => _$CreateCustomProtocolToJson(this);
}
