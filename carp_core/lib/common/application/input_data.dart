/*
 * Copyright 2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_core_common;

/// Custom input data as requested by a researcher.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class CustomInput extends Data {
  static const INPUT_TYPE_NAME = '${NameSpace.CARP}.input';
  static const type = '${CustomInput.INPUT_TYPE_NAME}.custom';

  /// A default value
  dynamic value;

  CustomInput(this.value) : super();

  @override
  Function get fromJsonFunction => _$CustomInputFromJson;
  factory CustomInput.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as CustomInput;
  @override
  Map<String, dynamic> toJson() => _$CustomInputToJson(this);
  @override
  String get jsonType => type;
}

/// Biological sex of a person.
enum Sex { Male, Female, Intersex }

/// The biological sex assigned at birth of a participant.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class SexInput extends Data {
  static const type = '${CustomInput.INPUT_TYPE_NAME}.sex';

  Sex value;
  SexInput(this.value) : super();

  @override
  Function get fromJsonFunction => _$SexInputFromJson;
  factory SexInput.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as SexInput;
  @override
  Map<String, dynamic> toJson() => _$SexInputToJson(this);
  @override
  String get jsonType => type;
}

/// The social security number of a participant.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class SocialSecurityNumberInput extends Data {
  static const type = '${CustomInput.INPUT_TYPE_NAME}.ssn';

  /// The social security number
  String socialSecurityNumber;

  SocialSecurityNumberInput(this.socialSecurityNumber) : super();

  @override
  Function get fromJsonFunction => _$SocialSecurityNumberInputFromJson;
  factory SocialSecurityNumberInput.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as SocialSecurityNumberInput;
  @override
  Map<String, dynamic> toJson() => _$SocialSecurityNumberInputToJson(this);
  @override
  String get jsonType => type;
}

/// The full name of a participant.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class NameInput extends Data {
  static const type = '${CustomInput.INPUT_TYPE_NAME}.name';

  String firstName, middleName, lastName;
  NameInput(this.firstName, this.middleName, this.lastName) : super();

  @override
  Function get fromJsonFunction => _$NameInputFromJson;
  factory NameInput.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as NameInput;
  @override
  Map<String, dynamic> toJson() => _$NameInputToJson(this);
  @override
  String get jsonType => type;
}

/// The informed consent from a participant.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class InformedConsentInput extends Data {
  static const type = '${CustomInput.INPUT_TYPE_NAME}.consent';

  /// The time this informed consent was signed.
  DateTime signedTimestamp;

  /// The full name of the participant signing this consent.
  String name;

  /// The content of the signed consent.
  ///
  /// This may be plain text or JSON.
  String? consent;

  /// The image of the provided signature in png format as bytes
  String? signatureImage;

  InformedConsentInput(
      this.name, this.consent, this.signedTimestamp, this.signatureImage)
      : super();

  @override
  Function get fromJsonFunction => _$InformedConsentInputFromJson;
  factory InformedConsentInput.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as InformedConsentInput;
  @override
  Map<String, dynamic> toJson() => _$InformedConsentInputToJson(this);
  @override
  String get jsonType => type;
}

/// The full address of a participant.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class AddressInput extends Data {
  static const type = '${CustomInput.INPUT_TYPE_NAME}.address';

  String? address1, address2, street, country, zip;
  AddressInput(
      this.address1, this.address2, this.street, this.country, this.zip)
      : super();

  @override
  Function get fromJsonFunction => _$AddressInputFromJson;
  factory AddressInput.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as AddressInput;
  @override
  Map<String, dynamic> toJson() => _$AddressInputToJson(this);
  @override
  String get jsonType => type;
}

/// The diagnosis of a patient.
///
/// We are using the WHO [ICD-11](https://www.who.int/standards/classifications/classification-of-diseases)
/// classification.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class DiagnosisInput extends Data {
  static const type = '${CustomInput.INPUT_TYPE_NAME}.diagnosis';

  /// The date this diagnosis was effective.
  DateTime? effectiveDate;

  /// A free text description of the diagnosis.
  String? diagnosis;

  /// The [ICD-11](https://www.who.int/standards/classifications/classification-of-diseases)
  /// code of this diagnosis.
  String icd11Code;

  /// Any conclusion or notes from the physician.
  String? conclusion;

  DiagnosisInput(
      this.effectiveDate, this.diagnosis, this.icd11Code, this.conclusion)
      : super();

  @override
  Function get fromJsonFunction => _$DiagnosisInputFromJson;
  factory DiagnosisInput.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as DiagnosisInput;
  @override
  Map<String, dynamic> toJson() => _$DiagnosisInputToJson(this);
  @override
  String get jsonType => type;
}
