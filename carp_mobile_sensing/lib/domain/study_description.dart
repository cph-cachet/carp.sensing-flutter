/*
 * Copyright 2018-2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of 'domain.dart';

@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class StudyDescription extends Serializable {
  /// A longer printer-friendly title for this study.
  String title;

  /// The description of this study.
  String description;

  /// The purpose of the study. To be used to inform the user about
  /// this study and its purpose.
  String purpose;

  /// The URL pointing to a web page description of this study.
  String? studyDescriptionUrl;

  /// The URL pointing to a web page with the privacy policy of this study.
  String? privacyPolicyUrl;

  /// The primary investigator (PI) responsible of this study.
  StudyResponsible? responsible;

  StudyDescription({
    required this.title,
    required this.description,
    required this.purpose,
    this.studyDescriptionUrl,
    this.privacyPolicyUrl,
    this.responsible,
  });

  @override
  Function get fromJsonFunction => _$StudyDescriptionFromJson;
  factory StudyDescription.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as StudyDescription;
  @override
  Map<String, dynamic> toJson() => _$StudyDescriptionToJson(this);

  @override
  String toString() =>
      '$runtimeType -  title: $title, description: $description. purpose: $purpose';
}

/// A person who is responsible for a [StudyProtocol].
/// Typically the Principal Investigator (PI) who is responsible for the study.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class StudyResponsible extends Serializable {
  String id;
  String name;
  String title;
  String email;
  String address;
  String affiliation;

  StudyResponsible({
    required this.id,
    required this.name,
    required this.title,
    required this.email,
    required this.affiliation,
    required this.address,
  });

  @override
  Function get fromJsonFunction => _$StudyResponsibleFromJson;
  factory StudyResponsible.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as StudyResponsible;
  @override
  Map<String, dynamic> toJson() => _$StudyResponsibleToJson(this);

  @override
  String toString() => '$runtimeType - $name, $title <$email>';
}
