/*
 * Copyright 2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of '../carp_core_common.dart';

/// Custom input data as requested by a researcher.
abstract class InputType {
  static const INPUT_TYPE_NAMESPACE = '${NameSpace.CARP}.input';
}

/// Custom input data as requested by a researcher.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class CustomInput extends Data {
  static const type = '${InputType.INPUT_TYPE_NAMESPACE}.custom';

  /// Any value
  dynamic value;

  CustomInput({this.value}) : super();

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
  static const type = '${InputType.INPUT_TYPE_NAMESPACE}.sex';

  /// Biological sex of a participant.
  Sex value;

  SexInput({required this.value}) : super();

  @override
  Function get fromJsonFunction => _$SexInputFromJson;
  factory SexInput.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as SexInput;
  @override
  Map<String, dynamic> toJson() => _$SexInputToJson(this);
  @override
  String get jsonType => type;
}

/// The social security number (SSN) of a participant.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class PhoneNumberInput extends Data {
  static const type = '${InputType.INPUT_TYPE_NAMESPACE}.phonenumber';

  /// The country code of this phone number.
  ///
  /// The country code is represented by a string, since some country codes
  /// contain a '-'. For example, "1-246" for Barbados or "44-1481" for Guernsey.
  ///
  /// See https://countrycode.org/ or https://en.wikipedia.org/wiki/List_of_country_calling_codes
  String countryCode;

  /// The ICO 3166 code of the [countryCode], if available.
  ///
  /// See https://en.wikipedia.org/wiki/List_of_ISO_3166_country_codes
  String? icoCode;

  /// The phone number.
  ///
  /// The phone number is represented as a string since it may be pretty-printed
  /// with spaces.
  String number;

  PhoneNumberInput({
    required this.countryCode,
    required this.number,
  }) : super();

  @override
  Function get fromJsonFunction => _$PhoneNumberInputFromJson;
  factory PhoneNumberInput.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as PhoneNumberInput;
  @override
  Map<String, dynamic> toJson() => _$PhoneNumberInputToJson(this);
  @override
  String get jsonType => type;
}

/// The social security number (SSN) of a participant.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class SocialSecurityNumberInput extends Data {
  static const type = '${InputType.INPUT_TYPE_NAMESPACE}.ssn';

  /// The social security number (SSN)
  String socialSecurityNumber;

  /// The country in which this [socialSecurityNumber] originates from.
  String country;

  SocialSecurityNumberInput({
    required this.socialSecurityNumber,
    required this.country,
  }) : super();

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
  static const type = '${InputType.INPUT_TYPE_NAMESPACE}.name';

  String? firstName, middleName, lastName;

  NameInput({
    this.firstName,
    this.middleName,
    this.lastName,
  }) : super();

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
  static const type = '${InputType.INPUT_TYPE_NAMESPACE}.consent';

  /// The time this informed consent was signed.
  DateTime signedTimestamp;

  /// The location where this informed consent was signed.
  String? signedLocation;

  /// The ID of the participant who signed this consent.
  String? userID;

  /// The full name of the participant who signed this consent.
  String name;

  /// The content of the signed consent.
  ///
  /// This may be plain text or JSON.
  String? consent;

  /// The image of the provided signature in png format as bytes.
  String? signatureImage;

  InformedConsentInput({
    required this.signedTimestamp,
    this.signedLocation,
    this.userID,
    required this.name,
    this.consent,
    this.signatureImage,
  }) : super();

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
  static const type = '${InputType.INPUT_TYPE_NAMESPACE}.address';

  String? address1, address2, street, country, zip;
  AddressInput({
    this.address1,
    this.address2,
    this.street,
    this.country,
    this.zip,
  }) : super();

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
  static const type = '${InputType.INPUT_TYPE_NAMESPACE}.diagnosis';

  /// The date this diagnosis was effective.
  DateTime? effectiveDate;

  /// A free text description of the diagnosis.
  String? diagnosis;

  /// The [ICD-11](https://www.who.int/standards/classifications/classification-of-diseases)
  /// code of this diagnosis.
  String icd11Code;

  /// Any conclusion or notes from the physician.
  String? conclusion;

  DiagnosisInput({
    this.effectiveDate,
    this.diagnosis,
    required this.icd11Code,
    this.conclusion,
  }) : super();

  @override
  Function get fromJsonFunction => _$DiagnosisInputFromJson;
  factory DiagnosisInput.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as DiagnosisInput;
  @override
  Map<String, dynamic> toJson() => _$DiagnosisInputToJson(this);
  @override
  String get jsonType => type;
}
