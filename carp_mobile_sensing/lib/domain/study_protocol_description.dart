/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of domain;

@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class StudyProtocolDescription extends Serializable {
  /// A longer printer-friendly title for this study.
  String? title;

  /// The description of this study.
  String? description;

  /// The purpose of the study. To be used to inform the user about
  /// this study and its purpose.
  String? purpose;

  /// The primary investigator (PI) responsible of this study.
  StudyProtocolReponsible? responsible;

  StudyProtocolDescription({this.title, this.description, this.purpose});

  Function get fromJsonFunction => _$StudyProtocolDescriptionFromJson;
  factory StudyProtocolDescription.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as StudyProtocolDescription;
  Map<String, dynamic> toJson() => _$StudyProtocolDescriptionToJson(this);

  String toString() =>
      '$runtimeType -  title: $title, description: $description. purpose: $purpose';
}

/// A person who is responsible for a [StudyProtocol].
/// Typically the Principal Investigator (PI) who is reposnibile for the study.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class StudyProtocolReponsible extends Serializable {
  String? id;
  String? name;
  String? title;
  String? email;
  String? address;
  String? affiliation;

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
      FromJsonFactory().fromJson(json) as StudyProtocolReponsible;
  Map<String, dynamic> toJson() => _$StudyProtocolReponsibleToJson(this);

  String toString() => '$runtimeType - $name, $title <$email>';
}
