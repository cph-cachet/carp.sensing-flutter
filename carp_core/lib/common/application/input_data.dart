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
  static const CUSTOM_INPUT_TYPE_NAME = '${CustomInput.INPUT_TYPE_NAME}.custom';

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
  String get jsonType => CUSTOM_INPUT_TYPE_NAME;
}

/// Biological sex of a person.
enum Sex { Male, Female, Intersex }

/// The biological sex assigned at birth of a participant.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class SexCustomInput extends Data {
  static const SEX_INPUT_TYPE_NAME = '${CustomInput.INPUT_TYPE_NAME}.sex';

  Sex value;

  SexCustomInput(this.value) : super();

  @override
  Function get fromJsonFunction => _$SexCustomInputFromJson;
  factory SexCustomInput.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as SexCustomInput;
  @override
  Map<String, dynamic> toJson() => _$SexCustomInputToJson(this);
  @override
  String get jsonType => SEX_INPUT_TYPE_NAME;
}
