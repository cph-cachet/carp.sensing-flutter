/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of carp_core_protocols;

/// Uniquely identifies a study protocol by the [ownerId] and it's [name].
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: true)
class StudyProtocolId {
  String ownerId;
  String name;
  StudyProtocolId(this.ownerId, this.name);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudyProtocolId &&
          runtimeType == other.runtimeType &&
          ownerId == other.ownerId &&
          name == other.name;

  @override
  int get hashCode => (ownerId + name).hashCode;

  factory StudyProtocolId.fromJson(Map<String, dynamic> json) =>
      _$StudyProtocolIdFromJson(json);
  Map<String, dynamic> toJson() => _$StudyProtocolIdToJson(this);

  String toString() => '$runtimeType - ownerId: $ownerId, name: $name';
}

/// Describes expected data related to one or multiple participants in a study.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: true)
class ParticipantAttribute {
  /// Uniquely identifies the type of data represented by this participant attribute.
  String inputType;

  ParticipantAttribute(this.inputType);

  factory ParticipantAttribute.fromJson(Map<String, dynamic> json) =>
      _$ParticipantAttributeFromJson(json);
  Map<String, dynamic> toJson() => _$ParticipantAttributeToJson(this);
}

/// Specifies a specific version for a [StudyProtocol], identified by a [tag].
///
/// [date] is the date when this version of the protocol was created.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: true)
class ProtocolVersion {
  String tag;
  late DateTime date;

  ProtocolVersion(this.tag) {
    date = DateTime.now();
  }

  factory ProtocolVersion.fromJson(Map<String, dynamic> json) =>
      _$ProtocolVersionFromJson(json);
  Map<String, dynamic> toJson() => _$ProtocolVersionToJson(this);

  String toString() => '$runtimeType - tag: $tag, date: $date';
}
