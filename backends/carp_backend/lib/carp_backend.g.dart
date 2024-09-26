// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'carp_backend.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CarpDataEndPoint _$CarpDataEndPointFromJson(Map<String, dynamic> json) =>
    CarpDataEndPoint(
      dataFormat: json['data_format'] as String? ?? NameSpace.CARP,
      name: json['name'] as String? ?? 'CARP Web Services',
      uploadMethod: $enumDecodeNullable(
              _$CarpUploadMethodEnumMap, json['upload_method']) ??
          CarpUploadMethod.stream,
      onlyUploadOnWiFi: json['only_upload_on_wi_fi'] as bool? ?? false,
      uploadInterval: (json['upload_interval'] as num?)?.toInt() ?? 10,
      deleteWhenUploaded: json['delete_when_uploaded'] as bool? ?? true,
    )
      ..$type = json['__type'] as String?
      ..type = json['type'] as String;

Map<String, dynamic> _$CarpDataEndPointToJson(CarpDataEndPoint instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['type'] = instance.type;
  val['data_format'] = instance.dataFormat;
  val['upload_method'] = _$CarpUploadMethodEnumMap[instance.uploadMethod]!;
  val['name'] = instance.name;
  val['only_upload_on_wi_fi'] = instance.onlyUploadOnWiFi;
  val['upload_interval'] = instance.uploadInterval;
  val['delete_when_uploaded'] = instance.deleteWhenUploaded;
  return val;
}

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

Map<String, dynamic> _$MessageToJson(Message instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'type': _$MessageTypeEnumMap[instance.type]!,
    'timestamp': instance.timestamp.toIso8601String(),
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('title', instance.title);
  writeNotNull('sub_title', instance.subTitle);
  writeNotNull('message', instance.message);
  writeNotNull('url', instance.url);
  writeNotNull('image', instance.image);
  return val;
}

const _$MessageTypeEnumMap = {
  MessageType.announcement: 'announcement',
  MessageType.article: 'article',
  MessageType.news: 'news',
};
