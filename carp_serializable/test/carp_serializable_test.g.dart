// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'carp_serializable_test.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

A _$AFromJson(Map<String, dynamic> json) => A()
  ..$type = json[r'$type'] as String?
  ..index = json['index'] as int?;

Map<String, dynamic> _$AToJson(A instance) => <String, dynamic>{
      r'$type': instance.$type,
      'index': instance.index,
    };

B _$BFromJson(Map<String, dynamic> json) => B()
  ..$type = json[r'$type'] as String?
  ..index = json['index'] as int?
  ..str = json['str'] as String?;

Map<String, dynamic> _$BToJson(B instance) => <String, dynamic>{
      r'$type': instance.$type,
      'index': instance.index,
      'str': instance.str,
    };
