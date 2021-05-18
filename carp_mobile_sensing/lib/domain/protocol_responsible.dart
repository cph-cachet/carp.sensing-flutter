/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of domain;

/// A person who is responsible for a [CAMSStudyProtocol].
/// Typically the Principal Investigator (PI) who is reposnibile for the study.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class StudyProtocolReponsible extends Serializable {
  String id;
  String name;
  String title;
  String email;
  String address;
  String affiliation;

  StudyProtocolReponsible({
    this.id,
    this.name,
    this.title,
    this.email,
    this.affiliation,
    this.address,
  });

  Function get fromJsonFunction => _$StudyProtocolReponsibleFromJson;
  factory StudyProtocolReponsible.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json);
  Map<String, dynamic> toJson() => _$StudyProtocolReponsibleToJson(this);

  String toString() => '$runtimeType - $name, $title <$email>';
}
