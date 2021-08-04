// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'carp_core_test.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

A _$AFromJson(Map<String, dynamic> json) {
  return A()
    ..$type = json[r'$type'] as String?
    ..index = json['index'] as int?;
}

Map<String, dynamic> _$AToJson(A instance) {
  final val = <String, dynamic>{
    r'$type': instance.$type,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('index', instance.index);
  return val;
}

B _$BFromJson(Map<String, dynamic> json) {
  return B()
    ..$type = json[r'$type'] as String?
    ..index = json['index'] as int?
    ..str = json['str'] as String?;
}

Map<String, dynamic> _$BToJson(B instance) {
  final val = <String, dynamic>{
    r'$type': instance.$type,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('index', instance.index);
  writeNotNull('str', instance.str);
  return val;
}
