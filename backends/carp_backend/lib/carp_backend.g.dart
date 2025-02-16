// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'carp_backend.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CarpDataEndPoint _$CarpDataEndPointFromJson(Map<String, dynamic> json) =>
    CarpDataEndPoint(
      dataFormat: json['dataFormat'] as String? ?? NameSpace.CARP,
      name: json['name'] as String? ?? 'CARP Web Services',
      uploadMethod: $enumDecodeNullable(
              _$CarpUploadMethodEnumMap, json['uploadMethod']) ??
          CarpUploadMethod.stream,
      onlyUploadOnWiFi: json['onlyUploadOnWiFi'] as bool? ?? false,
      uploadInterval: (json['uploadInterval'] as num?)?.toInt() ?? 10,
      deleteWhenUploaded: json['deleteWhenUploaded'] as bool? ?? true,
      compress: json['compress'] as bool? ?? true,
    )
      ..$type = json['__type'] as String?
      ..type = json['type'] as String;

Map<String, dynamic> _$CarpDataEndPointToJson(CarpDataEndPoint instance) =>
    <String, dynamic>{
      if (instance.$type case final value?) '__type': value,
      'type': instance.type,
      'dataFormat': instance.dataFormat,
      'uploadMethod': _$CarpUploadMethodEnumMap[instance.uploadMethod]!,
      'name': instance.name,
      'onlyUploadOnWiFi': instance.onlyUploadOnWiFi,
      'uploadInterval': instance.uploadInterval,
      'deleteWhenUploaded': instance.deleteWhenUploaded,
      'compress': instance.compress,
    };

const _$CarpUploadMethodEnumMap = {
  CarpUploadMethod.stream: 'stream',
  CarpUploadMethod.datapoint: 'datapoint',
  CarpUploadMethod.file: 'file',
};

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
      id: json['id'] as String?,
      type: $enumDecodeNullable(_$MessageTypeEnumMap, json['type']) ??
          MessageType.announcement,
      title: json['title'] as String?,
      subTitle: json['sub_title'] as String?,
      message: json['message'] as String?,
      url: json['url'] as String?,
      image: json['image'] as String?,
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'id': instance.id,
      'type': _$MessageTypeEnumMap[instance.type]!,
      'timestamp': instance.timestamp.toIso8601String(),
      if (instance.title case final value?) 'title': value,
      if (instance.subTitle case final value?) 'sub_title': value,
      if (instance.message case final value?) 'message': value,
      if (instance.url case final value?) 'url': value,
      if (instance.image case final value?) 'image': value,
    };

const _$MessageTypeEnumMap = {
  MessageType.announcement: 'announcement',
  MessageType.article: 'article',
  MessageType.news: 'news',
};
